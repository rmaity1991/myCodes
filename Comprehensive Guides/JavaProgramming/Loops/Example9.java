package JavaProgramming.Loops;

/*
 * When a break statement is encountered inside a loop, the loop is immediately
 * terminated and the program control resumes at the next statement following
 * the loop.
 * 
 * The Java break statement is used to break loop or switch statement. It breaks
 * the current flow of the program at specified condition. In case of inner
 * loop, it breaks only inner loop.
 * 
 * We can use Java break statement in all types of loops such as for loop, while
 * loop and do-while loop.
 */

//Java Program to demonstrate the use of break statement    
//inside the for loop. 

class BreakExample {
    public static void main(String[] args) {
        // using for loop
        for (int i = 1; i <= 10; i++) {
            if (i == 5) {
                // breaking the loop
                break;
            }
            System.out.println(i);
        }
    }
}