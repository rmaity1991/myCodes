/*
Interesting Facts about Macros and Preprocessors in C

In a C program, all lines that start with # are processed by preprocessor which is a special program invoked by the 
compiler. by this we mean to say that the ‘#’ symbol is used to process the functionality prior than other statements 
in the program, that is, which means it processes some code before run-time or say during the compile-time. In a very 
basic term, preprocessor takes a C program and produces another C program without any #.

The following are some interesting facts about preprocessors in C. 

1) When we use include directive,  the contents of included header file (after preprocessing) are copied to the current 
file. 
Angular brackets < and > instruct the preprocessor to look in the standard folder where all header files are held.  
Double quotes “ and “ instruct the preprocessor to look into the current folder (current directory). 

2) When we use define for a constant, the preprocessor produces a C program where the defined constant is searched 
and matching tokens are replaced with the given expression. For example in the following program max is defined as 100.

*/

#include <stdio.h>
#define max 100
int main()
{
    printf("max is %d", max);
    return 0;
}
