package JavaProgramming.Polymorphism;

/*
 * Exception Handling with Method Overriding in Java
 * There are many rules if we talk about method overriding with exception
 * handling.
 * 
 * Some of the rules are listed below:
 * 
 * If the superclass method does not declare an exception
 * If the superclass method does not declare an exception, subclass overridden
 * method cannot declare the checked exception but it can declare unchecked
 * exception.
 * If the superclass method declares an exception
 * If the superclass method declares an exception, subclass overridden method
 * can declare same, subclass exception or no exception but cannot declare
 * parent exception.
 * 
 * Rule 1: If the superclass method does not declare an exception, subclass overridden method cannot declare the checked exception.
 * 
 * 
 */
import java.io.*;

class Parent {

    // defining the method
    void msg() {
        System.out.println("parent method");
    }
}

class TestExceptionChild extends Parent {

    // overriding the method in child class
    // gives compile time error
    void msg() throws IOException {
        System.out.println("TestExceptionChild");
    }

    public static void main(String args[]) {
        Parent p = new TestExceptionChild();
        p.msg();
    }
}