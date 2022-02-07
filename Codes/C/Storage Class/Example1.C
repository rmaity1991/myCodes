#include<stdio.h>


/*
There are four storage classes in C:
(a) Automatic storage class

Storage − Memory.
Default initial value − An unpredictable value, which is often
 called a garbage value.
Scope − Local to the block in which the variable
 is defined.
Life − Till the control remains within the block
 in which the variable is defined. 


(b) Register storage class

The features of a variable defined to be of register storage class
are as under:
Storage - CPU registers.
Default initial value - Garbage value.
Scope - Local to the block in which the variable
 is defined.
Life - Till the control remains within the block
 in which the variable is defined.

(c) Static storage class
The features of a variable defined to have a static storage class are
as under:
Storage − Memory.
Default initial value − Zero. 
Scope − Local to the block in which the variable
 is defined.
Life − Value of the variable persists between
 different function calls. 

(d) External storage class
The features of a variable whose storage class has been defined as
external are as follows:
Storage − Memory.
Default initial value − Zero.
Scope − Global.
Life − As long as the program’s execution
 doesn’t come to an end.
*/

int external1;

/*
External variables differ from those we have already discussed in
that their scope is global, not local. External variables are declared
outside all functions, yet are available to all functions that care to
use them.
*/
int main(){

    int i, j ;
    register int k; 
    /*
    A value stored in a CPU register can always be accessed faster
    than the one that is stored in memory. Therefore, if a variable is
    used at many places in a program it is better to declare its storage
    class as register
    */

   static int l;
   /*
   Like auto variables, static variables are also local to the block in
   which they are declared. The difference between them is that static
   variables don’t disappear when the function is no longer active.
   Their values persist. If the control comes back to the same function
   again the static variables have the same values they had last time
   around
   */
    printf ( "\n%d %d", i, j ) ;
}