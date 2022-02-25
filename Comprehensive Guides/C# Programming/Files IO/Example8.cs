/*
C# TextReader
C# TextReader class is found in System.IO namespace. 
It represents a reader that can be used to read text or sequential series of characters.
*/

using System;  
using System.IO;  
namespace TextReaderExample  
{  
    class Program  
    {  
        static void Main(string[] args)  
        {  
            using (TextReader tr = File.OpenText("e:\\f.txt"))  
            {  
                Console.WriteLine(tr.ReadToEnd());  
            }  
        }  
    }  
}  