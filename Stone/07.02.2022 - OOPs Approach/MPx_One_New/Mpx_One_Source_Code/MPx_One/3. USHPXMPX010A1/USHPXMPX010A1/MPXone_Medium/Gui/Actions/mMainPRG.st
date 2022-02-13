USING System;
USING System.UI;
USING HEOneRow;

FUNCTION mMainPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    IF keyCounter>30 AND firstCycle AND NOT blockHmi THEN
        blockHmi := TRUE;
        StartupReset := TRUE;
        GoToMask(MaskList#DefSelection);
        RETURN;
    END_IF;
    
    IF firstCycle THEN
        RETURN;
    END_IF;

    // Block user interface
    IF NOT EnKeyboard THEN
        RETURN;
    END_IF;
    
    IF keyCounter>30 AND blockHmi = FALSE THEN
        blockHmi := TRUE;
        Navigation := TRUE;
        GoToMask(MaskList#mTxtPsd);
    END_IF;
    
END_FUNCTION
