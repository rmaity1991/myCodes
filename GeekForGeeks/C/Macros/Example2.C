/*
The macros can take function like arguments, the arguments are not checked for data type. For example, the 
following macro INCREMENT(x) can be used for x of any data type.
The macro arguments are not evaluated before macro expansion. For example, consider the following program
*/
#include <stdio.h>
#define INCREMENT(x) ++x
#define MULTIPLY(a, b) a* b
// here, instead of writing a*a we write (a)*(b)
#define MULTIPLY2(a, b) (a) * (b)
//The tokens passed to macros can be concatenated using operator ## called Token-Pasting operator
#define merge(a, b) a##b
//A token passed to macro can be converted to a string literal by using # before it.
#define get(a) #a
//The macros can be written in multiple lines using ‘\’. The last line doesn’t need to have ‘\’.
#define PRINT(i, limit)                                    \
    while (i < limit) {                                    \
        printf("GeeksQuiz ");                              \
        i++;                                               \
    }
//If we use inline functions, we get the expected output. Also, the program given in point 4 
//above can be corrected using inline functions.
//We can remove already defined macros using : 
//undef MACRO_NAME 
float div(float, float);
#define div(x, y) x / y

int main()
{
    char* ptr = "GeeksQuiz";
    int x = 10;
    printf("%s  ", INCREMENT(ptr));
    printf("%d", INCREMENT(x));

    // The macro is expanded as 2 + 3 * 3 + 5, not as 5*8
    printf("%d", MULTIPLY(2 + 3, 3 + 5));

    printf("%d", MULTIPLY2(2 + 3, 3 + 5));

    printf("%d ", merge(12, 34));

    printf("%s", get(GeeksQuiz));
    int i = 0;
    PRINT(i, 3);
    //Preprocessors also support if-else directives which are typically used for conditional compilation.
    #if VERBOSE >= 2
    printf("Trace Message");
    #endif

    // use of macro div
    // Note: %0.2f for taking two decimal value after point
    printf("%0.2f", div(10.0, 5.0));
// removing defined macro div
#undef div
    // function div is called as macro definition is removed
    printf("\n%0.2f", div(10.0, 5.0));
    return 0;
}
// div function definition
float div(float x, float y) { return y / x; }