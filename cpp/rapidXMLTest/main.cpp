
#include <rapidxml/rapidxml.hpp>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

int main(int argc, char** argv)
{
  if(argc != 2)
  {
    std::cout << "Supply xml file" << std::endl;
    exit(1);
  }
 
  char* fileName = *(argv+1);
  
  std::cout << "File we're parsing: " << fileName << std::endl;

  std::ifstream inFile;
  inFile.open(fileName);
  rapidxml::xml_node<> *root_node;
  rapidxml::xml_document<> doc;
  
  std::vector<char> buffer((std::istreambuf_iterator<char>(inFile)), std::istreambuf_iterator<char>());
  buffer.push_back('\0');
  doc.parse<0>(&buffer[0]);

  std::cout << "Name of my first node is: " << doc.first_node()->name() << "\n";
  root_node = doc.first_node("test");
  rapidxml::xml_node<> *node = root_node->first_node("testinside");

  std::cout << "This node is: " << node->name()
            << " It's blah is: " << node->first_attribute("blah")->value()
            << std::endl;

  inFile.close();
}
