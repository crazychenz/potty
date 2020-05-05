#pragma once

#include <utils/entt_wrap.hpp>

class IAction
{
public:
    virtual ~IAction() {}

    //virtual ActionResult actout(const entt::registry &registry) {}
    //virtual ActionResult update(const entt::registry &registry, double delta = 0, void *data = nullptr) {}
    //virtual ActionResult update(entt::registry &registry, double delta = 0, void *data = nullptr) {}
    virtual void perform(entt::registry &registry) {}
    virtual void unperform(entt::registry &registry) {}
    virtual Vector2 get_next() {}
    virtual Vector2 get_prev() {}
    /*virtual entt::entity get_entity() { return entity; }*/
};