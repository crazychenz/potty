#pragma once

class IPottyModel {
    
public:
    IPottyModel() { }
    virtual ~IPottyModel() {}

    virtual void on_updated() {}
    
    // TODO: Add parameters to this.
    virtual void on_updated_precommit() {}
};
