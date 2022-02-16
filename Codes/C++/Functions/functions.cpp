#include<iostream>

# define square(x) (x*x) // defining macro functions

using namespace std;

void display(); // Function Prototype which needs to be there for the compiler.

int sum(int,int y=0);

float sum(float,float);

double sum(double,double y=0);

int * addNumber(int * , int *); // This is a pointer function prototype
// Here we are going to use functions to operate on the Complex structure.

struct Complex{
    float real;
    float imag;
};
// Function prototypes of Complex Structures
Complex operator +(Complex,Complex); // For Operator Overloading

Complex operator -(Complex,Complex); // For Operator Overloading


Complex display(Complex);

Complex setComplex(float ,float);


// Inline Functions removes excess overheads
// and replaces the call area with the code
// written here.
inline int avg(int x, int y){
    return (x+y)/2;
}

int main(){

    display(); // function call as defined.
    sum(10); // a fucntion with one parameter and one default value.
    sum(34,56); // a function with both paramtetrs.

    sum(34.56,56.67); // a function with long both paramtetrs.
    sum(34.7,56.4); // a function with double both paramtetrs.

    Complex a,d,t,u; // Defining Complex Structures

    a=setComplex(23,45); // Setting the Complex Number
    d=setComplex(34,56); // Setting the Complex Number

    display(a); // Calling Display Function
    display(d);

    t=a+d; // Adding Complex Number based on operator overloading
    u=a-d; // Subtract Complex Number based on operator overloading

    display(t);
    display(u);

    square(10);

    int i=avg(10,20); // Inline Functions
    int j=avg(34,45); // Inline Functions

    cout<<i<<endl;
    cout<<j<<endl;

    int * result=addNumber(&i,&j);

    cout<<*result<<endl;

    return 0;
}
// This is zero parameter zero return function.
void display(){
    cout<<"Hello This is a function"<<endl;
}
int sum(int x,int y){
    cout<<(x+y)<<endl;
    return x+y;
}

float sum(float x,float y){
    cout<<(x+y)<<endl;
    return x+y;
}
double sum(double x,double y){
    cout<<(x+y)<<endl;
    return x+y;
}

Complex operator +(Complex x, Complex y){
    Complex temp;
    temp.real=x.real+y.real;
    temp.imag=x.imag+y.imag;
    return temp;
}

Complex operator -(Complex x, Complex y){
    Complex temp;
    temp.real=x.real-y.real;
    temp.imag=x.imag-y.imag;
    return temp;
}

Complex display(Complex t){

    cout<<t.real<<"+"<<t.imag<<"i"<<endl;

}

Complex setComplex(float x ,float y){
    Complex temp;
    temp.real=x;
    temp.imag=y;
    return temp;
}
// Function using Pointers and Address
int * addNumber( int *x, int *y){
    int *ptr=new int;

    *ptr=*x+*y;

    return ptr;
}

