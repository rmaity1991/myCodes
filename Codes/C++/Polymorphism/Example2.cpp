#include<iostream>

using namespace std;

class Shape {
   protected:
      int width, height;
      
   public:
      Shape( int a = 0, int b = 0) {
         width = a;
         height = b;
      }
      virtual int area() {
         cout << "Parent class area :" <<endl;
         return 0;
      }
};

/*
A virtual function is a function in a base class that is declared using the keyword virtual. 
Defining in a base class a virtual function, with another version in a derived class, signals to the 
compiler that we don't want static linkage for this function.

What we do want is the selection of the function to be called at any given point in the program to be 
based on the kind of object for which it is called. This sort of operation is referred to as dynamic linkage, or 
late binding.
*/