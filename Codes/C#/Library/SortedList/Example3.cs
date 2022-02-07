// C# program to illustrate how to
// check the given key or value
// present in the sortedlist or not
using System;
using System.Collections;
 
class GFG {
 
    // Main Method
    static public void Main()
    {
 
        // Creating a sortedlist
        // Using SortedList class
        SortedList my_slist = new SortedList();
 
        // Adding key/value pairs in
        // SortedList using Add() method
        my_slist.Add(1.02, "This");
        my_slist.Add(1.07, "Is");
        my_slist.Add(1.04, "SortedList");
        my_slist.Add(1.01, "Tutorial");
 
        // Using Contains() method to check
        // the specified key is present or not
        if (my_slist.Contains(1.02) == true)
        {
            Console.WriteLine("Key is found...!!");
        }
 
        else
        {
            Console.WriteLine("Key is not found...!!");
        }
 
        // Using ContainsKey() method to check
        // the specified key is present or not
        if (my_slist.ContainsKey(1.03) == true)
        {
            Console.WriteLine("Key is found...!!");
        }
        else
        {
            Console.WriteLine("Key is not found...!!");
        }
 
        // Using ContainsValue() method to check
        // the specified value is present or not
        if (my_slist.ContainsValue("Is") == true)
        {
            Console.WriteLine("Value is found...!!");
        }
 
        else
        {
            Console.WriteLine("Value is not found...!!");
        }
    }
}