

#include <signal.h>
#define CONSOLE_BUILD
#include <dummy/ConsoleEngine.hpp>
#include <dummy/ConsoleAdapter.hpp>
#include <iostream>

using std::wcout;

void fini(int arg);

int main(int argc, char **argv)
{
    signal(SIGINT, fini);
    if (argc > 1)
    {
        ConsoleAdapter(argv[1]).start();
    }
    else
    {
        ConsoleAdapter().start();
    }
    return 0;
}

void fini(int arg)
{
    wcout << "Caught Ctrl+C. Exiting process.\r\n";
    exit(0);
}

