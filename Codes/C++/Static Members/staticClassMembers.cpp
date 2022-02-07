#include<iostream>

using namespace std;

class Circle{

    private:

    char color;
    float radius;
    static int count; // Here we have static member which will count the number of times
    // this class is called. This value does not need any object to initialized
// This static memeber can only be accesed using the constructors

    public:

    Circle(char c,float r){
        color=c;
        radius=r;
        count++;
    }

    static void showCount(){
        cout<<"Count ="<<count<<endl;
    }
};

int Circle::count=0; // defining the static member outside the main function
/*
Few points to note for static memebers

1) An instance memeber function (like constructor) can access instance
as well as static data members
2) a static memeber function can access only static data memebers.
3) this pointer never exists for static function
4) static data member has nothing to do with static storage class.
*/
int main(){

   Circle c('R',1.2f);

   c.showCount(); // calling static function using objects created from Circle class

   Circle::showCount(); // calling static functions using Circle class


    

    return 0;
}