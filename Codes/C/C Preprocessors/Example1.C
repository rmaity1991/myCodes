/*
The preprocessor offers several features called preprocessor
directives. Each of these preprocessor directives begin with a #
symbol. The directives can be placed anywhere in a program but
are most often placed at the beginning of a program, before the
first function definition. We would learn the following
preprocessor directives here:
(a) Macro expansion
(b) File inclusion
(c) Conditional Compilation
(d) Miscellaneous directives 

*/
#include<stdio.h>

#define UPPER 25
#define PI 3.1415
#define CLEARSCREEN "\x1B[2J"
#define AND &&
#define OR || 

#define AND &&
#define ARANGE ( a > 25 AND a < 50 ) 

#if !defined (MESSAGE)
   #define MESSAGE "You wish!"
#endif

int main(){

 float r = 6.25 ;
 float area ;
 area = PI * r * r ;
 printf ( "\nArea of circle = %f", area ) ;


 int f = 1, x = 4, y = 90 ;
 if ( ( f < 5 ) AND ( x <= 20 OR y <= 45 ) )
 printf ( "\nYour PC will always work fine..." ) ;
 else
 printf ( "\nIn front of the maintenance man" ) ; 


  int a = 30 ;
 if ( ARANGE )
 printf ( "within range" ) ;
 else
 printf ( "out of range" ) ;

 #ifndef MESSAGE
   #define MESSAGE "You wish!"
#endif

#ifdef DEBUG
   /* Your debugging statements here */
#endif



}