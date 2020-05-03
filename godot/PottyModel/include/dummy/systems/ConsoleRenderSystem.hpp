#pragma once

#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/types.hpp>

#include <iostream>
#include <utils/entt_wrap.hpp>

#include <model/Vector2.hpp>

// TODO: Replace console output with logger.
class ConsoleRenderSystem : public entt::process<ConsoleRenderSystem, double>
{
    const entt::registry &registry;
    double timePassed = 0.0;

    void draw(const unique_ptr<Grid> &grid)
    {
        std::wcout << "----------\r\n";
        for (int y = 0; y < grid->height; ++y)
        {
            std::wcout << "|";
            for (int x = 0; x < grid->width; ++x)
            {
                entt::entity entity = grid->get_position(Vector2(x, y));
                if (entity == grid->empty)
                {
                    std::wcout << ".";
                    continue;
                }
                auto &ascii = registry.get<AsciiComponent>(entity);
                std::wcout << ascii.character;
            }
            std::wcout << "|\r\n";
        }
        std::wcout << "----------\r\n";
    }

public:
    ConsoleRenderSystem(const entt::registry &registry) : registry(registry) {}

    void update(double delta, void *data) {
        timePassed += delta;
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto &grid = ctx.grid;

        if (grid->dirty)
        {
            draw(grid);
            grid->dirty = false;
        }

    }
};