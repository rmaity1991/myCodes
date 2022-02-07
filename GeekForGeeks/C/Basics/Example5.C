/*
Block Scope: A Block is a set of statements enclosed within left and right braces i.e. ‘{‘ and ‘}’ respectively. 
Blocks may be nested in C(a block may contain other blocks inside it). A variable declared inside a block is accessible 
in the block and all inner blocks of that block, but not accessible outside the block. Basically these are local to the 
blocks in which the variables are defined and are not accessible outside.
*/
#include <stdio.h>
 
// Driver Code
int main()
{
    {
        int x = 10, y = 20;
        {
            // The outer block contains
            // declaration of x and
            // y, so following statement
            // is valid and prints
            // 10 and 20
            printf("x = %d, y = %d\n", x, y);
            {
                // y is declared again,
                // so outer block y is
                // not accessible in this block
                int y = 40;
 
                // Changes the outer block
                // variable x to 11
                x++;
 
                // Changes this block's
                // variable y to 41
                y++;
 
                printf("x = %d, y = %d\n", x, y);
            }
 
            // This statement accesses
            // only outer block's
            // variables
            printf("x = %d, y = %d\n", x, y);
        }
    }
    return 0;
}