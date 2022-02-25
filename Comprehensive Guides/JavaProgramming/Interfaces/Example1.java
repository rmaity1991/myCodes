package JavaProgramming.Interfaces;

/*
 * Interface in Java
 * Interface
 * Example of Interface
 * Multiple inheritance by Interface
 * Why multiple inheritance is supported in Interface while it is not supported
 * in case of class.
 * Marker Interface
 * Nested Interface
 * An interface in Java is a blueprint of a class. It has static constants and
 * abstract methods.
 * 
 * The interface in Java is a mechanism to achieve abstraction
 * . There can be only abstract methods in the Java interface, not method body.
 * It is used to achieve abstraction and multiple inheritance in Java
 * .
 * 
 * In other words, you can say that interfaces can have abstract methods and
 * variables. It cannot have a method body.
 * 
 * Java Interface also represents the IS-A relationship.
 * 
 * It cannot be instantiated just like the abstract class.
 * 
 * Since Java 8, we can have default and static methods in an interface.
 * 
 * Since Java 9, we can have private methods in an interface.
 * 
 * Why use Java interface?
 * There are mainly three reasons to use interface. They are given below.
 * 
 * It is used to achieve abstraction.
 * By interface, we can support the functionality of multiple inheritance.
 * It can be used to achieve loose coupling.
 */
interface printable {
    void print();
}

class A6 implements printable {
    public void print() {
        System.out.println("Hello");
    }

    public static void main(String args[]) {
        A6 obj = new A6();
        obj.print();
    }
}