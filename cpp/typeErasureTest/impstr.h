#include "interface.h"
#include <string>

#ifndef __IMPstr_H__
#define __IMPstr_H__ 

class impstr : public interface<std::string, std::string>
{
public:
  impstr();
  ~impstr();

  std::string getResult();
  void setSend(std::string dataToSend);

private:
  std::string send;
  std::string result;

};

#endif /* __IMPLEMENTATION_H__ */
