#pragma once

#include <memory>

#include <model/Grid.hpp>
#include <dummy/PlayerControllerState.hpp>
#include <dummy/ITransaction.hpp>
#include <dummy/types.hpp>

class ConsoleEngineContext
{
public:

    // Engine state
    PlayerControllerState player_controller_state;
    int player_move_state = PLAYER_MOVE_LEVELSELECT_STATE;
    bool redraw = false;

    // Game state
    int current_level = 1;
    int last_level = 2; //7;
    std::unique_ptr<Grid> grid;
    
    // Level state
    entt::entity player;
    entt::entity potty;
    entt::entity toddler;
    bool goal_reached = false;

    std::list<std::unique_ptr<ITransaction>> new_xaction_list = {};
    std::list<std::unique_ptr<ITransaction>> pending_xaction_list = {};
    std::list<std::unique_ptr<ITransaction>> done_xaction_list = {};
};
