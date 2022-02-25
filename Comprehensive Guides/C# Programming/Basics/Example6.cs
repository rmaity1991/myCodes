/*
Explicit Conversion
We can do the explicit conversion by defining the method. Users will do the explicit conversion. 
Users will do the conversion as per their requirements. The compiler will do the execution as per our command.

Now we will do this conversion by applying the following code:
*/

using System;  
using System.Collections.Generic;  
using System. Linq;  
using System. Text;  
using System.Threading.Tasks;  
  
namespace ConsoleApp2  
{  
    class ProgramExplicit  
    {  
        static void Main(string[] args)  
        {  
   double db = 7896.45;  
            int xy;  
  
            // here we do the cast double to int.  
            xy = (int)db;  
            Console.WriteLine(xy);  
            Console.ReadKey();  
        }  
    }  
}  