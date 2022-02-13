USING System;
USING System.UI;
USING HEOneRow;

FUNCTION Dir_ContCyclPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR


    ManContCycle_byDisplay := NOT ManContCycle_byDisplay;
    
END_FUNCTION
