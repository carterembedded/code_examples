#include <cctype>
#include <iostream>

int main()
{
    int16_t foo = 0x8000;
    int16_t bar = 0x0001;

    foo = foo<<1;
    bar = bar<<1;

    std::cout << foo << std::endl;
    std::cout << std::hex << foo << std::endl;
    std::cout << bar << std::endl;
    std::cout << std::hex << bar << std::endl;

}
