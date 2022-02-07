#include<iostream>

using namespace std;

/*
Virtual Functions are those which calls different functions of the same name in inherited classes
*/

class Shape{
    public:
     virtual void draw(){
         cout<<"In Shape Class"<<endl;
     }

};

class Circle:public Shape{
    public:
     void draw(){
         cout<<"In Circle Class"<<endl;
     }
};

class Rectangle:public Shape{
    public:
     void draw(){
         cout<<"In Rectangle Class"<<endl;
     }
};


/*
Pure Virtual Function

For a pure virtual function we will omit the body of the virtual function as shown below.
This makes the class abstract. which means that only inherited class can be used to create the object.
we cannot use class london to create an object.
*/

// This is a virtual pure function and the class is abstract
class london{
    public:
     virtual void draw()=0; // Pure Virtual Functions
};

class newpork:public london{
    public:
     void draw(){
         cout<<"Now we are in newyork class"<<endl;
     }
};

int main(){
 

    Shape x;
    Circle y;
    Rectangle z;

    x.draw();
    y.draw();
    z.draw();

    Shape *p[]={&x,&y,&z};

    for(int i=0;i<3;i++){

        p[i]->draw();

    }

    return 0;
}

