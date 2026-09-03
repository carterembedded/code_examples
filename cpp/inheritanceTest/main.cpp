#include <iostream>

class Bobj
{
public:
  Bobj();
  static int foo;
  int getFoo();
};

int Bobj::foo = 0;

class Aobj : public Bobj
{
public:
  Aobj();
};

class Obj : public Bobj
{
public:
 Obj();
};

Bobj::Bobj() 
{ 
  std::cout << "Blah" << std::endl;
  foo+=2; 
}

int Bobj::getFoo()
{
  return foo;
}

Aobj::Aobj()
{
  foo++;
}

Obj::Obj()
{
  foo++;
}


int main()
{
  Aobj aobj;
  Obj obj;
  std::cout << obj.getFoo() << std::endl;

 return 0;
}
