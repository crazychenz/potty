#pragma once

#include <vector>
#include <memory>
#include <map>
#include <dummy/actions/IAction.hpp>

using XAction = std::vector<std::shared_ptr<IAction>>;
using XActionMap = std::map<std::wstring, std::unique_ptr<XAction>>;

// Player movement system states
const int PLAYER_MOVE_WAITING_STATE = 0;
const int PLAYER_MOVE_PROCESSING_STATE = 1;
const int PLAYER_MOVE_PENDING_STATE = 2;
const int PLAYER_MOVE_COMMIT_STATE = 3;
const int PLAYER_MOVE_LEVELSELECT_STATE = 4;
const int PLAYER_MOVE_GAMEOVER_STATE = 5;

/*
    State Machine
----------------------


 ------------ LEVELSELECT <--------
 |                ^               |
 V                |               |
WAITING <------ COMMIT  ------> GAMEOVER
 |   ^             ^
 |   |             |
 V   |             |
PROCESSING ---> PENDING

WAITING -> PROCESSING - Transition when input gathered from user.
PROCESSING -> WAITING - User input/transaction request rejected.
PROCESSING -> PENDING - User input/transaction accepted.
PENDING -> COMMIT - Visual phase complete.
COMMIT -> WAITING - Commit phase complete.


*/