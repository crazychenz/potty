#pragma once

#include <memory>

#include <utils/entt_wrap.hpp>

#include <dummy/components/common_components.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <model/Vector2.hpp>
#include "IAction.hpp"

// TODO: Replace this with logger.
#include <iostream>

class HappinessAction : public IAction
{
    entt::entity entity;
    int old_happiness;
    int happiness_delta;

public:

    HappinessAction(entt::entity entity, int delta) :
        entity(entity),
        happiness_delta(delta)
    {}

    ~HappinessAction() {}

    entt::entity get_entity() { return entity; }

    void perform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        old_happiness = ctx.get_happiness();
        ctx.adjust_happiness(happiness_delta);
        std::wcout << "Happiness (perform): " << ctx.get_happiness() << "\r\n"; ctx.redraw = true;
    }

    void unperform(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        ctx.set_happiness(old_happiness);
        std::wcout << "Happiness (unperform): " << ctx.get_happiness() << "\r\n"; ctx.redraw = true;
    }

};