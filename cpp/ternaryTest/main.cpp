#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <iostream>

int main(int argc, char** argv)
{
  const char* path = "/home/marcks/testingGrounds/ternaryTest/main.cpp";
  struct stat path_stat;
  lstat(path, &path_stat);
  std::cout << (S_ISDIR(path_stat.st_mode)) << std::endl;

  return 0;
}
