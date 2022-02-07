#include<stdio.h>

int main(){
    int n,d5,d4,d3,d2,d1,revnum;

    printf("Enter the number to be reversed ( less than 32567) :");
    scanf("%d",&n);

    d5=n%10; // Remainder operator
    n=n/10; // Normal Division Operator
    d4=n%10;
    n=n/10;
    d3=n%10;
    n=n/10;
    d2=n%10;
    n=n/10;
    d1=n%10;
    n=n/10;

    revnum=d5*10000+d4*1000+d3*100+d4*10+d5*1;

    printf("The reversed number is : %d",revnum);

    return 0;


}
