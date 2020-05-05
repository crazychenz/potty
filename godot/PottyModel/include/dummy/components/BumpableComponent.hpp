#pragma once

#include <functional>

#include <utils/entt_wrap.hpp>
#include <dummy/ITransaction.hpp>
#include <model/Vector2.hpp>

using BumpableCondition = 
    std::function<bool (
        entt::registry&, /* registry */
        entt::entity, /* this entity */
        entt::entity, /* bumper */
        Vector2, /* direction */
        std::unique_ptr<ITransaction> &xaction
    )>;

class BumpableComponent {
public:
    BumpableComponent() : bump( [](auto &reg, auto us, auto them, auto dir, auto &xaction) -> bool {return true;} ) {}
    BumpableComponent(BumpableCondition lambda) : bump(lambda) {}
    BumpableCondition bump;
};