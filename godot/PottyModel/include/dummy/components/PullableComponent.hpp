#pragma once

#include <functional>

#include <utils/entt_wrap.hpp>
#include <dummy/ITransaction.hpp>
#include <model/Vector2.hpp>

using PullableCondition = 
    std::function<bool (
        entt::registry&, /* registry */
        entt::entity, /* this entity */
        entt::entity, /* puller */
        Vector2, /* delta to move (you'll find the pusher opposite of direction of current position.) */
        std::unique_ptr<ITransaction> &xaction
    )>;

class PullableComponent {
public:
    PullableComponent() : can_pull( [](auto &reg, auto us, auto them, auto dir, auto &xaction) -> bool {return true;} ) {}
    PullableComponent(PullableCondition lambda) : can_pull(lambda) {}
    PullableCondition can_pull;
};