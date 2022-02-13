USING System;
USING System.UI;
USING HEOneRow;

FUNCTION mMainUPDOWN
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    // Block user interface
    IF NOT EnKeyboard THEN
        RETURN;
    END_IF;
    
    Navigation := TRUE;
    BasicVisualiz := TRUE;
    PrbVisualiz := TRUE;
    LedOnArrow := TRUE;
    currMenuLevel := 1;
    
    GoToLoop(LoopList#VIS_Loop);

END_FUNCTION
