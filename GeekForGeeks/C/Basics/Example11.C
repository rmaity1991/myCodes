#include<stdio.h>
int main()
{
    float x = 0.1;
    if (x == 0.1)
        printf("IF");
    else if (x == 0.1f)
        printf("ELSE IF");
    else
        printf("ELSE");

    printf("%d %d %d", sizeof(x), sizeof(0.1), sizeof(0.1f));
    /*
    The values used in an expression are considered as double (double precision floating point format) unless a ‘f’ is 
    specified at the end. So the expression “x==0.1” has a double on right side and float which are stored in a single 
    precision floating point format on left side. In such situations, float is promoted to double (see this). The double 
    precision format uses more bits for precision than single precision format. 
    */
   
}