#pragma once

#include <utils/entt_wrap.hpp>

#include <dummy/actions/ActionResult.hpp>

#include <model/Vector2.hpp>

class BumpableComponent {
public:
    //                                               registry,        src,          dst,         tgt_position
    BumpableComponent(std::function<ActionResult (entt::registry&, entt::entity, /*entt::entity,*/ Vector2)> lambda) : bump(lambda) {}
    std::function<ActionResult (entt::registry&, entt::entity, /*entt::entity,*/ Vector2)> bump;

    MOVABLE_IF
    CONSUMABLE_IF


};


[](entt::registry &reg, /*entt::entity src,*/ entt::entity target, Vector2 direction) -> ActionResult {
                
                // This will allow moving.
                return ActionResult(ActionResult::TryAgain, std::make_shared<GridMoveAction>(target, direction));

                // This will allow consuming.
                //std::wcout << "target " << (uint32_t)target << "\r\n";
                //return ActionResult(std::make_shared<GridConsumeAction>(target));

                // This will allow moving only by player.
                //entt::entity source = get_source_entity(reg, target, direction);
                //auto player = reg.try_get<PlayerComponent> (source);
                //if (player == nullptr) return ActionResult(false);
                //return ActionResult(ActionResult::TryAgain, std::make_shared<GridMoveAction>(target, direction));
            });