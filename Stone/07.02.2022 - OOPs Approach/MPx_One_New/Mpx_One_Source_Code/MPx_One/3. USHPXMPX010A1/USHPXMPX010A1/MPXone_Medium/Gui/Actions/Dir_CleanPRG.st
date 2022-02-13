USING System;
USING System.UI;
USING HEOneRow;

FUNCTION Dir_CleanPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    ManClean := NOT ManClean;
END_FUNCTION
