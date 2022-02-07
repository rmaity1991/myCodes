#include<stdio.h>

void italy();
void brazil();
void argentina();

int main( )
{
 printf ( "\nI am in main" ) ;
 italy() ;
 printf ( "\nI am finally back in main" ) ;
}
void italy()
{
 printf ( "\nI am in italy" ) ;
 brazil( ) ;
 printf ( "\nI am back in italy" ) ;
}
void brazil()
{
 printf ( "\nI am in brazil" ) ;
 argentina( ) ;
}
void argentina()
{
 printf ( "\nI am in argentina" ) ;
} 