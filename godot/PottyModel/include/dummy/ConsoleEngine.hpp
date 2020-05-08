#pragma once

#include <time.h> // clock_gettime

#include <iostream>
#include <fstream>
#include <memory>
#include <vector>

#if (__GNUC__ <= 7) || defined(__clang__)
    #include <experimental/filesystem>
    namespace filesystem = std::experimental::filesystem;
#else
    #include <filesystem>
    namespace filesystem = std::filesystem;
#endif

#include <utils/entt_wrap.hpp>

#include <dummy/types.hpp>
#include <dummy/actions/common_actions.hpp>
#include <dummy/components/common_components.hpp>
#include <dummy/systems/AgingSystem.hpp>
#ifdef CONSOLE_BUILD
#include <dummy/systems/ConsoleInputSystem.hpp>
#endif
#include <dummy/systems/PlayerMovementSystem.hpp>
#include <dummy/systems/BladderSystem.hpp>
#include <dummy/systems/ConsoleRenderSystem.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/actions/IAction.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/IPottyModel.hpp>

#include <json/json.h>

class ConsoleEngine : public IConsoleEngine
{
    IPottyModel &adapter;
    bool running = true;
    double delta = 0.0;
    double timePassed = 0.0;
    double metaTimeout = 0.2;
    PlayerMovementSystem pms;
    BladderSystem bladder;
    ConsoleRenderSystem crs;
    #ifdef CONSOLE_BUILD
    ConsoleInputSystem cis;
    #endif

    entt::registry registry;

    Json::Value config;

    void parse_config(const char *config_path)
    {
        std::ifstream config_doc(config_path, std::ifstream::binary);
        config_doc >> config;
    }

    void init()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        int width = config["grid"]["width"].asInt();
        int height = config["grid"]["height"].asInt();
        ctx.grid = std::make_unique<Grid>(width, height, registry.create());
    }

    void generate_player(char ascii, int x, int y)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto entity = registry.create();

        registry.emplace<PushableComponent>(entity);
        registry.emplace<PullableComponent>(entity);
        registry.emplace<HealthComponent>(entity, 100);
        registry.emplace<NameComponent>(entity, L"myHero");
        registry.emplace<AsciiComponent>(entity, L'*');
        registry.emplace<GridPositionComponent>(entity, Vector2(x, y));
        ctx.grid->set_position(Vector2(x, y), entity);
        ctx.player = entity;
    }

    void generate_toddler(char ascii, int x, int y)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto entity = registry.create();

        registry.emplace<HealthComponent>(entity, 100);
        registry.emplace<NameComponent>(entity, L"myEnemy");
        registry.emplace<AsciiComponent>(entity, L'T');
        registry.emplace<PushableComponent>(entity,
        [](auto &reg, auto us, auto them, auto dir, auto &xaction) -> bool {
            xaction->push_back(std::make_shared<HappinessAction>(us, -5));
            return true;
        });
        registry.emplace<PullableComponent>(entity,
        [](auto &reg, auto us, auto them, auto dir, auto &xaction) -> bool {
            xaction->push_back(std::make_shared<HappinessAction>(us, -5));
            return true;
        });
        registry.emplace<GridPositionComponent>(entity, Vector2(x, y));
        ctx.grid->set_position(Vector2(x, y), entity);
        ctx.toddler = entity;
    }

    void generate_potty(char ascii, int x, int y)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto entity = registry.create();

        registry.emplace<NameComponent>(entity, L"myPotty");
        registry.emplace<AsciiComponent>(entity, L'P');
        registry.emplace<ConsumableComponent>(entity, 
        [](auto &registry, auto consumed, auto consumer, auto &xaction) -> bool {
            return true;
        },
        [](auto &registry, auto consumed, auto consumer, auto &xaction) -> void {
            auto &ctx = registry.template ctx<ConsoleEngineContext>();
            if (consumed == ctx.potty && consumer == ctx.toddler)
            {
                auto &gpc = registry.template get<GridPositionComponent>(consumed);
                xaction->push_back(std::make_shared<SinglePottyAction>(consumed, gpc.position));
            }
        });
        registry.emplace<GridPositionComponent>(entity, Vector2(x, y));
        ctx.grid->set_position(Vector2(x, y), entity);
        ctx.potty = entity;
    }

    void generate_chicken(char ascii, int x, int y)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        auto entity = registry.create();

        registry.emplace<NameComponent>(entity, L"myChicken");
        registry.emplace<AsciiComponent>(entity, L'C');
        registry.emplace<ConsumableComponent>(entity, 
        [](auto &registry, auto consumed, auto consumer, auto &xaction) -> bool {
            return true;
        },
        [](auto &registry, auto consumed, auto consumer, auto &xaction) -> void {
            auto &ctx = registry.template ctx<ConsoleEngineContext>();
            if (consumer == ctx.toddler)
            {
                // Consumer is baby, it's happiness is increased.
                xaction->push_back(std::make_shared<HappinessAction>(consumer, 10));
            }

            // Everything can consume this object.
            auto &gpc = registry.template get<GridPositionComponent>(consumed);
            xaction->push_back(std::make_shared<SingleRemoveAction>(consumed, gpc.position));
        });
        registry.emplace<GridPositionComponent>(entity, Vector2(x, y));
        ctx.grid->set_position(Vector2(x, y), entity);
        ctx.potty = entity;
    }

    void generate_ascii_entity(char ascii, int x, int y)
    {
        entt::entity entity;
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        switch (ascii)
        {
            case '*':
                generate_player(ascii, x, y);
                break;
            case 'P':
                generate_potty(ascii, x, y);
                break;
            case 'T':
                generate_toddler(ascii, x, y);
                break;
            case 'C':
                generate_chicken(ascii, x, y);
                break;
            case 'W':
                entity = registry.create();
                registry.emplace<NameComponent>(entity, L"myWall");
                registry.emplace<AsciiComponent>(entity, L'W');
                registry.emplace<GridPositionComponent>(entity, Vector2(x, y));
                ctx.grid->set_position(Vector2(x, y), entity);
                break;
            case 'D':
                entity = registry.create();
                registry.emplace<PushableComponent>(entity);
                registry.emplace<PullableComponent>(entity);
                registry.emplace<NameComponent>(entity, L"myDuck");
                registry.emplace<AsciiComponent>(entity, L'D');
                registry.emplace<GridPositionComponent>(entity, Vector2(x, y));
                ctx.grid->set_position(Vector2(x, y), entity);
                break;
        }
    }

    void load_level(int level_idx)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Clear the current volatile entities and grid.
        ctx.grid->clear();
        // TODO: Should be registry<GridPositionComponent>.clear()?
        registry.clear();
        ctx.goal_reached = false;
        ctx.redraw = true;
        // Wipe action lists
        ctx.new_xaction_list.clear();
        ctx.pending_xaction_list.clear();
        ctx.done_xaction_list.clear();
        ctx.set_happiness(100);
        ctx.set_bladder(0);

        const Json::Value layout = config["levels"][level_idx]["layout"];

        for (int y = 0; y < layout.size(); ++y)
        {
            const char *row = layout[y].asCString();
            for (int x = 0; x < std::strlen(row); ++x)
            {
                generate_ascii_entity(row[x], x, y);
            }
        }

        ctx.pause_bladder(false);
    }

    int get_current_stars()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        const Json::Value level = config["levels"][ctx.current_level];
        if (ctx.get_bladder() < level["3stars"]["bladderLessThan"].asInt() &&
                ctx.get_happiness() > level["3stars"]["happinessGreaterThan"].asInt())
        {
            return 3;
        }
        if (ctx.get_bladder() < level["2stars"]["bladderLessThan"].asInt() &&
                ctx.get_happiness() > level["2stars"]["happinessGreaterThan"].asInt())
        {
            return 2;
        }
        if (ctx.get_bladder() < level["1stars"]["bladderLessThan"].asInt() &&
                ctx.get_happiness() > level["1stars"]["happinessGreaterThan"].asInt())
        {
            return 1;
        }
        return 0;
    }

