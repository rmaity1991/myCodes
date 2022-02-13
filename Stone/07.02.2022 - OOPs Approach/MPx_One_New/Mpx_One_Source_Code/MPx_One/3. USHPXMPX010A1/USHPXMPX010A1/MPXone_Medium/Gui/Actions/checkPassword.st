USING System;
USING System.UI;
USING HEOneRow;


FUNCTION checkPassword
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    IF tmpPassword = TO_USINT(PwdDisplay) THEN
        GoToLoop(LoopList#Menu);
        blockHmi := TRUE;
        
        tmpPassword := 0;
        
        currMenu := 1; // Vis Menu
        currMenuLevel := 0; // Menu level
    ELSE
        // Wrong password
        LedBlinkArrow := FALSE;
        WrongPsw := TRUE;
        blockHmi := TRUE;
        GoToLoop(LoopList#Main);
    END_IF;
    
    
END_FUNCTION
