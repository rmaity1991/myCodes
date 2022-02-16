package com.rohitmaity.test;

import static org.junit.Assert.*;
import org.junit.Test;
import org.junit.runner.*;
/*
 * Let’s explain the above code. Firstly, we can see that there is a @Test annotation above the testSum() method. This
annotation indicates that the public void method to which it is attached can be run as a test case. Hence, the testSum()
method is the method that will test the sum() public method. We can also observe a method called assertEquals(sum,
testsum). The method assertEquals ([String message], object expected, object actual) takes
as inputs two objects and asserts that the two objects are equal.

 */


import com.rohitmaity.logic.Calculation;  

public class TestLogic {
	
	Calculation x = new Calculation();
	int sum = x.sum(2, 5);
	int testSum = 7;
	
	@Test
	public void testSum() {
	System.out.println("@Test sum(): " + sum + " = " + testSum);
	assertEquals(sum, testSum);
	}


}
