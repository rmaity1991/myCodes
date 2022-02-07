package Java.Arrays;

public class Example2 {

    public static void main(String args[]) {
        // Here we have declared a array of 2 dimensions
        int twoD[][] = new int[4][5];
        int i, j, k = 0;
        // Loops for filling values into the array
        for (i = 0; i < 4; i++)
            for (j = 0; j < 5; j++) {
                twoD[i][j] = k;
                k++;
            }
        // Printing the loops arrays
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 5; j++)
                System.out.print(twoD[i][j] + " ");
            System.out.println();
        }

        // Defining dimensions separately

        int twoD_new[][] = new int[4][];
        twoD_new[0] = new int[1];
        twoD_new[1] = new int[2];
        twoD_new[2] = new int[3];
        twoD_new[3] = new int[4];
        i = 0;
        j = 0;
        k = 0;
        // Filling the values of the array
        for (i = 0; i < 4; i++) {

            for (j = 0; j < i + 1; j++) {

                twoD_new[i][j] = k;
                k++;
            }

        }
        // Printing the loops arrays
        for (i = 0; i < 4; i++) {
            for (j = 0; j < i + 1; j++) {
                System.out.print(twoD_new[i][j] + " ");
                System.out.println();
            }

        }
    }

}
