USING System;
USING System.UI;
USING HEOneRow;


FUNCTION GoToPassword
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    // Block user interface
    IF NOT EnKeyboard THEN
        RETURN;
    END_IF;
    
    IF keyCounter>30 AND BlockHmi = FALSE THEN
        blockHmi := TRUE;
        Navigation := TRUE;
        GoToMask(MaskList#mPassword);
    END_IF;
    
END_FUNCTION
