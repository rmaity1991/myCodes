/*
Defining Constants
Constants are defined using the const keyword
*/

using System;

class Example5 {
      static void Main(string[] args) {
         const double pi = 3.14159;   
            
         // constant declaration 
         double r;
         Console.WriteLine("Enter Radius: ");
         r = Convert.ToDouble(Console.ReadLine());
            
         double areaCircle = pi * r * r;
         Console.WriteLine("Radius: {0}, Area: {1}", r, areaCircle);
         Console.ReadLine();
      }
   }