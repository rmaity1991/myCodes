#include<iostream>
/*
Inheritance is very important concept of OOPS, because it helps us create objects classes from existing classes

*/

using namespace std;

class Index{ // Base Class

protected:
int count;

public:

Index(){
    count=0;
}

void display(){
    cout<<"count ="<<count<<endl;
}

void operator ++ (){
    count++;
}

};

class NewIndex:public Index{ // This is a Inherited Class from Index and Index is made public so that its metods are accessible

public:

NewIndex(){
    count=-1;
}
void operator -- (){
    count--;
}

};


const int MAX=10;

class Stack { // Base class 

protected:
int arr[MAX];
int top;

public:
Stack(){
    top=-1;
}

void push(int num){
    top++;
    arr[top]=num;
}

int pop(){
    int num;
    num=arr[top];
    top--;
    return num;
}

};

class NewStack:public Stack{ // Inherited Class
     public:
     bool isfull(){
         if(top==MAX-1){
             return true;
         }
         else{
             return false;
         }
     }

     bool isempty(){
         if(top==-1){
             return true;
         }
         else{
             return false;
         }
     }
};


// Now we will use Inheritance for the purposes which it is defined

/*
1) Use existing functionality
2) Override existing functionality
3) Provide new functionality
4) Combination of existing and new functionality
*/

class Ex{
    public:

    Ex(){

    }

    void fun(){
        cout<<"Inside Ex- fun()"<<endl;
    }

    void save(){
        cout<<"Inside Ex- save()"<<endl;
    }

    void enc(){
        cout<<"Inside Ex- enc()"<<endl;
    }

    void open(){
        cout<<"Inside Ex- open()"<<endl;
    }
};

class NewEx:public Ex{

   void fun(){
        cout<<"Inside NewEx- fun()"<<endl;
    }

    void save(){
        cout<<"Inside NewEx- save()"<<endl;
    }

    void enc(){
        cout<<"Inside NewEx- enc()"<<endl;
    }

    void open(){
        cout<<"Inside NewEx- open()"<<endl;
    } 
};

int main(){
    
    NewIndex x; // Here constructor is called for New Index and not Index.

    ++x;
    ++x;

    x.display();
    --x;
    x.display();

    NewStack stk;

    if(!stk.isfull()){
        stk.push(10);
    }
    else{
        cout<<"Stack is Full"<<endl;
    }

    if(!stk.isfull()){
        stk.push(20);
    }
    else{
        cout<<"Stack is Full"<<endl;
    }



    


    return 0;

}