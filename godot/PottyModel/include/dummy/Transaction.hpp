#pragma once

#include <memory>
#include <dummy/actions/IAction.hpp>

class Transaction
{
    std::unique_ptr<std::vector<std::shared_ptr<IAction>>> action_list;
    double ctime;
public:

    bool player_xaction = false;

    Transaction(double ctime) : ctime(ctime) {
        action_list = std::make_unique<std::vector<std::shared_ptr<IAction>>>();
    }

    virtual ~Transaction() { action_list->clear(); }

    virtual void push_back(std::shared_ptr<IAction> action)
    {
        action_list->push_back(action);
    }

    virtual void commit()
    {
        // TODO: Implement this.
    }

    // TODO: Make this an iterator instead.
    const std::unique_ptr<std::vector<std::shared_ptr<IAction>>>& get_list() {
        return action_list;
    }

};