package JavaProgramming.Basics;

/*
 * Types of Variables
 * There are three types of variables in Java:
 * 
 * local variable
 * instance variable
 * static variable
 * 
 * 1) Local Variable
 * A variable declared inside the body of the method is called local variable.
 * You can use this variable only within that method and the other methods in
 * the class aren't even aware that the variable exists.
 * 
 * A local variable cannot be defined with "static" keyword.
 * 
 * 2) Instance Variable
 * A variable declared inside the class but outside the body of the method, is
 * called an instance variable. It is not declared as static.
 * 
 * It is called an instance variable because its value is instance-specific and
 * is not shared among instances.
 * 
 * 3) Static variable
 * A variable that is declared as static is called a static variable. It cannot
 * be local. You can create a single copy of the static variable and share it
 * among all the instances of the class. Memory allocation for static variables
 * happens only once when the class is loaded in the memory.
 */

class A {
    static int m = 100;// static variable

    void method() {
        int n = 90;// local variable
        System.out.println("The value is " + n);
    }

    public static void main(String args[]) {
        int data = 50;// instance variable
        System.out.println("The value is " + data);
    }
}// end of class