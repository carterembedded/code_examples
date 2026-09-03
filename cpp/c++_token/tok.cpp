#include <string>
#include <sstream>
#include <iostream>

using namespace std;

int main()
{
	std::string x;
	std::stringstream s;
       s<< "EXAMPLE OF SENTENCE";
	std::stringstream s2;
       s2<<"WORD";

	int counter = 0;
	while(getline(s, x, ','))
	{
		counter++;
	}
	std::cout << counter << std::endl;
	counter = 0;

	while(getline(s, x, ','))
	{
		counter++;
	}

	std::cout << counter << std::endl;

}

