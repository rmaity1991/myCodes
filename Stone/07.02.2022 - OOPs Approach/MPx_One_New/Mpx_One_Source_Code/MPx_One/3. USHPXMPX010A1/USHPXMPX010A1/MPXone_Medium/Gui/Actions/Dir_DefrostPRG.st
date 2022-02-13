USING System;
USING System.UI;
USING HEOneRow;

FUNCTION Dir_DefrostPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    ManDfr := NOT ManDfr;

END_FUNCTION
