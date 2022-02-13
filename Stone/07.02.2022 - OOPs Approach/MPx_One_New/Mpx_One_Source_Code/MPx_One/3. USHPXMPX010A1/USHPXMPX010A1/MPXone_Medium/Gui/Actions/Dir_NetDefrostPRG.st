USING System;
USING System.UI;
USING HEOneRow;

FUNCTION Dir_NetDefrostPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    NetworkDfr := NOT NetworkDfr;

END_FUNCTION
