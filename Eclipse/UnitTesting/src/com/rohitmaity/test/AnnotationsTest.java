package com.rohitmaity.test;

import static org.junit.Assert.*;
import java.util.*;
import org.junit.*;

/*
 * Annotation Description
@Test public void method() 

The Test annotation indicates that the public void method
to which it is attached can be run as a test case.

@Before public void method() 

The Before annotation indicates that this method must be
executed before each test in the class, so as to execute some
preconditions necessary for the test.

@BeforeClass public static void
method()

The BeforeClass annotation indicates that the static
method to which is attached must be executed once and
before all tests in the class. That happens when the test
methods share computationally expensive setup (e.g.
connect to database).

@After public void method() 

The After annotation indicates that this method gets
executed after execution of each test (e.g. reset some
variables after execution of every test, delete temporary
variables etc)

@AfterClass public static void method() 

The AfterClass annotation can be used when a method
needs to be executed after executing all the tests in a JUnit
Test Case class so as to clean-up the expensive set-up (e.g
disconnect from a database). Attention: The method
attached with this annotation (similar to BeforeClass)
must be defined as static.

@Ignore public static void method() 

The Ignore annotation can be used when you want
temporarily disable the execution of a specific test. Every
method that is annotated with @Ignore won?t be
executed.

 */

public class AnnotationsTest {
	
	private ArrayList testList;

	
	@BeforeClass // Executed before each tests
	public static void onceExecutedBeforeAll() {
	System.out.println("@BeforeClass: onceExecutedBeforeAll");
	}
	
	@Before
	public void executedBeforeEach() {
	testList = new ArrayList();
	System.out.println("@Before: executedBeforeEach");
	}
	
	@AfterClass
	public static void onceExecutedAfterAll() {
	System.out.println("@AfterClass: onceExecutedAfterAll");
	}
	
	@After
	public void executedAfterEach() {
	testList.clear();
	System.out.println("@After: executedAfterEach");
	}
	
	@Test
	public void EmptyCollection() {
	assertTrue(testList.isEmpty());
	System.out.println("@Test: EmptyArrayList");
	}
	
	@Test
	public void OneItemCollection() {
	testList.add("oneItem");
	assertEquals(1, testList.size());
	System.out.println("@Test: OneItemArrayList");
	}
	
	@Ignore
	public void executionIgnored() {
	System.out.println("@Ignore: This execution is ignored");
	}


}
