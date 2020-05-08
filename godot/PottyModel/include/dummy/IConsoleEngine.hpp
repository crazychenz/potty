#pragma once

class IConsoleEngine
{

public:
    virtual ~IConsoleEngine() {}

    virtual void start() {}
    virtual void stop() {}

    virtual void start_new_game() {}
    virtual void reset_level() {}
    virtual void next_level() {}
    virtual bool currently_playing() {}

    virtual void happiness_updated(int value) {}
    virtual void bladder_updated(int value) {}
    virtual void pause_bladder(bool value) {}

};