#include<iostream>

using namespace std;

int main(){

    /*
    Static memory allocation which is done on stack where how much memory to allocate the
    decision is taken on compilatuon time.
    */

   int i=100;
   float x;
   double y;

   int *ptr=&i;

   cout<<*ptr<<endl;
   cout<<&ptr<<endl;
   cout<<ptr<<endl;

   /*
   Dynamic memory allocation take place dusring execution time and is stored on the heap
   and it can be freed. Dynamic aalocations are done using the new keyword and deleted usig
   the delete keyword. This is used for large datatypes and takes care of the overheads
   */

  int *ptrint=new int; 
  float *ptrfloat=new float;
  double *ptrdouble=new double;

  // The new operator allocates the memory and returns a pointer to the address.

  *ptrint=23;
  *ptrfloat=23.45;
  *ptrdouble=45678;

  cout<<&ptrint<<endl; // address of the pointer
  cout<<ptrint<<endl; // address stored inside the pointer
  cout<<*ptrint<<endl; // value of the address stored inside the pointer.


  delete ptrint;
  delete ptrfloat;
  delete ptrdouble;
  return 0;
}