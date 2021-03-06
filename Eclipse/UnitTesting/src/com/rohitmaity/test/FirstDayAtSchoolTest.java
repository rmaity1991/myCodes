package com.rohitmaity.test;

import static org.junit.Assert.*;

import org.junit.Ignore;
import org.junit.Test;

import com.rohitmaity.logic.FirstDayOfSchool;



public class FirstDayAtSchoolTest {
	
	FirstDayOfSchool school = new FirstDayOfSchool();
	String[] bag1 = { "Books", "Notebooks", "Pens" };
	String[] bag2 = { "Books", "Notebooks", "Pens", "Pencils" };
	@Test
	public void testPrepareMyBag() {
	System.out.println("Inside testPrepareMyBag()");
	assertArrayEquals(bag1, school.prepareMyBag());
	}
	@Test
	public void testAddPencils() {
	System.out.println("Inside testAddPencils()");
	assertArrayEquals(bag2, school.addPencils());
	}
	
	@Ignore
	@Test
	public void testAddPencils1() {
		System.out.println("Inside testAddPencils()");
		assertArrayEquals(bag2, school.addPencils());
		}
	
	

}
