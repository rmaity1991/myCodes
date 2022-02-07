// C# - Passing Parameters by Output
/*
A return statement can be used for returning only one value from a function. 
However, using output parameters, you can return two values from a function. 
Output parameters are similar to reference parameters, except that they transfer 
data out of the method rather than into it.
*/

using System;

namespace CalculatorApplication {
   class NumberManipulator {
      public void getValue(out int x ) {
         int temp = 5;
         x = temp;
      }
      static void Main(string[] args) {
         NumberManipulator n = new NumberManipulator();
         
         /* local variable definition */
         int a = 100;
         
         Console.WriteLine("Before method call, value of a : {0}", a);
         
         /* calling a function to get the value */
         n.getValue(out a);

         Console.WriteLine("After method call, value of a : {0}", a);
         Console.ReadLine();
      }
   }
}