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

// TODO: Replace this with logger.
#include <iostream>

class SingleMoveAction : public IAction
{
    entt::entity entity;
    Vector2 prev_position;
    Vector2 next_position;

public:

    SingleMoveAction(entt::entity entity, Vector2 prev_position, Vector2 next_position) :
        entity(entity),
        prev_position(prev_position),
        next_position(next_position)
    {}

    ~SingleMoveAction() {}

    virtual bool has_movement() { return true; }
    Vector2 get_next() { return next_position; }
    Vector2 get_prev() { return prev_position; }

    void perform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;

        std::wcout << "Moving " << prev_position << " -> " << next_position << "\r\n"; ctx.redraw = true;
        grid->set_position(prev_position, grid->empty);
        grid->set_position(next_position, entity);
        registry.get<GridPositionComponent>(entity).position = next_position;


        /*if (moves.size() > 0)
        {
            std::reverse(moves.begin(), moves.end());
            for (auto action = moves.begin(); action != moves.end(); action++)
            {
                (*action)->perform(registry);
            }
        }*/
    }

    void unperform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;

        grid->set_position(next_position, grid->empty);
        grid->set_position(prev_position, entity);
        registry.get<GridPositionComponent>(entity).position = prev_position;
    }

};