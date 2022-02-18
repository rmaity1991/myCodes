package JavaProgramming.Polymorphism;

/*
 * Polymorphism in Java is a concept by which we can perform a single action in
 * different ways. Polymorphism is derived from 2 Greek words: poly and morphs.
 * The word "poly" means many and "morphs" means forms. So polymorphism means
 * many forms.
 * 
 * There are two types of polymorphism in Java: compile-time polymorphism and
 * runtime polymorphism. We can perform polymorphism in java by method
 * overloading and method overriding.
 * 
 * If you overload a static method in Java, it is the example of compile time
 * polymorphism. Here, we will focus on runtime polymorphism in java.
 * 
 * Runtime polymorphism or Dynamic Method Dispatch is a process in which a call
 * to an overridden method is resolved at runtime rather than compile-time.
 * 
 * In this process, an overridden method is called through the reference
 * variable of a superclass. The determination of the method to be called is
 * based on the object being referred to by the reference variable.
 * 
 * Let's first understand the upcasting before Runtime Polymorphism.
 * 
 * Upcasting
 * If the reference variable of Parent class refers to the object of Child
 * class, it is known as upcasting. For example:
 */
class Bike {
    void run() {
        System.out.println("running");
    }
}

class Splendor extends Bike {
    void run() {
        System.out.println("running safely with 60km");
    }

    public static void main(String args[]) {
        Bike b = new Splendor();// upcasting
        b.run();
    }
}