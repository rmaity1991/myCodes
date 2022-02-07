#include<iostream>

using namespace std;

/*
Templates are the best way for overloaded functions whic was defined earlier.
*/

// Template Funtions
// This entire declaration is called a function template.
template<class T>

T myMin(T a, T b){
    if(a>b){
        cout<<"The smaller is"<<a<<endl;
        return a;
    }
    else{
        cout<<"The smaller is"<<b<<endl;
        return b;
    }
}

template<class T, class S, class Z>

void fun(T a, S b, Z c){
    cout<<a<<endl<<b<<endl<<c<<endl;
}

int main(){

    myMin(1,2);
    myMin(3.2f,4.5f);
    myMin(23.45,34.56);


    fun(23,45.56f,56);


    return 0;
}
