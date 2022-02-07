#include<stdio.h>
#include<string.h>

void xstrcpy(char*,char*);
int main( )
{
 char source[] = "Sayonara" ;
 char target[20] ;
 strcpy ( target, source ) ;
 printf ( "\nsource string = %s", source ) ;
 printf ( "\ntarget string = %s", target ) ;


 xstrcpy ( target, source ) ;
 printf ( "\nsource string = %s", source ) ;
 printf ( "\ntarget string = %s", target ) ; 

} 


void xstrcpy ( char *t, char *s ) // fucntions same as strcpy
{
 while ( *s != '\0' )
 {
 *t = *s ;
 s++ ;
 t++ ;
 }
 *t = '\0' ;
} 