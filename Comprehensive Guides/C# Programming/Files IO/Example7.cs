/*
C# TextWriter
C# TextWriter class is an abstract class. It is used to write text or sequential series of characters into file. 
It is found in System.IO namespace.
*/
using System;  
using System.IO;  
namespace TextWriterExample  
{  
    class Program  
    {  
        static void Main(string[] args)  
        {  
            using (TextWriter writer = File.CreateText("e:\\f.txt"))  
            {  
                writer.WriteLine("Hello C#");  
                writer.WriteLine("C# File Handling by JavaTpoint");  
            }  
            Console.WriteLine("Data written successfully...");  
        }  
    }  
}  
