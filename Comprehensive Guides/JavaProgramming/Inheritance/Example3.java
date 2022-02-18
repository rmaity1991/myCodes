package JavaProgramming.Inheritance;

/*
 * Multilevel Inheritance Example
 * When there is a chain of inheritance, it is known as multilevel inheritance.
 * As you can see in the example given below, BabyDog class inherits the Dog
 * class which again inherits the Animal class, so there is a multilevel
 * inheritance.
 */
class Animal {
    void eat() {
        System.out.println("eating...");
    }
}

class Dog extends Animal {
    void bark() {
        System.out.println("barking...");
    }
}

class BabyDog extends Dog {
    void weep() {
        System.out.println("weeping...");
    }
}

class TestInheritance2 {
    public static void main(String args[]) {
        BabyDog d = new BabyDog();
        d.weep();
        d.bark();
        d.eat();
    }
}