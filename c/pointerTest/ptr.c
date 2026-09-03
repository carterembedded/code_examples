#include <stdio.h>

int ptrFunction(const char **str_p)
{
  printf("%c\n", **str_p);
  printf("%x\n", &*str_p);
  printf("%c\n", *++(*str_p));
  printf("%x\n", &*str_p);
}

int main()
{
  const char *str_p = "Hello, World!";
  ptrFunction(&str_p);
  printf("%c\n", *str_p);
  printf("%x\n", str_p);
  return 0;
}