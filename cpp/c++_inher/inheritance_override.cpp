#include <iostream>

class foo {
    public:
        virtual void shout ()
        {
            std::cout << "foo" << std::endl;
        }
};

class bar {
    public:
        void shout () override
        {
            std::cout << "bar" << std::endl;
        }
};

class baz : public bar, public foo
{
};

int main(int argc, char** argv)
{
    auto b = new baz;
    b->shout();
    delete b;
    return 0;
}
