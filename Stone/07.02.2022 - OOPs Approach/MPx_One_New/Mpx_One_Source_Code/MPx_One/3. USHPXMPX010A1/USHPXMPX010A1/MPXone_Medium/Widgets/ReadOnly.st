USING System.UI;
USING HEOneRow;
USING System.Math;
USING System;
USING System.Globalization;


{METADATA DEFAULT_SELECTABLE "FALSE"}
{METADATA WIDGET_TYPE "Text"}
{METADATA PREVIEW_STRING "R/O"}
{METADATA SUPPORT_TERMINALS "SevenSegments;HEOneRow"}
CLASS ReadOnlyWidget
    
	VAR PUBLIC
		x,y : INT;	//auto-assigned
        Acronim : STRING[3];
        ValIndex : USINT := 1;
	END_VAR
	
	VAR PRIVATE
        (*not modify, just for widget*)
        StringWrite : STRING[5];
        
        showValue : BOOL;
        
	END_VAR

	
	METHOD PUBLIC Init
        // Reset the visualization
        //ValIndex := 0;
        THIS.showValue := FALSE;
	END_METHOD
	

	METHOD PUBLIC Draw
        VAR
            _UOM : UOM;
            _REAL : REAL;
        END_VAR
        
        _UOM := UOM#NONE;
        // Mostly Celsius
        IF ValIndex >= 1 AND ValIndex <= 13 THEN
            _UOM := UOM#CELSIUS;
        END_IF;
        CASE ValIndex OF
            5:  _UOM := UOM#BAR;
            10: _UOM := UOM#PERCENT_rH;
            14: _UOM := UOM#CELSIUS;
            16: _UOM := UOM#PERCENT;
        END_CASE;
        
        CONVERT_UOM_ZONE(RegValues[ValIndex], _UOM, _REAL, GetUIZone());
        
        IF THIS.showValue THEN
            StringWrite := REAL_TO_DISPLAY(_REAL);
        ELSE
            StringWrite := Acronim;
        END_IF;
        
        (*draw the string*)
        DrawString(StringWrite, 0, 0);
        
    END_METHOD
    

	{METADATA ACTION "KEY_DOWN"}
	METHOD PUBLIC KeyDown
        THIS.showValue := FALSE;
        GoToNextMask();        
	END_METHOD
    
    {METADATA ACTION "KEY_UP"}
 	METHOD PUBLIC KeyUp
        THIS.showValue := FALSE;
        GoToPreviousMask();
    END_METHOD
    
    {METADATA ACTION "KEY_PRG"}
 	METHOD PUBLIC KeyPrg
        THIS.showValue := NOT THIS.showValue;
    END_METHOD

        
    {METADATA ACTION "KEY_PROGRAM_RELEASE"}
    METHOD PUBLIC KeyProgramRelease
        
    END_METHOD
     
    {METADATA ACTION "KEY_ALARM"}
 	METHOD PUBLIC KeyAlarm
        THIS.showValue := FALSE;
        
        // blockHmi := TRUE; 
        // IdxVis := 1; 
        // LedOnArrow := FALSE;
        // GoToMask(MaskList#mMain);
        // Navigation := FALSE;
    END_METHOD

END_CLASS
    