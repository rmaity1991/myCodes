USING System;
USING System.TIMER;

VAR_GLOBAL
    case_comp : int;
    test_int : int;
    test_bit : bool;
    test_bit2 : bool;
    test_int2 : int;
    test_blinker : DFR_FB_Blinker;
    

    
END_VAR





    
PROGRAM CINTestMng 
    
    VAR
      
    END_VAR
    
    
    Case_Comp := DFR_CINCaseSystemComponent(Test_Int);
    Test_Bit2 := DFR_CINControlComponent(Test_Int2);

          
        test_blinker(InSignal := TRUE, DelaySecs := 5, Count := 3); 
        test_bit := test_blinker.Out;
    

END_PROGRAM