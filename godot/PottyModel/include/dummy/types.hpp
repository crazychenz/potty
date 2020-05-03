#pragma once

#include <vector>
#include <memory>
#include <map>
#include <dummy/actions/IAction.hpp>

using XAction = std::vector<std::shared_ptr<IAction>>;
using XActionMap = std::map<std::wstring, std::unique_ptr<XAction>>;