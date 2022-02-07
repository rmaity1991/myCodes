#include<stdio.h>


int xstrlen(char*);

int main( )
{
 char arr[ ] = "Bamboozled" ;
 int len1, len2 ;
 len1 = xstrlen ( arr ) ;
 len2 = xstrlen ( "Humpty Dumpty" ) ;
 printf ( "\nstring = %s length = %d", arr, len1 ) ;
 printf ( "\nstring = %s length = %d", "Humpty Dumpty", len2 ) ;
} 

// Here we are defining a function called xstrlen to imitate the strlen function from string.h library
int xstrlen ( char *s )
{
 int length = 0 ;
 while ( *s != '\0' )
 {
 length++ ;
 s++ ;
 }
 return ( length ) ;
} 