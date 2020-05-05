#pragma once

class ConsumableComponent {
public:
    ConsumableComponent() : can_consume( [](auto &reg, auto ent, auto dir) -> bool {return true;} ) {}
    ConsumableComponent(std::function<
        bool (
            entt::registry&, /* registry */
            entt::entity, /* this entity */
            entt::entity, /* consumer */
        )> lambda) : can_consume(lambda) {}
    std::function<bool (entt::registry&, entt::entity, Vector2)> can_consume;
};