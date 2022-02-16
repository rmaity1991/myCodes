class Shape {
   protected:
      int width, height;

   public:
      Shape(int a = 0, int b = 0) {
         width = a;
         height = b;
      }
      
      // pure virtual function
      virtual int area() = 0;
};

//Pure Virtual Functions
/*
It is possible that you want to include a virtual function in a base class so that it may be redefined in a 
derived class to suit the objects of that class, 
but that there is no meaningful definition you could give for the function in the base class.
*/