#include <dirent.h>
#include <iostream>
#include <stdlib.h>

int main(void)
{
  std::cout << "1" << std::endl;
  DIR* dir = opendir("/home/marcks/testingGrounds/direntTest");
  if (dir == NULL )
  {
    std::cout << "BANG!1" << std::endl;
  }

  struct dirent *dp = readdir(dir);
  std::cout << "2" << std::endl;
  std::cout << dp->d_name << std::endl;
  std::cout << "3" << std::endl;

  dp = readdir(dir);
  std::cout << "2" << std::endl;
  std::cout << dp->d_name << std::endl;
  std::cout << "3" << std::endl;
  dp = readdir(dir);
  std::cout << "2" << std::endl;
  std::cout << dp->d_name << std::endl;
  std::cout << "3" << std::endl;
  dp = readdir(dir);
  std::cout << "2" << std::endl;
  std::cout << dp->d_name << std::endl;
  std::cout << "3" << std::endl;

  dp = readdir(dir);
  if (dp == NULL)
  {
    std::cout << "BANG!2" << std::endl;
    exit(0);
  }

  std::cout << "2" << std::endl;
  std::cout << dp->d_name << std::endl;
  std::cout << "3" << std::endl;
}
