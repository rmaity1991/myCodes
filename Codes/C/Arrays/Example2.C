#include<stdio.h>


int main(){

    
 int i ;
 int marks[ ] = { 55, 65, 75, 56, 78, 78, 90 } ;
 for ( i = 0 ; i <= 6 ; i++ ){
   display ( marks[i] ) ; 
 }
 
  for ( i = 0 ; i <= 6 ; i++ ){
   disp ( &marks[i] ) ;
  }
  

}
void display ( int m )
{
 printf ( "%d ", m ) ;
} 

void disp ( int *n )
{
 printf ( "%d ", *n ) ;
} 