/*
C# Protected Access Specifier
It is accessible within the class and has limited scope. It is also accessible within sub class or child class, in case of inheritance.
*/
using System;  
namespace AccessSpecifiers  
{  
    class ProtectedTest  
    {  
        protected string name = "Shashikant";  
        protected void Msg(string msg)  
        {  
            Console.WriteLine("Hello " + msg);  
        }  
    }  
    class Program  
    {  
        static void Main(string[] args)  
        {  
            ProtectedTest protectedTest = new ProtectedTest();  
            // Accessing protected variable  
            Console.WriteLine("Hello "+ protectedTest.name);  
            // Accessing protected function  
            protectedTest.Msg("Swami Ayyer");  
        }  
    }  
}  