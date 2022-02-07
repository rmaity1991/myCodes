/*
For representing floating point numbers, we use float, double and long double.

What’s the difference ?

double has 2x more precision then float.

float is a 32 bit IEEE 754 single precision Floating Point Number1 bit for the sign, 
(8 bits for the exponent, and 23* for the value), i.e. float has 7 decimal digits of precision.

double is a 64 bit IEEE 754 double precision Floating Point Number 
(1 bit for the sign, 11 bits for the exponent, and 52* bits for the value), i.e. 
double has 15 decimal digits of precision.
*/
// C program to demonstrate 
// double and float precision values
  
#include <stdio.h>
#include <math.h>
  
// utility function which calculate roots of 
// quadratic equation using double values
void double_solve(double a, double b, double c){
    double d = b*b - 4.0*a*c;
    double sd = sqrt(d);
    double r1 = (-b + sd) / (2.0*a);
    double r2 = (-b - sd) / (2.0*a);
    printf("%.5f \t %.5f \n", r1, r2);
}
  
// utility function which calculate roots of 
// quadratic equation using float values
void float_solve(float a, float b, float c){
    float d = b*b - 4.0f*a*c;
    float sd = sqrtf(d);
    float r1 = (-b + sd) / (2.0f*a);
    float r2 = (-b - sd) / (2.0f*a);
    printf("%.5f \t %.5f \n", r1, r2);
}   
  
// driver program
int main(){
    float fa = 1.0f;
    float fb = -4.0000000f;
    float fc = 3.9999999f;
    double da = 1.0;
    double db = -4.0000000;
    double dc = 3.9999999;
  
    printf("roots of equation x2 - 4.0000000 x + 3.9999999 = 0 are : \n");
    printf("for float values: \n");
    float_solve(fa, fb, fc);
  
    printf("for double values: \n");
    double_solve(da, db, dc);
    return 0;
}  