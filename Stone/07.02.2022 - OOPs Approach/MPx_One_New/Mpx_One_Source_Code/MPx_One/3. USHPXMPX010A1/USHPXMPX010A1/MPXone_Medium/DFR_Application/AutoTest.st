USING System;
USING System.TIMER;

VAR_GLOBAL    
    // Test Variables Declared
    TestClass : UnitTesting;
    UnitTestStatus : ARRAY[1..10] OF STRING;
    StartTest : ARRAY[1..10] OF BOOL;
    ExpectedOutputsBOOL : ARRAY[1..10] OF BOOL;
    ExpectedOutputsREAL : ARRAY[1..10] OF REAL;
    ExpectedOutputsINT : ARRAY[1..10] OF INT;
    
END_VAR


PROGRAM DFR_AutoTestMng
    
        TestClass.assertEquals(StartTest[1], // Start Bit
                       DFR_CINCaseSystemComponent(Test_Int), // Functions to be tested 
                       ExpectedOutputsINT[1], // Expected Output
                       UnitTestStatus[1]); // Test Result
    
        TestClass.assertEquals(StartTest[2], // Start Bit
                        DFR_CINControlComponent(Test_Int2),// Functions to be tested
                        ExpectedOutputsBOOL[1], // Expected Output 
                        UnitTestStatus[2]);// Test Result
    
    
        TestClass.assertEquals(StartTest[3], // Start Bit
                               DFR_RANGE_REAL(12000,4000,20000),// Functions to be tested
                               ExpectedOutputsBool[2],// Expected Output
                               UnitTestStatus[3]);// Test Result
    
    
        TestClass.assertTrue(StartTest[4],// Start Bit
                               DFR_RANGE_REAL(12000,4000,20000),// Functions to be tested
                               UnitTestStatus[4]);// Test Result
    
    
        TestClass.assertFalse(StartTest[5],// Start Bit
                               DFR_RANGE_REAL(12000,4000,20000),// Functions to be tested
                               UnitTestStatus[5]);// Test Result

    
END_PROGRAM