#pragma once

#include <iostream>
#include <memory>
#include <utils/entt_wrap.hpp>
#include <dummy/types.hpp>
#include <dummy/Transaction.hpp>
#include <dummy/components/common_components.hpp>

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

        std::unique_ptr<ITransaction> xaction = estimate_xaction();
        if (xaction == nullptr)
        {
            // move rejected
            ctx.player_move_state = PLAYER_MOVE_WAITING_STATE;
            return;
        }

        // Check validity of xaction.
        if (has_conflicts(xaction))
        {
            // TODO: Try to resolve things.
            // For now, we're going to just forget it.
            std::wcout << "Detected conflicts with transaction.\r\n"; ctx.redraw = true;
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

    void bail_and_cleanup(std::unique_ptr<ITransaction> &xaction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        if (xaction->is_player_xaction()) // TODO: Is this check nessessary?
        {
            // We just processed a player_xaction, re-enable the player controls.
            //std::wcout << "Re-enabled player controls.\r\n"; ctx.redraw = true;
            //std::wcout << "ctx.player_move_state = PLAYER_MOVE_WAITING_STATE\r\n";
            ctx.player_move_state = PLAYER_MOVE_WAITING_STATE;
        }
    }

    bool _conflicts_with_pending_xactions(
            std::unique_ptr<ITransaction> &xaction,
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
            // TODO: Do this more intelligently.
            if (!ctx.grid->isPositionValid(pt1) && pt1 != Vector2(-1000000, -1000000)) { return true; }
            //std::wcout << pt1 << " isValid " << ctx.grid->isPositionValid(pt1) << "\r\n";

            for (auto xaction_itr = xaction_list.begin(); xaction_itr != xaction_list.end(); ++xaction_itr)
            {
                for (auto other_act_itr = (*xaction_itr)->get_list().begin(); other_act_itr != (*xaction_itr)->get_list().end(); ++other_act_itr)
                //for (auto other_act_itr: (*xaction_itr)->get_list())
                {
                    auto pt2 = (*other_act_itr)->get_next();
                    //std::wcout << "Comparing " << pt1 << " and " << pt2 << "\r\n";
                    if (pt1 == pt2) {
                        std::wcout << "Conflict: " << pt1 << " and " << pt2 << "\r\n"; ctx.redraw = true;
                        return true;
                    }
                }
            }
        }

        return false;
    }

    bool has_conflicts(std::unique_ptr<ITransaction> &xaction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Only allow (last) moves to empty spaces.
        auto itr = xaction->get_list().end();
        Vector2 dest = (*(--itr))->get_next();
        if (ctx.grid->isPositionValid(dest) && ctx.grid->get_position(dest) != ctx.grid->empty) {
            return true;
        }
        //std::wcout << "Dest " << dest << " Entity " << (uint32_t)ctx.grid->get_position(dest) << " Empty " << (uint32_t)ctx.grid->empty << "\r\n";

        if (_conflicts_with_pending_xactions(xaction, ctx.new_xaction_list) ||
            _conflicts_with_pending_xactions(xaction, ctx.pending_xaction_list))
        {
            return true;
        }

        return false;
    }

    std::unique_ptr<ITransaction> estimate_xaction()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        Vector2 direction(ctx.player_controller_state.direction);
        std::unique_ptr<ITransaction> xaction = make_unique<Transaction>(timePassed);

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
                    PullableComponent *pullable = registry.try_get<PullableComponent>(pulled_entity);
                    if (pullable != nullptr && pullable->can_pull(registry, pulled_entity, current, direction, xaction))
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
                // Position invalid.
                break;
            }

            if (target == grid->empty)
            {
                // Nothing else to move.
                ctx.redraw = true;
                break;
            }

            {   // Bumping takes precedence.
                BumpableComponent *bumpable = registry.try_get<BumpableComponent>(target);
                if (bumpable != nullptr)
                {
                    if (!bumpable->bump(registry, target, current, direction, xaction))
                    {
                        // Bump refuses to move or get out of the way.
                        break;
                    }
                    goto next;
                }
            }

            {   // If bumpable not available, fallback to pushable.
                PushableComponent *pushable = registry.try_get<PushableComponent>(target);
                if (pushable != nullptr)
                {
                    if (!pushable->can_push(registry, target, current, direction, xaction))
                    {
                        // Pushable refuses to move.
                        break;
                    }
                    goto next;
                }
            }

            
            {   // If pushable not available, fallback to consumable.
                ConsumableComponent *consumable = registry.try_get<ConsumableComponent>(target);
                if (consumable != nullptr)
                {
                    if (!consumable->can_consume(registry, target, current, xaction))
                    {
                        // Consumable refuses to consume.
                        break;
                    }
                    // TODO: consume() could return a boolean to determine if we continue or break.
                    consumable->consume(registry, target, current, xaction);
                    break;
                }
            }

            // If we're here, we likely hit a wall.
            return nullptr;

            next: // Advance to the next space.
            position = nextPosition;
            nextPosition = position + direction;
            current = target;
        }

        return std::move(xaction);

    }
};

