// C# program to illustrate how
// to remove objects from the list
using System;
using System.Collections.Generic;
 
class GFG {
 
    // Main Method
    static public void Main()
    {
 
        // Creating list using List class
        // and List<T>() Constructor
        List<int> my_list = new List<int>();
 
        // Adding elements to List
        // Using Add() method
        my_list.Add(1);
        my_list.Add(10);
        my_list.Add(100);
        my_list.Add(1000);
        my_list.Add(10000);
        my_list.Add(100000);
        my_list.Add(1000000);
        my_list.Add(10000000);
        my_list.Add(100000000);
 
        // Initial count
        Console.WriteLine("Initial count:{0}", my_list.Count);
 
        // After using Remove() method
        my_list.Remove(10);
        Console.WriteLine("2nd count:{0}", my_list.Count);
 
        // After using RemoveAt() method
        my_list.RemoveAt(4);
        Console.WriteLine("3rd count:{0}", my_list.Count);
 
        // After using RemoveRange() method
        my_list.RemoveRange(0, 2);
        Console.WriteLine("4th count:{0}", my_list.Count);
 
        // After using Clear() method
        my_list.Clear();
        Console.WriteLine("5th count:{0}", my_list.Count);
    }
}