USING System;
USING System.UI;
USING HEOneRow;

FUNCTION MenuUPDOWN
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    // keyPressed = 14 tasto UP
    IF keyPressed = 14 THEN
        currMenu := currMenu - 1;
        IF currMenu > MENU_ITEMS THEN // CurrMenu is unsigned so it will become 255 insthead of -1
            currMenu := MENU_ITEMS;
        END_IF;
        GoToPreviousMask();
    END_IF;
    
    // keyPressed = 15 tasto DOWN
    IF keyPressed = 15 THEN
        currMenu := currMenu + 1;
        IF currMenu > MENU_ITEMS THEN
            currMenu := 0;
        END_IF;
        GoToNextMask();
    END_IF;


END_FUNCTION
