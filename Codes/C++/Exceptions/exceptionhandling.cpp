#include<iostream>
#include<fstream>
#include<string>
#include<exception>


using namespace std;


int main(){

    try
    {
        /* code */
    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << '\n';
    }
    


    return 0;
}