#pragma once

#include <memory>
#include <utils/entt_wrap.hpp>

#include <model/Vector2.hpp>

using namespace std;

class Grid {

private:

    entt::entity grid[8][8];

public:

    void clear()
    {
        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x < width; ++x)
            {
                grid[y][x] = empty;
            }
        }
    }
    Grid() : width(1), height(1) { clear(); }
    Grid(int width, int height, entt::entity empty) : width(width), height(height), empty(empty) { clear(); }
    virtual ~Grid() {}

    void set_position(Vector2 position, entt::entity entity) {
        grid[position.getY()][position.getX()] = entity;
        dirty = true;
    }

    entt::entity get_position(Vector2 position) const {
        return grid[position.getY()][position.getX()];
    }

    bool isPositionValid(const Vector2 &pos) const {
        return pos.getX() >= 0 && pos.getY() >= 0 && pos.getX() < width && pos.getY() < height;
    }

    int width;
    int height;

    // This is not atomic safe, but I really don't care.
    bool dirty;
    entt::entity empty;

};
