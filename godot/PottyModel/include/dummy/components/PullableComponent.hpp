#pragma once

class PullableComponent {
public:
    PullableComponent() : can_pull( [](auto &reg, auto ent, auto dir) -> bool {return true;} ) {}
    PullableComponent(std::function<
        bool (
            entt::registry&, /* registry */
            entt::entity, /* this entity */
            Vector2 /* delta to move (you'll find the puller in delta from current position.)*/
        )> lambda) : can_pull(lambda) {}
    std::function<bool (entt::registry&, entt::entity, Vector2)> can_pull;
};