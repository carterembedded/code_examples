
class Bobj
{
  Bobj();
  static int foo;
  int getFoo();
}

class Aobj : public Bobj
{
  Aobj();
}

class Obj
{
 Obj();
}

Bobj::Bobj() : foo(0) {}

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
