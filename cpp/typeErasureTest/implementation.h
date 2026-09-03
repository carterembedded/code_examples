#include "interface.h"

#ifndef __IMPLEMENTATION_H__
#define __IMPLEMENTATION_H__ 

class implementation : public interface<int, int>
{
public:
  implementation();
  ~implementation();

  int getResult();
  void setSend(int dataToSend);

private:
  int send;
  int result;

};

#endif /* __IMPLEMENTATION_H__ */
