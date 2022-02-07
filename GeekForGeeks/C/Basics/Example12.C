/*
In C and C++, there are four different data type available for holding the integers i.e., short, int, long and long long.
 Each of these data type requires different amounts of memory.
But there is a catch, the size of “long” data type is not fixed unlike other data types. It varies from architectures, 
operating system and even with compiler that we are using
*/
// C program to check the size of 'long'
//  data type
#include<stdio.h>
int main()
{
    printf("Size of int = %ld\n", sizeof(int));
    printf("Size of long = %ld\n", sizeof(long));
    printf("Size of long long = %ld", sizeof(long long));
}