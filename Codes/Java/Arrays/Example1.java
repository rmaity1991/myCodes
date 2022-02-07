package Java.Arrays;

public class Example1 {
    public static void main(String args[]) {
        int month_days[];
        month_days = new int[12];
        month_days[0] = 31;
        month_days[1] = 28;
        month_days[2] = 31;
        month_days[3] = 30;
        month_days[4] = 31;
        month_days[5] = 30;
        month_days[6] = 31;
        month_days[7] = 31;
        month_days[8] = 30;
        month_days[9] = 31;
        month_days[10] = 30;
        month_days[11] = 31;
        System.out.println("April has " + month_days[3] + " days.");

        int month_days_new[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31,
                30, 31 };
        System.out.println("April has " + month_days_new[3] + " days.");

        double nums[] = { 10.1, 11.2, 12.3, 13.4, 14.5 };
        double result = 0;
        int i;

        for (i = 0; i < 5; i++) {

            result = result + nums[i];
            System.out.println("Average is " + result / 5);

        }

    }

}
