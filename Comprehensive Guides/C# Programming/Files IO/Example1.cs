/*
C# FileStream class provides a stream for file operation. It can be used to perform synchronous and asynchronous read and write operations. 
By the help of FileStream class, we can easily read and write data into file.
*/

using System;  
using System.IO;  
public class FileStreamExample  
{  
    public static void Main(string[] args)  
    {  
        FileStream f = new FileStream("d:\\test.txt", FileMode.OpenOrCreate);//creating file stream  
        f.WriteByte(65);//writing byte into stream  
        f.Close();//closing stream  
    }  
}  
