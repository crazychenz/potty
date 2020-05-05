#pragma once

#include <functional>

#include <utils/entt_wrap.hpp>
#include <dummy/ITransaction.hpp>
#include <model/Vector2.hpp>

using PushableCondition = 
    std::function<bool (
        entt::registry&, /* registry */
        entt::entity, /* this entity */
        entt::entity, /* pusher */
        Vector2, /* delta to move (you'll find the pusher opposite of direction of current position.) */
        std::unique_ptr<ITransaction> &xaction
    )>;

class PushableComponent {
public:
    PushableComponent() : can_push( [](auto &reg, auto us, auto them, auto dir, auto &xaction) -> bool {return true;} ) {}
    PushableComponent(PushableCondition lambda) : can_push(lambda) {}
    PushableCondition can_push;
};