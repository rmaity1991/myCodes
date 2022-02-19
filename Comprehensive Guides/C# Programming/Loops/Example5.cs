/*
The C# do-while loop is used to iterate a part of the program several times. If the number of iteration is not fixed and you must 
have to execute the loop at least once, it is recommended to use do-while loop.

The C# do-while loop is executed at least once because condition is checked after loop body.
*/
using System;  
public class DoWhileExample  
    {  
      public static void Main(string[] args)  
      {  
          int i = 1;  
            
          do{  
              Console.WriteLine(i);  
              i++;  
          } while (i <= 10) ;  
    
     }  
   }  
