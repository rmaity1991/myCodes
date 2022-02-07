package Java.Basics;

import java.io.*;
import java.util.Scanner;

public class Example2 {
    public static void main(String args[]) {
        Scanner scr = new Scanner(System.in);
        double a = 3.0, b = 4.0; // initializing the variable ways
        // c is dynamically initialized
        double c = Math.sqrt(a * a + b * b); // static class MATH and its sqrt method
        System.out.println("Hypotenuse is " + c);
    }
}
