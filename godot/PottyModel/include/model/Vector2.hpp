#pragma once

class Vector2 {

private:
    int _x;
    int _y;

public:
    Vector2() /*: x(_x), y(_y)*/ {}
    Vector2(int x_param, int y_param) : _x(x_param), _y(y_param)/*, x(_x), y(_y)*/ {}
    Vector2(const Vector2 &vec) : _x(vec.getX()), _y(vec.getY())/*, x(_x), y(_y)*/ {}
    ~Vector2() {}

    std::wstring toStr()
    {
        return L"(" + std::to_wstring(getX()) + L", " + std::to_wstring(getY()) + L")";
    }

    int getX() const { return _x; }
    int getY() const { return _y; }

    //const int &x;
    //const int &y;



};
