#include<iostream>

using namespace std;

template <class T>

class Stack{
    private:
    T stk[100];
    int top;

    public:
     Stack(){
         top=-1;
     }

     void push(T data){
         if(top==100-1){
             cout<<"The stack is full"<<endl;
         }
         else{
             top++;
             stk[top]=data;
         }
         
     }

     T pop(){
         if(top==-1){
             cout<<"Stack is empty"<<endl;
         }
         else{
             T data;
             data=stk[top];
             top--;
             return data;

         }
         
     }
};

int main(){
    
    return 0;
}

