package JavaProgramming.Loops;

/*
 * Java Simple for Loop
 * A simple for loop is the same as C/C++. We can initialize the variable, check
 * condition and increment/decrement value. It consists of four parts:
 * 
 * Initialization: It is the initial condition which is executed once when the
 * loop starts. Here, we can initialize the variable, or we can use an already
 * initialized variable. It is an optional condition.
 * Condition: It is the second condition which is executed each time to test the
 * condition of the loop. It continues execution until the condition is false.
 * It must return boolean value either true or false. It is an optional
 * condition.
 * Increment/Decrement: It increments or decrements the variable value. It is an
 * optional condition.
 * Statement: The statement of the loop is executed each time until the second
 * condition is false.
 */
//Java Program to demonstrate the example of for loop  
//which prints table of 1  
class ForExample {
    public static void main(String[] args) {
        // Code of Java for loop
        for (int i = 1; i <= 10; i++) {
            System.out.println(i);
        }
    }
}