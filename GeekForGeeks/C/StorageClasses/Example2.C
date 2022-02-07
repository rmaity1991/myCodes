/*
Static variables have a property of preserving their value even after they are out of their scope! Hence, static 
variables preserve their previous value in their previous scope and are not initialized again in the new scope
A static int variable remains in memory while the program is running. A normal or auto variable is destroyed when a 
function call where the variable was declared is over. 
For example, we can use static int to count a number of times a function is called, but an auto variable can’t be 
used for this purpose.
For example below program prints “1 2” 

Static variables are allocated memory in data segment, not stack segment.

Static variables (like global variables) are initialized as 0 if not initialized explicitly. For example in the 
below program, value of x is printed as 0, while value of y is something garbage.
*/
#include<stdio.h>
int fun()
{
  static int count = 0;
  count++;
  return count;
}
  
int main()
{
  printf("%d ", fun());
  printf("%d ", fun());

  static int x;
    int y;
    printf("%d \n %d", x, y);
  return 0;
}