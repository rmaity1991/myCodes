#include<iostream>

using namespace std;

/*
Usage of const keyword in 2 ways
1) to prevent variables from modified
2) to prevent a function from modifying actual arguments using formal arguments

we can you use const in 3 more situations

1) on objects
2) on member functions of classes
3) on member function arguments
*/

class Sample{
    private:
     int data;

    public:
     Sample(){
         data=0;
     }

     void changeData() const
     {
         // data=10;
     }

     void showData(){
         cout<<endl<<"data ="<<data<<endl;
     }

     void add(Sample const &s,Sample const &t){
         data=s.data+t.data;
         // s.data=34; //error
         // t.data=54; //error
     }

     void getData(){
         cin>>data;
     }
};