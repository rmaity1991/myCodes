USING System;
USING System.UI;
USING HEOneRow;

FUNCTION GlassGUIALARM
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    IF AckAlm AND keyCounter < 30 THEN 
        // Block user interface
        IF NOT EnKeyboard THEN
            RETURN;
        END_IF;
        
        IF (NOT OrAlrm) AND (NOT OrWarning) THEN
            RETURN;
        END_IF;
        
        GoToMask(MaskList#ActiveAlarms);
        //InsideLoopAlrm := TRUE; 
        Navigation := TRUE;
    END_IF; 
    
    IF NOT Alarms.Al.Warn_Door.Info.Trigger THEN
        AckAlm := TRUE;
    END_IF;
    
END_FUNCTION
