/*
Function Prototype Scope: These variables range includes within the function parameter list. The scope of the these 
variables begins right after the declaration in the function prototype and runs to the end of the declarations list. 
These scopes don’t include the function definition, but just the function prototype.

Function Scope: A Function scope begins at the opening of the function and ends with the closing of it. Function scope 
is applicable to labels only. A label declared is used as a target to go to the statement and both goto and label 
statement must be in the same function. 

*/
// C program to illustrate
// function prototype scope
 
#include <stdio.h>
  
// function prototype scope
//(not part of a function definition)
int Sub(int num1, int num2);
 
// file scope
int num1;
 
// Function to subtract
int Sub(int num1, int num2)
{
    return (num1-num2);
}
 
// Driver method
int main(void)
{
    printf("%d\n", Sub(10,5));
    return 0;
}

void func1()
{
    {
        // label in scope even
        // though declared later
        goto label_exec;
 
    label_exec:;
    }
 
    // label ignores block scope
    goto label_exec;
}
 
void funct2()
{
 
    // throwserror:
    // as label is in func1() not funct2()
    // goto label_exec;
}