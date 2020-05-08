#pragma once

class ConsoleAdapter : public IPottyModel {
    
    ConsoleEngine engine;

public:
    ConsoleAdapter(const char *config_path = "potty-config.json") : 
        engine(*this, config_path) 
    { engine.start_new_game(); }

    virtual ~ConsoleAdapter() {}

    void start() {
        engine.start();
    }

    virtual void goal_reached(int stars)
    {
        std::wcout << "Goal reached.\r\n";
        engine.next_level();
    }

    virtual void game_beat(int stars)
    {
        std::wcout << "Game Beat.\r\n";
        std::wcout << "Starting over.\r\n";
        engine.start_new_game();
    }

    virtual void game_failed()
    {
        std::wcout << "Game Lost.\r\n";
        std::wcout << "Starting over.\r\n";
        engine.start_new_game();
    }

    virtual void happiness_updated(int value) {}
    virtual void bladder_updated(int value) {}

    virtual void on_updated() {}

    virtual void on_updated_precommit(std::unique_ptr<std::vector<Vector2>> simple_moves) {}

    virtual void meta_update(std::string &str) {}
};