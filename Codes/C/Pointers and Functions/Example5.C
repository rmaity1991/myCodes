#include<stdio.h>

/*
Here we will return more than 1 variable as return from the function by using pointers
*/
void areaperi ( int ,float * , float * );

int main( )
{
 int radius ;
 float area, perimeter ;
 printf ( "\nEnter radius of a circle " ) ;
 scanf ( "%d", &radius ) ;
 areaperi ( radius, &area, &perimeter ) ; // passing the area and perimeter pointer to the pointer variable
 printf ( "Area = %f", area ) ;
 printf ( "\nPerimeter = %f", perimeter ) ;

 return 0;
}

void areaperi ( int r, float *a, float *p )
{
 *a = 3.14 * r * r ; // changing the value of area
 *p = 2 * 3.14 * r ; // changing the value of perimeter
}