package JavaProgramming.Class;

/*
 * 3 Ways to initialize object
 * There are 3 ways to initialize object in Java.
 * 
 * By reference variable
 * By method
 * By constructor
 * 1) Object and Class Example: Initialization through reference
 * Initializing an object means storing data into the object. Let's see a simple
 * example where we are going to initialize the object through a reference
 * variable.
 */
class Student {
    int id;
    String name;
}

class TestStudent2 {
    public static void main(String args[]) {
        Student s1 = new Student();
        Student s2 = new Student();
        // Initializing objects
        s1.id = 101;
        s1.name = "Sonoo";
        s2.id = 102;
        s2.name = "Amit";
        // Printing data
        System.out.println(s1.id + " " + s1.name);
        System.out.println(s2.id + " " + s2.name);
    }
}