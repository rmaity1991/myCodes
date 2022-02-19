using System;  
namespace AccessSpecifiers  
{  
    class Program  
    {  
        // User defined function  
        public void Show(params object[] items) // Params Paramater  
        {  
            for (int i = 0; i < items.Length; i++)  
            {  
                Console.WriteLine(items[i]);  
            }     
        }  
        // Main function, execution entry point of the program  
        static void Main(string[] args)  
        {  
            Program program = new Program(); // Creating Object  
            program.Show("Ramakrishnan Ayyer","Ramesh",101, 20.50,"Peter", 'A'); // Passing arguments of variable length  
        }     
    }  
}  