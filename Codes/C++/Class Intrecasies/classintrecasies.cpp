#include<iostream>

using namespace std;

struct Employee{
    string name;
    int age;
    float salary;
};
/*
Dynamic Aloocation of objects has one additional aspect to it as compared to dynamic allocation of built in types and arrays.
When objects are created dynamically using new keyword. 
1) It allocates storage of proper size to the object
2) Runs the constructor function
3) Return a pointer of correct type.
*/
class Sample{
    private:
    int i;float a;

    public:

    Sample(){
        i=10;
        a=3.14f;
    }

    Sample(int x,float y){
        i=x;
        a=y;
    }

    void showData(){
        cout<<i<<endl<<a<<endl;
    }

    ~ Sample(){
        cout<<"Reached Destructor"<<endl;
    }
};

int main(){
/*
Static memory allocations for Structures
*/

int num[25];
struct Employee x;

/*
Dynamic Memory Allocations
*/

int *intptr=new int[25]; // Arrays are handled by pointers by default. So & is not required.

struct Employee *ptr=new struct Employee;

ptr->name="Rohit Maity";
ptr->salary=15000;
ptr->age=30;

intptr[0]=34;
intptr[1]=45;

Sample *ptrsample= new Sample;

ptrsample->showData();

delete ptrsample;

Sample *ptrsample1= new Sample(23,45);

ptrsample1->showData();

delete ptrsample1;


    return 0;
}