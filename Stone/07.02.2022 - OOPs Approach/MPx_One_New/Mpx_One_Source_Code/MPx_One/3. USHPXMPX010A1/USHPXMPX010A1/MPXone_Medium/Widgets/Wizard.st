USING System.UI;
USING HEOneRow;
USING System.Math;
USING System;
USING System.Globalization;
USING Libs.CustomGas;

VAR_GLOBAL
    tmpWiz: WizParams;
    
    tmpConfOk : ARRAY[0..NUM_WIZ_PARAMS] OF BOOL;
    wizCanEnd : BOOL := FALSE;
END_VAR

VAR_GLOBAL CONSTANT
    {IF NOT DEF(MPXONE_ADVANCED)}    
    NUM_WIZ_PARAMS : USINT := 12;
    {ELSE}
    NUM_WIZ_PARAMS : USINT := 13;
    {ENDIF}
END_VAR

TYPE 
    WizData : UNION
        bool : BOOL;
        usint : USINT;
        sint : SINT;
        real : REAL;
    END_UNION;
    
    WizStruct: STRUCT
        (** Master or slave configuration *)
        In : WizData := (bool := FALSE);
        (** Number or slave devices *)
        Sn : WizData := (usint := 0);
        (** Number or slave devices *)
        H0 : WizData := (usint := 199);
        (** BMS protocol selection *)
        H3 : WizData := (bool := TRUE);
        (** Type of probes on Group1 (S1, S2 and S3) *)
        _P1 : WizData := (bool := TRUE);
        (** Valve type *)
        {IF NOT DEF(MPXONE_ADVANCED)}
        P1 :  WizData := (usint := 0);
        {ELSE}
        P1 :  WizData := (usint := 1); //valve present by default in PMXone Advanced
        {ENDIF}
        (** Refrigerant type *)
        PH :  WizData := (usint := 3);
        (** Type of probes on Group2 (S4 and S5) *)
        _P2 :  WizData := (usint := 2);
        (** Type of probes on Group3 (S6)*)
        _P3 :  WizData := (usint := 1);
        (** Channel of suction temperature probe *)
        _FD :  WizData := (usint := 0);
        (** Channel of evaporation pressure probe *)
        _FE :  WizData := (usint := 0);
        (** Maximum of evaporation pressure probe *)
        _UE :  WizData := (real := 9.3);
        (** Minimum of evaporation pressure probe *)
        _LE :  WizData := (real := -1.0);
         {IF DEF(MPXONE_ADVANCED)}       
        (** Type of probes on Group3 (S8)*)
        _P5 :  WizData := (usint := 1);        
        {ENDIF}
    END_STRUCT;
    
    WizParams : UNION
        Fct : WizStruct;
        Arr : ARRAY [0..NUM_WIZ_PARAMS] OF WizData;    // Biggest data type
    END_UNION;

END_TYPE


