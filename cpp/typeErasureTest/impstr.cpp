#include "impstr.h"

impstr::impstr():
 send(""),
 result("")
{
  
}

impstr::~impstr()
{

}

std::string impstr::getResult()
{
  return send;
}

void impstr::setSend(std::string dataToSend)
{
  send = dataToSend;
}
