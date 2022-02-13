USING System;
USING System.UI;
USING HEOneRow;

FUNCTION MenuSecondUPDOWN
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    // keyPressed = 14 tasto UP
    IF keyPressed = 14 THEN
        currMenu_SecondLev := currMenu_SecondLev - 1;
        IF currMenu_SecondLev > 2 THEN // CurrMenu is unsigned so it will become 255 insthead of -1
            currMenu_SecondLev := 2;
        END_IF;
        GoToPreviousMask();
    END_IF;
    
    // keyPressed = 15 tasto DOWN
    IF keyPressed = 15 THEN
        currMenu_SecondLev := currMenu_SecondLev + 1;
        IF currMenu_SecondLev > 2 THEN
            currMenu_SecondLev := 0;
        END_IF;
        GoToNextMask();
    END_IF;

END_FUNCTION
