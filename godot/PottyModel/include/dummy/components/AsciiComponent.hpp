#pragma once

#include <string>

#include <utils/entt_wrap.hpp>

class AsciiComponent
{
public:
    AsciiComponent(wchar_t character) : character(character) {}
    wchar_t character;
};