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
    //XActionMap xactionMap;

    /*
    The general idea for actions is that they should be able to:
      - perform() Perform the action to the game state. Returns ActionResult.
        ** Need to figure out if this needs parameters.
      - unperform() Perform the opposite of the action.
        ** Highly recommended to be done in order to provide undo behavior.
        ** Note: May be able to tie actions together to prevent misuse.
    */

public:

    void commit_xaction(std::unique_ptr<Transaction> &xaction)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Process all the actions in this xaction.
        std::reverse(xaction->get_list()->begin(), xaction->get_list()->end());
        for (auto action = xaction->get_list()->begin(); action != xaction->get_list()->end(); action++) {
            (*action)->perform(registry);
        }
        std::wcout << "Performed xaction\r\n";

        // Reset the transaction.
        // !BUG: This for loop is preventing a memory leak.
        // !     Why are we leaking memory here?!
        //std::for_each(xaction.begin(), xaction.end(), [](auto &action){ action.reset(); });
        //xaction.clear(); // TODO: Consider storing into undo queue.

        if (xaction->player_xaction)
        {
            // We just processed a player_xaction, re-enable the player controls.
            std::wcout << "Re-enabled player controls.\r\n";
            ctx.player_move_pending = false;
        }
    }



    CommonEngine() : cregistry(registry) {}
    virtual ~CommonEngine() {}

};