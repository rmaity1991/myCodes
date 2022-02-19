/*
Like other programming languages, array in C# is a group of similar types of elements that have contiguous memory location. 
In C#, array is an object of base type System.Array. In C#, array index starts from 0. We can store only fixed set of elements in C# array.

There are 3 types of arrays in C# programming:

Single Dimensional Array
Multidimensional Array
Jagged Array


*/

using System;  
public class ArrayExample  
{  
    public static void Main(string[] args)  
    {  
        int[] arr = new int[5];//creating array  
        arr[0] = 10;//initializing array  
        arr[2] = 20;  
        arr[4] = 30;  
  
        //traversing array  
        for (int i = 0; i < arr.Length; i++)  
        {  
            Console.WriteLine(arr[i]);  
        }  
    }  
}  
