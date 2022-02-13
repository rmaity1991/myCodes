USING System.UI;
USING HEOneRow;
USING System.Math;
USING System.Timer;
USING System;
USING System.Alarm;

    (*
        +--------------------------------+            /|
        |                                |           /  ------ -  -
        | Insert WIDGET source code here |          |
        |                                |           \  ------ -  -
        +--------------------------------+            \|
    *)

{REGION Alarm_Hyst}

    {METADATA DEFAULT_SELECTABLE "FALSE"}
    {METADATA WIDGET_TYPE "Text"}
    {METADATA PREVIEW_STRING "ALM"}
    {METADATA SUPPORT_TERMINALS "SevenSegments;HEOneRow"}
    CLASS AlarmHystWidget
        
    	VAR PUBLIC
    		x,y : INT;	//auto-assigned
    	END_VAR
    	
    	VAR PRIVATE
            (*not modify, just for widget*)
            StringWrite : STRING[3];
            CompactAlrmHyst : ARRAY[1..NUM_ALARMS_HYST] OF ArrayCompactAlrmHyst;
    	END_VAR
        	
    	METHOD PUBLIC Init

    	END_METHOD
    
    	METHOD PUBLIC Draw
            
            (*draw the string*)
            (*mantain ready alway the first element*)
            LedOnArrow := TRUE; 
            
            THIS.createAlrmCodeArray();
            
            CASE AlrmHyst_idx OF
                ALRMHYST_ENUM#CODE: 
                        StringWrite := CompactAlrmHyst[IdxVis_AlrmHyst].Code_Str;
                    
                ALRMHYST_ENUM#YEAR:
                    IF CompactAlrmHyst[IdxVis_AlrmHyst].Year > 2000 THEN
                        StringWrite := TO_STRING(CompactAlrmHyst[IdxVis_AlrmHyst].Year - 2000);
                    ELSE
                        StringWrite := STRING_ALM_HYST_EMPTY;
                    END_IF;
                ALRMHYST_ENUM#MONTH:
                    StringWrite := TO_STRING(CompactAlrmHyst[IdxVis_AlrmHyst].Month);
                ALRMHYST_ENUM#DAY:
                    StringWrite := TO_STRING(CompactAlrmHyst[IdxVis_AlrmHyst].Day);
                ALRMHYST_ENUM#HOUR:
                    StringWrite := TO_STRING(CompactAlrmHyst[IdxVis_AlrmHyst].Hour);
                ALRMHYST_ENUM#MIN:
                    StringWrite := TO_STRING(CompactAlrmHyst[IdxVis_AlrmHyst].Minute);
                ALRMHYST_ENUM#DURATION:
                    StringWrite := TO_STRING(CompactAlrmHyst[IdxVis_AlrmHyst].Duration);
                ALRMHYST_ENUM#WRITE_ESC:
                    StringWrite := 'ESC';
            END_CASE;
            
            IF StringWrite <> STRING_ALM_HYST_EMPTY THEN
                DrawString(StringWrite, 0, 0);
            ELSE
                DrawString(StringWrite, 0, 1);
            END_IF;            
        END_METHOD
        
    	{METADATA ACTION "KEY_DOWN"}
    	METHOD PUBLIC KeyDown
            IF StringWrite = STRING_ALM_HYST_EMPTY THEN
                AlrmHyst_idx := ALRMHYST_ENUM#WRITE_ESC;
            ELSIF AlrmHyst_idx = ALRMHYST_ENUM#WRITE_ESC  THEN
                AlrmHyst_idx := ALRMHYST_ENUM#CODE;
            ELSE
                AlrmHyst_idx := AlrmHyst_idx + 1;
            END_IF;
    	END_METHOD
        
        {METADATA ACTION "KEY_UP"}
     	METHOD PUBLIC KeyUp
            IF StringWrite = STRING_ALM_HYST_EMPTY THEN
                AlrmHyst_idx := ALRMHYST_ENUM#WRITE_ESC;
            ELSIF AlrmHyst_idx = ALRMHYST_ENUM#CODE  THEN
                AlrmHyst_idx := ALRMHYST_ENUM#WRITE_ESC;
            ELSE
                AlrmHyst_idx := AlrmHyst_idx - 1;
            END_IF;
        END_METHOD
        
        {METADATA ACTION "KEY_PRG"}
     	METHOD PUBLIC KeyPrg            
            
        END_METHOD
        
        {METADATA ACTION "KEY_PROGRAM_RELEASE"}
        METHOD PUBLIC KeyPrgRelease
            IF StringWrite = 'ESC' THEN
                blockHmi := TRUE;
                IdxVis_AlrmHyst := 0;
                LedOnArrow := TRUE;
                PopLastMask();
                AlrmHyst_idx := ALRMHYST_ENUM#CODE;
                Navigation := FALSE;
            END_IF;
        END_METHOD
        
        {METADATA ACTION "KEY_ALARM"}
     	METHOD PUBLIC KeyAlarm
            blockHmi := TRUE; 
            IdxVis_AlrmHyst := 0; 
            LedOnArrow := FALSE;
            GoToMask(MaskList#mMain);
            Navigation := FALSE;
        END_METHOD
        
        METHOD PRIVATE createAlrmCodeArray
            VAR
                i : INT;
//                k : INT := 1;
                memIdx : INT := 1;
                Al_Year : UINT;
                Al_Month : UINT;
                Al_Day : UINT;
                Al_Hour : UINT;
                AL_Minute : UINT;
                AL_Second : UINT;
                Al_Millisecond : UINT;
                timeStampStop, timeStampStart : DATE_AND_TIME;
            END_VAR
            
            FOR i := 1 TO TO_INT(UPPER_BOUND(THIS.CompactAlrmHyst,1)) DO
                THIS.CompactAlrmHyst[i].Code_Str := '---';
                THIS.CompactAlrmHyst[i].Year := 0;
                THIS.CompactAlrmHyst[i].Month := 0;
                THIS.CompactAlrmHyst[i].Day := 0;
                THIS.CompactAlrmHyst[i].Hour := 0;
                THIS.CompactAlrmHyst[i].Minute := 0;
                THIS.CompactAlrmHyst[i].Duration := 0;
            END_FOR;
            
            memIdx := 1;
            FOR i := 1 TO TO_INT(UPPER_BOUND(LogAlarms,1)) DO
                IF LogAlarms[i].Code <> 0 AND LogAlarms[i].Status = 0 THEN
                    THIS.CompactAlrmHyst[memIdx].Code_Str := findAlrmCodeStr(LogAlarms[i].Code);
                    timeStampStart := LogAlarms[i].TimeStamp;
                    SPLIT_DT(timeStampStart, Al_Year, Al_Month, Al_Day, Al_Hour, AL_Minute, AL_Second, Al_Millisecond);
                    THIS.CompactAlrmHyst[memIdx].Year := Al_Year;
                    THIS.CompactAlrmHyst[memIdx].Month := Al_Month;
                    THIS.CompactAlrmHyst[memIdx].Day := Al_Day;
                    THIS.CompactAlrmHyst[memIdx].Hour := Al_Hour;
                    THIS.CompactAlrmHyst[memIdx].Minute := AL_Minute;
                    timeStampStop := findLogAlrmTimeStamp(LogAlarms[i].Code, AlarmStatus#Stop, i);
                    THIS.CompactAlrmHyst[memIdx].Duration := TO_UDINT(timeStampStop - timeStampStart) / 60000;
                    IF THIS.CompactAlrmHyst[memIdx].Duration > 999 THEN
                        THIS.CompactAlrmHyst[memIdx].Duration := 999;
                    END_IF;
                    
                    memIdx := memIdx + 1;
                    IF memIdx > TO_INT(UPPER_BOUND(CompactAlrmHyst,1)) THEN
                        memIdx := 1;
                    END_IF;
                END_IF;
            END_FOR;
            
        END_METHOD
        
        METHOD PRIVATE findAlrmCodeStr : STRING[3]
            VAR_INPUT
                Al_Code_tmp : UINT;
            END_VAR
            
            IF Al_Code_tmp <= TO_UINT(UPPER_BOUND(Alarms.Arr,1)) THEN
                findAlrmCodeStr := Alarms.Arr[AL_Code_tmp].StrCode;
            ELSE
                findAlrmCodeStr := '---';
            END_IF;
        END_METHOD
        
        METHOD PRIVATE findLogAlrmTimeStamp : DATE_AND_TIME
            VAR_INPUT
                Al_code_tmp : UINT;
                startStop_type : AlarmStatus;
                startIndx : INT;
            END_VAR
            
            VAR
                i : INT;
            END_VAR
            
            startIndx := startIndx + 1;
            FOR i := startIndx TO TO_INT(UPPER_BOUND(LogAlarms,1)) DO
                IF LogAlarms[i].Code = Al_Code_tmp AND LogAlarms[i].Status >= startStop_type THEN
                    findLogAlrmTimeStamp := LogAlarms[i].TimeStamp;
                    EXIT;
                END_IF;
            END_FOR;
            
        END_METHOD
        
    END_CLASS    
{ENDREGION }