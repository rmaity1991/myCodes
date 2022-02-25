/*
Function is a block of code that has a signature. Function is used to execute statements specified in the code block. 
A function consists of the following components:

Function name: It is a unique name that is used to make Function call.

Return type: It is used to specify the data type of function return value.

Body: It is a block that contains executable statements.

Access specifier: It is used to specify function accessibility in the application.

Parameters: It is a list of arguments that we can pass to the function during call.
*/

using System;  
namespace FunctionExample  
{  
    class Program  
    {  
        // User defined function without return type  
        public void Show() // No Parameter  
        {  
            Console.WriteLine("This is non parameterized function");  
            // No return statement  
        }  
        // Main function, execution entry point of the program  
        static void Main(string[] args)  
        {  
            Program program = new Program(); // Creating Object  
            program.Show(); // Calling Function             
        }  
    }  
}  
