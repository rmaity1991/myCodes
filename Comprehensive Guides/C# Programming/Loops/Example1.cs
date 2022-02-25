/*
The C# for loop is used to iterate a part of the program several times. If the number of iteration is fixed, 
it is recommended to use for loop than while or do-while loops.

The C# for loop is same as C/C++. We can initialize variable, check condition and increment/decrement value.
*/
using System;  
public class ForExample  
    {  
      public static void Main(string[] args)  
      {  
          for(int i=1;i<=10;i++){  // starts from 1 and goes looping till 10 and incremented by 1   
            Console.WriteLine(i);    
          }    
      }  
    }  