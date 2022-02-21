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
    
    VAR
        FB1 : DFR_Feature_PullDownTest;
        TestCases : INT;
    END_VAR
    
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
    
    
    
        // Pull down Testing Cases
    
    
        FB1(CycleTime:=0.5,Preset_RegFailTime:=30,Preset_RegTime:=30);
        TestCases := 0;
    
    
    CASE TestCases OF
        
        
    0: // Testing Discharge Air Temperature for  No Door Case and MT Case
        FB1.FanSP := 50; // Fan Setpoint
        FB1.FanHystSP := 5; // Fan Hysterisis SP
        FB1.Reg_SP := 10; // Regulation Setpoint
    
        FB1.In1 := ExpectedOutputsREAL[1]; // Discharge Air Temp
        FB1.In2 := ExpectedOutputsREAL[2]; // Defrost Temp
        
        ExpectedOutputsBOOL[3] := FALSE;
        ExpectedOutputsBOOL[4] := FALSE;
            
    IF(StartTest[6]) THEN
        FB1.Enable := TRUE;
           
        TestClass.assertEquals(StartTest[6],
            FB1.Out1, //CDU Enable - V_OM_Solenoid_Flag 
            ExpectedOutputsBOOL[3],
            UnitTestStatus[6]);
    
        TestClass.assertEquals(StartTest[6],
            FB1.Out2, // Fan Enable - V_OM_Fans_Flag
            ExpectedOutputsBOOL[4],
            UnitTestStatus[7]);
        
        TestClass.assertEquals(StartTest[6],
            FB1.DFR_Regulation_Sts, // Fan Enable - V_OM_Fans_Flag
            'PAS',
            UnitTestStatus[8]);       
    ELSE
        FB1.Enable := FALSE;
    END_IF;
    
    1: // Testing Discharge Air Temperature for  LT Door Case Only
        FB1.FanSP := 50; // Fan Setpoint
        FB1.FanHystSP := 5; // Fan Hysterisis SP
        FB1.Reg_SP := 10; // Regulation Setpoint
    
        FB1.In1 := ExpectedOutputsREAL[1]; // Discharge Air Temp
        FB1.In2 := ExpectedOutputsREAL[2]; // Defrost Temp
        
        ExpectedOutputsBOOL[3] := TRUE;       
            
    IF(StartTest[6]) THEN
        FB1.Enable := TRUE;
           
        TestClass.assertEquals(StartTest[6],
            FB1.Out1, //CDU Enable - V_OM_Solenoid_Flag 
            ExpectedOutputsBOOL[3],
            UnitTestStatus[6]);
        
        IF (FB1.In2 <= FB1.FanSP) THEN
            
            ExpectedOutputsBOOL[4] := TRUE;
    
        TestClass.assertEquals(StartTest[6],
            FB1.Out2, // Fan Enable - V_OM_Fans_Flag
            ExpectedOutputsBOOL[4],
            UnitTestStatus[7]);
            
        ELSIF(FB1.In2 > FB1.FanSP + FB1.FanHystSP) THEN
            
            ExpectedOutputsBOOL[4] := FALSE;
            
        TestClass.assertEquals(StartTest[6],
            FB1.Out2, // Fan Enable - V_OM_Fans_Flag
            ExpectedOutputsBOOL[4],
            UnitTestStatus[7]);
            
        END_IF;
        
        TestClass.assertEquals(StartTest[6],
            FB1.DFR_Regulation_Sts, // Fan Enable - V_OM_Fans_Flag
            'PAS',
            UnitTestStatus[8]);
        
    ELSE
        FB1.Enable := FALSE;
    END_IF;
    
END_CASE;
    

    
END_PROGRAM