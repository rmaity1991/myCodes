package JavaProgramming.Polymorphism;

/*
 * Protected
 * The protected access modifier is accessible within package and outside the
 * package but through inheritance only.
 * 
 * The protected access modifier can be applied on the data member, method and
 * constructor. It can't be applied on the class.
 * 
 * It provides more accessibility than the default modifer.
 */
class A {
    private void msg() {
        System.out.println("Hello java");
    }
}

class Simple extends A {
    void msg() {
        System.out.println("Hello java");
    }// C.T.Error

    public static void main(String args[]) {
        Simple obj = new Simple();
        obj.msg();
    }
}