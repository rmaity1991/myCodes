#include<stdio.h>

struct book
{
char name ;
float price ;
int pages ;
} ;
int main(){

    struct book b[100] ;
int i ;
for ( i = 0 ; i <= 99 ; i++ )
{
printf ( "\nEnter name, price and pages " ) ;
scanf ( "%c %f %d", &b[i].name, &b[i].price, &b[i].pages ) ;
}
for ( i = 0 ; i <= 99 ; i++ )
printf ( "\n%c %f %d", b[i].name, b[i].price, b[i].pages ) ;


    return 0;
}

void linkfloat( )
{
float a = 0, *b ;
b = &a ; /* cause emulator to be linked */
a = *b ; /* suppress the warning - variable not used */
}