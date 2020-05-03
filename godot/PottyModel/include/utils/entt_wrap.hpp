#pragma once

#include <entt/entt.hpp>

#include <model/Vector2.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/components/GridPositionComponent.hpp>

namespace entt {

template<typename... Types>
using simple_view = entt::basic_view<entt::entity, entt::exclude_t<>, Types...>;

} // namespace entt

// TODO: This needs a better home.
entt::entity get_source_entity(entt::registry &registry, entt::entity target, Vector2 &direction)
{
    auto &ctx = registry.ctx<ConsoleEngineContext>();
    auto &grid = ctx.grid;

    // Ghetto direction flip.
    int x = 0;
    int y = 0;
    if (direction.getX() == 1) x = -1;
    else if (direction.getX() == -1) x = 1;
    if (direction.getY() == 1) y = -1;
    else if (direction.getY() == -1) y = 1;
    // Get this entity.
    auto &gpc = registry.get<GridPositionComponent>(target);
    Vector2 source_pos(gpc.position.getX() + x, gpc.position.getY() + y);
    return grid->get_position(source_pos);
}