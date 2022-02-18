package JavaProgramming.Loops;

public class Example1 {
    public static void main(String[] args) {
        // TODO Auto-generated method stub
        int sum = 0;
        for (int j = 1; j <= 10; j++) {
            sum = sum + j;
        }
        System.out.println("The sum of first 10 natural numbers is " + sum);

        String[] names = { "Java", "C", "C++", "Python", "JavaScript" };
        System.out.println("Printing the content of the array names:\n");
        for (String name : names) {
            System.out.println(name);
        }

        int i = 0;
        System.out.println("Printing the list of first 10 even numbers \n");
        while (i <= 10) {
            System.out.println(i);
            i = i + 2;
        }

        i = 0;
        System.out.println("Printing the list of first 10 even numbers \n");
        do {
            System.out.println(i);
            i = i + 2;
        } while (i <= 10);

        for (i = 0; i <= 10; i++) {
            System.out.println(i);
            if (i == 6) {
                break;
            }
        }

        a: for (i = 0; i <= 10; i++) {
            b: for (int j = 0; j <= 15; j++) {
                c: for (int k = 0; k <= 20; k++) {
                    System.out.println(k);
                    if (k == 5) {
                        break a;
                    }
                }
            }

        }
    }
}
