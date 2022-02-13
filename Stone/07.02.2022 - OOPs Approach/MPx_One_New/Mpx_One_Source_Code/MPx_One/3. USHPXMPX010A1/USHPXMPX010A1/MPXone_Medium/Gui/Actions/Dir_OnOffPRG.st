USING System;
USING System.UI;
USING HEOneRow;

FUNCTION Dir_OnOffPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    IF NOT(DigitalInputs.Fct.RemoteOff) THEN // TRAC #99: Allow to change the status from UI only if remote off is not active
        KeyboardOnOff := NOT KeyboardOnOff;
        //        UnitStatus := NOT UnitStatus;
    END_IF;
    
END_FUNCTION
