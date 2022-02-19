/*
C# Method Overriding
If derived class defines same method as defined in its base class, it is known as method overriding in C#. 
It is used to achieve runtime polymorphism. It enables you to provide specific implementation of the method which is already provided by 
its base class.

To perform method overriding in C#, you need to use virtual keyword with base class method and override keyword with derived class method.

C# Method Overriding Example
Let's see a simple example of method overriding in C#. In this example, we are overriding the eat() method by the help of override keyword.
*/

using System;  
public class Animal{  
    public virtual void eat(){  
        Console.WriteLine("Eating...");  
    }  
}  
public class Dog: Animal  
{  
    public override void eat()  
    {  
        Console.WriteLine("Eating bread...");  
    }  
}  
public class TestOverriding  
{  
    public static void Main()  
    {  
        Dog d = new Dog();  
        d.eat();  
    }  
}  