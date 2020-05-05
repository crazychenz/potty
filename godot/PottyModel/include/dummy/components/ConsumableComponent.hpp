#pragma once

#include <functional>

#include <utils/entt_wrap.hpp>
#include <dummy/ITransaction.hpp>
#include <model/Vector2.hpp>

using ConsumableCondition = 
    std::function<bool (
        entt::registry&, /* registry */
        entt::entity, /* this entity */
        entt::entity, /* consumer */
        std::unique_ptr<ITransaction> &xaction
    )>;

using ConsumableProcessor = 
    std::function<void (
        entt::registry&, /* registry */
        entt::entity, /* this entity */
        entt::entity, /* consumer */
        std::unique_ptr<ITransaction> &xaction
    )>;

class ConsumableComponent {
public:
    ConsumableComponent() : 
        can_consume( [](auto &reg, auto ent, auto dir, auto &xaction) -> bool {return true;} ),
        consume( [](auto &reg, auto ent, auto dir, auto &xaction) {} )
    {}
    ConsumableComponent(ConsumableCondition cond) : can_consume(cond) {}
    ConsumableComponent(ConsumableProcessor proc) : consume(proc) {}
    ConsumableComponent(ConsumableCondition cond, ConsumableProcessor proc) : 
        can_consume(cond), consume(proc)
    {}
    ConsumableCondition can_consume;
    ConsumableProcessor consume;
};