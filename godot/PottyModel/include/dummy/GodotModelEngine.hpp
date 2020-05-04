#pragma once

#include <iostream> // for debug wcout

#include <memory>
#include <vector>
#include <utils/entt_wrap.hpp>

#include <dummy/types.hpp>
#include <dummy/actions/common_actions.hpp>
#include <dummy/components/common_components.hpp>
#include <dummy/systems/MovementSystem.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/actions/IAction.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/CommonEngine.hpp>

#include <dummy/IPottyModel.hpp>

class GodotModelEngine : public CommonEngine
{
    IPottyModel &adapter;

public:

    GodotModelEngine(IPottyModel &pottyModel) : adapter(pottyModel) {

        // Create a transaction object to use for this frame.
        xactionMap[L"output"] = std::make_unique<XAction>();
        xactionMap[L"input"] = std::make_unique<XAction>();

        // The map.
        //auto gridEntity = registry.create();
        //registry.emplace<GridComponent>(gridEntity, 8, 8);
        //Grid &grid = registry.get<GridComponent>(gridEntity).grid;
        //ctx.grid = std::make_unique<Grid>(8, 8);
        registry.set<ConsoleEngineContext>();
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        ctx.grid = std::make_unique<Grid>(8, 8, registry.create());


        // Flesh some entities.
        auto myHero = registry.create();
        registry.emplace<PlayerComponent>(myHero);
        registry.emplace<HealthComponent>(myHero, 100);
        registry.emplace<NameComponent>(myHero, L"myHero");
        registry.emplace<AsciiComponent>(myHero, L'*');
        registry.emplace<GridPositionComponent>(myHero, Vector2(3, 3));
        ctx.grid->set_position(Vector2(3, 3), myHero);
        ctx.player = myHero;
        std::wcout << "myHero: " << (uint32_t)myHero << "\r\n";

        auto myRock = registry.create();
        registry.emplace<HealthComponent>(myRock, 100);
        registry.emplace<NameComponent>(myRock, L"myRock");
        registry.emplace<AsciiComponent>(myRock, L'R');
        registry.emplace<MoveableComponent>(myRock);
        registry.emplace<GridPositionComponent>(myRock, Vector2(5, 4));
        ctx.grid->set_position(Vector2(5, 4), myRock);
        //std::wcout << "myHero: " << (uint32_t)myRock << "\r\n";

        auto myEnemy = registry.create();
        registry.emplace<HealthComponent>(myEnemy, 100);
        registry.emplace<NameComponent>(myEnemy, L"myEnemy");
        registry.emplace<AsciiComponent>(myEnemy, L'T');
        registry.emplace<MoveableComponent>(myEnemy);
        registry.emplace<BumpableComponent>(myEnemy, 
            [](entt::registry &reg, /*entt::entity src,*/ entt::entity target, Vector2 direction) -> ActionResult {
                
                // This will allow moving.
                return ActionResult(ActionResult::TryAgain, std::make_shared<GridMoveAction>(target, direction));

                // This will allow consuming.
                //std::wcout << "target " << (uint32_t)target << "\r\n";
                //return ActionResult(std::make_shared<GridConsumeAction>(target));

                // This will allow moving only by player.
                //entt::entity source = get_source_entity(reg, target, direction);
                //auto player = reg.try_get<PlayerComponent> (source);
                //if (player == nullptr) return ActionResult(false);
                //return ActionResult(ActionResult::TryAgain, std::make_shared<GridMoveAction>(target, direction));
            });
        registry.emplace<GridPositionComponent>(myEnemy, Vector2(5, 5));
        ctx.grid->set_position(Vector2(5, 5), myEnemy);
        //std::wcout << "myHero: " << (uint32_t)myEnemy << "\r\n";

        // Create a scheduler to run through systems.
        // TODO: Consider using a dependency graph of systems and using topo_sort.hpp
        // TODO: to ensure they execute in the correct order.

        // Note: ConsoleInputSystem needs to run first since we're not saving
        //       captured input across frames.
        // Note: EnTT claims that the scheduler is unordered. That said, the actual
        //       implementation runs each of them in reverse order of attachment.
        scheduler.attach<MovementSystem>(registry);
    }

    virtual void update(double delta)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Run through all the registered processes (i.e. systems).
        scheduler.update(delta, (void *)&xactionMap);

        // All input viewers complete. Clear the user input vector.
        xactionMap[L"input"]->clear();

        if (xactionMap[L"output"]->size() > 0)
        {
            // If there was actions to be done, send them to GUI 
            // and wait for the do_commit() response to make it so.
            // TODO: Put together the things to tween.
            /*
            std::vector<Vector2> srcpos;
            XAction &xaction = *xactionMap[L"output"];
            for (auto action = xaction.begin(); action != xaction.end(); action++) {
                entt::entity entity = (*action)->get_entity();
                auto &gpc = registry.get<GridPositionComponent>(entity);
                srcpos.push_back(gpc.position);
            }
            */

            adapter.on_updated_precommit(/*srcpos*/);
            ctx.input_allowed = false;
        }
    }

    virtual void do_commit()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        commit_xaction();
        adapter.on_updated();
        ctx.input_allowed = true;
    }

    virtual void player_move(Vector2 direction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        xactionMap[L"input"]->push_back(std::make_shared<GridMoveAction>(ctx.player, direction));
        //std::wcout << "Player moved. " << direction.getX() << " " << direction.getY() << "\r\n";
    }

    virtual int grid_width() const
    {
        const auto &ctx = registry.ctx<ConsoleEngineContext>();
        return ctx.grid->width;
    }

    virtual int grid_height() const
    {
        const auto &ctx = registry.ctx<ConsoleEngineContext>();
        return ctx.grid->height;
    }

    virtual std::unique_ptr<std::wstring> grid_ascii_state()
    {
        const auto &ctx = registry.ctx<ConsoleEngineContext>();
        const auto &grid = ctx.grid;
        std::unique_ptr<std::wstring> ascii_state;
        ascii_state = make_unique<std::wstring>(grid->width * grid->height, L'.');
        for (int y = 0; y < grid->height; ++y)
        {
            for (int x = 0; x < grid->width; ++x)
            {
                entt::entity entity = grid->get_position(Vector2(x, y));
                if (entity == grid->empty)
                {
                    ascii_state->replace(y * grid->height + x, 1, L".");
                    continue;
                }
                auto &ascii = registry.get<AsciiComponent>(entity);
                ascii_state->replace(y * grid->height + x, 1, &ascii.character);
            }
        }
        return std::move(ascii_state);
    }
};