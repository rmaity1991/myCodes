#include<stdio.h>

void swapr(int*,int*);

int main( )
{
 int a = 10, b = 20 ;
 swapr ( &a, &b ) ; // pass by address to the function
 printf ( "\na = %d b = %d", a, b ) ;
}

void swapr( int *x, int *y ) // Call by Reference
{
 int t ;
 t = *x ;
 *x = *y ;
 *y = t ;
}