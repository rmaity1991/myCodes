#include<iostream>

using namespace std;

int addSum(int&,int&);
void swap(int&,int&);
void swap(int*,int*);
int main(){
    int i=10;

    int x=12;
    int y=23;

    /*
    A reference contains address of the variable that it is refereing to. 
    But to access the data of the reference we do not need the * as we use in pointers.

    */

    int &j=i;

    int result=addSum(x,y);

    cout<<result<<endl;

    cout<<endl<<i<<endl<<j<<endl;
    j++;
    cout<<endl<<i<<endl<<j<<endl;

    cout<<"The value of x before swap"<<x<<endl;
     cout<<"The value of y before swap"<<y<<endl;

    swap(x,y);

    cout<<"The value of x after swap"<<x<<endl;
     cout<<"The value of y after swap"<<y<<endl;


    cout<<"The value of x before swap"<<x<<endl;
     cout<<"The value of y before swap"<<y<<endl;

    swap(&x,&y);

    cout<<"The value of x after swap"<<x<<endl;
     cout<<"The value of y after swap"<<y<<endl;



}

int addSum(int& a, int& b){
    int c=a+b;
    return c;
}

void swap(int & a, int&b){
    int temp;
    temp=a;
    a=b;
    b=temp;
}

void swap(int * a, int *b){
    int temp;
    temp=*a;
    *a=*b;
    *b=temp;
}

