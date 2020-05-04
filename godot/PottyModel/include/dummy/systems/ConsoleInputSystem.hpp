#pragma once

#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <sys/select.h>

#include <termios.h>
#include <string.h>
#include <fcntl.h>
#include <time.h>
#include <stdlib.h>

#include <iostream>
#include <string>

#include <utils/entt_wrap.hpp>
#include <dummy/types.hpp>
#include <dummy/IConsoleEngine.hpp>
#include <dummy/actions/common_actions.hpp>

#ifndef STDIN_FILENO
#define STDIN_FILENO (0)
#endif

class ConsoleEngine;

// TODO: Replace console output with logger.
class ConsoleInputSystem : public entt::process<ConsoleInputSystem, double>
{
    std::wstring endl = L"\r\n";

    static const unsigned int KEY_UPARROW = 0x415b1b;
    static const unsigned int KEY_DOWNARROW = 0x425b1b;
    static const unsigned int KEY_LEFTARROW = 0x445b1b;
    static const unsigned int KEY_RIGHTARROW = 0x435b1b;
    static const unsigned int KEY_ENTER = 0x0d;
    static const unsigned int KEY_ESCAPE = 0x1b;
    static const unsigned int KEY_TAB = 0x09;
    static const unsigned int KEY_DELETE = 0x7e335b1b;
    static const unsigned int KEY_BACKSPACE = 0x7f;
    static const unsigned int KEY_HOME = 0x485b1b;
    static const unsigned int KEY_END = 0x465b1b;
    static const unsigned int KEY_PAGEUP = 0x7e355b1b;
    static const unsigned int KEY_PAGEDOWN = 0x7e365b1b;
    static const unsigned int KEY_FWDSLASH = 0x2f;
    static const unsigned int KEY_ASTERISK = 0x2a;
    static const unsigned int KEY_HYPEN = 0x2d;
    static const unsigned int KEY_PLUS = 0x2b;
    static const unsigned int KEY_KEYPADPERIOD = 0x7e335b1b;
    static const unsigned int KEY_KEYPADZERO = 0x7e325b1b;
    static const unsigned int KEY_KEYPAD1 = 0x465b1b;
    static const unsigned int KEY_KEYPAD2 = 0x425b1b;
    static const unsigned int KEY_KEYPAD3 = 0x7e365b1b;
    static const unsigned int KEY_KEYPAD4 = 0x445b1b;
    //static const unsigned int KEY_KEYPAD5; // this isn't getting caught
    static const unsigned int KEY_KEYPAD6 = 0x435b1b;
    static const unsigned int KEY_KEYPAD7 = 0x485b1b;
    static const unsigned int KEY_KEYPAD8 = 0x415b1b;
    static const unsigned int KEY_KEYPAD9 = 0x7e355b1b;
    static const unsigned int KEY_CTRLZ = 0x1a;

    entt::registry &registry;
    IConsoleEngine &engine;

    double timePassed = 0.0;
    

public:
    ConsoleInputSystem(
        entt::registry &registry, 
        IConsoleEngine &engine) : 
        registry(registry), 
        engine(engine)
    {
        setup_console();
    }
    ~ConsoleInputSystem()
    {
        teardown_console();
    }

    void setup_console()
    {
        // Set terminal to raw mode 
        system("stty raw -echo onlcr -icanon");

        // get current file status flags
        int flags = fcntl(0, F_GETFL, 0);

        // turn off blocking flag
        flags |= O_NONBLOCK;

        /* set up non-blocking read */
        fcntl(0, F_SETFL, flags);
    }

    void teardown_console()
    {
        system("stty cooked echo");
    }

    void get_console_input(int *ret) {

        auto &ctx = registry.ctx<ConsoleEngineContext>();
        if (ctx.input_allowed == false) { return; }

        /* BUG: If you press keys really quickly, this'll grab more than one. (Maybe just ignore it?) */
        ret[0] = read(STDIN_FILENO, &ret[1], 4);
        if (ret[0] < 0)
        {
            if (errno == EAGAIN)
            {
                ret[0] = 0;
                ret[1] = 0;
                return;
            }
            perror("read():");
            exit(-1);
        }
    }

    void handle_special_input(const int *input, XActionMap &xactionMap)
    {
        auto &ctx = registry.ctx<ConsoleEngineContext>();
        //entt::simple_view<HealthComponent, NameComponent>
        auto view = registry.view<const PlayerComponent>();
        auto entity = *view.begin();

        
        switch(input[1])
        {
            case ConsoleInputSystem::KEY_ESCAPE:
                std::wcout << "Caught Escape. Stopping Engine." << endl;
                engine.stop();
                break;
            case ConsoleInputSystem::KEY_CTRLZ:
                std::wcout << "TODO: Implement undo feature." << endl;
                break;
            case 'n':
                xactionMap[L"input"]->push_back(nullptr);
                break;
            case 'w':
                //std::wcout << "up" << endl;
                xactionMap[L"input"]->push_back(std::make_shared<GridMoveAction>(entity, Vector2(0, -1)));
                break;
            case 'a':
                //std::wcout << "left" << endl;
                xactionMap[L"input"]->push_back(std::make_shared<GridMoveAction>(entity, Vector2(-1, 0)));
                break;
            case 's':
                //std::wcout << "down" << endl;
                xactionMap[L"input"]->push_back(std::make_shared<GridMoveAction>(entity, Vector2(0, 1)));
                break;
            case 'd':
                //std::wcout << "right" << endl;
                xactionMap[L"input"]->push_back(std::make_shared<GridMoveAction>(entity, Vector2(1, 0)));
                break;
            case 'p':
                ctx.player_pulling = !ctx.player_pulling;
                std::wcout << "pulling = " << ctx.player_pulling << "\r\n";
            default:
                std::wcout << "Unmapped key pressed: " << std::hex << input[1] << endl;
        }
    }

    void update(double delta, void *data)
    {
        XActionMap *xactionMap = (XActionMap *)data;
        timePassed += delta;
        int input[2] = {};
        get_console_input(input);
        if (input[0] != 0)
            handle_special_input(input, *xactionMap);
    }

};