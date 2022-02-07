#include<iostream>

using namespace std;

// Access Specifiers

    /*

    public : accessed by public

    private : accessed by class itself

    protected: accessed by class and inherited

    static: belongs to the class itself

    internal: belongs to class internal

    */

class Complex{

    private: // This are access specifiers which helps us in abstraction and polymorphism
     float real,imag;

    public :

    Complex(){
        this->real=0;
        this->imag=0;
    } // This is a zero argument constructor which will not define any complex
      // but will set the initial paramters to be zero

    Complex(float x,float y){
        this->real=x;
        this->imag=y;
    } // This is a argument constructor which sets the real and imag to the ones which
    // the user defines.

    ~ Complex(){
        cout<<"The item has been deleted"<<endl;
    } // destructor creations

    void display(){

        cout<<this->real<<"+"<<this->imag<<"i"<<endl;

    }

    void displayOther(Complex t){

        cout<<t.real<<"+"<<t.imag<<"i"<<endl;

    }

    Complex addComplex(Complex t,Complex u){
        Complex temp;
        temp.real=t.real+u.real;
        temp.imag=t.imag+u.imag;
        return temp;
    }

    // Operator overloading + in class methods.

    Complex operator +(Complex u){
        Complex t;

        t.real=this->real+u.real;
        t.imag=this->imag+u.imag;
        return t;

    }

    // Operator overloading - in class methods.

    Complex operator -(Complex u){
        Complex t;

        t.real=this->real-u.real;
        t.imag=this->imag-u.imag;
        return t;

    }

    // Operator overloading * in class methods.

    Complex operator *(Complex u){
        Complex t;

        t.real=this->real*u.real;
        t.imag=this->imag*u.imag;
        return t;

    }
    // Operator overloading / in class methods.

    Complex operator /(Complex u){
        Complex t;

        t.real=this->real/u.real;
        t.imag=this->imag/u.imag;
        return t;

    }

    float conjugate(){

        float x=this->real*this->real;
        float y=this->imag*this->imag;
        return (x-y);

    }

    
};


class Index{

private:
int count;

public:
Index(){
    count=0;
}

Index(int i){
    count=i;
}

Index operator ++(){
    ++count;
    return *this;
}

Index operator ++ (int ){
    Index temp(count);
    count++;
    return temp;
}


};


struct example{
    private:
    int x,y;
    public:

    void setValue(int x, int y){
        x=x;
        y=y;
    }

    void display(){
        cout<<x<<endl;
        cout<<y<<endl;
    }
};

int main(){

    Complex x (23,34);
    Complex y;

    y.display();

    x.display();

    return 0;
}