#include <string>
#include <iostream>
#include <algorithm>

int main()
{
	std::string str = "test1234";
	std::transform(str.begin(), str.end(), str.begin(), ::toupper);
    std::cout << str << std::endl;
    
}
