#pragma once

#include <memory>

#include <model/Grid.hpp>
#include <dummy/PlayerControllerState.hpp>
#include <dummy/ITransaction.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/types.hpp>

class ConsoleEngineContext
{
    IConsoleEngine &engine;
    int happiness = 100;
    int bladder = 0;

public:

    ConsoleEngineContext(IConsoleEngine &engine) : engine(engine) {}

    // Engine state
    PlayerControllerState player_controller_state;
    int player_move_state = PLAYER_MOVE_GAMEOVER_STATE;
    bool redraw = false;

    // Game state
    int current_level = 0;
    int last_level = 6; // TODO: Automatic this.
    std::unique_ptr<Grid> grid;
    
    // Level state
    entt::entity player;
    entt::entity potty;
    entt::entity toddler;
    bool goal_reached = false;
    bool bladder_paused = true;
    
    int get_happiness()
    {
        return happiness;
    }

    void adjust_happiness(int value)
    {
        // TODO: Clamp to "maxHappiness".
        set_happiness(happiness + value);
    }

    void set_happiness(int value)
    {
        // TODO: Clamp to "maxHappiness".
        happiness = value;
        engine.happiness_updated(happiness);
        std::wcout << "Happiness: " << happiness << "\r\n"; redraw = true;
    }

    int get_bladder()
    {
        return bladder;
    }

    void adjust_bladder(int value)
    {
        // TODO: Clamp to "maxHappiness".
        set_bladder(bladder + value);
    }

    void set_bladder(int value)
    {
        // TODO: Clamp to "maxHappiness".
        bladder = value;
        engine.bladder_updated(bladder);
        std::wcout << "Bladder: " << bladder << "\r\n"; redraw = true;
    }

    void pause_bladder(bool value)
    {
        bladder_paused = value;
    }

    std::list<std::unique_ptr<ITransaction>> new_xaction_list = {};
    std::list<std::unique_ptr<ITransaction>> pending_xaction_list = {};
    std::list<std::unique_ptr<ITransaction>> done_xaction_list = {};
};
