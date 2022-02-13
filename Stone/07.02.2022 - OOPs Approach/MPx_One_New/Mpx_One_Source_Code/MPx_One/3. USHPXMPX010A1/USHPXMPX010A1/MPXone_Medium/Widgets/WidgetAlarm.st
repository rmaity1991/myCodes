USING System.UI;
USING HEOneRow;
USING System.Math;
USING System;





    (*
        +--------------------------------+            /|
        |                                |           /  ------ -  -
        | Insert WIDGET source code here |          |
        |                                |           \  ------ -  -
        +--------------------------------+            \|
    *)





{REGION Alarm}

    {METADATA DEFAULT_SELECTABLE "FALSE"}
    {METADATA WIDGET_TYPE "Text"}
    {METADATA PREVIEW_STRING "ALM"}
    {METADATA SUPPORT_TERMINALS "SevenSegments;HEOneRow"}
    CLASS AlarmWidget
        
    	VAR PUBLIC
    		x,y : INT;	//auto-assigned
    	END_VAR
    	
    	VAR PRIVATE
            (*not modify, just for widget*)
            StringWrite : STRING[3];
            //CompactAlrmAct : ARRAY[1..NUM_ALARMS] OF UINT;
            CompactAlrmAct : ARRAY[1..NUM_ALARMS + NUM_WARN_STATUS] OF UINT;
            i : INT := 1;
            k : INT := 1;
            IdxVis : INT := 1;
            
    	END_VAR
        	
    	METHOD PUBLIC Init

    	END_METHOD
    	
    	METHOD PUBLIC Draw
        (*draw the string*)
        (*mantain ready alway the first element*)
        LedOnArrow := TRUE; 
        k := TO_INT(LOWER_BOUND(CompactAlrmAct,1));
        FOR i := TO_INT(LOWER_BOUND(ActiveAlm,1)) TO TO_INT(UPPER_BOUND(ActiveAlm,1)) DO
            (*clear the list before to write*)
            CompactAlrmAct[i] := 0;
            (*compact the list of active alarm*)
            IF ActiveAlm[i] > 0 THEN 
                CompactAlrmAct[k] := TO_UINT(i); 
                //CompactAlrmAct[k] := ActiveAlm[i];
                k := k + 1;
            END_IF;
        END_FOR;
            
        IF IdxVis = k OR IdxVis = TO_INT(LOWER_BOUND(CompactAlrmAct,1)) THEN 
            StringWrite := 'ESC';
        END_IF;
        (*last index, go to first*)
        IF IdxVis >= k OR IdxVis < TO_INT(LOWER_BOUND(CompactAlrmAct,1)) THEN 
            IF IdxVis < TO_INT(LOWER_BOUND(CompactAlrmAct,1)) THEN 
                IdxVis := k;
            END_IF;
            
            IF IdxVis > k THEN 
                IdxVis := TO_INT(LOWER_BOUND(CompactAlrmAct,1));
            END_IF;
            
        ELSE 
            (*reset compact*)
            k := TO_INT(LOWER_BOUND(CompactAlrmAct,1));
            IF CompactAlrmAct[TO_INT(LOWER_BOUND(CompactAlrmAct,1))] = 0 THEN
                (*write no alarm*)
                StringWrite := ' NO';
            ELSE 
                (*write determinated alarm*)
                StringWrite := Alarms.Arr[CompactAlrmAct[IdxVis]].StrCode;
                //StringWrite := ALARM_CODES[CompactAlrmAct[IdxVis]];
            END_IF;
        END_IF;
            
        DrawString(StringWrite, 0, 0);
            
        END_METHOD
        

    	{METADATA ACTION "KEY_DOWN"}
    	METHOD PUBLIC KeyDown
            IdxVis := IdxVis + 1;
    	END_METHOD
        
        {METADATA ACTION "KEY_UP"}
     	METHOD PUBLIC KeyUp
            IdxVis := IdxVis - 1;
        END_METHOD
        
        {METADATA ACTION "KEY_PRG"}
     	METHOD PUBLIC KeyPrg
            
            IF StringWrite = 'ESC' THEN 
                blockHmi := TRUE; 
                IdxVis := TO_INT(LOWER_BOUND(CompactAlrmAct,1));
                LedOnArrow := FALSE;
                GoToMask(MaskList#mMain);
                Navigation := FALSE;
            END_IF;
        END_METHOD
        
        {METADATA ACTION "KEY_ALARM"}
     	METHOD PUBLIC KeyAlarm
            blockHmi := TRUE; 
            IdxVis := TO_INT(LOWER_BOUND(CompactAlrmAct,1));
            LedOnArrow := FALSE;
            GoToMask(MaskList#mMain);
            Navigation := FALSE;
        END_METHOD

    END_CLASS
    
{ENDREGION }