USING System;
USING System.UI;
USING HEOneRow;

FUNCTION ALM_menu_ESC_PROGRAM_RELEASE
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    currMenuLevel := 1;
    currMenu := 4;
    GoToMask(MaskList#ALM);

END_FUNCTION
