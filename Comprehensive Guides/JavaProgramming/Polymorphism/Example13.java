package JavaProgramming.Polymorphism;

/*
 * Covariant Return Type
 * The covariant return type specifies that the return type may vary in the same
 * direction as the subclass.
 * 
 * Before Java5, it was not possible to override any method by changing the
 * return type. But now, since Java5, it is possible to override method by
 * changing the return type if subclass overrides any method whose return type
 * is Non-Primitive but it changes its return type to subclass type. Let's take
 * a simple example:
 */
class A {
    A get() {
        return this;
    }
}

class B1 extends A {
    @Override
    B1 get() {
        return this;
    }

    void message() {
        System.out.println("welcome to covariant return type");
    }

    public static void main(String args[]) {
        new B1().get().message();
    }
}