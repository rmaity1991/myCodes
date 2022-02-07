/*
In C#, List is a generic collection which is used to store the elements or objects in the form of a list and it is 
defined under System.Collection.Generic namespace. It provides the same functionality like ArrayList, but there is 
only one difference i.e., a list is a generic whereas ArrayList is a non-generic collection. It is dynamic in nature 
means the size of the list grows, according to the need.
*/
// C# program to illustrate how
// to create a list
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
 
        // Accessing elements of my_list
        // Using foreach loop
        foreach(int a in my_list)
        {
            Console.WriteLine(a);
        }
    }
}