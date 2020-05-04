#pragma once

#include <memory>

#include <model/Grid.hpp>
#include <dummy/PlayerControllerState.hpp>
#include <dummy/Transaction.hpp>

class ConsoleEngineContext
{
public:
    std::unique_ptr<Grid> grid;
    entt::entity player;
    //bool player_pulling = false;

    PlayerControllerState player_controller_state;
    bool player_move_pending = false;
    bool redraw = false;

    std::list<std::unique_ptr<Transaction>> new_xaction_list;
    std::list<std::unique_ptr<Transaction>> pending_xaction_list;
    std::list<std::unique_ptr<Transaction>> done_xaction_list;
};
