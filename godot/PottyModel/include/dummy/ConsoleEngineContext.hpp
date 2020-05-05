#pragma once

#include <memory>

#include <model/Grid.hpp>
#include <dummy/PlayerControllerState.hpp>
#include <dummy/ITransaction.hpp>
#include <dummy/types.hpp>

class ConsoleEngineContext
{
public:

    std::unique_ptr<Grid> grid;
    entt::entity player;
    //bool player_pulling = false;

    PlayerControllerState player_controller_state;
    int player_move_state = PLAYER_MOVE_WAITING_STATE;
    bool redraw = false;

    std::list<std::unique_ptr<ITransaction>> new_xaction_list = {};
    std::list<std::unique_ptr<ITransaction>> pending_xaction_list = {};

    std::list<std::unique_ptr<ITransaction>> done_xaction_list = {};
};