public:

    ConsoleEngine(IPottyModel &pottyModel, const char *config_path = "../potty-config.json") :
        registry(),
        adapter(pottyModel),
        crs(registry),
        #ifdef CONSOLE_BUILD
        cis(registry, *this),
        #endif
        pms(registry),
        bladder(registry)
    {
        registry.set<ConsoleEngineContext>(*this);
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        std::wcout << "Current path is " << filesystem::current_path() << "\r\n";
        std::wcout << "loading config from " << config_path << "\r\n";

        parse_config(config_path);
        init();

    }

    virtual void reset_level()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        load_level(ctx.current_level);
        ctx.player_move_state = PLAYER_MOVE_WAITING_STATE;
    }

    virtual void start_new_game()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        ctx.current_level = 0;
        reset_level();
    }

    virtual void next_level()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        ctx.current_level += 1;
        reset_level();
    }

    virtual void happiness_updated(int value)
    {
        adapter.happiness_updated(value);
    }

    virtual void bladder_updated(int value)
    {
        adapter.bladder_updated(value);
    }

    virtual void pause_bladder(bool value)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        ctx.pause_bladder(value);
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

        if (ctx.get_bladder() >= 100 || ctx.get_happiness() <= 0)
        {
            ctx.player_move_state = PLAYER_MOVE_GAMEOVER_STATE;
            adapter.game_failed();
            return;
        }

        #ifdef CONSOLE_BUILD
        cis.update(delta);
        #endif

        pms.update(delta);
        bladder.update(delta);

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

        // Run through all the registered processes (i.e. systems).
        //scheduler.update(delta);
        if (ctx.goal_reached)
        {
            if (ctx.current_level == ctx.last_level)
            {
                ctx.player_move_state = PLAYER_MOVE_GAMEOVER_STATE;
                adapter.game_beat(get_current_stars());
                return;
            }
            ctx.player_move_state = PLAYER_MOVE_LEVELSELECT_STATE;
            adapter.goal_reached(get_current_stars());
            return;
        }

        ctx.player_move_state = PLAYER_MOVE_WAITING_STATE;
    }

    virtual bool currently_playing()
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        return ctx.player_move_state != PLAYER_MOVE_GAMEOVER_STATE;
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