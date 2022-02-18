package JavaProgramming.Inheritance;

/*
 * If a class have an entity reference, it is known as Aggregation. Aggregation
 * represents HAS-A relationship.
 * 
 * Consider a situation, Employee object contains many informations such as id,
 * name, emailId etc. It contains one more object named address, which contains
 * its own informations such as city, state, country, zipcode etc. as given
 * below.
 */
class Operation {
    int square(int n) {
        return n * n;
    }
}

class Circle {
    Operation op;// aggregation
    double pi = 3.14;

    double area(int radius) {
        op = new Operation();
        int rsquare = op.square(radius);// code reusability (i.e. delegates the method call).
        return pi * rsquare;
    }

    public static void main(String args[]) {
        Circle c = new Circle();
        double result = c.area(5);
        System.out.println(result);
    }
}