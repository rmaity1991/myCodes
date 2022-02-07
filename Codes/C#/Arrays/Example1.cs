using System;

namespace ArrayApplication {
   class MyArray {
      static void Main(string[] args) {

          double[] balance = new double[10];
          double[] balance2 = { 2340.0, 4523.69, 3421.0};
          int [] marks = new int[5]  { 99,  98, 92, 97, 95};
          int [] marks2 = new int[]  { 99,  98, 92, 97, 95};
         int []  n = new int[10]; /* n is an array of 10 integers */
         int i,j;

         /* initialize elements of array n */
         for ( i = 0; i < 10; i++ ) {
            n[ i ] = i + 100;
         }
         
         /* output each array element's value */
         for (j = 0; j < 10; j++ ) {
            Console.WriteLine("Element[{0}] = {1}", j, n[j]);
         }
         Console.ReadKey();
      }
   }
}