using System;
/*
The variables in C#, are categorized into the following types −

Value types
Reference types
Pointer types
*/

/*
Reference Type
The reference types do not contain the actual data stored in a variable, but they contain a reference to the variables.
Example of built-in reference types are: object, dynamic, and string.
*/

/*
The Object Type is the ultimate base class for all data types in C# Common Type System (CTS). 
Object is an alias for System.Object class. The object types can be assigned values of any other types, 
value types, reference types, predefined or user-defined types.

Dynamic Type
You can store any type of value in the dynamic data type variable.
It is used to avoid the compile-time type checking. The compiler does not check the type of the dynamic type variable 
at compile time, 
instead of this, the compiler gets the type at the run time

String Type
The String Type allows you to assign any string values to a variable. 
The string type is an alias for the System.String class. 
It is derived from object type.

Pointer Type
Pointer type variables store the memory address of another type. 
Pointers in C# have the same capabilities as the pointers in C or C++.
*/


class Example3 {
      static void Main(string[] args) {
         Console.WriteLine("Size of int: {0}", sizeof(int));

         object obj;
obj = 100; // this is boxing

dynamic d = 20;
String str = "Tutorials Point";
// These are pointers variables
char* cptr;
int* iptr;
         Console.ReadLine();
      }
   }
