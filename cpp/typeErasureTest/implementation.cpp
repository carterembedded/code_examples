#include "implementation.h"

implementation::implementation():
 send(-1),
 result(-1)
{
  
}

implementation::~implementation()
{

}

int implementation::getResult()
{
  return send;
}

void implementation::setSend(int dataToSend)
{
  send = dataToSend;
}
