// C# Member Overloading Example: By changing data type of arguments

using System;  
public class Cal{  
    public static int add(int a, int b){  
        return a + b;  
    }  
    public static float add(float a, float b)  
    {  
        return a + b;  
    }  
}  
public class TestMemberOverloading  
{  
    public static void Main()  
    {  
        Console.WriteLine(Cal.add(12, 23));  
        Console.WriteLine(Cal.add(12.4f,21.3f));  
    }  
}  