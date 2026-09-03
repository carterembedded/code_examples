#include <stdio.h>

int main(int argc, char** argv)
{
  int c;
  while((c = getchar()) != EOF)
  {
    if ( c>= 'a' && c <= 'z')
       c-=32; 

    putchar(c);
  }


  return 0;
}
