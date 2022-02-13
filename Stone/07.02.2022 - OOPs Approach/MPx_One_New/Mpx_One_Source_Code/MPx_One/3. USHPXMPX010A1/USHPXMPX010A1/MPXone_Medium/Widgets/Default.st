USING System.UI;
USING HEOneRow;
USING System.Timer;
USING System;


{METADATA DEFAULT_SELECTABLE "FALSE"}
{METADATA WIDGET_TYPE "Text"}
{METADATA PREVIEW_STRING "DEF"}
{METADATA SUPPORT_TERMINALS "SevenSegments;HEOneRow"}
CLASS DefaultWidget
    
	VAR PUBLIC
		x,y : INT;	//auto-assigned
	END_VAR
	
	VAR PRIVATE
        value : USINT;
        CnfRes : BOOL := TRUE;
        errTON : TON;
	END_VAR

	
	METHOD PUBLIC Init
        // Reset the visualization
        value := 0;
	END_METHOD
	

	METHOD PUBLIC Draw
        
        (*draw the string*)
        DrawString(TO_STRING(value), 0, 0);
        
        errTON(IN := NOT CnfRes, PT := T#5s);
        CnfRes := CnfRes OR errTON.Q;
        
        SetBuzzer(NOT CnfRes);
        LEDAlmOn := NOT CnfRes;
        
    END_METHOD
    

	{METADATA ACTION "KEY_DOWN"}
	METHOD PUBLIC KeyDown
        value := value - 1;
        // Unsigned lower bound check
        IF value > 2 THEN
            value := 2;
        END_IF;
	END_METHOD
    
    {METADATA ACTION "KEY_UP"}
 	METHOD PUBLIC KeyUp
        value := value + 1;
        // Unsigned upper bound check
        IF value > 2 THEN
            value := 0;
        END_IF;
    END_METHOD
    
    {METADATA ACTION "KEY_PRG"}
 	METHOD PUBLIC KeyPrg
        
        // Wait until PRG is released
        IF BlockHmi THEN
            RETURN;
        END_IF;
        
        CASE value OF
            0: // Reset carel default
            ResCarelSets := TRUE;
            THIS.Close(MaskList#WIZ_In);
            
            1: // MT Configuration
            CnfRes := SetConfiguration('C1');
            IF CnfRes THEN
                //GoToMask(MaskList#mMain);
                THIS.Close(MaskList#mMain);
                StartupReset := FALSE;
            END_IF;
            
            2: // LT Configuration
            CnfRes := SetConfiguration('C2');
            IF CnfRes THEN
                //GoToMask(MaskList#mMain);
                THIS.Close(MaskList#mMain);
                StartupReset := FALSE;
            END_IF;
            
        END_CASE;
        
    END_METHOD

    METHOD Close
        VAR_INPUT
            msk : MaskList;
        END_VAR
        
        //StartupReset := FALSE;
        LedBlinkArrow := FALSE;
        //WizDone := FALSE;
        
        GoToMask(msk);
        
    END_METHOD    
    
    {METADATA ACTION "KEY_PROGRAM_RELEASE"}
    METHOD PUBLIC DefaultPROGRAM_RELEASE


        IF BlockHmi THEN
           BlockHmi := FALSE;
        END_IF;


    END_METHOD
    
END_CLASS
    