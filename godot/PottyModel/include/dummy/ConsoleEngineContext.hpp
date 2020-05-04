#pragma once

#include <memory>

#include <model/Grid.hpp>

class ConsoleEngineContext
{
public:
    std::unique_ptr<Grid> grid;
    entt::entity player;
    bool player_pulling = false;
    bool input_allowed = true;
};