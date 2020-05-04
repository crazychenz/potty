#include <iostream>
#include <model/Vector2.hpp>

int main()
{
    Vector2i vec(3, 4);
    Vector2i delta(5, -6);
    Vector2i result(8, -2);

    std::cout << "  Expected: vec " << vec << " + delta " << delta << " = result " << result << std::endl;
    std::cout << "Calculated: vec " << vec << " + delta " << delta << " = result " << (vec + delta) << std::endl;
    std::cout << "Calculated: vec " << vec << " - delta " << delta << " = result " << (vec - delta) << std::endl;
    std::cout << "Calculated: vec " << vec << " += delta " << delta; vec += delta;
    std::cout << "; vec == " << vec << std::endl;
    std::cout << "Calculated: vec " << vec << " -= delta " << delta; vec -= delta;
    std::cout << "; vec == " << vec << std::endl;
    std::cout << "vec " << vec << " != delta is " << (vec != delta) << std::endl;
    std::cout << "vec " << vec << " == vec is " << (vec == vec) << std::endl;
}
