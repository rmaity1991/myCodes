#include<iostream>

using namespace std;

class Vehicle
{
   public:
    virtual void speed()
    {
        cout<<endl<<"In speed of the Vehicle"<<endl;
    }

    virtual void maintainence()
    {
        cout<<endl<<"In maintainence of Vehicle"<<endl;
    }

    void value()
    {
        cout<<endl<<"In value of Vehicle"<<endl;
    }
};

class FourWheeler:public Vehicle
{
    public:
     void speed()
     {
         cout<<endl<<"In speed of the FourWheeler"<<endl;
     }

     void maintainence()
     {
        cout<<endl<<"In maintainence of FourWheeler"<<endl; 
     }

     
};


class TwoWheeler:public Vehicle
{
    public:
     void speed()
     {
         cout<<endl<<"In speed of the TwoWheeler"<<endl;
     }

     void maintainence()
     {
        cout<<endl<<"In maintainence of TwoWheeler"<<endl; 
     }

     void value()
     {
         cout<<endl<<"In value of TwoWheeler"<<endl;
     }

     
};

class AirBorne:public Vehicle
{
    public:
     void speed()
     {
         cout<<endl<<"In speed of the AirBorne"<<endl;
     }

};


int main(){

    Vehicle *ptr1;
    Vehicle v;

    ptr1=&v;

    ptr1->speed();
    ptr1->maintainence();
    ptr1->value();

    Vehicle *ptr2,*ptr3,*ptr4;

    FourWheeler maruti;
    TwoWheeler bajaj;
    AirBorne jumbo;

    ptr2=&maruti;
    ptr3=&bajaj;
    ptr4=&jumbo;

    ptr2->speed();
    ptr2->maintainence();

    ptr3->speed();
    ptr3->maintainence();


    return 0;
}