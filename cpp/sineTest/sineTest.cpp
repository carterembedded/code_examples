#include <math.h>
#include <iostream>

#define PI   (double)3.141592653 /* pi */
#define PHIS (double)0.017453293 /* Radians */

int main()
{
    double time = 0;
    double sinVal = 0;
    double radians = PI/180;

    for(int i = 0; i < 96; ++i)
    {
        sinVal = (sin(time*radians*3));
        time++; 
//        std::cout << "time: " << time << " " << sinVal << std::endl;
        std::cout << sinVal << "," << std::endl;
    }

    return 1;
}
