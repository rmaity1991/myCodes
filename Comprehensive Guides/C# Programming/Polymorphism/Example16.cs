/*
C# Protected Internal Access Specifier
Variable or function declared protected internal can be accessed in the assembly in which it is declared. 
It can also be accessed within a derived class in another assembly.
*/

using System;  
namespace AccessSpecifiers  
{  
    class InternalTest  
    {  
        protected internal string name = "Shantosh Kumar";  
        protected internal void Msg(string msg)  
        {  
            Console.WriteLine("Hello " + msg);  
        }  
    }  
    class Program  
    {  
        static void Main(string[] args)  
        {  
            InternalTest internalTest = new InternalTest();  
            // Accessing protected internal variable  
            Console.WriteLine("Hello " + internalTest.name);  
            // Accessing protected internal function  
            internalTest.Msg("Peter Decosta");  
        }  
    }  
}  
