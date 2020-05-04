#pragma once

#include <iostream>

class Vector2i {

private:
    int _x;
    int _y;

public:
    Vector2i() /*: x(_x), y(_y)*/ {}
    Vector2i(int x_param, int y_param) : _x(x_param), _y(y_param)/*, x(_x), y(_y)*/ {}
    Vector2i(const Vector2i &vec) : _x(vec.getX()), _y(vec.getY())/*, x(_x), y(_y)*/ {}
    ~Vector2i() {}

    std::wstring toStr()
    {
        return L"(" + std::to_wstring(getX()) + L", " + std::to_wstring(getY()) + L")";
    }

    int getX() const { return _x; }
    int getY() const { return _y; }

    //const int &x;
    //const int &y;

    friend std::ostream& operator<<(std::ostream& os, const Vector2i& dt)
    {
        os << "(" << dt.getX() << ", " << dt.getY() << ")";
        return os;
    }

    friend std::wostream& operator<<(std::wostream& os, const Vector2i& dt)
    {
        os << L"(" << std::to_wstring(dt.getX()) << L", " << std::to_wstring(dt.getY()) << L")";
        return os;
    }

    Vector2i& operator+=(const Vector2i& rhs)
    {
        _x += rhs.getX();
        _y += rhs.getY();
        return *this;
    }

    Vector2i& operator-=(const Vector2i &rhs)
    {
        _x -= rhs.getX();
        _y -= rhs.getY();
        return *this;
    }

    friend Vector2i operator+(const Vector2i &lhs, const Vector2i &rhs)
    {
        return Vector2i(lhs.getX() + rhs.getX(), lhs.getY() + rhs.getY());
    }

    friend Vector2i operator-(const Vector2i &lhs, const Vector2i &rhs)
    {
        return Vector2i(lhs.getX() - rhs.getX(), lhs.getY() - rhs.getY());
    }

    friend bool operator==(const Vector2i &lhs, const Vector2i &rhs)
    {
        return lhs.getX() == rhs.getX() && lhs.getY() == rhs.getY();
    }

    friend bool operator!=(const Vector2i &lhs, const Vector2i &rhs)
    {
        return lhs.getX() != rhs.getX() || lhs.getY() != rhs.getY();
    }

};

typedef Vector2i Vector2;

class Vector2f {

private:
    float _x;
    float _y;

public:
    Vector2f() /*: x(_x), y(_y)*/ {}
    Vector2f(int x_param, int y_param) : _x(x_param), _y(y_param)/*, x(_x), y(_y)*/ {}
    Vector2f(const Vector2f &vec) : _x(vec.getX()), _y(vec.getY())/*, x(_x), y(_y)*/ {}
    ~Vector2f() {}

    std::wstring toStr()
    {
        return L"(" + std::to_wstring(getX()) + L", " + std::to_wstring(getY()) + L")";
    }

    float getX() const { return _x; }
    float getY() const { return _y; }

    //const int &x;
    //const int &y;

    friend std::ostream& operator<<(std::ostream& os, const Vector2f& dt)
    {
        os << "(" << dt.getX() << ", " << dt.getY() << ")";
        return os;
    }

    friend std::wostream& operator<<(std::wostream& os, const Vector2f& dt)
    {
        os << L"(" << std::to_wstring(dt.getX()) << L", " << std::to_wstring(dt.getY()) << L")";
        return os;
    }

    Vector2f& operator+=(const Vector2f& rhs)
    {
        _x += rhs.getX();
        _y += rhs.getY();
        return *this;
    }

    Vector2f& operator-=(const Vector2f &rhs)
    {
        _x -= rhs.getX();
        _y -= rhs.getY();
        return *this;
    }

    friend Vector2f operator+(const Vector2f &lhs, const Vector2f &rhs)
    {
        return Vector2f(lhs.getX() + rhs.getX(), lhs.getY() + rhs.getY());
    }

    friend Vector2f operator-(const Vector2f &lhs, const Vector2f &rhs)
    {
        return Vector2f(lhs.getX() - rhs.getX(), lhs.getY() - rhs.getY());
    }

    friend bool operator==(const Vector2f &lhs, const Vector2f &rhs)
    {
        return lhs.getX() == rhs.getX() && lhs.getY() == rhs.getY();
    }

    friend bool operator!=(const Vector2f &lhs, const Vector2f &rhs)
    {
        return lhs.getX() != rhs.getX() || lhs.getY() != rhs.getY();
    }

};


