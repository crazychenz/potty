#pragma once

class IPottyModel {
    
public:
    IPottyModel() { }
    virtual ~IPottyModel() {}

    virtual void on_updated() {}
    
    // TODO: Add parameters to this.
    virtual void on_updated_precommit(std::unique_ptr<std::vector<Vector2>> simple_moves) {}
};
