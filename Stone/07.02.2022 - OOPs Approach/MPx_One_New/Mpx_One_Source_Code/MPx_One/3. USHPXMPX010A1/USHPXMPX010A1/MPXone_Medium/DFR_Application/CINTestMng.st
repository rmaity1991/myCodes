USING System;
USING System.TIMER;

VAR_GLOBAL
    case_comp : int;
    test_int : int;
    test_bit : bool;
    test_bit2 : bool;
    test_int2 : int;
    test_blinker : DFR_FB_Blinker;
    
    PullDownExample : DFR_Feature_PullDownTest;
    
    
    // Test Variables Declared
    TestClass : UnitTesting;
    UnitTestStatus : ARRAY[1..5] OF STRING;
    StartTest : ARRAY[1..5] OF BOOL;
    TestTimers : ARRAY[1..5] OF TON;
    ExpectedOutputsBOOL : ARRAY[1..5] OF BOOL;
    ExpectedOutputsREAL : ARRAY[1..5] OF REAL;
    ExpectedOutputsINT : ARRAY[1..5] OF INT;
    
END_VAR





    
PROGRAM CINTestMng 
    
    VAR
        
    END_VAR
    
    
    Case_Comp := DFR_CINCaseSystemComponent(Test_Int);
    Test_Bit2 := DFR_CINControlComponent(Test_Int2);
    
    
    TestClass.assertEquals(StartTest[1],
                       DFR_CINCaseSystemComponent(Test_Int), 
                       ExpectedOutputsINT[1],
                       UnitTestStatus[1]);
    
    TestClass.assertEquals(StartTest[2],
                        DFR_CINControlComponent(Test_Int2),
                        ExpectedOutputsBOOL[1],  
                        UnitTestStatus[2]);
    
    

    
    
    /* Pull Down Test Unit Testing */
          
        test_blinker(InSignal := StartTest[3], DelaySecs := 5, Count := 3); 
        test_bit := test_blinker.Out;
    

END_PROGRAM