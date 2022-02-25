/*
C# Private Access Specifier
Private Access Specifier is used to specify private accessibility to the variable or function. 
It is most restrictive and accessible only within the body of class in which it is declared.
*/

using System;  
namespace AccessSpecifiers  
{  
    class PrivateTest  
    {  
        private string name = "Shantosh Kumar";  
        private void Msg(string msg)  
        {  
            Console.WriteLine("Hello " + msg);  
        }  
    }  
    class Program  
    {  
        static void Main(string[] args)  
        {  
            PrivateTest privateTest = new PrivateTest();  
            // Accessing private variable  
            Console.WriteLine("Hello " + privateTest.name);  
            // Accessing private function  
            privateTest.Msg("Peter Decosta");  
        }  
    }  
}  
