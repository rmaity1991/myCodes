USING System;

(* 0 highest priority, 10 lowest *)
CONFIGURATION __CONFIGURATION__
	RESOURCE __RESOURCE__ ON RUNTIMETARGET
        TASK ExceptionTask (SYSTEM := EVENT_EXCEPTION, PRIORITY := 0);
		PROGRAM ExceptionInstance WITH ExceptionTask : ExceptionManager;

        TASK UITask (EVENT := UI_EVENT, PRIORITY := 2);
		PROGRAM UIInstance WITH UITask : UIManager;

		TASK MainTask (INTERVAL := T#300ms, PRIORITY := 3);
		PROGRAM MainInstance WITH MainTask : Main;
	END_RESOURCE
END_CONFIGURATION

{METADATA NOT_AN_ACTION}
FUNCTION ManageKey : BOOL
	VAR_INPUT
		keyPressed, keyCounter : UINT;
	END_VAR
	SevenSegments.OnGui(keyPressed, keyCounter);
    ManageKey := TRUE;
END_FUNCTION
