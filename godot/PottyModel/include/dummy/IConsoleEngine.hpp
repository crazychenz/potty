#pragma once

class IConsoleEngine
{

public:
    virtual ~IConsoleEngine() {}

    virtual void start() {}
    virtual void stop() {}

};