/*
The #define Preprocessor
The #define preprocessor directive creates symbolic constants.

#define lets you define a symbol such that, by using the symbol 
as the expression passed to the #if directive, the expression evaluates to true
*/

#define PI 
using System;

namespace PreprocessorDAppl {
   class Program {
      static void Main(string[] args) {
         #if (PI)
            Console.WriteLine("PI is defined");
         #else
            Console.WriteLine("PI is not defined");
         #endif
         Console.ReadKey();
      }
   }
}