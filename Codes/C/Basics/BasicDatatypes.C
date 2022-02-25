#include<stdio.h>

int main(){
    /*
    The Basic Datatypes in C programming are of 2 types namely 
    1) Primitive Datatypes - byte,short,int,float,double,long, long double
    2) No Primitive Types - Strings & Arrays
    3) User Defined - Structure & Unions
    */
   short f;
   int a=3; // declaring the integer type
   float b=34; // declaring the float type
   double c= 34.56; // declaring double type
   long d=34.67890; // declaring long type
   long double e= 3456.7890; // declaring long double


   // Size of the variables which arevdeclared
   printf("The size of short is %d \n",sizeof(f));
   printf("The size of int is %d \n",sizeof(a));
   printf("The size of float is %d \n",sizeof(b));
   printf("The size of double is %d \n",sizeof(c));
   printf("The size of long is %d \n",sizeof(d));
   printf("The size of long double is %d \n",sizeof(e));

   // Type coversions - Implicit Type & Explicit Type

   float x=a;
   double y=b;
   long z=c;

   printf("The converted value from int %d to float is %f \n",a,x);
   printf("The converted value from float %f to double is %f \n",b,y);
   printf("The converted value from double %f to long is %f \n",c,z);

   int var1=(int)b; // This is called type casting - converting a larger datatype to a smaller one.
   float var2=(float)c;
   double var3=(double)d;
   long var4=(long)e;

   // This ends the basic datatypes
   
   long var5=12.4567;

   printf("The value of var1 is %d \n",var5);
   printf("The value of var1 is %0.4d \n",var5);
   printf("The value of var1 is %2.4d \n",var5);

   printf("The value of var1 is %f \n",var5);
   printf("The value of var1 is %0.4f \n",var5);
   printf("The value of var1 is %2.4f \n",var5);



   return 0;


}