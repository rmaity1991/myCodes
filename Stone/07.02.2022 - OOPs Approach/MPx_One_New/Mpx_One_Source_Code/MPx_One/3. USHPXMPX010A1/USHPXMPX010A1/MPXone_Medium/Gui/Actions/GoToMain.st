USING System;
USING System.UI;
USING HEOneRow;


FUNCTION GoToMain
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    // Turn off LEDS used for menu
    LedOnArrow := FALSE;
    LedBlinkArrow := FALSE;
    
    /*rkLed[0] := FALSE;
    rkLed[1] := FALSE;
    rkLed[2] := FALSE;
    rkLed[3] := FALSE;
    lkLed[0] := FALSE;
    lkLed[1] := FALSE;
    lkLed[2] := FALSE;
    lkLed[3] := FALSE;
    lkLed[4] := FALSE;
    LedAlarm := FALSE;*/
    
    Navigation := FALSE;
    InsideLoopDirFunct := FALSE; 
    currMenuLevel := 0;
    
    blockHmi := TRUE;
    BasicVisualiz := FALSE;
    
    GoToMask(MaskList#mMain);
END_FUNCTION
