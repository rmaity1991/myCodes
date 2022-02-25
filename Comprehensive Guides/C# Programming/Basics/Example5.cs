/*
Type Casting in C#
When the variable of one data type is changed to another data type is known as the Type Casting. 
According to our needs, we can change the type of data. At the time of the compilation, C# is a statically-typed i.e., 
after the declaration of the variable, we cannot declare it again. The value of the variable cannot be assigned to another 
type of variable unless we implicitly change the type of the variable.

Here we will take an example of the string data type. We cannot convert the string implicitly to the int. Therefore, if 
we declare the variable 'i' as an int, we cannot assign the string value "Hello" into it.
However, we can face a situation when there is a need to copy the value of one variable into another variable or method 
parameter of another type. For example, we have a variable integer, and we need to pass it to a method parameter whose 
type is double. Or the situation can be to assign the class variable to the variable of the type of interface. These types 
of operations are called Type Conversion.

In C#, we can perform a different kinds of conversions.
Implicit Conversion: For the implicit conversion, there is not any need for the special syntax. This type of conversion is safe; 
in this conversion, there is not any loss of the data. Implicit conversions include the conversion of the small type to large integral types, 
and from the derived class to the base class conversion.

Explicit Conversion (Type Caste): Explicit conversion will be done with the cast operator (). We will do the casting when 
there is the situation of the data loss, or when the conversion is not succeeded. There can be any other reason for the explicit conversion. 
The example of the casting is the conversion of the numeric type to the less precision or smaller range. Explicit Conversion also 
includes the conversion of the base-class instance to the derived class.

User-Defined Conversion: We can do this conversion by defining the method. We can use the technique to enable the 
explicit-implicit conversion between the custom type, which does not have any relationship with the base-class or derived-class.
Conversion with the helper class: For the conversion of the non-compatible type like integer and System.DateTime objects or 
hexadecimal strings and byte arrays, we can use System.BitConversion class, System. Convert class and the Parse methods of the 
built-in numeric type like as int32 Parse.


Implicit Conversion: We can easily understand and use the implicit conversion. Here we are going to assign the integer to the double 
is known as the implicit conversion because we are haven't lost any data in this conversion.

To understand this conversion here, we are going to take an example.
*/
using System;  
namespace ConsoleApp2  
{  
    class SumProgramme  
    {  
        static void Main(string[] args)  
        {  
            int value1 = 567;  
            int value2 = 765;  
            long summation;  
  
            summation = value1 + value2;  
  
            Console.WriteLine("summation = " + summation);  
  
            Console.ReadLine();  
        }  
    }  
}  