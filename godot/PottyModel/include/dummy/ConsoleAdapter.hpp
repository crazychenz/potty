#pragma once

class ConsoleAdapter : public IPottyModel {
    
public:
    ConsoleAdapter() { }
    virtual ~ConsoleAdapter() {}

    virtual void on_updated() {}
    
    // TODO: Add parameters to this.
    virtual void on_updated_precommit(std::unique_ptr<std::vector<Vector2>> simple_moves) {}

    virtual void meta_update(std::string &str) {}
};