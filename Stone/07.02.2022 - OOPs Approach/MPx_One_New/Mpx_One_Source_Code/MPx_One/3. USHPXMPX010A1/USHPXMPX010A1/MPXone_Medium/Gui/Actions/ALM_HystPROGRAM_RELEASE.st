USING System;
USING System.UI;
USING HEOneRow;

FUNCTION ALM_HystPROGRAM_RELEASE
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    currMenuLevel := 2;
    
    GoToLoop(LoopList#ALM_LOG);

END_FUNCTION
