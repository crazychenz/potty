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
#ifdef CONSOLE_BUILD
#include <dummy/systems/ConsoleInputSystem.hpp>
#endif
#include <dummy/systems/PlayerMovementSystem.hpp>
#include <dummy/systems/ConsoleRenderSystem.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/actions/IAction.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/CommonEngine.hpp>
#include <dummy/IPottyModel.hpp>

class ConsoleEngine : public CommonEngine
{
    IPottyModel &adapter;
    bool running = true;
    double delta = 0.0;
    double timePassed = 0.0;
    double metaTimeout = 0.2;
    PlayerMovementSystem pms;
    ConsoleRenderSystem crs;
    #ifdef CONSOLE_BUILD
    ConsoleInputSystem cis;
    #endif
public:

    ConsoleEngine(IPottyModel &pottyModel) :
        adapter(pottyModel),
        crs(registry),
        #ifdef CONSOLE_BUILD
        cis(registry, *this),
        #endif
        pms(registry)
    {
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

        auto myPotty = registry.create();
        registry.emplace<NameComponent>(myPotty, L"myPotty");
        registry.emplace<AsciiComponent>(myPotty, L'P');
        registry.emplace<MovableComponent>(myPotty, [](entt::registry &reg, entt::entity target, Vector2 direction) -> bool {
            return false;
        });
        registry.emplace<GridPositionComponent>(myPotty, Vector2(7, 7));
        ctx.grid->set_position(Vector2(7, 7), myPotty);
        std::wcout << "myPotty: " << (uint32_t)myPotty << "\r\n";

        // Create a scheduler to run through systems.
        // TODO: Consider using a dependency graph of systems and using topo_sort.hpp
        // TODO: to ensure they execute in the correct order.

        // Note: ConsoleInputSystem needs to run first since we're not saving
        //       captured input across frames.
        // Note: EnTT claims that the scheduler is unordered. That said, the actual
        //       implementation runs each of them in reverse order of attachment.
        //scheduler.attach<ConsoleRenderSystem>(registry);
        //scheduler.attach<MyAgingSystem>(cregistry);
        //scheduler.attach<PlayerMovementSystem>(registry);
        //scheduler.attach<ConsoleInputSystem>(registry, *this);
    }

    virtual void start()
    {

        struct timespec tstart={0,0}, tend={0,0};
        std::wcout << "Now waiting for user input.\r\n";
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        while(running){
            clock_gettime(CLOCK_MONOTONIC, &tstart);

            update(delta);

            do_commit();

            // Re-enable player input after transaction committed.

            clock_gettime(CLOCK_MONOTONIC, &tend);

            delta = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
        }
    }

    virtual void stop()
    {
        running = false;
    }




    virtual void update(double delta)
    {
        timePassed += delta;
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        metaTimeout -= delta;
        if (metaTimeout < 0.0)
        {
            // Send meta update
            std::string meta = 
                "timePassed: " + std::to_string(timePassed) + "\n" +
                "delta: " + std::to_string(delta) + "\n" +
                "ctx.player_move_state = " + std::to_string(ctx.player_move_state) + "\n" +
                "ctx.new_xaction_list.size = " + std::to_string(ctx.new_xaction_list.size()) + "\n" +
                "ctx.pending_xaction_list.size = " + std::to_string(ctx.new_xaction_list.size()) + "\n" +
                "ctx.done_xaction_list.size = " + std::to_string(ctx.done_xaction_list.size()) + "\n";
            adapter.meta_update(meta);
            metaTimeout = 0.001;
        }

        // Run through all the registered processes (i.e. systems).
        //scheduler.update(delta);
        #ifdef CONSOLE_BUILD
        cis.update(delta);
        #endif

        pms.update(delta);

        #ifdef CONSOLE_BUILD
        crs.update(delta);
        #endif

        // Note: The direction state is reset each frame.
        // TODO: Is this desired? It doesn't work if you remove it.
        ctx.player_controller_state.direction = Vector2(0, 0);

        if (ctx.new_xaction_list.size() > 0)
        {
            // Generate list of simple moves from new_xaction list.
            std::unique_ptr<std::vector<Vector2>> simple_moves = std::make_unique<std::vector<Vector2>>();
            for (auto xitr = ctx.new_xaction_list.begin(); xitr != ctx.new_xaction_list.end(); ++xitr)
            {
                for (auto itr = (*xitr)->get_list().begin(); itr != (*xitr)->get_list().end(); ++itr)
                {
                    //std::wcout << "move " << (*actitr)->get_next() << "\r\n";
                    simple_moves->push_back((*itr)->get_prev());
                    simple_moves->push_back((*itr)->get_next());
                }
            }
            adapter.on_updated_precommit(std::move(simple_moves));
        }

        // Move new xactions to pending xactions.
        while (ctx.new_xaction_list.size() > 0)
        {
            // Move new xactions to pending.
            ctx.pending_xaction_list.push_back(std::move(ctx.new_xaction_list.front()));
            ctx.new_xaction_list.pop_front();
        }
    }

    virtual void do_commit()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        if (ctx.player_move_state != PLAYER_MOVE_PENDING_STATE) return;
        //std::wcout << "ctx.player_move_state = PLAYER_MOVE_COMMIT_STATE\r\n";
        ctx.player_move_state = PLAYER_MOVE_COMMIT_STATE;

        // Note: This is where we wait for GUI completion notification
        //       -- OR -- internal flush due to some NPC actor.

        // Flush pending xactions.
        // TODO: We should be able to flush a range from time to past.
        for (auto itr = ctx.pending_xaction_list.begin(); itr != ctx.pending_xaction_list.end(); ++itr)
        {
            (*itr)->commit(registry);
        }

        // Now we move everything from pending to done.
        // Note: This will become the Undo list.
        while (ctx.pending_xaction_list.size() > 0)
        {
            // Move new xactions to pending.
            ctx.done_xaction_list.push_back(std::move(ctx.pending_xaction_list.front()));
            ctx.pending_xaction_list.pop_front();
        }

        // Everything *should* be OK, but we resend the board state updated anyway.
        adapter.on_updated();

        //std::wcout << "ctx.player_move_state = PLAYER_MOVE_WAITING_STATE\r\n";
        ctx.player_move_state = PLAYER_MOVE_WAITING_STATE;
    }

    // Note: Godot needs to set this to (0, 0) when nothing is pressed.
    virtual void player_move(Vector2 direction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        if (ctx.player_move_state != PLAYER_MOVE_WAITING_STATE) return;

        ctx.player_controller_state.direction = direction;
        if (direction != Vector2(0, 0))
        {
            //std::wcout << "ctx.player_move_state = PLAYER_MOVE_PROCESSING_STATE " << direction << "\r\n";
            ctx.player_move_state = PLAYER_MOVE_PROCESSING_STATE;
        }
    }

    virtual void player_pull(bool value)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        if (ctx.player_move_state != PLAYER_MOVE_WAITING_STATE) return;

        ctx.player_controller_state.pulling = value;
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