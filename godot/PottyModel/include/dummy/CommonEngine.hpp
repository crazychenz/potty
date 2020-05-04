#pragma once

#include <iostream> // for debug wcout

#include <memory>
#include <vector>
#include <utils/entt_wrap.hpp>

#include <dummy/types.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/actions/IAction.hpp>

class CommonEngine : public IConsoleEngine
{
protected:
    // using entt::register = entt::basic_registry<entt::entity>
    entt::registry registry;
    const entt::registry &cregistry;
    entt::scheduler<double> scheduler;
    XActionMap xactionMap;

    /*
    The general idea for actions is that they should be able to:
      - perform() Perform the action to the game state. Returns ActionResult.
        ** Need to figure out if this needs parameters.
      - unperform() Perform the opposite of the action.
        ** Highly recommended to be done in order to provide undo behavior.
        ** Note: May be able to tie actions together to prevent misuse.
    */

public:

    void commit_xaction()
    {
        XAction &xaction = *xactionMap[L"output"];
        // Process all the actions at once. (i.e. commit).
        for (auto action = xaction.begin(); action != xaction.end(); action++) {
            (*action)->perform(registry);
        }
        // Reset the transaction.
        // !BUG: This for loop is preventing a memory leak.
        // !     Why are we leaking memory here?!
        //std::for_each(xaction.begin(), xaction.end(), [](auto &action){ action.reset(); });
        xaction.clear(); // TODO: Consider storing into undo queue.
    }



    CommonEngine() : cregistry(registry) {}
    virtual ~CommonEngine() {}

};