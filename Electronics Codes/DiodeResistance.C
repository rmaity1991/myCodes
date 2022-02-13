#include<stdio.h>

int main(){

    float iD;
    printf("Enter the value of Diode Current");

    scanf("%f",&iD);

    float rD=0.00026/iD;



    printf("The value of Diode Resistance is %5f",rD);
}