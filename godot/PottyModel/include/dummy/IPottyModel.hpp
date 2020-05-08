#pragma once

class IPottyModel {
    
public:
    IPottyModel() { }
    virtual ~IPottyModel() {}

    virtual void goal_reached() {}

    virtual void game_beat() {}

    virtual void on_updated() {}
    
    // TODO: Add parameters to this.
    virtual void on_updated_precommit(std::unique_ptr<std::vector<Vector2>> simple_moves) {}

    virtual void meta_update(std::string &str) {}

    virtual void happiness_updated(int value) {}
    virtual void bladder_updated(int value) {}
};
