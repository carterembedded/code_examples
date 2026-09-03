#include <unistd.h>
#include <stdarg.h>
#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "vargsHandle.h"

//TODO: Move the __write() functions out and make things more generic and pass char*'s around

#define STRINGIFY(x) #x
#define INTMIN_STR STRINGIFY(INT_MIN)

int printf2(const char *, ...);

// If write function changes, change this here
inline static ssize_t __write(int fd, const void *buf, size_t count)
{
  return write(1, buf, count);
}

static void __HandleFmt(const char **fmt_p, va_list args);

static void __vaPrintInteger(va_list args, int base, int width, int precision);
static void __PrintInteger(int number, int base, int width, int precision);

static void __PrintFloat(double flt, int width, int prec);
static void __vaPrintFloat(va_list args, int width, int prec);

static void __vaPrintChar(va_list args);
static void __PrintChar(char c);

static void __vaPrintString(va_list args, int padding, bool justication);
static void __PrintString(char *str, int padding, bool justification);

static void __PrintEscapeCharacter(const char **fmt_p);

int main(int argc, char** argv)
{
  int count = 0;
  // printf2("%s, %d, %c", "Hello, World!\n", 2018, '\n');
  printf2("%d\n%d\n%f\n%.5f\n", 2018, 1995, 22.85566, 123.123456);
  //printf2("%c", '\n');
}

int printf2(const char *fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);

  const int max = 10;
  char ch[max];
  const char *fmt_p = fmt;
  int bytesWritten = 0;

  while (*fmt_p != '\0')
  {
    switch (*fmt_p)
    {
    // Format
    case '%':
      // printf("%x\n", &fmt_p);
      __HandleFmt(&fmt_p, ap);
      break;
    // Escape
    case '\\':
      __PrintEscapeCharacter(&fmt_p);
      break;
    // Anything else
    default:
      __write(1, fmt_p, 1);
      break;
    }
    bytesWritten++;
    ++fmt_p;
  }

  va_end(ap);

  return bytesWritten;
}

int __getPrecision(const char** fmt_p)
{

}

int __getWidth(const char** fmt_p)
{

}

static void __HandleFmt(const char **fmt_p, va_list args)
{
  // Will define to what precision we wish to print floating points
  static int prec = 0;
  static int width = 0;
  char c;

  // printf("%x\n", &(*fmt_p));
  switch (*++(*fmt_p))
  {
  case '%':
    __write(1, ++*(fmt_p), 1);
    break;
  // char
  case 'c':
    __vaPrintChar(args);
    break;
  // integer
  case 'd':
    __vaPrintInteger(args, 10, prec, width);
    break;
  // double
  case 'f':
    __vaPrintFloat(args, width, prec);
    break;
  // string
  case 's':
    __vaPrintString(args, 0, false);
    break;
  // Precision
  case '.':
    (*++(*fmt_p));
    c = (*(*fmt_p));
    if(!isdigit(c))
      exit(1);

    prec = (*(*fmt_p)) - '0';
    //Recurse
    __HandleFmt(fmt_p, args);
    // reset width and precision
    prec = 0;
    width = 0;
    break;
    // Handle anything else after a %
  default:
    (*++(*fmt_p));
    c = (*(*fmt_p));
    if(!isdigit(c))
      exit(1);

    width = (*(*fmt_p)); -'0';
    __HandleFmt(fmt_p, args);
    prec = 0;
    width = 0;
    break;
  }
}

// String functions
static void __PrintString(char *str, int width, bool justification)
{
  char padd = '\0';
  while(width)
  {
    __write(1, &padd, 1);
    --width;
  }

  do
  {
    __write(1, str, 1);
  } while (*++str != '\0');
}

static void __vaPrintString(va_list args, int width, bool justification)
{
  char *str = va_arg(args, char *);

  __PrintString(str, width, justification);
}

// Char functions
static void __vaPrintChar(va_list args)
{
  __PrintChar(va_arg(args, int));
}

static void __PrintChar(char c)
{
  __write(1, &c, 1);
}

// Integer Funcitons
static void __vaPrintInteger(va_list args, int base, int width, int precision)
{
  __PrintInteger(va_arg(args, int), base, width, precision);
}

static void __PrintInteger(int anInteger, int base, int width, int precision)
{
  char str[128] = {0}; // large enough for an int even on 64-bit

  if (anInteger == INT_MIN)
  {
    // Handle corner case
    __write(1, INTMIN_STR, 128);
    return;
  }

  int flag = 0;
  int i = 126;
  if (anInteger < 0)
  {
    flag = 1;
    anInteger = -anInteger;
  }

  while (anInteger != 0)
  {
    str[i--] = (anInteger % base) + '0';
    anInteger /= base;
  }

  if (flag)
    str[i--] = '-';

  __PrintString((str + i + 1), width, false);
}

// Float functions
static void __vaPrintFloat(va_list args, int width, int prec)
{
  __PrintFloat(va_arg(args, double), width, prec);
}

static void __PrintFloat(double flt, int width, int prec)
{
  // // Will store our bytes (double can have upto 64-bit precision. i.e. 8 bytes)
  // ssize_t numbers[8];
  // // Get the decimal part
  // int dec = (int)flt;
  // // Remove the integer part
  // flt = flt - dec;

  // int i = 0;
  // for (i = 0; i < 8; ++i)
  // {
  //   numbers[i] = (ssize_t)flt;      //truncate whole numbers
  //   flt = (flt - numbers[i]) * 100; //remove whole part of flt and shift 2 places over
  // }

  // __PrintInteger(dec, 10, width, prec);
  // __PrintChar('.');
  // for (i = 0; i < 8; ++i)
  //   __PrintInteger(numbers[i], 10, width, prec);

  int integer = (int)flt;

  int timeser = prec;
  if(timeser == 0)
    timeser = 20;

  int decimal = ((int)(flt*(10*timeser))%(int)(10*timeser));

  printf("BLAH: %d.%d\n", integer, decimal);
  __PrintInteger(integer, 10, width, 0);
  __PrintChar('.');
  __PrintInteger(decimal, 10, width, 0);
}

//Escape character functions
static void __PrintEscapeCharacter(const char **fmt_p)
{
  char esc = '\0';
  switch (*++(*fmt_p))
  {
  case 'n':
    esc = '\n';
    break;
  case '0':
    esc = '\0';
    break;
  case '"':
    esc = '\"';
    break;
  case '\'':
    esc = '\'';
    break;
  case '\\':
    esc = '\\';
    break;
  case 'a':
    esc = '\a';
    break;
  case 'b':
    esc = '\b';
    break;
  case 'e':
    esc = '\e';
    break;
  case 'f':
    esc = '\f';
    break;
  case 'r':
    esc = '\r';
    break;
  case 't':
    esc = '\t';
    break;
  case 'v':
    esc = '\v';
    break;
  case '?':
    esc = '\?';
    break;
  }

  __write(1, &esc, 1);
}
