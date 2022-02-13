USING System;
USING System.UI;
USING HEOneRow;

FUNCTION Dir_LightPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    LightsOn := NOT LightsOn;
END_FUNCTION
