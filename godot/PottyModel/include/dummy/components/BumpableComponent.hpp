#pragma once

#include <utils/entt_wrap.hpp>

#include <dummy/actions/ActionResult.hpp>

#include <model/Vector2.hpp>

class BumpableComponent {
public:
    //                                               registry,        src,          dst,         tgt_position
    BumpableComponent(std::function<ActionResult (entt::registry&, entt::entity, /*entt::entity,*/ Vector2)> lambda) : bump(lambda) {}
    std::function<ActionResult (entt::registry&, entt::entity, /*entt::entity,*/ Vector2)> bump;
};
