package com.rohitmaity.test;

import static org.junit.Assert.*;
import org.junit.*;

import com.rohitmaity.logic.Calculator;


public class CalculatorTest {
	
	public Calculator x;
	
	@BeforeClass
	public static void startTestSuite() {
		System.out.println("This will be executed before all tests only once");
	}
	
	@Before
	public void InitializeTest() {
		System.out.println("This is executed before each test");
		x= new Calculator();
	}
	
	@Test
	public void confirmAddTest1() {
	    int result=x.add(2, 3);
	    
	    assertEquals(5,result);
	}
	
	@Test
	public void confirmAddTest2() {
	    int result=x.add(5, 6);
	    
	    assertEquals(5,result);
	}
	
	@After
	public void endTest() {
		System.out.println("Each test is being completed");
	}
	
	@AfterClass
	public static void endTestSuite() {
		System.out.println("All tests are completed");
	}
	
	

}
