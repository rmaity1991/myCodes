{IF NOT DEF(NO_SEV_SUPPORT)}

USING System;
USING System.Net.Plan;
USING System.UI;
USING System.UI.SEV;

FUNCTION_BLOCK SevenSegmentsFB
	VAR_INPUT
		keyPressed, keyCounter : UINT;
	END_VAR
	VAR_IN_OUT
		pLanAddress : UINT;
	END_VAR
	VAR
		config : BOOL;
		lastCall : UDINT;
	END_VAR
	
	IF NOT config THEN
		IF (keyPressed = KEY_SEV_SEG_PRESSED) THEN	
			config := TRUE;
			SetMaxBacklight();
			lastCall := GetSystemTime();
			pLanAddress := GetPlanAddress();
		END_IF;
    ELSE
		IF (keyPressed = KEY_SEV_SEG_RELEASED) THEN 
			config := FALSE;
			SetNormalBacklight();
			lastCall := GetSystemTime();
			IF (pLanAddress <> GetPlanAddress()) THEN
				SetPlanAddress(pLanAddress);
			END_IF;
		ELSE //keyPressed = KEY_SEV_SEG_PRESSED
			IF (GetSystemTime() - lastCall > 300) THEN
				lastCall := GetSystemTime();
				pLanAddress := FindNextAddressFrom(pLanAddress);
				SetNumber(pLanAddress);
			END_IF;
		END_IF;
	END_IF;
END_FUNCTION_BLOCK

{ENDIF}