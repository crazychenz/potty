

#include <signal.h>
#include <dummy/ConsoleEngine.hpp>
#include <iostream>

using std::wcout;

void fini(int arg);

int main()
{
    signal(SIGINT, fini);
    ConsoleEngine().start();
    return 0;
}

void fini(int arg)
{
    wcout << "Caught Ctrl+C. Exiting process.\r\n";
    exit(0);
}

