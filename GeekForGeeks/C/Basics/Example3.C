/*
In C, variables are always statically (or lexically) scoped i.e., binding of a variable can be determined by program 
text and is independent of the run-time function call stack.

For example, output for the below program is 0, i.e., the value returned by f() is not dependent on who is calling it. 
f() always returns the value of global variable x.
*/
# include <stdio.h>
  
int x = 0;
int f()
{
   return x;
}
int g()
{
   int x = 1;
   return f();
}
int main()
{
  printf("%d", g());
  printf("\n");
  getchar();
}