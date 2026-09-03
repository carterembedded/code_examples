#include "interface.h"
#include "implementation.h"
#include "impstr.h"
#include <stdio.h>
#include <iostream>
#include <vector>

int main()
{
  implementation imp;
  impstr imps;
  imp.setSend(1);
  imps.setSend("AAAAAAAAA");

  std::vector<interface*> invec;  
  invec.push_back(&imp);
  invec.push_back(&imps);


  std::cout << invec[0].getResult() << " : " << invec[1].getResult() << std::endl;
}
