#include <boost/function.hpp>
#include <boost/shared_ptr.hpp>

class Plugin
{
public:
    virtual const char *name(void) const = 0;
    virtual const int add(const int v1, const int v2) = 0;
};

int main()
{
    typedef boost::shared_ptr<Plugin>(PluginCreate)();
    boost::function <PluginCreate> pluginCreator;
    
    return 0;
}
