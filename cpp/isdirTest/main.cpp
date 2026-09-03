#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <iostream>
#include <iomanip>

int main(int argc, char** argv)
{

  std::cout << "EACCES: " << EACCES << std::endl;
  std::cout << "EBADF: " << EBADF << std::endl;
  std::cout << "EMFILE: " << EMFILE << std::endl;
  std::cout << "ENFILE: " << ENFILE << std::endl;
  std::cout << "ENOENT: " << ENOENT << std::endl;
  std::cout << "ENOMEM: " << ENOMEM << std::endl;
  std::cout << "ENOTDIR: " << ENOTDIR << std::endl;

  DIR *dir_p = opendir("/home/marcks/testingGrounds/isdirTest/main.cpp");
  if(dir_p == NULL)
  {
    std::cout << strerror(errno) << std::endl;
    std::cout << "Errno: " << errno << std::endl;
  }

  struct stat lstatstruct;
  lstat("/home/marcks/testingGrounds/isdirTest/main.cpp", &lstatstruct);
  std::cout << std::hex << (lstatstruct.st_mode & 0xF000) << std::endl;

  lstat("/home/marcks/testingGrounds/isdirTest/", &lstatstruct);
  std::cout << std::hex << (lstatstruct.st_mode & 0xF000) << std::endl;

  stat("//home/marcks/testingGrounds/isdirTest/isDir.out", &lstatstruct);
  std::cout << std::hex << S_ISDIR(lstatstruct.st_mode) << std::endl;

  stat("/home/marcks/testingGrounds/isdirTest/zip.gz", &lstatstruct);
  std::cout << std::hex << S_ISDIR(lstatstruct.st_mode) << std::endl;
  return 0;
}
