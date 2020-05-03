#pragma once

#include <utils/entt_wrap.hpp>

#include <dummy/components/common_components.hpp>
#include "IAction.hpp"

class AgeAction : public IAction
{

    entt::entity entity;
    int health_delta;
    double oldLastUpdated;
    double updateTime;

public:

    AgeAction(entt::entity entity, int health_delta, double updateTime) :
        entity(entity),
        health_delta(health_delta),
        updateTime(updateTime)
    {}

    ~AgeAction() {}

    void perform(entt::registry &registry)
    {
        //auto view = registry.view<HealthComponent>(entity);
        registry.get<HealthComponent>(entity).health += health_delta;
        oldLastUpdated = registry.get<HealthComponent>(entity).lastUpdated;
        registry.get<HealthComponent>(entity).lastUpdated = updateTime;
    }

    void unperform(entt::registry &registry)
    {
        //auto view = registry.view<HealthComponent>(entity);
        registry.get<HealthComponent>(entity).health -= health_delta;
        registry.get<HealthComponent>(entity).lastUpdated = oldLastUpdated;
    }

};