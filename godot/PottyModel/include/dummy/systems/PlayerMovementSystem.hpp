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

        if (ctx.player_move_state != PLAYER_MOVE_PROCESSING_STATE) return;

        std::unique_ptr<Transaction> xaction = estimate_xaction();
        if (xaction == nullptr)
        {
            // TODO: Handle no memory?
        }

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
            //std::wcout << "ctx.player_move_state = PLAYER_MOVE_PENDING_STATE\r\n";
            ctx.player_move_state = PLAYER_MOVE_PENDING_STATE;
            
            return;
            // TODO: Do this here or in main engine loop?
            //ctx.player_controller_state.direction = Vector2(0, 0);
        }
    }

    void bail_and_cleanup(std::unique_ptr<Transaction> &xaction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        if (xaction->player_xaction) // TODO: Is this check nessessary?
        {
            // We just processed a player_xaction, re-enable the player controls.
            //std::wcout << "Re-enabled player controls.\r\n"; ctx.redraw = true;
            //std::wcout << "ctx.player_move_state = PLAYER_MOVE_WAITING_STATE\r\n";
            ctx.player_move_state = PLAYER_MOVE_WAITING_STATE;
        }
    }

    bool _conflicts_with_pending_xactions(
            std::unique_ptr<Transaction> &xaction,
            std::list<std::unique_ptr<ITransaction>> &xaction_list)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Reject if any xaction destination is already a destination of a pending xaction.
        // TODO: Check positions that are occupied (but may move soon.)
        for (auto action_itr = xaction->get_list().begin(); action_itr != xaction->get_list().end(); ++action_itr)
        {
            auto pt1 = (*action_itr)->get_next();

            // Only allow moves to valid positions.
            // ! No use case for this until we have AI.
            if (!ctx.grid->isPositionValid(pt1)) { return true; }
            //std::wcout << pt1 << " isValid " << ctx.grid->isPositionValid(pt1) << "\r\n";

            for (auto xaction_itr = xaction_list.begin(); xaction_itr != xaction_list.end(); ++xaction_itr)
            {
                for (auto other_act_itr = (*xaction_itr)->get_list().begin(); other_act_itr != (*xaction_itr)->get_list().end(); ++other_act_itr)
                //for (auto other_act_itr: (*xaction_itr)->get_list())
                {
                    auto pt2 = (*other_act_itr)->get_next();
                    //std::wcout << "Comparing " << pt1 << " and " << pt2 << "\r\n";
                    if (pt1 == pt2) { return true; }
                }
            }
        }

        return false;
    }

    bool has_conflicts(std::unique_ptr<Transaction> &xaction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Only allow (last) moves to empty spaces.
        auto itr = xaction->get_list().end();
        Vector2 dest = (*(--itr))->get_next();
        if (ctx.grid->get_position(dest) != ctx.grid->empty) { return true; }
        //std::wcout << "Dest " << dest << " Entity " << (uint32_t)ctx.grid->get_position(dest) << " Empty " << (uint32_t)ctx.grid->empty << "\r\n";

        if (_conflicts_with_pending_xactions(xaction, ctx.new_xaction_list) ||
            _conflicts_with_pending_xactions(xaction, ctx.pending_xaction_list))
        {
            return true;
        }

#if 0
        // check against new (should be none?)
        for (auto actitr1 = xaction->get_list().begin(); actitr1 != xaction->get_list().end(); ++actitr1)
        {
            auto pt1 = (*actitr1)->get_next();

            if (!ctx.grid->isPositionValid(pt1))
            {
                //std::wcout << "Moving to invalid poaition " << pt1 << "\r\n";  ctx.redraw = true;
                return true;
            }

            for (auto xactitr = ctx.new_xaction_list.begin(); xactitr != ctx.new_xaction_list.end(); ++xactitr)
            {
                for (auto actitr2 = (*xactitr)->get_list().begin(); actitr2 != (*xactitr)->get_list().end(); ++actitr2)
                {
                    auto pt2 = (*actitr2)->get_next();

                    if (pt1 == pt2) {
                        // ! No use case for this.
                        //std::wcout << "Two points going for same position.\r\n";  ctx.redraw = true;
                        return true;
                    }
                }
            }
        }

        // check against pending (could be some?)
        for (auto actitr1 = xaction->get_list().begin(); actitr1 != xaction->get_list().end(); ++actitr1)
        {
            auto pt1 = (*actitr1)->get_next();

            if (!ctx.grid->isPositionValid(pt1))
            {
                //std::wcout << "Moving to invalid poaition " << pt1 << "\r\n";  ctx.redraw = true;
                return true;
            }

            for (auto xactitr = ctx.pending_xaction_list.begin(); xactitr != ctx.pending_xaction_list.end(); ++xactitr)
            {
                for (auto actitr2 = (*xactitr)->get_list().begin(); actitr2 != (*xactitr)->get_list().end(); ++actitr2)
                {
                    auto pt2 = (*actitr2)->get_next();

                    if (pt1 == pt2) {
                        // ! No use case for this.
                        //std::wcout << "Two points going for same position.\r\n";  ctx.redraw = true;
                        return true;
                    }
                }
            }
        }
#endif

        return false;
    }

    std::unique_ptr<Transaction> estimate_xaction()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Skip this until the last player move was complete.
        // Note: If we implement UNDO, the player just has to wait until
        //       their last command is complete.
        //if (ctx.player_move_pending) { return; }

        Vector2 direction(ctx.player_controller_state.direction);

        std::unique_ptr<Transaction> xaction = make_unique<Transaction>(timePassed);

        xaction->player_xaction = true;
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
                        xaction->push_back(make_shared<SingleMoveAction>(pulled_entity, pull_pos, position));
                    }
                }
            }
        }

        while(true) {
            xaction->push_back(make_shared<SingleMoveAction>(current, position, nextPosition));

            entt::entity target = grid->get_position(nextPosition);

            if (!grid->isPositionValid(nextPosition))
            {
                //std::wcout << "Position invalid.\r\n";  ctx.redraw = true;
                break;
            }

            if (target == grid->empty)
            {
                //std::wcout << "Nothing else to move.\r\n";
                ctx.redraw = true;
                break;
            }

            auto movable = registry.try_get<MovableComponent>(target);
            if (movable == nullptr)
            {
                //std::wcout << "No movable component found.\r\n";  ctx.redraw = true;
                break;
            }

            if (!movable->can_move(registry, target, direction))
            {
                //std::wcout << "Movable component refuses to move.\r\n";  ctx.redraw = true;
                break;
            }

            // Advance to the next space.
            position = nextPosition;
            nextPosition = position + direction;
            current = target;
        }

        return std::move(xaction);

    }
};

