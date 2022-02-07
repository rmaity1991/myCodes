// C# program to illustrate how
// sort a list
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
        my_list.Add(496);
        my_list.Add(1000);
        my_list.Add(100);
        my_list.Add(10);
        my_list.Add(10000);
        my_list.Add(10000000);
        my_list.Add(1000000);
        my_list.Add(100000);
        my_list.Add(0000);
 
        // Without sorted List
        Console.WriteLine("UnSorted List:");
        foreach(int a in my_list)
        {
            Console.WriteLine(a);
        }
 
        // After Sort method
        my_list.Sort();
        Console.WriteLine("Sorted List:");
        foreach(int a in my_list)
        {
            Console.WriteLine(a);
        }
    }
}