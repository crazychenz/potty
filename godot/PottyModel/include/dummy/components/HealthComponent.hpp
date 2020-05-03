#pragma once

#include <string>

#include <utils/entt_wrap.hpp>

class HealthComponent
{
public:
    int health = 100;
    double lastUpdated = 0.0;
};