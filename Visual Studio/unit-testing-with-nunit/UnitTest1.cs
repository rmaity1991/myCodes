using NUnit.Framework;

using unit_testing_with_nunit;

namespace unit_testing_with_nunit
{
    /*
     * The [TestFixture] attribute denotes a class that contains unit tests. The [Test] attribute indicates a method is a test method.
     */

    [TestFixture]
    public class Tests
    {
        public Calculator x;
        [SetUp]
        public void Setup()
        {
            x = new Calculator();
        }

        [Test]
        public void Test1()
        {
            var result=x.add(3, 4);

            Assert.AreEqual(7, result);
        }
        /*
         * Now that you've made one test pass, it's time to write more. 
         * There are a few other simple cases for prime numbers: 0, -1. 
         * You could add new tests with the [Test] attribute, but that quickly becomes tedious. 
         * There are other NUnit attributes that enable you to write a suite of similar tests. 
         * A [TestCase] attribute is used to create a suite of tests that execute the same code 
         * but have different input arguments. You can use the [TestCase] attribute to specify 
         * values for those inputs
         */

        [TestCase(1,2)]
        [TestCase(3,4)]
        [TestCase(5,6)]
        public void Test2(int a, int b)
        {
            var result = x.add(a,b);

            Assert.AreEqual(7, result);
        }
    }
}