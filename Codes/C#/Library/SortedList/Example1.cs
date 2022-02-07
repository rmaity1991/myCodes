/*
In C#, SortedList is a collection of key/value pairs which are sorted according to keys. By default, this collection 
sort the key/value pairs in ascending order. It is of both generic and non-generic type of collection. The generic 
SortedList is defined in System.Collections.Generic namespace whereas non-generic SortedList is defined under 
System.Collections namespace, here we will discuss non-generic type SortedList. 
*/

// C# program to illustrate how
// to create a sortedlist
using System;
using System.Collections;
 
class GFG {
 
    // Main Method
    static public void Main()
    {
 
        // Creating a sortedlist
        // Using SortedList class
        SortedList my_slist1 = new SortedList();
 
        // Adding key/value pairs in
        // SortedList using Add() method
        my_slist1.Add(1.02, "This");
        my_slist1.Add(1.07, "Is");
        my_slist1.Add(1.04, "SortedList");
        my_slist1.Add(1.01, "Tutorial");
 
        foreach(DictionaryEntry pair in my_slist1)
        {
            Console.WriteLine("{0} and {1}",
                      pair.Key, pair.Value);
        }
        Console.WriteLine();
 
        // Creating another SortedList
        // using Object Initializer Syntax
        // to initialize sortedlist
        SortedList my_slist2 = new SortedList() {
                                  { "b.09", 234 },
                                  { "b.11", 395 },
                                  { "b.01", 405 },
                                  { "b.67", 100 }};
                 
        foreach(DictionaryEntry pair in my_slist2)
        {
            Console.WriteLine("{0} and {1}",
                      pair.Key, pair.Value);
        }
    }
}