#pragma once

class IPottyModel {
    
public:
    IPottyModel() { }
    virtual ~IPottyModel() {}

    virtual void on_updated() {}
};
