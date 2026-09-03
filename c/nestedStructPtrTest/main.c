struct nested {
    int a;
};

struct outer {
    struct nested *inny;
};

int main()
{
    struct outer foo = {0};
    struct nested bar = {0};
    bar.a = 69;

    foo.inny = &bar;
    
    struct nested *bar_p = foo.inny;

   printf("%d", bar_p->a); 
}
