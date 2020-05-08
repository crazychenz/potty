#pragma once

#include <memory>

#include <utils/entt_wrap.hpp>

#include <dummy/components/common_components.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <model/Vector2.hpp>
#include "IAction.hpp"

// TODO: Replace this with logger.
#include <iostream>

class SinglePottyAction : public IAction
{
    entt::entity entity;
    Vector2 prev_position;

public:

    SinglePottyAction(entt::entity entity, Vector2 prev_position) :
        entity(entity),
        prev_position(prev_position)
    {}

    ~SinglePottyAction() {}

    virtual bool has_movement() { return true; }
    entt::entity get_entity() { return entity; }
    Vector2 get_prev() { return prev_position; }

    void perform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;

        std::wcout << "Removing " << prev_position << "\r\n"; ctx.redraw = true;
        grid->set_position(prev_position, grid->empty);

        // TODO: This doesn't feel right.
        ctx.goal_reached = true;
    }

    void unperform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;

        grid->set_position(prev_position, entity);

        // TODO: Probably unnessessary.
        registry.get<GridPositionComponent>(entity).position = prev_position;
    }

};