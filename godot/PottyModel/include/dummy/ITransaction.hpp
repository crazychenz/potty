#pragma once

#include <memory>
#include <vector>
#include <utils/entt_wrap.hpp>
#include <dummy/actions/IAction.hpp>

class ITransaction
{

public:
    virtual ~ITransaction() { }

    virtual void push_back(std::shared_ptr<IAction> action) = 0;

    virtual void commit(entt::registry &registry) = 0;

    virtual bool is_player_xaction() = 0;

    virtual void set_player_xaction(bool v) = 0;

    // TODO: Make this an iterator instead.
    virtual std::vector<std::shared_ptr<IAction>>& get_list() = 0;
};