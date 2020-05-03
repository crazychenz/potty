#pragma once

#include <iostream>
#include <utils/entt_wrap.hpp>
#include <dummy/types.hpp>

// TODO: Replace console output with logger.
class MyAgingSystem : public entt::process<MyAgingSystem, double>
{
    const entt::registry &registry;
    double timePassed = 0.0;
public:
    MyAgingSystem(const entt::registry &registry) : registry(registry) {}

    void update(double delta, void *data) {
        timePassed += delta;
        //entt::simple_view<HealthComponent, NameComponent>
        auto view = registry.view<const HealthComponent, const NameComponent>();
        // TODO: Do a more C++ style cast here.
        XActionMap *xactionMap = (XActionMap *)data;
        
        for (auto entity: view) {
            const HealthComponent &h = registry.get<HealthComponent>(entity);
            const NameComponent &n = registry.get<NameComponent>(entity);
            //std::wcout << "Entity: " << n.name << " Health: " << h.health << "\r\n";

            if (timePassed - h.lastUpdated > 0.5)
            {
                // TODO: Create an action to modify the entity.
                // TODO: Populate the transaction with the action.
                //xaction->push_back(std::make_unique<AgeAction>(entity, -1, timePassed));
            }
        }
        //std::wcout << "MyAgingSystem updated.\r\n";

        // succeed();
    }
};