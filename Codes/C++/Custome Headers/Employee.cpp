#include<iostream>
#include "Employee.h"

// The main function is included in the custom header .cpp

using namespace std;

Employee::Employee(){
    name="";
    age=0;
}

Employee::Employee(string n, int a){
    name=n;
    age=a;
}

void Employee::getData(){
    cout<<endl<<"Enter the name and age"<<endl;
    cin>>name>>age;
}

void Employee::showData(){
    cout<<"name="<<name<<endl<<"age ="<<age<<endl;
}
