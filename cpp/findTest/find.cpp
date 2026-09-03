#include <string>
#include <iostream>

int main()
{
  std::string rootDir;
  std::string unappliedDir = "/this/is/a/test/";
  std::string editing = "/root/////Just/a/dir///";

  if (unappliedDir.find('/') == std::string::npos)
    rootDir = unappliedDir;

  const size_t lastSlashIndex = unappliedDir.rfind('/');
  if (std::string::npos != lastSlashIndex)
  {
    rootDir = unappliedDir.substr(0,lastSlashIndex);
  }

  while(editing.empty() == false &&
        editing.at(editing.length()-1) == '/')
  {
    editing = editing.erase(editing.length()-1, 1);
  }

  std::cout << rootDir << std::endl;
  std::cout << unappliedDir << std::endl;
  std::cout << editing << std::endl;
}
