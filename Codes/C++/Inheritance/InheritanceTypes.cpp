#include<iostream>

using namespace std;

/*
The types of Inheritance are 

1) Single Inheritance
  a) Public Inheritance
  b) Protected Inheritance
  c) Private Inheritance

  Example :

  class Sample:public base

  class Sample: private base

  class Sample: protected base

2) Multiple Inheritance

 class Sample: public Base1, public Base2
*/

class Item{
    private:

    string title;
    float price;

    public:

    void getData();

    void displayData();
};

class Sales{
    private:
    float salesFigure[3];
    public:

    void getData();
    void displayData();
};

class HardwareItem:private Item,private Sales{
    private:
     string category;
     string oem;
    public:
     void getData();
     void displayData();
};

class SoftwareItem:private Item,private Sales{
    private:
     string category;
     string os;
    public:
     void getData();
     void displayData();
};



