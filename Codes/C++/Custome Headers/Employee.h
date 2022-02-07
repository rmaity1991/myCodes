#include<string>
using namespace std;
// The main function is included in the custom header .cpp
class Employee{
    private:
    string name;
    int age;

    public:
    Employee();
    Employee(string n, int a);
    void getData();
    void showData();
};


