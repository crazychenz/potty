#pragma once

//#include "IAction.hpp"

#include <memory>

class IAction;

class ActionResult {

public:

    enum class Result { Accepted, Rejected, TryAgain };
    static const Result Rejected = Result::Rejected;
    static const Result Accepted = Result::Accepted;
    static const Result TryAgain = Result::TryAgain;

    // TODO: These initializers may need to go into a cpp file. C++17 should allow this though.
    //static const ActionResult SUCCESS = ActionResult(true);
    //static const ActionResult FAILURE = ActionResult(false);

    std::shared_ptr<IAction> alternate;
    Result result;

    ActionResult(bool succeeded) : alternate(nullptr) {
        if (succeeded) result = Result::Accepted;
        else result = Result::Rejected;
    }
    ActionResult(std::shared_ptr<IAction> alternate) : result(Result::Accepted), alternate(alternate) {}
    ActionResult(Result result) : result(result), alternate(nullptr) {}
    ActionResult(Result result, std::shared_ptr<IAction> alternate) : result(result), alternate(alternate) {}

    virtual ~ActionResult() {}
};
