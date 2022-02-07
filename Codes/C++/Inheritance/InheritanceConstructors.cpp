#include<iostream>

using namespace std;

class Base{
    public:
    Base(){
        cout<<"Base 0 arg Constructor"<<endl;
    }

    Base(int x){
        cout<<"Base 1 arg Constructor"<<endl;
    }

};

class Der:public Base{
    public:
    Der(){
        cout<<"Derived class 0 arg Constructor"<<endl;
    }

    Der(int x):Base(x){ // This helps to call the consructor of Der otherwise the Base(int x) would have been called.

        cout<<"Der's 1 arg constructor"<<endl;

    }
};

int main(){

    return 0;
}