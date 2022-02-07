/*
The word polymorphism means having many forms. In object-oriented programming paradigm, polymorphism is often expressed as 
'one interface, multiple functions'.

Polymorphism can be static or dynamic. In static polymorphism, the response to a function is determined at the compile time. 
In dynamic polymorphism, it is decided 
at run-time.

Static Polymorphism
The mechanism of linking a function with an object during compile time is called early binding. It is also called static 
binding. C# provides two techniques to implement static polymorphism. They are −

Function overloading
Operator overloading

Function Overloading
You can have multiple definitions for the same function name in the same scope. The definition of the function must differ 
from each other by the types and/or the number of arguments in the argument list. You cannot overload function declarations 
that differ only by return type.
*/
using System;

namespace PolymorphismApplication {
   class Printdata {
      void print(int i) {
         Console.WriteLine("Printing int: {0}", i );
      }
      void print(double f) {
         Console.WriteLine("Printing float: {0}" , f);
      }
      void print(string s) {
         Console.WriteLine("Printing string: {0}", s);
      }
      static void Main(string[] args) {
         Printdata p = new Printdata();
         
         // Call print to print integer
         p.print(5);
         
         // Call print to print float
         p.print(500.263);
         
         // Call print to print string
         p.print("Hello C++");
         Console.ReadKey();
      }
   }
}