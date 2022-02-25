/*
C# Operator Overloading
Overloading is generally defined as a process of implementing popular

Object-oriented programming concepts such as Polymorphism, which means one name having different forms and implementations. 
It allows the variables or the object to take different kinds of forms while executing the code. It is mainly used when you want the 
method property not to be similar to the given arguments, rather want a different order of execution when one name can be used with 
different types of execution methods and properties. This can be achieved in a program with different types of parameters and their count. 
There are various types of operator overloading methods in C#. You will learn all such methods in this tutorial conveniently.

Operator Overloading Techniques in C#
Operator overloading in C# can be done using different forms of operators. But before proceeding to the techniques, let's consider the 
validations of operators and how are they used while performing operator overloading.
*/

using System;    
class Complex    
{    
    private int x;    
    private int y;    
    public Complex()    
    {    
    }    
    public Complex(int i, int j)    
    {    
        x = i;    
        y = j;    
    }    
    public void ShowXY()    
    {    
        Console.WriteLine("{0} {1}", x, y);    
    }    
    public static Complex operator -(Complex c)    
    {    
        Complex temp = new Complex();    
        temp.x = -c.x;    
        temp.y = -c.y;    
        return temp;    
    }    
}    
class MyClient    
{    
    public static void Main()    
    {    
        Complex c1 = new Complex(10, 20);    
        c1.ShowXY(); // displays 10 & 20    
        Complex c2 = new Complex();    
        c2.ShowXY(); // displays 0 & 0    
        c2 = -c1;    
        c2.ShowXY(); // diapls -10 & -20    
    }    
}  