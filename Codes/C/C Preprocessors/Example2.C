#include<stdio.h>
#define FOUND printf ( "The Yankee Doodle Virus" ) ;
#define AREA(x) ( 3.14 * x * x )
#define ISDIGIT(y) ( y >= 48 && y <= 57 )
#define SQUARE(n) n * n 

// Multiple Line Arguments and Macros
#define HLINE for ( int i = 0 ; i < 79 ; i++ ) { \

                   printf ( "%d", i ) ;  \
                   }

#define VLINE( X, Y ) { \
          gotoxy ( X, Y ) ; \
          printf ( "%c", 179 ) ; \
        } 

int main(){


 char signature ;
 if ( signature == 'Y' )
 FOUND
 else
 printf ( "Safe... as yet !" ) ;

 float r1 = 6.25, r2 = 2.5, a ;

 a = AREA ( r1 ) ;
 printf ( "\nArea of circle = %f", a ) ;
 a = AREA ( r2 ) ;
 printf ( "\nArea of circle = %f", a ) ; 

 char ch ;
 printf ( "Enter any digit " ) ;
 scanf ( "%c", &ch ) ;
 if ( ISDIGIT ( ch ) )
 printf ( "\nYou entered a digit" ) ;
 else
 printf ( "\nIllegal input" ) ; 

/*
If macroname has been #defined, the block of code will be
processed as usual; otherwise not. 
*/
 #ifdef OKAY
 statement 1 ;
 statement 2 ; /* detects virus */
 statement 3 ;
 statement 4 ; /* specific to stone virus */
 #endif 
/*
A more sophisticated use of #ifdef has to do with making the
programs portable, i.e. to make them work on two totally
different computers.
*/

 #ifdef INTEL
 code suitable for a Intel PC;
 #else
 code suitable for a Motorola PC;
 #endif

 #ifndef INTEL
 code suitable for a Nokia PC
 #else
 code suitable for a Motorola PC
 #endif



}