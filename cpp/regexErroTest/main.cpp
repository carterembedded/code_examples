#include <regex.h>
#include <iostream>

int main()
{
  std::cout << REG_BADBR << ":"
<< REG_BADPAT << ":"
<< REG_BADRPT << ":"
<< REG_EBRACE << ":"
<< REG_EBRACK << ":"
<< REG_ECOLLATE << ":"
<< REG_ECTYPE << ":"
<< REG_EEND << ":"
<< REG_EPAREN << ":"
<< REG_ERANGE << ":"
<< REG_ESIZE << ":"
<< REG_ESPACE << ":"
<< REG_ESUBREG << ":" << std::endl;

}
