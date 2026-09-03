#include "vargsHandle.h"

int getint(va_list args)
{
  return va_arg(args, int);
}

char getChar(va_list args)
{
  return va_arg(args, char);
}

double getFloat(va_list args)
{
  return va_arg(args, float);
}