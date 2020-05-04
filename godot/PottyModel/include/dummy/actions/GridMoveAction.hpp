/* This file works but leaves alot to be desired. I've attempted to 
   implement this in a general manner but in the end it was easier to
   just do something similar to what I had before. The one difference
   between this algorithm and the on in GDScript is that this one isn't
   recursive (which I prefer). The bump() call is very restrictive and
   the pulling feels janky. In conclusion, this all works for the current
   pottytime project use cases, but if evolving this to another project,
   there is a bunch of technical debt to be settled first.
*/

#pragma once

#include <memory>

#include <utils/entt_wrap.hpp>

#include <dummy/components/common_components.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <model/Vector2.hpp>
#include "IAction.hpp"
#include "ActionResult.hpp"

// TODO: Replace this with logger.
#include <iostream>

class GridMoveAction : public IAction
{
    Vector2 direction;
    entt::entity entity;

    // Populated by update()
    // This is shared to allow ActionResult to work.
    std::vector<std::shared_ptr<IAction>> moves;

    // Not populated until perform()
    std::unique_ptr<Vector2> oldPosition;

    Vector2 getNextPosition(const Vector2 &pos)
    {
        return Vector2(pos.getX() + direction.getX(), pos.getY() + direction.getY());
    }

    Vector2 getNewPosition(const entt::registry &registry)
    {
        const GridPositionComponent &gpc = registry.get<GridPositionComponent>(entity);
        return getNextPosition(gpc.position);
    }

public:

    GridMoveAction(entt::entity entity, Vector2 direction) :
        entity(entity),
        direction(direction)
    {}

    ~GridMoveAction() {}

    // Note: We named this update because it is itself like a subsystem.
    ActionResult update(entt::registry &registry, double delta = 0, void *data = nullptr) {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;

        const GridPositionComponent &gpc = registry.get<GridPositionComponent>(entity);
        Vector2 position = Vector2(gpc.position.getX(), gpc.position.getY());
        Vector2 nextPosition = getNextPosition(gpc.position);
        entt::entity lastTarget;
        entt::entity target = entity;

        do {

            // Fast fail: Is nextPosition a valid move?
            if (grid->isPositionValid(nextPosition) != true)
            {
                moves.clear(); // TODO: deallocate memory too?
                return ActionResult(ActionResult::Rejected);
            }

            // Fast win: Is nextPosition empty?
            lastTarget = target;
            entt::entity target = grid->get_position(nextPosition);
            if (target == grid->empty)
            {
                //moves.push_back(std::make_shared<GridMoveAction>(target, direction));
                return ActionResult(ActionResult::Accepted);
            }

            // TODO: Consider converting this to a tuple?
            auto bumpable = registry.try_get<BumpableComponent>(target);
            auto moveable = registry.try_get<MoveableComponent>(target);

            if (moveable == nullptr)
            {
                std::wcout << "Not moveable\r\n";
                moves.clear(); // TODO: deallocate memory too?
                return ActionResult(ActionResult::Rejected);
            }

            if (bumpable == nullptr)
            {
                // We're moveable, but not bumpable.
                // Add this move to the list and continue.
                std::wcout << "Moving\r\n";
                moves.push_back(std::make_shared<GridMoveAction>(target, direction));
                //return ActionResult(true);
            }
            else
            {
                std::wcout << "Bumping\r\n";

                while (true)
                {
                    // Note: For now, all ActionResult alternates are blindly pushed into moves vector.
                    // Note: The use case is to allow an entity to decide if its consumable based
                    //       on last target or simply moveable.
                    
                    ActionResult result = bumpable->bump(registry, target, direction);

                    //std::shared_ptr<IAction> action = std::make_shared<GridMoveAction>(target, direction);
                    //ActionResult result = bumpable->bump(registry, action);

                    if (result.result == ActionResult::Rejected)
                    {
                        //std::wcout << "result.succeeded != true\r\n";
                        // We may have gone down a sequence of actions that led us
                        // to a dead end (e.g. moving a block that is against a wall).
                        // In this case, we just ignore that we ever saw the action.
                        // Note: This ignored action needs to be cleaned up by the
                        //       caller.
                        moves.clear(); // TODO: deallocate memory too?
                        return result;
                    }
                    else if (result.alternate == nullptr)
                    {
                        // If we're here, we know we haven't failed and there was
                        // no alternate action to account for.
                        //std::wcout << "result.alternate == null\r\n";
                        moves.push_back(std::make_shared<GridMoveAction>(target, direction));
                        break;
                    }
                    else {
                        // The action resulted in an alternate action. It is assumed that
                        // the bump action produced an action that doesn't need updating.
                        std::wcout << "Bumpable passed back an alternate action.\r\n";
                        moves.push_back(result.alternate);
                        
                        if (result.result == ActionResult::Accepted)
                            return result;
                        break;
                    }
                }
            }

            // Advance to the next space.
            position = nextPosition;
            nextPosition = getNextPosition(position);

        } while(true);
    
        // If we get here, we do nothing.
        return ActionResult(ActionResult::Rejected);

    }

    void perform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;

        if (moves.size() > 0)
        {
            std::reverse(moves.begin(), moves.end());
            for (auto action = moves.begin(); action != moves.end(); action++)
            {
                (*action)->perform(registry);
            }
        }

        //auto view = registry.view<HealthComponent>(entity);
        entt::entity source = get_source_entity(registry, entity, direction);
        GridPositionComponent &gpc = registry.get<GridPositionComponent>(entity);
        oldPosition = std::make_unique<Vector2>(gpc.position);
        // TODO: Add the addition operator to Vector2
        Vector2 newPosition = Vector2(oldPosition->getX() + direction.getX(), oldPosition->getY() + direction.getY());
        grid->set_position(gpc.position, grid->empty);
        grid->set_position(newPosition, entity);
        registry.replace<GridPositionComponent>(entity, newPosition);

        // Check if we're the player and we're pulling.
        if (ctx.player == entity && ctx.player_pulling)
        {
            // Move the thing that was next to player if moveable.
            //entt::entity source = get_source_entity(registry, entity, direction);
            auto moveable = registry.try_get<MoveableComponent>(source);
            if (moveable == nullptr) { return; }

            GridPositionComponent &src_gpc = registry.get<GridPositionComponent>(source);
            Vector2 newSrcPosition = Vector2(src_gpc.position.getX() + direction.getX(), src_gpc.position.getY() + direction.getY());
            grid->set_position(src_gpc.position, grid->empty);
            grid->set_position(newSrcPosition, source);
            registry.replace<GridPositionComponent>(source, newSrcPosition);

        }

        //registry.get<GridPositionComponent>(entity).position = oldPosition + direction;
        //std::wcout << L"Moved " << std::to_wstring((std::uint32_t)entity) << L" from " << oldPosition->toStr() << L" to " << gpc.position.toStr() << "\r\n";

    }

    void unperform(entt::registry &registry)
    {
        // TODO: Implement this once we have an undo queue.
        //auto view = registry.view<HealthComponent>(entity);
        /*std::wcout << "Unmoving " << entity << " from " << registry.get<HealthComponent>(entity).position.toStr() << " to " << oldPosition.toStr() << "\r\n";
        registry.get<HealthComponent>(entity).position = oldPosition;*/
    }

};