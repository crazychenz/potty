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

    virtual void goal_reached()
    {
        std::wcout << "Goal reached.\r\n";
        engine.next_level();
    }

    virtual void game_beat()
    {
        std::wcout << "Game Beat.\r\n";
        std::wcout << "Starting over.\r\n";
        engine.start_new_game();
    }

    virtual void on_updated() {}
    
    // TODO: Add parameters to this.
    virtual void on_updated_precommit(std::unique_ptr<std::vector<Vector2>> simple_moves) {}

    virtual void meta_update(std::string &str) {}
};