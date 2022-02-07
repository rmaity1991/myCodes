/*
C# Constructors
A class constructor is a special member function of a class that is executed whenever we create new objects of that class.

A constructor has exactly the same name as that of class and it does not have any return type.
A default constructor does not have any parameter but if you need, a constructor can have parameters. 
Such constructors are called parameterized constructors.
*/
using System;

namespace LineApplication {
   class Line {
      private double length;   // Length of a line
      
      public Line() {
         Console.WriteLine("Object is being created");
      }
      public Line(double len) {  //Parameterized constructor
         Console.WriteLine("Object is being created, length = {0}", len);
         length = len;
      }
      public void setLength( double len ) {
         length = len;
      }
      public double getLength() {
         return length;
      }

      static void Main(string[] args) {
         Line line = new Line();    
         
         // set line length
         line.setLength(6.0);
         Console.WriteLine("Length of line : {0}", line.getLength());
         Console.ReadKey();
      }
   }
}