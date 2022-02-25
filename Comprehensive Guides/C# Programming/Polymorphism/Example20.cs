/*
Binary Operator Overloading
To overload a binary operator, you must seek two arguments. You need to ensure that one of the operators should be of type class or struct where the operator is defined. As previously discussed, a binary operator cannot return void, but it can return all other types of values while implementing overloading. The general form of operator overloading in binary operators can be shown using the following syntax.
*/

using System;    
class Complex    
{    
    private int x;    
    private int y;    
    public Complex()    
    
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
class MyClient    
{    
    public static void Main()    
    {    
        Complex c1 = new Complex(10, 20);    
        c1.ShowXY(); // displays 10 & 20    
        Complex c2 = new Complex(20, 30);    
        c2.ShowXY(); // displays 20 & 30    
        Complex c3 = new Complex();    
        c3 = c1 + c2;    
        c3.ShowXY(); // dislplays 30 & 50    
    }    
}    