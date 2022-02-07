/*
Encapsulation is defined 'as the process of enclosing one or more items within a physical or logical package'. 
Encapsulation, in object oriented programming methodology, prevents access to implementation details.

Abstraction and encapsulation are related features in object oriented programming. 
Abstraction allows making relevant information visible 
and encapsulation enables a programmer to implement the desired level of abstraction.

Encapsulation is implemented by using access specifiers. 
An access specifier defines the scope and visibility of a class member. C# supports the following access specifiers −

Public
Private
Protected
Internal
Protected internal
*/

using System;

namespace RectangleApplication {
   class Rectangle {
      //member variables
      public double length;
      public double width;
      
      public double GetArea() {
         return length * width;
      }
      public void Display() {
         Console.WriteLine("Length: {0}", length);
         Console.WriteLine("Width: {0}", width);
         Console.WriteLine("Area: {0}", GetArea());
      }
   }//end class Rectangle
   
   class ExecuteRectangle {
      static void Main(string[] args) {
         Rectangle r = new Rectangle();
         r.length = 4.5;
         r.width = 3.5;
         r.Display();
         Console.ReadLine();
      }
   }
}