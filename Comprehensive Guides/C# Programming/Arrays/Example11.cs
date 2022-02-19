/*
In C#, params is a keyword which is used to specify a parameter that takes variable number of arguments. 
It is useful when we don't know the number of arguments prior. Only one params keyword is allowed and no additional parameter is 
permitted after params keyword in a function declaration.
*/

using System;  
namespace AccessSpecifiers  
{  
    class Program  
    {  
        // User defined function  
        public void Show(params int[] val) // Params Paramater  
        {  
            for (int i=0; i<val.Length; i++)  
            {  
                Console.WriteLine(val[i]);  
            }  
        }  
        // Main function, execution entry point of the program  
        static void Main(string[] args)  
        {  
            Program program = new Program(); // Creating Object  
            program.Show(2,4,6,8,10,12,14); // Passing arguments of variable length  
        }  
    }  
}  
