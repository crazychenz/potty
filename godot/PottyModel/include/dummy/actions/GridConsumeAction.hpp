#pragma once

#include <utils/entt_wrap.hpp>

#include <dummy/components/common_components.hpp>
#include "IAction.hpp"

class GridConsumeAction : public IAction
{
    entt::entity entity;

public:

    GridConsumeAction(entt::entity entity) :
        entity(entity)
    {}

    ~GridConsumeAction() {}

    void perform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;
        auto &pos = registry.get<GridPositionComponent>(entity);
        grid->set_position(pos.position, grid->empty);
    }

    void unperform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;
        auto &pos = registry.get<GridPositionComponent>(entity);
        grid->set_position(pos.position, entity);
    }

};