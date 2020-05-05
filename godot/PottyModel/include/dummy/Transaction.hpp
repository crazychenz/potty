#pragma once

#include <iostream>

#include <memory>
#include <utils/entt_wrap.hpp>
#include <dummy/actions/IAction.hpp>
#include <dummy/ConsoleEngineContext.hpp>
#include <dummy/ITransaction.hpp>

class Transaction : public ITransaction
{
    std::vector<std::shared_ptr<IAction>> action_list;
    double ctime;
public:

    bool player_xaction = false;

    Transaction(double ctime = 0) : ctime(ctime), action_list() {
        //std::wcout << "Building transaction\r\n";
    }

    virtual ~Transaction() { action_list.clear(); }

    virtual bool is_player_xaction() { return player_xaction; }

    virtual void set_player_xaction(bool v) { player_xaction = v; }

    virtual void push_back(std::shared_ptr<IAction> action)
    {
        action_list.push_back(action);
    }

    virtual void commit(entt::registry &registry)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();

        // Process all the actions in this xaction.
        std::reverse(action_list.begin(), action_list.end());
        for (auto action = action_list.begin(); action != action_list.end(); action++) {
            (*action)->perform(registry);
        }
        //std::wcout << "Committed xaction\r\n"; ctx.redraw = true;

        if (player_xaction)
        {
            // We just processed a player_xaction, re-enable the player controls.
            //std::wcout << "Re-enabled player controls.\r\n";
            ctx.redraw = true;
        }
    }

    // TODO: Make this an iterator instead.
    std::vector<std::shared_ptr<IAction>>& get_list() {
        return action_list;
    }

};