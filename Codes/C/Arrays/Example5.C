#include<stdio.h>


int main( )
{
 int stud[4][2] ;
 int i, j ;
 for ( i = 0 ; i <= 3 ; i++ )
 {
 printf ( "\n Enter roll no. and marks" ) ;
 scanf ( "%d %d", &stud[i][0], &stud[i][1] ) ;
 }
 for ( i = 0 ; i <= 3 ; i++ )
 printf ( "\n%d %d", stud[i][0], stud[i][1] ) ;

 int stud1[4][2] = { 1234, 56, 1212, 33, 1434, 80, 1312, 78 } ;
 
} 