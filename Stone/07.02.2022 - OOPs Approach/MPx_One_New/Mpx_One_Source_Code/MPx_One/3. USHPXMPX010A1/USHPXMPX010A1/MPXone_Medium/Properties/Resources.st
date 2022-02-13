USING System;

(* 0 highest priority, 10 lowest *)
CONFIGURATION __CONFIGURATION__
	RESOURCE __RESOURCE__ ON RUNTIMETARGET
        TASK ExceptionTask (SYSTEM := EVENT_EXCEPTION, PRIORITY := 0);
//		PROGRAM ExceptionInstance WITH ExceptionTask : ExceptionManager;
        PROGRAM ExceptionInstance WITH ExceptionTask : ExceptionManagerAutomaticTest;
        PROGRAM DFR_AnalogInputsProcessingInstance WITH MainTask : DFR_AnalogInputsProcessing;
        PROGRAM DFR_OutputMngInstance WITH MainTask : DFR_OutputMng;
        //{IF DEF(NO_SEV_SUPPORT)}
        TASK UITask(EVENT := UI_EVENT, PRIORITY := 2);//, AUTOSTART := 0);
		PROGRAM UIInstance              WITH UITask : UIManager;
        PROGRAM UI_MngInstance          WITH UITask : UI_Mng; //All the management related to the user interface
        //{ENDIF}
               
        PROGRAM PulseValveControlMngInstance WITH MainTask : PulseValveControlMng; 
        PROGRAM DFR_EOLTestMngInstance WITH MainTask : DFR_EOLTestMng;
        PROGRAM DFRLogMngInstance WITH MainTask : DFR_EOLLogMng;
        PROGRAM CINTestMngInstance WITH MainTask : CINTestMng;        
        PROGRAM P_CompProtectionInstance WITH MainTask : P_CompProtection;
        PROGRAM DFR_CaseStandardizationInstance WITH MainTask : DFR_CaseStandardization;
        PROGRAM DFR_AutoTestingInstance WITH MainTask : DFR_AutoTestMng;
	END_RESOURCE
END_CONFIGURATION

//{IF DEF(NO_SEV_SUPPORT)} // Seems unused so far
{METADATA NOT_AN_ACTION}
FUNCTION ManageKey : BOOL
	VAR_INPUT
		keyPressed, keyCounter : UINT;
	END_VAR
	HEOneRow.OnGui(keyPressed, keyCounter);
    ManageKey := TRUE;
END_FUNCTION
//{ENDIF}

