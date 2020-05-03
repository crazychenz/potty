#pragma once

#include <string>

#include <utils/entt_wrap.hpp>

class NameComponent
{
public:
    NameComponent(std::wstring name) : name(name) {}
    std::wstring name;
};