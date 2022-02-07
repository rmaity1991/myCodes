package Java.Basics;

import java.io.*; // library function which are imported

public class Example1 { // every java program must have a class and a main function

    public static void main(String args[]) { // arguments here are strings

        boolean b; // datatype boolean

        b = false;
        System.out.println("b is " + b); // standard print statements
        b = true;
        System.out.println("b is " + b);
        // a boolean value can control the if statement

        if (b)
            System.out.println("This is executed.");
        b = false;
        if (b)
            System.out.println("This is not executed.");
        // outcome of a relational operator is a boolean value
        System.out.println("10 > 9 is " + (10 > 9));
    }
}
