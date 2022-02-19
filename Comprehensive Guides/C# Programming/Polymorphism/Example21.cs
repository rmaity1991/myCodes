
/*
Operator overloading & Inheritance
Another instance is that even if you declare the overloaded operators as static, they will inherit the derived class. 
This happens because the operator's declaration requires it to be struct or class where the operator is being declared. 
It facilitates the operator's signature. Thus, it is not possible for an operator previously declared in the derived class 
to hide an operator present in the parent class already. Hence, the new modifier is not an option to consider since they are 
not allowed while declaring the operator. This instance can be shown using the following code snippet given below.
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
    public static Complex operator +(Complex c1, Complex c2)    
    {    
        Complex temp = new Complex();    
        temp.x = c1.x + c2.x;    
        temp.y = c1.y + c2.y;    
        return temp;    
    }    
}    
class MyComplex: Complex    
{    
    private double x;    
    private double y;    
    public MyComplex(double i, double j)    
    {    
        x = i;    
        y = j;    
    }    
    public MyComplex()    
    {    
    }    
    public new void ShowXY()    
    {    
        Console.WriteLine("{0} {1}", x, y);    
    }    
}    
class MyClient    
{    
    public static void Main()    
    {    
        MyComplex mc1 = new MyComplex(1.5, 2.5);    
        mc1.ShowXY();    
        MyComplex mc2 = new MyComplex(3.5, 4.5);    
        mc2.ShowXY();    
        MyComplex mc3 = new MyComplex();    
        //mc3 = mc1 + mc2;    
        //mc3.ShowXY();    
    }    
}     