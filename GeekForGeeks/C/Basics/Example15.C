/*
A type cast is basically a conversion from one type to another. There are two types of type conversion:

Implicit Type Conversion
Also known as ‘automatic type conversion’.

Done by the compiler on its own, without any external trigger from the user.
Generally takes place when in an expression more than one data type is present. In such condition type conversion 
(type promotion) takes place to avoid loss of data.
All the data types of the variables are upgraded to the data type of the variable with largest data type.
*/
// An example of implicit conversion
#include<stdio.h>
int main()
{
    int x = 10;    // integer x
    char y = 'a';  // character c
  
    // y implicitly converted to int. ASCII 
    // value of 'a' is 97
    x = x + y;
     
    // x is implicitly converted to float
    float z = x + 1.0;
  
    printf("x = %d, z = %f", x, z);
    return 0;

    /*
    Explicit Type Conversion
    This process is also called type casting and it is user defined. 
    Here the user can type cast the result to make it of a particular data type.
    */
    double x = 1.2;
  
    // Explicit conversion from double to int
    int sum = (int)x + 1;
  
    printf("sum = %d", sum);
}