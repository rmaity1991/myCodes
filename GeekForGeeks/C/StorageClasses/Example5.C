/*
The qualifier const can be applied to the declaration of any variable to specify that its value will not be changed 
( Which depends upon where const variables are stored, we may change the value of const variable by using pointer ). 
The result is implementation-defined if an attempt is made to change a const. 
We can change the value of ptr and we can also change the value of object ptr pointing to. Pointer and value pointed 
by pointer both are stored in the read-write area. See the following code fragment.
*/
#include <stdio.h>
int main(void)
{
    // Pointer to variable. 
    int i = 10;
    int j = 20;
    int *ptr = &i;
    /* pointer to integer */
    printf("*ptr: %d\n", *ptr);
  
    /* pointer is pointing to another variable */
    ptr = &j;
    printf("*ptr: %d\n", *ptr);
  
    /* we can change value stored by pointer */
    *ptr = 100;
    printf("*ptr: %d\n", *ptr);

    //Pointer to constant. 
    const int *ptr = &i;   
  
    printf("ptr: %d\n", *ptr);
    /* error: object pointed cannot be modified
    using the pointer ptr */   
    *ptr = 100;
  
    ptr = &j;          /* valid */
    printf("ptr: %d\n", *ptr);
  
    return 0;
}
