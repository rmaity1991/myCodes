/*
C# Generics
Generic is a concept that allows us to define classes and methods with placeholder. C# compiler replaces these placeholders with 
specified type at compile time. The concept of generics is used to create general purpose classes and methods.

o define generic class, we must use angle <> brackets. The angle brackets are used to declare a class or method as generic type. 
In the following example, we are creating generic class that can be used to deal with any type of data.
*/

using System;  
namespace CSharpProgram  
{  
    class GenericClass<T>  
    {  
        public GenericClass(T msg)  
        {  
            Console.WriteLine(msg);  
        }  
    }  
    class Program  
    {  
        static void Main(string[] args)  
        {  
            GenericClass<string> gen   = new GenericClass<string> ("This is generic class");  
            GenericClass<int>    genI  = new GenericClass<int>(101);  
            GenericClass<char>   getCh = new GenericClass<char>('I');  
        }  
    }  
}  
