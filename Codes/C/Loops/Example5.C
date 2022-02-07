#include<stdio.h>

int main( )
{
 char another = 'y' ;
 int num ;
 for ( ; another == 'y' ; )
 {
 printf ( "Enter a number " ) ;
 scanf ( "%d", &num ) ;
 printf ( "square of %d is %d", num, num * num ) ;
 printf ( "\nWant to enter another number y/n " ) ;
 scanf ( " %c", &another ) ;
 }

 return 0;
} 