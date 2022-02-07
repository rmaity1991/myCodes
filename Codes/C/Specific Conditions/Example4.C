#include<stdio.h>
#include<stdlib.h>

int main( )
{
 int goals ;
 printf ( "Enter the number of goals scored against India" ) ;
 scanf ( "%d", &goals ) ;
 if ( goals <= 5 ){
   goto sos ;
 }
 else
 {
 printf ( "About time soccer players learnt C\n" ) ;
 printf ( "and said goodbye! adieu! to soccer" ) ;
 exit; /* terminates program execution */
 }

 sos :
 printf ( "To err is human!" ) ;

 return 0;
}