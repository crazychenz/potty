#pragma once

#include <iostream> // for debug wcout

#include <memory>
#include <vector>
#include <utils/entt_wrap.hpp>

#include <dummy/types.hpp>
#include <dummy/actions/common_actions.hpp>
#include <dummy/components/common_components.hpp>
#include <dummy/systems/PlayerMovementSystem.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/actions/IAction.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/CommonEngine.hpp>

#include <dummy/IPottyModel.hpp>

class GodotModelEngine : public CommonEngine
{
    IPottyModel &adapter;

    PlayerMovementSystem pms;

public:

    GodotModelEngine(IPottyModel &pottyModel) : 
            adapter(pottyModel),
            pms(registry)
    {

        // Create a transaction object to use for this frame.
        //xactionMap[L"output"] = std::make_unique<XAction>();
        //xactionMap[L"input"] = std::make_unique<XAction>();

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
        //scheduler.attach<MovementSystem>(registry);
    }

    virtual void update(double delta)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Run through all the registered processes (i.e. systems).
        //scheduler.update(delta);
        pms.update(delta);

/*
        if (ctx.new_xaction_list.size() > 0)
        {
            // TODO: Generate list of simple moves from new_xaction list.
            std::wcout << "HERE3\r\n";

            std::unique_ptr<std::vector<Vector2>> simple_moves = std::make_unique<std::vector<Vector2>>();
            for (std::list<std::unique_ptr<ITransaction>>::iterator xitr = ctx.new_xaction_list.begin(); xitr != ctx.new_xaction_list.end(); ++xitr)
            {
                std::unique_ptr<ITransaction> &xaction = *xitr;
                std::vector<std::shared_ptr<IAction>>& action_list = xaction->get_list();
                std::wcout << "action_list size " << action_list.size() << "\r\n";
                for (auto itr = action_list.begin(); itr != action_list.end(); ++itr)
                {
                    //std::wcout << "move " << (*itr)->get_next() << "\r\n";
                    simple_moves->push_back((*itr)->get_prev());
                    simple_moves->push_back((*itr)->get_next());
                }
            }
            std::wcout << "HERE4\r\n";
        }
*/

        if (ctx.new_xaction_list.size() > 0)
        {
            // TODO: Generate list of simple moves from new_xaction list.
            std::wcout << "HERE3\r\n";

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
            std::wcout << "HERE4\r\n";
            adapter.on_updated_precommit(std::move(simple_moves));
            std::wcout << "HERE5\r\n";
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
    }

    // Note: Godot needs to set this to (0, 0) when nothing is pressed.
    virtual void player_move(Vector2 direction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        ctx.player_controller_state.direction = direction;
        ctx.player_move_pending = true;
        //xactionMap[L"input"]->push_back(std::make_shared<GridMoveAction>(ctx.player, direction));
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