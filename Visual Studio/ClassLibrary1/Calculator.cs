using System;

namespace ClassLibrary1
{
    public class Calculator
    {

        public Calculator()
        {
            Console.WriteLine("The object has been created");
        }

        ~Calculator()
        {
            Console.WriteLine("Object Destroyed");
        }

        public int add(int x, int y)
        {
            Console.WriteLine("The result is : " + (x + y));
            return x + y;
        }

        public float add(float x, float y)
        {
            Console.WriteLine("The result is : " + (x + y));
            return x + y;
        }

        public double add(double x, double y)
        {
            Console.WriteLine("The result is : " + (x + y));
            return x + y;
        }

        public int sub(int x, int y)
        {
            Console.WriteLine("The result is : " + (x - y));
            return x - y;
        }

        public float sub(float x, float y)
        {
            Console.WriteLine("The result is : " + (x - y));
            return x - y;
        }

        public double sub(double x, double y)
        {
            Console.WriteLine("The result is : " + (x - y));
            return x - y;
        }

        public int mul(int x, int y)
        {
            Console.WriteLine("The result is : " + (x * y));
            return x * y;
        }

        public float mul(float x, float y)
        {
            Console.WriteLine("The result is : " + (x * y));
            return x * y;
        }

        public double mul(double x, double y)
        {
            Console.WriteLine("The result is : " + (x * y));
            return x * y;
        }

        public int division(int x, int y)
        {
            Console.WriteLine("The result is : " + (x / y));
            return x / y;
        }

        public float division(float x, float y)
        {
            Console.WriteLine("The result is : " + (x / y));
            return x / y;
        }

        public double division(double x, double y)
        {
            Console.WriteLine("The result is : " + (x / y));
            return x / y;
        }

    }
}
