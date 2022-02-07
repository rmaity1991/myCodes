#include<stdio.h>

// Declaration of enum
typedef enum { F, T } boolean;

int main()
{
  bool arr[2] = {true, false};

  boolean bool1, bool2;
    bool1 = F;

    /*
    There is one more way to do it using enum function in C language. You can create a bool using enum. 
    One enum will be created as bool, then put the elements of enum as True and False respectively. The 
    false will be at the first position, 
    so it will hold 0, and true will be at the second position, so it will get value 1
    */

  
    if (bool1 == F) {
        printf("bool1 is false\n");
    }
    else {
        printf("bool1 is true\n");
    }
    // bool2 = 2;
    if (bool2 == F) {
        printf("bool2 is false\n");
    }
    else {
        printf("bool2 is true\n");
    }

  return 0;
}