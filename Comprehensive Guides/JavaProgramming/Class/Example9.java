package JavaProgramming.Class;

/*
 * In Java, a constructor is a block of codes similar to the method. It is
 * called when an instance of the class is created. At the time of calling
 * constructor, memory for the object is allocated in the memory.
 * 
 * It is a special type of method which is used to initialize the object.
 * 
 * Every time an object is created using the new() keyword, at least one
 * constructor is called.
 * 
 * It calls a default constructor if there is no constructor available in the
 * class. In such case, Java compiler provides a default constructor by default.
 * There are two types of constructors in Java: no-arg constructor, and
 * parameterized constructor.
 * 
 * Note: It is called constructor because it constructs the values at the time
 * of object creation. It is not necessary to write a constructor for a class.
 * It is because java compiler creates a default constructor if your class
 * doesn't have any.
 * 
 * Rules for creating Java constructor
 * There are two rules defined for the constructor.
 * 
 * Constructor name must be the same as its class name
 * A Constructor must have no explicit return type
 * A Java constructor cannot be abstract, static, final, and synchronized
 * Types of Java constructors
 * There are two types of constructors in Java:
 * 
 * Default constructor (no-arg constructor)
 * Parameterized constructor
 */
//Let us see another example of default constructor  
//which displays the default values  
class Student3 {
    int id;
    String name;

    // method to display the value of id and name
    void display() {
        System.out.println(id + " " + name);
    }

    public static void main(String args[]) {
        // creating objects
        Student3 s1 = new Student3();
        Student3 s2 = new Student3();
        // displaying values of the object
        s1.display();
        s2.display();
    }
}