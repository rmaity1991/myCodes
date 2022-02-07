#include<stdio.h>

// #define MyMacro1

int main(){


    #ifdef MyMacro1

    printf("Hello World");

    #endif


    #ifdef MyMacro1

    printf("Hello World");
    
    #else

    printf("Hello There");

    #endif
}