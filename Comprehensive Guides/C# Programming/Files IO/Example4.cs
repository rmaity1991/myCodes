/*
C# StreamWriter
C# StreamWriter class is used to write characters to a stream in specific encoding. It inherits TextWriter class. 
It provides overloaded write() and writeln() methods to write data into file.
*/
using System;  
using System.IO;  
public class StreamWriterExample  
{  
    public static void Main(string[] args)  
    {  
        FileStream f = new FileStream("e:\\output.txt", FileMode.Create);  
        StreamWriter s = new StreamWriter(f);  
  
        s.WriteLine("hello c#");  
        s.Close();  
        f.Close();  
     Console.WriteLine("File created successfully...");  
    }  
} 
