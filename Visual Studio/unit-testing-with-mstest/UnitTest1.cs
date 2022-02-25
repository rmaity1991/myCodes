using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace unit_testing_with_mstest
{
    /*
     * The TestClass attribute denotes a class that contains unit tests. 
     * The TestMethod attribute indicates a method is a test method.
     * 
     */
    
    [TestClass]
    public class UnitTest1
    {
        public Calculator x;

        [TestInitialize] // This sets up the test before each tests
        public void setup()
        {
            x = new Calculator();
            Console.WriteLine("The Tests has been Initialized");
        }

        [TestMethod]
        public void intAddition()
        {
            var result = x.add(2, 3);

            Assert.AreEqual(5, result);

        }

        [TestMethod]
        public void floatAddition()
        {
            var result = x.add(2, 3);

            Assert.AreEqual(5, result);
        }

        [TestMethod]
        public void doubleAddition()
        {
            var result = x.add(2, 3);

            Assert.AreEqual(5, result);
        }

        [TestCleanup]
        public void TearDown()
        {
            Console.WriteLine("The Tests has been completed");
        }

        /*
         * Now that you've made one test pass, it's time to write more. 
         * There are a few other simple cases for prime numbers: 0, -1. 
         * You could add new tests with the TestMethod attribute, but that quickly becomes tedious. 
         * There are other MSTest attributes that enable you to write a suite of similar tests. 
         * A test method can execute the same code but have different input arguments. 
         * You can use the DataRow attribute to specify values for those inputs.
         * 
         */


        [DataTestMethod]
        [DataRow(3,4)]
        [DataRow(5, 4)]
        [DataRow(6, 4)]
        public void doubleSubstraction(int a, int b)
        {
            var result = x.sub(a, b);

            Assert.AreEqual(5, result);
        }




    }
}
