// C# - Array Class
/*
The Array class is the base class for all the arrays in C#. 
It is defined in the System namespace. 
The Array class provides various properties and methods to work with arrays.
*/

using System;

namespace ArrayApplication {
   class MyArray {
      static void Main(string[] args) {
         int[] list = { 34, 72, 13, 44, 25, 30, 10 };
         int[] temp = list;
         Console.Write("Original Array: ");
         
         foreach (int i in list) {
            Console.Write(i + " ");
         }
         Console.WriteLine();
         
         // reverse the array
         Array.Reverse(temp);
         Console.Write("Reversed Array: ");
         
         foreach (int i in temp) {
            Console.Write(i + " ");
         }
         Console.WriteLine();
         
         //sort the array
         Array.Sort(list);
         Console.Write("Sorted Array: ");
         
         foreach (int i in list) {
            Console.Write(i + " ");
         }
         Console.WriteLine();
         Console.ReadKey();
      }
   }
}