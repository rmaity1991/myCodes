/*
printf() : It returns total number of Characters Printed, Or negative value if an output error or an encoding error 
*/
// C/C++ program to demonstrate return value
// of printf()
#include <stdio.h>
 
int main()
{
    char st[] = "CODING";
 
    printf("While printing ");
    printf(", the value returned by printf() is : %d",
    printf("%s", st));

    long int n = 123456789;
 
    printf("While printing ");
    printf(", the value returned by printf() is : %d",
    printf("%ld", n));
    // scanf() : It returns total number of Inputs Scanned successfully, or 
    // EOF if input failure occurs before the first receiving argument was assigned.

    char a[100], b[100], c[100];
 
    // scanf() with one input
    printf("\n First scanf() returns : %d",
    scanf("%s", a));
 
    // scanf() with two inputs
    printf("\n Second scanf() returns : %d",
    scanf("%s%s", a, b));
 
    // scanf() with three inputs
    printf("\n Third scanf() returns : %d",
    scanf("%s%s%s", a, b, c));
 
    return 0;
}