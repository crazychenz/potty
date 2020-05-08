#pragma once

#include <iostream>
#include <utils/entt_wrap.hpp>
#include <dummy/types.hpp>

// TODO: Replace console output with logger.
class BladderSystem : public entt::process<BladderSystem, double>
{
    entt::registry &registry;
    double bladderInterval = 1.0;
    double lastBladderInterval = 0.0;
    int bladderStep = 1;

public:
    BladderSystem(entt::registry &registry) : registry(registry) {}

    void update(double delta) {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        if (ctx.player_move_state == PLAYER_MOVE_WAITING_STATE && ctx.bladder_paused == false)
        {
            lastBladderInterval += delta;
            if (lastBladderInterval >= bladderInterval)
            {
                // TODO: Consider making this an action?
                ctx.adjust_bladder(bladderStep);
                lastBladderInterval -= bladderInterval;
            }
        }
    }
};