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
#include <dummy/systems/PlayerMovementSystem.hpp>
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
        registry.emplace<MovableComponent>(myHero);
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
        registry.emplace<MovableComponent>(myRock);
        registry.emplace<GridPositionComponent>(myRock, Vector2(5, 4));
        ctx.grid->set_position(Vector2(5, 4), myRock);
        std::wcout << "myRock: " << (uint32_t)myRock << "\r\n";

        auto myEnemy = registry.create();
        registry.emplace<HealthComponent>(myEnemy, 100);
        registry.emplace<NameComponent>(myEnemy, L"myEnemy");
        registry.emplace<AsciiComponent>(myEnemy, L'T');
        registry.emplace<MovableComponent>(myEnemy);
        registry.emplace<GridPositionComponent>(myEnemy, Vector2(5, 5));
        ctx.grid->set_position(Vector2(5, 5), myEnemy);
        std::wcout << "myEnemy: " << (uint32_t)myEnemy << "\r\n";

        // Create a scheduler to run through systems.
        // TODO: Consider using a dependency graph of systems and using topo_sort.hpp
        // TODO: to ensure they execute in the correct order.

        // Note: ConsoleInputSystem needs to run first since we're not saving
        //       captured input across frames.
        // Note: EnTT claims that the scheduler is unordered. That said, the actual
        //       implementation runs each of them in reverse order of attachment.
        scheduler.attach<ConsoleRenderSystem>(registry);
        //scheduler.attach<MyAgingSystem>(cregistry);
        scheduler.attach<PlayerMovementSystem>(registry);
        scheduler.attach<ConsoleInputSystem>(registry, *this);
    }

    

    virtual void start()
    {
        ConsoleRenderSystem crs(registry);
        PlayerMovementSystem pms(registry);
        ConsoleInputSystem cis(registry, *this);
        struct timespec tstart={0,0}, tend={0,0};
        std::wcout << "Now waiting for user input.\r\n";
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        while(running){
            clock_gettime(CLOCK_MONOTONIC, &tstart);

            // Create a transaction object to use for this frame.
            //xactionMap[L"output"] = std::make_unique<XAction>();
            //xactionMap[L"input"] = std::make_unique<XAction>();

            // Run through all the registered processes (i.e. systems).
            //scheduler.update(delta);
            cis.update(delta);
            if (ctx.player_move_pending == true)
            {
                int j = 4;
            }
            pms.update(delta);
            crs.update(delta);

            // Note: The direction state is reset each frame in console version.
            ctx.player_controller_state.direction = Vector2(0, 0);

            // Note: If we had a tween, we'd advertise any new transactions to tween here.

            // Move new xactions to pending xactions.
            while (ctx.new_xaction_list.size() > 0)
            {
                // Move new xactions to pending.
                ctx.pending_xaction_list.push_back(std::move(ctx.new_xaction_list.front()));
                ctx.new_xaction_list.pop_front();
            }

            // Note: This is where we wait for GUI completion notification or internal flush.

            // Flush pending xactions.
            // TODO: We should be able to flush a range from time to past.
            for (auto itr = ctx.pending_xaction_list.begin(); itr != ctx.pending_xaction_list.end(); ++itr)
            {
                commit_xaction(*itr);
            }

            // Now we move everything from pending to done.
            while (ctx.pending_xaction_list.size() > 0)
            {
                // Move new xactions to pending.
                ctx.done_xaction_list.push_back(std::move(ctx.pending_xaction_list.front()));
                ctx.pending_xaction_list.pop_front();
            }

            // Re-enable player input after transaction committed.

            clock_gettime(CLOCK_MONOTONIC, &tend);

            delta = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
        }
    }

    virtual void stop()
    {
        running = false;
    }
};