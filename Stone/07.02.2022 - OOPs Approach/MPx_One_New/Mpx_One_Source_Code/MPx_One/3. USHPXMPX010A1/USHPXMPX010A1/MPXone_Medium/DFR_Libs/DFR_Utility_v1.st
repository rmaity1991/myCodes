USING System.Math;
USING System;
USING System.Timer;
USING System.Text;


CLASS PUBLIC DFR_LIBRARY
    (**
    This class library contains majorly used 
    functions required for development 
    of the Dover Food and Retail Case Platform.
    
    Initial Development: Rohit Maity
                         08/01/2022
    **)
    
    METHOD PUBLIC DFR_DiagAntiSweatHeater
        
        VAR_INPUT
            Inp : BOOL;
            Trigger : BOOL;
          //TotTime : REAL;
        END_VAR
        
        VAR_IN_OUT
            Out1 : BOOL;
            Out2 : REAL;
          //TimerDone : BOOL;
            Test_Status : STRING;
        END_VAR
        
    IF Inp AND NOT Trigger THEN
        Out1 := TRUE;
        Out2 := 100;
        Test_Status := 'NA';
    ELSIF (Inp AND Trigger) THEN
        Out1 := FALSE;
        Out2 := 0;
        Test_Status := 'PAS';
    END_IF;
        
    END_METHOD
    
    METHOD PUBLIC DFR_DiagLights
        
    VAR_INPUT
        Inp : BOOL;
        TotTime : REAL;
    END_VAR
        
    VAR_IN_OUT
        Out : BOOL;
        TimerDone : BOOL;
    END_VAR
        
    VAR
        LightTimer : DFRTimer;
    END_VAR
        
    IF Inp THEN
        LightTimer(Ena := Inp, PLCCycletime := 0.5, ProgramTime := TotTime);
        IF LightTimer.ElapsedTime <= (TotTime / 10) THEN
            Out := TRUE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 10) AND LightTimer.ElapsedTime <= (TotTime / 7.5) THEN
            Out := FALSE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 7.5) AND LightTimer.ElapsedTime <= (TotTime / 5) THEN
            Out := TRUE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 5) AND LightTimer.ElapsedTime <= (TotTime / 2.5) THEN
            Out := FALSE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 2.5) AND LightTimer.ElapsedTime <= (TotTime / 2) THEN
            Out := TRUE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 2) AND LightTimer.ElapsedTime <= (TotTime / 1.5) THEN
            Out := FALSE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 1.5) AND LightTimer.ElapsedTime <= (TotTime / 1.25) THEN
            Out := TRUE;
        ELSE
            Out := FALSE;
        END_IF;
        IF LightTimer.Q THEN
            LightTimer(Ena := FALSE);
            TimerDone := TRUE;
        END_IF;
    ELSE
        Out := FALSE;
        TimerDone := FALSE;
        LightTimer(Ena := FALSE);
        
    END_IF; 
    END_METHOD
    
    METHOD PUBLIC DFR_DiagDrainheater   
        VAR_INPUT
        Inp : BOOL;
        Trigger : BOOL;
        //TotTime : REAL; 
    END_VAR
    
    VAR
        //DrainHtrTimer : DFRTimer;
    END_VAR
    VAR_IN_OUT
        Output : BOOL;
        //TimerDone : BOOL;
        Test_Status : STRING;
    END_VAR
    IF Inp AND NOT Trigger THEN
        Output := TRUE;
        Test_Status := 'NA';
    ELSIF (Inp AND Trigger) THEN
        Output := FALSE;
        Test_Status := 'PAS';
    END_IF;
        
    END_METHOD
    
    METHOD PUBLIC DFR_CINCaseSystemComponent:INT
        VAR_INPUT
        comp_num : INT;
        END_VAR
    VAR
        out_info    : string;
        length      : int;
        str1        : string;
        str2        : string;
        str3        : string;
        str4        : string;
        str5        : string;
        str6        : string;
    END_VAR  
    
  //  V_CSM_CaseSystemInfo := '05052021121065001113237';
    
    str1 := format('%04u', C_CSM_CaseSystemInfo1);
    str2 := format('%04u', C_CSM_CaseSystemInfo2);
    str3 := format('%04u', C_CSM_CaseSystemInfo3);
    str4 := format('%04u', C_CSM_CaseSystemInfo4);
    str5 := format('%04u', C_CSM_CaseSystemInfo5);
    str6 := format('%03u', C_CSM_CaseSystemInfo6);
    
    V_CSM_CaseSystemInfo := str1 + str2 + str3 + str4 + str5 + str6;
    
    length := to_int(len(V_CSM_CaseSystemInfo));
    
    IF length <= 1 AND NOT WIZDONE THEN
        V_CSM_InvalidCIN_Flag := TRUE;
        out_info := '0';
    ELSE
         V_CSM_InvalidCIN_Flag := FALSE;
        CASE comp_num OF
            1: // Case date
                out_info := left(V_CSM_CaseSystemInfo, 2);
            2: // Case month
                out_info := mid(V_CSM_CaseSystemInfo, 2, 2);
            3: // Case year
                out_info := mid(V_CSM_CaseSystemInfo, 4, 4); 
            4: // Case Series
                out_info := mid(V_CSM_CaseSystemInfo, 3, 8); 
            5: // Refrigerant : 1-R-22, 2-R-404A, 3-R-407A, 4-R-410A, 5-R-422D, 6-R-507A, 7-R-448A, 8-R-449A, 9-CO2 DX, 10-CO2 SC, 11-Glycol SC
                out_info := mid(V_CSM_CaseSystemInfo, 2, 11); 
            6: // Doors : 0,1,2,3,4,5,6
                out_info := mid(V_CSM_CaseSystemInfo, 1, 13); 
            7: // Length in feet : 0,4,6,8,10,12
                out_info := mid(V_CSM_CaseSystemInfo, 2, 14); 
            8: // Evaporator : 0-Standard , 1- NRG
                out_info := mid(V_CSM_CaseSystemInfo, 1, 16); 
            9: // Control Temp : 0 -Dual,1-LT ,2-MT
                out_info := mid(V_CSM_CaseSystemInfo, 1, 17); 
            10: // Defrost Type : 0-Off-time, 1-Electric, 2-Hotgas
                out_info := mid(V_CSM_CaseSystemInfo, 1, 18); 
            11: // Metering Device Type : 0-None, 1-TXV, 2-PWM, 3-Stepper
                out_info := mid(V_CSM_CaseSystemInfo, 1, 19); 
            12: // Temperature Control Type : 1-Self Contained, 2-Remote
                out_info := mid(V_CSM_CaseSystemInfo, 1, 20); 
            13: // Controller Type : 1- Dixell, 2- MPXOne, 3 – Cpco Mini 
                out_info := mid(V_CSM_CaseSystemInfo, 2, 21);
            ELSE
                out_info := '0';
        END_CASE;
    END_IF;
    DFR_CINCaseSystemComponent := to_int(out_info);
        
        END_METHOD
    
