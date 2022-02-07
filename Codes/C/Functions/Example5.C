#include<stdio.h>

/*
With a sound basis of the preliminaries of C functions, let us now
get into their intricacies. Following advanced topics would be
considered here.
(a) Function Declaration and Prototypes
(b) Calling functions by value or by reference
(c) Recursion
*/
float square(float);

int main( )
{
 float a, b ;
 printf ( "\nEnter any number " ) ;
 scanf ( "%f", &a ) ;
 b = square ( a ) ;
 printf ( "\nSquare of %f is %f", a, b ) ;

 void gospel() ; 

 return 0;
}

float square ( float x )
{
 float y ;
 y = x * x ;
 return ( y ) ;
} 

void gospel( )
{
 printf ( "\nViruses are electronic bandits..." ) ;
 printf ( "\nwho eat nuggets of information..." ) ;
 printf ( "\nand chunks of bytes..." ) ;
 printf ( "\nwhen you least expect..." ) ;
} 