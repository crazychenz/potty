#pragma once

#include <string>

#include <model/Vector2.hpp>

class GridPositionComponent
{
public:
    GridPositionComponent() {}
    GridPositionComponent(Vector2 position) : position(position) {}
    Vector2 position;
};