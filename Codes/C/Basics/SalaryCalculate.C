#include<stdio.h>

int main(){

    float bp,da,hra,grpay;

    printf("Enter the Basic Salary of Ramesh :");
    scanf("%f",&bp); // user inputs stored in a variable address using scanf

    da=0.4*bp; // multiply
    hra=0.2*bp;
    grpay=bp+da+hra;

    printf("The basic Salary of Ramesh is : %f",bp);
    printf("The HRA of Ramesh is : %f",hra);
    printf("The Dearness Allowance is : %f",da);
    printf("The Gross Pay of Ramesh is : %f",grpay);

    return 0;
}