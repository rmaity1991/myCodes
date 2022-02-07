/*
Conditional Directives
You can use the #if directive to create a conditional directive. Conditional directives are useful for testing 
a symbol or symbols to check if they evaluate to true. If they do evaluate to true, the compiler evaluates all 
the code between the #if and the next directive.
*/
#define DEBUG
#define VC_V10
using System;

public class TestClass {
   public static void Main() {
      #if (DEBUG && !VC_V10)
         Console.WriteLine("DEBUG is defined");
      #elif (!DEBUG && VC_V10)
         Console.WriteLine("VC_V10 is defined");
      #elif (DEBUG && VC_V10)
         Console.WriteLine("DEBUG and VC_V10 are defined");
      #else
         Console.WriteLine("DEBUG and VC_V10 are not defined");
      #endif
      Console.ReadKey();
   }
}