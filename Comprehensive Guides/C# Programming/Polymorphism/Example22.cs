/*
Equality Operator Overloading
You might have already been familiar with all the user-defined classes that inherit Syste.object from the Syste.object.
Equals() method by default, in C#. The reference-based comparison is provided by the Equals() method. But there is a possibility 
that this method can override the methods residing inside the class defined by the user. Hence, value-based comparison can be easily 
achieved by using this method. This is how the Equality operator is operated. To overload this operator, you need to follow the 
following code snippet shown below.
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
}    
class MyClient    
{    
    public static void Main()    
    {    
        Complex c1 = new Complex(10, 20);    
        c1.ShowXY(); // displays 10 & 20    
        Complex c2 = new Complex(10, 20);    
        c2.ShowXY(); // displays 10 & 20    
        Complex c3 = c2;    
        c3.ShowXY(); // dislplays 10 & 20    
        if (c1.Equals(c2))    
            Console.WriteLine("OK");    
        else    
            Console.WriteLine("NOT OK");    
        if (c2.Equals(c3))    
            Console.WriteLine("OK1");    
    }    
}    