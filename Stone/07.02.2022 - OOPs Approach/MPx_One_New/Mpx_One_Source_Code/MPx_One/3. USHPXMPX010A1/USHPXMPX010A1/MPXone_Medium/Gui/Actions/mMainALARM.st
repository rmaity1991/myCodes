USING System;
USING System.UI;
USING HEOneRow;

FUNCTION mMainALARM
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

//    IF AckAlm THEN 
//        GoToMask(MaskList#ActiveAlarms);
//        //InsideLoopAlrm := TRUE; 
//        Navigation := TRUE;
//    END_IF; 
    
    // Block user interface
    IF NOT EnKeyboard THEN
        RETURN;
    END_IF;
    
    // Long press to reset alarm
    IF keyCounter>30 AND blockHmi = FALSE THEN
        AlrmRes := TRUE;
    END_IF;

END_FUNCTION