END_CLASS



CLASS PUBLIC UnitTesting
(**
    
    Initial Creation:
    09/02/2022
    DFR Control
    
    This has been created to make Automatic Testing on Results from Function Blocks created for DFR.   
    
**)
    
    VAR PUBLIC
        PassTimeSP : TIME;
        FailTimeSP : TIME;
    END_VAR
    
    VAR 
       PassTimer : TON;
       FailTimer : TON;
    END_VAR
    
    (**
    Timer Initial Methods called Init
    **)
    
    METHOD Init               
        PassTimer(PT := PassTimeSP);
        FailTimer(PT := FailTimeSP);        
    END_METHOD
    
   (**
                 Testing INT Equality
    **)

    METHOD assertEquals
        
        VAR_INPUT
            IN : BOOL;
            intActualResult : INT;
            intExpectedResult : INT;
       
        END_VAR
        
        VAR_IN_OUT
            Status : STRING;
       
        END_VAR
        
        VAR
            Output : INT;
        END_VAR
        
        Init();
        
                
    IF (IN) THEN      
        IF  (intActualResult = intExpectedResult) THEN
            PassTimer.IN := TRUE;
            
            IF(NOT PassTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(PassTimer.Q) THEN
                Output := 1;
                PassTimer.IN := FALSE;
              
            END_IF;
                            
        ELSIF (intActualResult <> intExpectedResult) THEN
            FailTimer(In := TRUE);
            
            IF(NOT FailTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(FailTimer.Q) THEN
               Output := 2; 
               FailTimer.In := FALSE;
         
            END_IF;               
        END_IF;
    ELSIF (NOT IN) AND (Output<>0) THEN
                //Output := 0;
            
    END_IF;
        
    CASE Output OF
        0: Status := 'The Test is not Running';
        1: Status := 'The Test is Passed for given Time Frame';
        2: Status := 'The Test is Failed for given Time Frame';
        4: Status := 'Test is Running';
    END_CASE;
        
        
        
    END_METHOD
    
    (**
            Testing REAL Equality
    **)
    
    METHOD assertEquals
        
        VAR_INPUT
            IN : BOOL;
            realActualResult : REAL;
            realExpectedResult : REAL;
        END_VAR
        
        VAR_IN_OUT
            Status : STRING;
        END_VAR
        
        VAR
            Output : INT;

        END_VAR
        
        Init();
                
    IF (IN) THEN      
        IF  (realActualResult = realExpectedResult) THEN
            PassTimer.IN := TRUE;
            
            IF(NOT PassTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(PassTimer.Q) THEN
                Output := 1;
                PassTimer.IN := FALSE;

            END_IF;
                            
        ELSIF (realActualResult <> realExpectedResult) THEN
            FailTimer(In := TRUE);
            
            IF(NOT FailTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(FailTimer.Q) THEN
               Output := 2; 
               FailTimer.In := FALSE;

            END_IF;               
        END_IF;
    ELSIF (NOT IN) AND (Output<>0) THEN
                //Output := 0;
            
    END_IF;
        
    CASE Output OF
        0: Status := 'The Test is not Running';
        1: Status := 'The Test is Passed for given Time Frame';
        2: Status := 'The Test is Failed for given Time Frame';
        4: Status := 'Test is Running';
    END_CASE;
               
    END_METHOD
    
    (**
           Testing BOOLEAN Equality
    **)
    
    METHOD assertEquals
        
        VAR_INPUT
            IN : BOOL;
            boolActualResult :BOOL;
            boolExpectedResult : BOOL;

        END_VAR
        
        VAR_IN_OUT
            Status : STRING;
        END_VAR
        
        VAR
            Output : INT;

        END_VAR
        
        Init();
                
    IF (IN) THEN      
        IF  (boolActualResult = boolExpectedResult) THEN
            PassTimer.IN := TRUE;
            
            IF(NOT PassTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(PassTimer.Q) THEN
                Output := 1;
                PassTimer.IN := FALSE;
            END_IF;
                            
        ELSIF (boolActualResult <> boolExpectedResult) THEN
            FailTimer(In := TRUE);
            
            IF(NOT FailTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(FailTimer.Q) THEN
               Output := 2; 
               FailTimer.In := FALSE;
            END_IF;               
        END_IF;
    ELSIF (NOT IN) AND (Output<>0) THEN
                //Output := 0;
            
    END_IF;
        
    CASE Output OF
        0: Status := 'The Test is not Running';
        1: Status := 'The Test is Passed for given Time Frame';
        2: Status := 'The Test is Failed for given Time Frame';
        4: Status := 'Test is Running';
    END_CASE;
       
    END_METHOD
    
    METHOD assertEquals
        
        VAR_INPUT
            IN : BOOL;
            stringActualResult :  STRING;
            stringExpectedResult : STRING;           
        END_VAR
        
        VAR_IN_OUT
            Status : STRING;
        END_VAR
        
        VAR
            Output : INT;
        END_VAR
        
        Init();
                
    IF (IN) THEN      
        IF  (stringActualResult = stringExpectedResult) THEN
            PassTimer.IN := TRUE;
            
            IF(NOT PassTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(PassTimer.Q) THEN
                Output := 1;
                PassTimer.IN := FALSE;
            END_IF;
                            
        ELSIF (stringActualResult <> stringExpectedResult) THEN
            FailTimer(In := TRUE);
            
            IF(NOT FailTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(FailTimer.Q) THEN
               Output := 2; 
               FailTimer.In := FALSE;
            END_IF;               
        END_IF;
    ELSIF (NOT IN) AND (Output<>0) THEN
                //Output := 0;
            
    END_IF;
        
    CASE Output OF
        0: Status := 'The Test is not Running';
        1: Status := 'The Test is Passed for given Time Frame';
        2: Status := 'The Test is Failed for given Time Frame';
        4: Status := 'Test is Running';
    END_CASE;
       
    END_METHOD
    
    
    METHOD assertTrue
        
        VAR_INPUT
            IN : BOOL;
            actualResult : BOOL;
        END_VAR
        
        VAR_IN_OUT
            Status : STRING;
        END_VAR
        
        VAR
            Output : INT;
        END_VAR
        
        Init();
                
    IF (IN) THEN      
        IF  (actualResult = TRUE) THEN
            PassTimer.IN := TRUE;
            
            IF(NOT PassTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(PassTimer.Q) THEN
                Output := 1;
                PassTimer.IN := FALSE;
            END_IF;
                            
        ELSIF (actualResult = FALSE) THEN
            FailTimer(In := TRUE);
            
            IF(NOT FailTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(FailTimer.Q) THEN
               Output := 2; 
               FailTimer.In := FALSE;
            END_IF;               
        END_IF;
    ELSIF (NOT IN) AND (Output<>0) THEN
                //Output := 0;
            
    END_IF;
        
    CASE Output OF
        0: Status := 'The Test is not Running';
        1: Status := 'The Test is Passed for given Time Frame';
        2: Status := 'The Test is Failed for given Time Frame';
        4: Status := 'Test is Running';
    END_CASE;
        
END_METHOD
    
    METHOD assertFalse
        
        VAR_INPUT
            IN : BOOL;
            actualResult : BOOL;
        END_VAR
        
        VAR_IN_OUT
            Status : STRING;
        END_VAR
        
        VAR
            Output : INT;
        END_VAR
        
        Init();
                
    IF (IN) THEN      
        IF  (actualResult = FALSE) THEN
            PassTimer.IN := TRUE;
            
            IF(NOT PassTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(PassTimer.Q) THEN
                Output := 1;
                PassTimer.IN := FALSE;
            END_IF;
                            
        ELSIF (actualResult = TRUE) THEN
            FailTimer(In := TRUE);
            
            IF(NOT FailTimer.Q) THEN
                Output := 4;
            END_IF;
            
            IF(FailTimer.Q) THEN
               Output := 2; 
               FailTimer.In := FALSE;
            END_IF;               
        END_IF;
    ELSIF (NOT IN) AND (Output<>0) THEN
                //Output := 0;
            
    END_IF;
        
    CASE Output OF
        0: Status := 'The Test is not Running';
        1: Status := 'The Test is False and Passed ';
        2: Status := 'The Test is True and Failed';
        4: Status := 'Test is Running';
    END_CASE;
        
END_METHOD
        
        
        
        
            

   
END_CLASS

        