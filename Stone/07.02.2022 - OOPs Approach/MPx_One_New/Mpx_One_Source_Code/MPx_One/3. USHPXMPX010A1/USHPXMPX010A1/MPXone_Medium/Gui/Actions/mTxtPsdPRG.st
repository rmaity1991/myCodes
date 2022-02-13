USING System;
USING System.UI;
USING HEOneRow;

FUNCTION mTxtPsdPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    IF NOT blockHmi THEN
        LedOnArrow := FALSE;
        LedBlinkArrow := TRUE;
        GoToMask(MaskList#mPassword);
    END_IF;   

END_FUNCTION
