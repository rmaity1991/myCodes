/*
Following are the examples of some very common data types used in C:

char: The most basic data type in C. It stores a single character and requires a single byte of memory in 
almost all compilers.
int: As the name suggests, an int variable is used to store an integer.
float: It is used to store decimal numbers (numbers with floating point value) with single precision.
double: It is used to store decimal numbers (numbers with floating point value) with double precision. 
*/

#include <stdio.h>
int main()
{
    int a = 1;
    char b = 'G';
    double c = 3.14;
    printf("Hello World!\n");
 
    // printing the variables defined
    // above along with their sizes
    printf("Hello! I am a character. My value is %c and "
           "my size is %lu byte.\n",
           b, sizeof(char));
    // can use sizeof(b) above as well
 
    printf("Hello! I am an integer. My value is %d and "
           "my size is %lu  bytes.\n",
           a, sizeof(int));
    // can use sizeof(a) above as well
 
    printf("Hello! I am a double floating point variable."
           " My value is %lf and my size is %lu bytes.\n",
           c, sizeof(double));
    // can use sizeof(c) above as well
 
    printf("Bye! See you soon. :)\n");
 
    return 0;
}