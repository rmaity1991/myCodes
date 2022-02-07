#include<stdio.h>

int calsum(int,int,int);
char fun();

int main()
{
 int a, b, c, sum ;
 printf ( "\nEnter any three numbers " ) ;
 scanf ( "%d %d %d", &a, &b, &c ) ;
 sum = calsum ( a, b, c ) ; 
 printf ( "\nSum = %d", sum ) ;
}

int calsum ( int x, int y, int z ){

 int d ;
 d = x + y + z ;
 return ( d ) ;
}

char fun( )
{
 char ch ;
 printf ( "\nEnter any alphabet " ) ;
 scanf ( "%c", &ch ) ;
 if ( ch >= 65 && ch <= 90 ){
   return ( ch ) ;
 }
 else{
   return ( ch + 32 ) ;
 }

} 
