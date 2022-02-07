/*
File Scope : Scope of a Identifier starts at the beginning of the file and ends at the end of the file. 
It refers to only those Identifiers that are declared outside of all functions. 
The Identifiers of File scope are visible all over the file Identifiers having file scope are global

Block Scope : Scope of a Identifier begins at opening of the block / ‘{‘ and ends at the end of the block / ‘}’. 
Identifiers with block scope are local to their block
Function 
Prototype Scope	: Identifiers declared in function prototype are visible within the prototype
Function scope :	Function scope begins at the opening of the function and ends with the closing of it. 
Function scope is applicable to labels only. A label declared is used as a target to goto statement and both 
goto and label statement must be in same function
*/
// C program to illustrate the global scope
 
#include <stdio.h>
  
// Global variable
int global = 5;
  
// global variable accessed from
// within a function
void display()
{
    printf("%d\n", global);
}
  
// main function
int main()
{
    printf("Before change within main: ");
    display();
  
    // changing value of global
    // variable from main function
    printf("After change within main: ");
    global = 10;
    display();
}