{METADATA DEFAULT_SELECTABLE "TRUE"}
{METADATA WIDGET_TYPE "Text"}
{METADATA PREVIEW_STRING "Wiz"}
{METADATA SUPPORT_TERMINALS "SevenSegments;HEOneRow"}
CLASS WizardWidget
    
	VAR PUBLIC
		x,y : INT;	//auto-assigned
        Acronim : STRING[3];
        ValIndex : USINT := 0;
	END_VAR
	
	VAR PRIVATE
        (*not modify, just for widget*)
        StringWrite : STRING[5];
        
        showValue : BOOL;
        
        tmpVal : WizData;
        
        isReal : BOOL;
        isBool : BOOL;
        isUsint : BOOL;
        isSint : BOOL;
        
        Min, Max : REAL;
        
        _UOM : UOM := UOM#NONE;
	END_VAR

	
	METHOD PUBLIC Init        
        // Reset the visualization
        //ValIndex := 0;
        showValue := FALSE;
        
        // Get value of Wiz parameter
        tmpVal :=  tmpWiz.Arr[ValIndex];
        
        
        // Get type of Wiz parameter
        CASE ValIndex OF
            0, 3 , 4: THIS.isBool := TRUE;
            1, 2, 5..8: THIS.isUsint := TRUE;
            9..10: THIS.isSint := TRUE;
            11..12: THIS.isReal := TRUE;
            13: THIS.isSint := TRUE;
            _UOM := UOM#BAR;
        END_CASE;
        
        // Get limits
        CASE ValIndex OF
            1: THIS.Min := 0.0; THIS.Max := 9.0; // parameter Sn
            2: THIS.Min := 1.0; THIS.Max := 247.0; // parameter H0
            5: THIS.Min := 0.0; THIS.Max := 6.0; // parameter P1
            6: THIS.Min := 0; THIS.Max := 40; // parameter PH
            7: THIS.Min := 1; THIS.Max := 3; // parameter /P2
            8: THIS.Min := 0; THIS.Max := 4; // parameter /P3
            {IF NOT DEF (MPXONE_ADVANCED)} 
                9: THIS.Min := -4; THIS.Max := 6; // parameter /Fd
                10: THIS.Min := -4; THIS.Max := 6; // parameter /FE
            {ENDIF}
            {IF DEF (MPXONE_ADVANCED)} 
                9: THIS.Min := -4; THIS.Max := 8; // parameter /Fd
                10: THIS.Min := -4; THIS.Max := 8; // parameter /FE
            {ENDIF}            
            11: THIS.Min := EvapMin; THIS.Max := 200.0; // parameter /UE
            12: THIS.Min := -1.0; THIS.Max := EvapMax; // parameter /LE
            
            {IF DEF (MPXONE_ADVANCED)} 
            13: THIS.Min := 1; THIS.Max := 2; // parameter /P5
            {ENDIF}
        END_CASE;
                
	END_METHOD
	

	METHOD PUBLIC Draw
        
        IF showValue THEN
            IF THIS.isBool THEN
                StringWrite := TO_STRING(TO_USINT(tmpVal.bool));
            ELSIF THIS.isUsint THEN
                StringWrite := TO_STRING(tmpVal.usint);
            ELSIF THIS.isSint THEN
                StringWrite := TO_STRING(tmpVal.sint);
            ELSIF THIS.isReal THEN
                StringWrite := REAL_TO_DISPLAY(tmpVal.real);
            END_IF;
        ELSE
            StringWrite := Acronim;
        END_IF;
        
        (*draw the string*)
        DrawString(StringWrite, 0, 0);
        
    END_METHOD
    

	{METADATA ACTION "KEY_DOWN"}
	METHOD PUBLIC KeyDown
        IF showValue THEN
            IF THIS.isBool THEN
                tmpVal.bool := NOT tmpVal.bool;
                
            ELSIF THIS.isUsint THEN
                tmpVal.usint := tmpVal.usint - 1;
                
                IF tmpVal.usint > TO_USINT(THIS.Max) THEN
                    tmpVal.usint := TO_USINT(THIS.Max);
                END_IF;
                
                IF tmpVal.usint < TO_USINT(THIS.Min) THEN
                    tmpVal.usint := TO_USINT(THIS.Max);
                END_IF;
            ELSIF THIS.isSint THEN
                tmpVal.sint := tmpVal.sint - 1;
                
                IF tmpVal.sint < TO_SINT(THIS.Min) THEN
                    tmpVal.sint := TO_SINT(THIS.Max);
                END_IF;
            ELSIF THIS.isReal THEN
                tmpVal.real := tmpVal.real - 0.1;
                
                IF tmpVal.real < THIS.Min THEN
                    tmpVal.real := THIS.Max;
                END_IF;
            END_IF;
        ELSE
            GoToNextMask();
        END_IF;
	END_METHOD
    
    {METADATA ACTION "KEY_UP"}
 	METHOD PUBLIC KeyUp
        IF showValue THEN
            IF THIS.isBool THEN
                tmpVal.bool := NOT tmpVal.bool;
                
            ELSIF THIS.isUsint THEN
                tmpVal.usint := tmpVal.usint + 1;
                
                IF tmpVal.usint > TO_USINT(THIS.Max) THEN
                    tmpVal.usint := TO_USINT(THIS.Min);
                END_IF;
            ELSIF THIS.isSint THEN 
                tmpVal.sint := tmpVal.sint + 1;
                
                IF tmpVal.sint > TO_SINT(THIS.Max) THEN
                    tmpVal.sint := TO_SINT(THIS.Min);
                END_IF;
            ELSIF THIS.isReal THEN
                tmpVal.real := tmpVal.real + 0.1;
                
                IF tmpVal.real > THIS.Max THEN
                    tmpVal.real := THIS.Min;
                END_IF;
            END_IF;
        ELSE
            GoToPreviousMask();
        END_IF;
    END_METHOD
    
    {METADATA ACTION "KEY_PRG"}
 	METHOD PUBLIC KeyPrg
        VAR
            i : INT;
        END_VAR
        
        showValue := NOT showValue;
        
        IF NOT showValue THEN
            tmpConfOk[ValIndex] := TRUE;
            tmpWiz.Arr[ValIndex] := tmpVal;
            
            // Check if wizard can finish
            wizCanEnd := TRUE;
            FOR i := TO_INT(LOWER_BOUND(tmpWiz.Arr, 1)) TO TO_INT(UPPER_BOUND(tmpWiz.Arr, 1)) DO
                IF i = 1 AND NOT tmpWiz.Fct.In.bool THEN CONTINUE; END_IF;
                IF i = 4 OR i = 5 AND isBasic THEN CONTINUE; END_IF;
                IF i > 5 AND NOT VlvPresent THEN CONTINUE; END_IF;
                
                wizCanEnd := wizCanEnd AND tmpConfOk[i];
            END_FOR;
        END_IF;
    END_METHOD
    
    {METADATA ACTION "KEY_ALARM"}
 	METHOD PUBLIC KeyAlarm
        //showValue := FALSE;
        
        // blockHmi := TRUE; 
        // IdxVis := 1; 
        // LedOnArrow := FALSE;
        // GoToMask(MaskList#mMain);
        // Navigation := FALSE;
    END_METHOD

END_CLASS
    