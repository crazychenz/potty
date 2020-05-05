#pragma once

class PushableComponent {
public:
    PushableComponent() : can_push( [](auto &reg, auto ent, auto dir) -> bool {return true;} ) {}
    PushableComponent(std::function<
        bool (
            entt::registry&, /* registry */
            entt::entity, /* this entity */
            Vector2 /* delta to move (you'll find the pusher opposite of direction of current position.) */
        )> lambda) : can_push(lambda) {}
    std::function<bool (entt::registry&, entt::entity, Vector2)> can_push;
};