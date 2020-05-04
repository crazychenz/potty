#pragma once

class MovableComponent {
public:
    MovableComponent() : can_move( [](auto &reg, auto ent, auto dir) -> bool {return true;} ) {}
    MovableComponent(std::function<
        bool (
            entt::registry&, /* registry */
            entt::entity, /* this entity */
            Vector2 /* delta to move */
        )> lambda) : can_move(lambda) {}
    std::function<bool (entt::registry&, entt::entity, Vector2)> can_move;
};