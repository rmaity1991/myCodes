USING System;
USING System.UI;
USING HEOneRow;

FUNCTION mMainPROGRAM_RELEASE
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    // Block user interface
    IF NOT EnKeyboard THEN
        RETURN;
    END_IF;

    Navigation := FALSE; 
    InsideLoopDirFunct := FALSE; 
    
    IF blockHmi = FALSE AND keyCounter <30 AND EnDirFunct AND NOT firstCycle THEN
        Navigation := TRUE; 
        InsideLoopDirFunct := TRUE;
        LedBlinkArrow := FALSE; 
        LedOnArrow := TRUE; 
        blockHmi := TRUE;

        GoToLoop(LoopList#DirFunction);
    END_IF;

    
    blockHmi := FALSE;

END_FUNCTION
