/*
In C#, value-type parameters are that pass a copy of original value to the function rather than reference. 
It does not modify the original value. A change made in passed value does not alter the actual value. In the following example, 
we have pass value during function call.
*/
using System;  
namespace CallByValue  
{  
    class Program  
    {  
        // User defined function  
        public void Show(int val)  
        {  
             val *= val; // Manipulating value  
            Console.WriteLine("Value inside the show function "+val);  
            // No return statement  
        }  
        // Main function, execution entry point of the program  
        static void Main(string[] args)  
        {  
            int val = 50;  
            Program program = new Program(); // Creating Object  
            Console.WriteLine("Value before calling the function "+val);  
            program.Show(val); // Calling Function by passing value            
            Console.WriteLine("Value after calling the function " + val);  
        }  
    }  
}  