/*
A variable in simple terms is a storage place which has some memory allocated to it. Basically, a variable used to 
store some form of data. Different types of variables require different amounts of memory, 
and have some specific set of operations which can be applied on them.
*/
#include <stdio.h>
int x = 20;//global variable
static int y = 30;//static variable
int main()
{
    // declaration and definition of variable 'a123'
    char a123 = 'a';
 
    // This is also both declaration and definition as 'b' is allocated
    // memory and assigned some garbage value.  
    float b; 
 
    // multiple declarations and definitions
    int _c, _d45, e;
 
    // Let us print a variable
    printf("%c \n", a123);

    /*
    Types of Variables in C 
1. Local Variable 
A variable that is declared and used inside the function or block is called local variable. 
It’s scope is limited to function or block. It cannot be used outside the block.Local variables need 
to be initialized before use. 
*/
function();
/*
2. Global Variable 
A variable that is declared outside the function or block is called a global variable. 
It is declared at the starting of program. It is available to all the functions. 
*/
function1();
function2();
/*
Static Variable 
A variable that retains its value between multiple function calls is known as static variable. 
It is declared with the static keyword. 
*/

/*
Automatic Variable 
All variables in C that are declared inside the block, are automatic variables by default. We 
can explicitly declare an automatic variable using auto keyword.Automatic variables are similar as 
local variables. 
*/
auto y=20;//automatic variable
/*
External Variable 
External variable can be shared between multiple C files.We can declare external variable using extern keyword.
*/

 
    return 0;
}

void function() {
  int x = 10; // local variable
}

void function1()
{
  printf("%d\n" , x);
}
void function2()
{
  printf("%d\n" , x);
}