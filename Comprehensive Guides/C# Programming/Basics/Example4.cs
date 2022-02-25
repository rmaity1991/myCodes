/*
A variable is a name of memory location. It is used to store data. Its value can be changed and it can be reused many times.

It is a way to represent memory location through symbol so that it can be easily identified.
A data type specifies the type of data that a variable can store such as integer, floating, character etc.
The value data types are integer-based and floating-point based. C# language supports both signed and unsigned literals.

There are 2 types of value data type in C# language.
1) Predefined Data Types - such as Integer, Boolean, Float, etc.

2) User defined Data Types - such as Structure, Enumerations, etc.

The memory size of data types may change according to 32 or 64 bit operating system.

The reference data types do not contain the actual data stored in a variable, but they contain a reference to the variables.

If the data is changed by one of the variables, the other variable automatically reflects this change in value.

There are 2 types of reference data type in C# language.
Predefined Types - such as Objects, String
User defined Types - such as Classes, Interface.

The pointer in C# language is a variable, it is also known as locator or indicator that points to an address of a value.
The pointer in C# language can be declared using * (asterisk symbol).

*/
using System;

public class Example4{
    public static void Main(String[] args){

        int * a;  //pointer to int      
        char * c; //pointer to char  

    }
}