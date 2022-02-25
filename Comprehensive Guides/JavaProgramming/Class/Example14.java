package JavaProgramming.Class;

/*
 * The static keyword in Java is used for memory management mainly. We can apply
 * static keyword with variables, methods, blocks and nested classes. The static
 * keyword belongs to the class than an instance of the class.
 * 
 * The static can be:
 * 
 * Variable (also known as a class variable)
 * Method (also known as a class method)
 * Block
 * Nested class
 * Static in Java
 * 1) Java static variable
 * If you declare any variable as static, it is known as a static variable.
 * 
 * The static variable can be used to refer to the common property of all
 * objects (which is not unique for each object), for example, the company name
 * of employees, college name of students, etc.
 * The static variable gets memory only once in the class area at the time of
 * class loading.
 */
//Java Program to demonstrate the use of static variable  
class Student {
    int rollno;// instance variable
    String name;
    static String college = "ITS";// static variable
    // constructor

    Student(int r, String n) {
        rollno = r;
        name = n;
    }

    // method to display the values
    void display() {
        System.out.println(rollno + " " + name + " " + college);
    }
}

// Test class to show the values of objects
class TestStaticVariable1 {
    public static void main(String args[]) {
        Student s1 = new Student(111, "Karan");
        Student s2 = new Student(222, "Aryan");
        // we can change the college of all objects by the single line of code
        // Student.college="BBDIT";
        s1.display();
        s2.display();
    }
}