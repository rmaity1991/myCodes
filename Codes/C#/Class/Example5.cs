/*
Static Members of a C# Class
We can define class members as static using the static keyword. When we declare a member of a class as static, 
it means no matter how many objects of the class are created, there is only one copy of the static member.

The keyword static implies that only one instance of the member exists for a class. Static variables are used for 
defining constants because their values can be retrieved by invoking the class without creating an instance of it. 
Static variables can be initialized outside the member function or class definition. You can also initialize static 
variables inside the class definition.

You can also declare a member function as static. Such functions can access only static variables. The static functions 
exist even before the object is created
*/

using System;

namespace StaticVarApplication {
   class StaticVar {
      public static int num;
      
      public void count() {
         num++;
      }
      public int getNum() {
         return num;
      }
      public static int getNumstatic() {
         return num;
      }
   }
   class StaticTester {
      static void Main(string[] args) {
         StaticVar s1 = new StaticVar();
         StaticVar s2 = new StaticVar();
         
         s1.count();
         s1.count();
         s1.count();
         
         s2.count();
         s2.count();
         s2.count();
         
         Console.WriteLine("Variable num for s1: {0}", s1.getNum());
         Console.WriteLine("Variable num for s2: {0}", s2.getNum());

         Console.WriteLine("Variable num: {0}", StaticVar.getNumstatic());
         Console.ReadKey();
      }
   }
}