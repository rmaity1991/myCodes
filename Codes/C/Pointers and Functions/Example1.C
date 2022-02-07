#include<stdio.h>

/*
Call by Value and Call by Reference( Using Pointers)
*/

int main(){

 int i = 3 ;
 printf ( "\nAddress of i = %u", &i ) ;
 printf ( "\nValue of i = %d", i ) ;


 int *j ;
 j = &i ;
 printf ( "\nAddress of i = %u", &i ) ;
 printf ( "\nAddress of i = %u", j ) ;
 printf ( "\nAddress of j = %u", &j ) ;
 printf ( "\nValue of j = %u", j ) ;
 printf ( "\nValue of i = %d", i ) ;
 printf ( "\nValue of i = %d", *( &i ) ) ;
 printf ( "\nValue of i = %d", *j ) ;  

}