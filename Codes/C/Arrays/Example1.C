#include<stdio.h>

int main(){

 int avg, sum = 0 ;
 int i ;
 int marks[30] ; /* array declaration */
 for ( i = 0 ; i <= 29 ; i++ )
 {
 printf ( "\nEnter marks " ) ;
 scanf ( "%d", &marks[i] ) ; /* store data in array */
 }
 for ( i = 0 ; i <= 29 ; i++ )
 sum = sum + marks[i] ; /* read data from an array*/
 avg = sum / 30 ;
 printf ( "\nAverage marks = %d", avg ) ; 


 int num[6] = { 2, 4, 12, 5, 45, 5 } ;
 int n[ ] = { 2, 4, 12, 5, 45, 5 } ;
 float press[ ] = { 12.3, 34.2 -23.4, -11.3 } ;

return 0;

}
