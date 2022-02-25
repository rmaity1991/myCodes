package JavaProgramming.Class;

/** 
 * Object means a real-world entity such as a pen, chair, table, computer,
 * watch, etc. Object-Oriented Programming is a methodology or paradigm to
 * design a program using classes and objects. It simplifies software
 * development and maintenance by providing some concepts:
 * 
 * Object
 * Class
 * Inheritance
 * Polymorphism
 * Abstraction
 * Encapsulation
 * Apart from these concepts, there are some other terms which are used in
 * Object-Oriented design:
 * 
 * Coupling
 * Cohesion
 * Association
 * Aggregation
 * Composition
 * 
 * Inheritance
 * When one object acquires all the properties and behaviors of a parent object,
 * it is known as inheritance. It provides code reusability. It is used to
 * achieve runtime polymorphism.
 * 
 * Polymorphism in Java
 * Polymorphism
 * If one task is performed in different ways, it is known as polymorphism. For
 * example: to convince the customer differently, to draw something, for
 * example, shape, triangle, rectangle, etc.
 * 
 * In Java, we use method overloading and method overriding to achieve
 * polymorphism.
 * 
 * Another example can be to speak something; for example, a cat speaks meow,
 * dog barks woof, etc.
 * 
 * Abstraction
 * Hiding internal details and showing functionality is known as abstraction.
 * For example phone call, we don't know the internal processing.
 * Encapsulation
 * Binding (or wrapping) code and data together into a single unit are known as
 * encapsulation. For example, a capsule, it is wrapped with different
 * medicines.
 * 
 * A java class is the example of encapsulation. Java bean is the fully
 * encapsulated class because all the data members are private here.
 * 
 * 
 * Coupling
 * Coupling refers to the knowledge or information or dependency of another
 * class. It arises when classes are aware of each other. If a class has the
 * details information of another class, there is strong coupling. In Java, we
 * use private, protected, and public modifiers to display the visibility level
 * of a class, method, and field. You can use interfaces for the weaker coupling
 * because there is no concrete implementation.
 * 
 * Cohesion
 * Cohesion refers to the level of a component which performs a single
 * well-defined task. A single well-defined task is done by a highly cohesive
 * method. The weakly cohesive method will split the task into separate parts.
 * The java.io package is a highly cohesive package because it has I/O related
 * classes and interface. However, the java.util package is a weakly cohesive
 * package because it has unrelated classes and interfaces.
 * 
 * Association
 * Association represents the relationship between the objects. Here, one object
 * can be associated with one object or many objects. There can be four types of
 * association between the objects:
 * One to One
 * One to Many
 * Many to One, and
 * Many to Many
 * Let's understand the relationship with real-time examples. For example, One
 * country can have one prime minister (one to one), and a prime minister can
 * have many ministers (one to many). Also, many MP's can have one prime
 * minister (many to one), and many ministers can have many departments (many to
 * many).
 * 
 * Association can be undirectional or bidirectional.
 * 
 * Aggregation
 * Aggregation is a way to achieve Association. Aggregation represents the
 * relationship where one object contains other objects as a part of its state.
 * It represents the weak relationship between objects. It is also termed as a
 * has-a relationship in Java. Like, inheritance represents the is-a
 * relationship. It is another way to reuse objects.
 * 
 * Composition
 * The composition is also a way to achieve Association. The composition
 * represents the relationship where one object contains other objects as a part
 * of its state. There is a strong relationship between the containing object
 * and the dependent object. It is the state where containing objects do not
 * have an independent existence. If you delete the parent object, all the child
 * objects will be deleted automatically.
 */
//Java Program to illustrate how to define a class and fields  
//Defining a Student class.  
class Student {
    // defining fields
    int id;// field or data member or instance variable
    String name;

    // creating main method inside the Student class
    public static void main(String args[]) {
        // Creating an object or instance
        Student s1 = new Student();// creating an object of Student
        // Printing values of the object
        System.out.println(s1.id);// accessing member through reference variable
        System.out.println(s1.name);
    }
}