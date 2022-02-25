using System;  
   public class Student  
    {  
        public int id;   
        public String name;  
        public void insert(int i, String n)  
        {  
            id = i;  
            name = n;  
        }  
        public void display()  
        {  
            Console.WriteLine(id + " " + name);  
        }  
   }  
   class TestStudent{  
       public static void Main(string[] args)  
        {  
            Student s1 = new Student();  
            Student s2 = new Student();  
            s1.insert(101, "Ajeet");  
            s2.insert(102, "Tom");  
            s1.display();  
            s2.display();  
  
        }  
    }  