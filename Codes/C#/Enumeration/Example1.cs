/*
An enumeration is a set of named integer constants. 
An enumerated type is declared using the enum keyword.

C# enumerations are value data type. I
n other words, enumeration contains its own values and cannot inherit or cannot pass inheritance.
*/
using System;

namespace EnumApplication {
   class EnumProgram {
      enum Days { Sun, Mon, tue, Wed, thu, Fri, Sat };

      static void Main(string[] args) {
         int WeekdayStart = (int)Days.Mon;
         int WeekdayEnd = (int)Days.Fri;
         
         Console.WriteLine("Monday: {0}", WeekdayStart);
         Console.WriteLine("Friday: {0}", WeekdayEnd);
         Console.ReadKey();
      }
   }
}