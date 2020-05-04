#pragma once

#include <iostream> // for debug wcout

#include <time.h> // clock_gettime
#include <unistd.h> // usleep // TODO: Get rid of this.

#include <memory>
#include <vector>
#include <utils/entt_wrap.hpp>

#include <dummy/types.hpp>
#include <dummy/actions/common_actions.hpp>
#include <dummy/components/common_components.hpp>
#include <dummy/systems/AgingSystem.hpp>
#include <dummy/systems/ConsoleInputSystem.hpp>
#include <dummy/systems/MovementSystem.hpp>
#include <dummy/systems/ConsoleRenderSystem.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/actions/IAction.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/CommonEngine.hpp>

class ConsoleEngine : public CommonEngine
{
    bool running = true;
    double delta = 0.0;

public:

    ConsoleEngine() {

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
        std::wcout << "myHero: " << (uint32_t)myRock << "\r\n";

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
        std::wcout << "myHero: " << (uint32_t)myEnemy << "\r\n";

        // Create a scheduler to run through systems.
        // TODO: Consider using a dependency graph of systems and using topo_sort.hpp
        // TODO: to ensure they execute in the correct order.

        // Note: ConsoleInputSystem needs to run first since we're not saving
        //       captured input across frames.
        // Note: EnTT claims that the scheduler is unordered. That said, the actual
        //       implementation runs each of them in reverse order of attachment.
        scheduler.attach<ConsoleRenderSystem>(cregistry);
        scheduler.attach<MyAgingSystem>(cregistry);
        scheduler.attach<MovementSystem>(registry);
        scheduler.attach<ConsoleInputSystem>(registry, *this);

    }

    virtual void start()
    {
        struct timespec tstart={0,0}, tend={0,0};
        std::wcout << "Now waiting for user input.\r\n";
        while(running){
            clock_gettime(CLOCK_MONOTONIC, &tstart);

            // Create a transaction object to use for this frame.
            xactionMap[L"output"] = std::make_unique<XAction>();
            xactionMap[L"input"] = std::make_unique<XAction>();

            // Run through all the registered processes (i.e. systems).
            scheduler.update(delta, (void *)&xactionMap);

            // All input viewers complete. Clear the user input vector.
            xactionMap[L"input"]->clear();

            // TODO: After the scheduler runs, commit/defer the returned actions.
            // TODO: Consider allowing for deferred transactions here.
            commit_xaction();

            clock_gettime(CLOCK_MONOTONIC, &tend);

            delta = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
        }
    }

    virtual void stop()
    {
        running = false;
    }
};