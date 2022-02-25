/*
Arguments that are passed by command line known as command line arguments. We can send arguments to the Main method while executing the code. 
The string args variable contains all the values passed from the command line.

In the following example, we are passing command line arguments during execution of program.
*/

using System;  
namespace CSharpProgram  
{  
    class Program  
    {  
        // Main function, execution entry point of the program  
        static void Main(string[] args) // string type parameters  
        {  
            // Command line arguments  
            Console.WriteLine("Argument length: "+args.Length);  
            Console.WriteLine("Supplied Arguments are:");  
            foreach (Object obj in args)  
            {  
                Console.WriteLine(obj);       
            }  
        }  
    }  
}  
