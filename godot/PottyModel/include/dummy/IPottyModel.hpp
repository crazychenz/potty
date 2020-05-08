#pragma once

class IPottyModel {
    
public:
    IPottyModel() { }
    virtual ~IPottyModel() {}

    virtual void goal_reached(int stars) {}

    virtual void game_beat(int stars) {}

    virtual void on_updated() {}
    
    // TODO: Add parameters to this.
    virtual void on_updated_precommit(std::unique_ptr<std::vector<Vector2>> simple_moves) {}

    virtual void meta_update(std::string &str) {}

    virtual void happiness_updated(int value) {}
    virtual void bladder_updated(int value) {}
    virtual void pause_bladder(bool value) {}
    virtual void game_failed() {}
};
