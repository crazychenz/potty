#pragma once

#include <iostream>
#include <memory>
#include <utils/entt_wrap.hpp>
#include <dummy/types.hpp>
#include <dummy/Transaction.hpp>

/*
    Note: implicit 'bump reactions' should be encoded into the design.

    An algorithm for processing input actions that return output actions.
    void process() {
        var action = actors[_currentActor].getAction();
        if (action == null) return;
        while (true) {
            var result = action.perform();
            if (!result.succeeded) return;
            if (result.alternate == null) break;
            action = result.alternate;
        }
        _currentActor = (_currentActor + 1) % actors.length;
    }
*/

// TODO: Replace console output with logger.
class PlayerMovementSystem : public entt::process<PlayerMovementSystem, double>
{
    entt::registry &registry;
    double timePassed = 0.0;

public:
    PlayerMovementSystem(entt::registry &registry) : registry(registry) {}

    void update(double delta) 
    {
        timePassed += delta;

        auto &ctx = registry.ctx<ConsoleEngineContext>();

        if (ctx.player_controller_state.direction == Vector2(0, 0)) { return; }
        std::wcout << ctx.player_controller_state.direction << "\r\n"; ctx.redraw = true;

        std::unique_ptr<ITransaction> xaction = estimate_xaction();
        if (xaction == nullptr)
        {
            // TODO: Handle no memory?
        }

        std::wcout << "ASDFSADF2\r\n";
        // Check validity of xaction.
        if (has_conflicts(xaction))
        {
            // TODO: Try to resolve things.
            // For now, we're going to just forget it.
            bail_and_cleanup(xaction);
            return;
        }

        if (xaction->get_list().size() > 0)
        {
            ctx.new_xaction_list.push_back(std::move(xaction));
            return;
            // TODO: Do this here or in main engine loop?
            //ctx.player_controller_state.direction = Vector2(0, 0);
        }
    }

    void bail_and_cleanup(std::unique_ptr<ITransaction> &xaction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        if (xaction->is_player_xaction()) // TODO: Is this check nessessary?
        {
            // We just processed a player_xaction, re-enable the player controls.
            std::wcout << "Re-enabled player controls.\r\n"; ctx.redraw = true;
            ctx.player_move_pending = false;
        }
    }

    bool has_conflicts(std::unique_ptr<ITransaction> &xaction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // check against new (should be none?)
        std::wcout << "ASDFSADF\r\n";
        for (auto &actitr1: xaction->get_list())
        {
            std::wcout << "pt1 " << actitr1->get_next() << "\r\n";
            Vector2 pt1 = actitr1->get_next();
            

            if (!ctx.grid->isPositionValid(pt1))
            {
                std::wcout << "Moving to invalid poaition " << pt1 << "\r\n";  ctx.redraw = true;
                return true;
            }

            for (auto xactitr = ctx.new_xaction_list.begin(); xactitr != ctx.new_xaction_list.end(); ++xactitr)
            {
                for (auto actitr2 = (*xactitr)->get_list().begin(); actitr2 != (*xactitr)->get_list().end(); ++actitr2)
                {
                    auto pt2 = (*actitr2)->get_next();

                    if (pt1 == pt2) {
                        // ! No use case for this.
                        std::wcout << "Two points going for same position.\r\n";  ctx.redraw = true;
                        return true;
                    }
                }
            }
        }


        return false;
    }

    std::unique_ptr<ITransaction> estimate_xaction()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Skip this until the last player move was complete.
        // Note: If we implement UNDO, the player just has to wait until
        //       their last command is complete.
        //if (ctx.player_move_pending) { return; }

        Vector2 direction(ctx.player_controller_state.direction);

        std::unique_ptr<ITransaction> xaction = std::make_unique<Transaction>();
        std::wcout << xaction->get_list().size() << "\r\n";

        xaction->set_player_xaction(true);
        auto &grid = ctx.grid;
        const GridPositionComponent &gpc = registry.get<GridPositionComponent>(ctx.player);
        Vector2 position = Vector2(gpc.position);
        Vector2 nextPosition = position + direction;
        entt::entity current = ctx.player;

        if (ctx.player_controller_state.pulling)
        {
            // Since we're pulling, go ahead and do all the pulling checks and stuff here.
            // This could probably be more fancy, but working against a deadline now.
            Vector2 pull_pos = position - direction;
            if (grid->isPositionValid(position - direction))
            {
                entt::entity pulled_entity = grid->get_position(pull_pos);
                if (pulled_entity != grid->empty)
                {
                    // TODO: We need a pullable and pushable component, but for
                    // TODO: now we'll limp along with this noise.
                    auto movable = registry.try_get<MovableComponent>(pulled_entity);
                    if (movable != nullptr && movable->can_move(registry, current, direction))
                    {
                        // Assuming if movable, also pullable.
                        // Note: The can_move code may look in the wrong direction for conditionals?
                        xaction->push_back(std::make_shared<SingleMoveAction>(pulled_entity, pull_pos, position));
                    }
                }
            }
        }

        while(true) {
            xaction->push_back(std::make_shared<SingleMoveAction>(current, position, nextPosition));
            auto &mylist = xaction->get_list();
            const auto &myitr = xaction->get_list().begin();

            entt::entity target = grid->get_position(nextPosition);

            if (!grid->isPositionValid(nextPosition))
            {
                std::wcout << "Position invalid.\r\n";  ctx.redraw = true;
                break;
            }

            if (target == grid->empty)
            {
                std::wcout << "Nothing else to move.\r\n";
                ctx.redraw = true;
                break;
            }

            auto movable = registry.try_get<MovableComponent>(target);
            if (movable == nullptr)
            {
                std::wcout << "No movable component found.\r\n";  ctx.redraw = true;
                break;
            }

            if (!movable->can_move(registry, target, direction))
            {
                std::wcout << "Movable component refuses to move.\r\n";  ctx.redraw = true;
                break;
            }

            // Advance to the next space.
            position = nextPosition;
            nextPosition = position + direction;
            current = target;
        }

        return xaction;

    }
};

