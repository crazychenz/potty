#pragma once

#include <iostream>
#include <memory>
#include <utils/entt_wrap.hpp>
#include <dummy/types.hpp>

/*
    Note: implicit 'bump reactions' should be encoded into the design.

    An algorithm for processing input actions that return output actions.
    void process() {
        var action = actors[_currentActor].getAction();
        if (action == null) return;
        while (true) {
            var result = action.perform();
            if (!result.succeeded) return;
            if (result.alternate == null) break;
            action = result.alternate;
        }
        _currentActor = (_currentActor + 1) % actors.length;
    }
*/

// TODO: Replace console output with logger.
class MovementSystem : public entt::process<MovementSystem, double>
{
    entt::registry &registry;
    double timePassed = 0.0;
public:
    MovementSystem(entt::registry &registry) : registry(registry) {}

    void process(std::shared_ptr<IAction> input_action, std::unique_ptr<XAction> &output)
    {
        std::shared_ptr<IAction> action = input_action;

        // TODO: We may no longer need action result.
        ActionResult result = action->update(registry);

        // If the update returns false, do nothing.
        if (result.result == ActionResult::Rejected) return;

        // For now, just forward to the output action list.
        //std::wcout << "Input actions processed\r\n";
        output->push_back(action);
    }

    void update(double delta, void *data) {
        timePassed += delta;

        XActionMap &xactionMap = *((XActionMap *)data);

        // TODO: Make this recursively push everything in its path.
        for (auto action_itr = xactionMap[L"input"]->begin(); action_itr != xactionMap[L"input"]->end(); ++action_itr) {

            // TODO: Need to determine clean way to remove nullptr slots. For now, ignoring.
            if (*action_itr == nullptr) continue;

            /*std::unique_ptr<IAction> action = std::move(*action_itr);
            do {
                ActionResult result = action->actout();
                // TODO: Need to cleanup this ignored action.
                if (result.succeeded != true) goto next;
                if (result.alternate == nullptr) break;
                action = std::move(result.alternate);
            } while (true);*/

            process(*action_itr, xactionMap[L"output"]);

            next:;
        }
    }
};




















#if 0
while (true)
{
    ActionResult result = action->actout(registry);
    // TODO: Need to cleanup this ignored action.
    if (result.succeeded != true)
    {
        //std::wcout << "result.succeeded != true\r\n";
        // We may have gone down a sequence of actions that led us
        // to a dead end (e.g. moving a block that is against a wall).
        // In this case, we just ignore that we ever saw the action.
        // Note: This ignored action needs to be cleaned up by the
        //       caller.
        return;
    }
    if (result.alternate == nullptr)
    {
        // If we're here, we know we haven't failed and there was
        // no alternate action to account for.
        //std::wcout << "result.alternate == null\r\n";
        break;
    }

    // The action resulted in an alternate action. Therefore we
    // process this alternate action on the next iteration.
    action = result.alternate;
}
#endif