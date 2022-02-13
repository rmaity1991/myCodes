USING System.UI;
USING HEOneRow;
USING System.Math;
USING System;
USING System.Timer;
USING System.Globalization;
USING System.io;

VAR_GLOBAL
            // same of Ain_offset but orderd by channel (introduced for compatibility)
    U_offset    : ARRAY[1..LIB_IO_MAX_U_CH] OF REAL;
END_VAR

{METADATA DEFAULT_SELECTABLE "FALSE"}
{METADATA WIDGET_TYPE "Text"}
{METADATA PREVIEW_STRING "VAL"}
{METADATA SUPPORT_TERMINALS "SevenSegments;HEOneRow"}
CLASS MainWidget
    
	VAR PUBLIC
		x,y : INT;	//auto-assigned
	END_VAR
	
	VAR PRIVATE
        (*not modify, just for widget*)
        StringVal_HMImain_TMP : STRING[5];
        StringVal_HMIrem_TMP : STRING[5];
        StringAlrm : STRING[4];
        i, startI : INT := 1; 
        TON_CAROSEL : TON;
        ShowStringAlarm : BOOL;
        ShowStringOff : BOOL;
        ShowStringDef : BOOL;
        FoundAlrm : BOOL;
        
        DefRT : R_TRIG;
        DefStoredT : STRING[5];
        DefStoredT_RemHMI : STRING[5];        
        keepHMIDef : BOOL;
        DefStoredTVal : REAL;
        HMIVisValue : REAL;
	END_VAR

	
	METHOD PUBLIC Init
        
	END_METHOD
	
    METHOD PRIVATE ValueToStr : STRING[5]
        VAR_INPUT
            uomVal : UOM;
            realVal : REAL;
        END_VAR
        VAR
            _INT : INT;
            _REAL : REAL;
        END_VAR
        
        CONVERT_UOM_ZONE(realVal, uomVal, _REAL, GetUIZone());
        
        _INT := TO_INT(TRUNC(_REAL));
        IF DisDecPointMainVar THEN 
            ValueToStr := TO_STRING(_INT);
        ELSE
            ValueToStr := REAL_TO_DISPLAY(_REAL);
        END_IF;
        
    END_METHOD
    
    METHOD PRIVATE ValueToStr : STRING[5]
        VAR_INPUT
            realVal : REAL;
        END_VAR
        VAR
            _INT : INT;
        END_VAR
        
        _INT := TO_INT(TRUNC(realVal));
        IF DisDecPointMainVar THEN 
            ValueToStr := TO_STRING(_INT);
        ELSE
            ValueToStr := REAL_TO_DISPLAY(realVal);
        END_IF;
        
    END_METHOD
    
    METHOD PRIVATE showErrToDisp : BOOL
        VAR_INPUT
            HMI_Sel : USINT;
        END_VAR

        CASE HMI_Sel OF            
            1..8: // Physical probes
                showErrToDisp := Alarms.Al.Al_PrbBroken[HMI_Sel].Info.Active;
            
            9: // Control probe
                showErrToDisp := DutySettings;
            
            10: // Virtual probe
                showErrToDisp := VirtualComposition = 0 AND AirOffBroken OR VirtualComposition = 100 AND AirOnBroken;
            
            11..14: // Serial probes
                IF HMI_Sel - 10 < 1 THEN
                    showErrToDisp := TRUE;
                ELSE
                    showErrToDisp := Alarms.Al.Al_SerialInputs[HMI_Sel - 10].Info.Active;    
                END_IF;                
            ELSE
                showErrToDisp := FALSE;    
        END_CASE;       
    END_METHOD
    
    METHOD PRIVATE createStringToDisp : STRING[5]
        VAR_INPUT
            HMI_Sel : USINT;
        END_VAR
        
        VAR
            PhysPrb_tmp : REAL;
            CtlPrb_tmp : REAL;
            VirtPrb_tmp : REAL;
        END_VAR
        
        Offset_Fct2Ch();
        CASE HMI_Sel OF
            0: // Terminal disabled
                createStringToDisp := '';
                HMIVisValue := 0.0;
            
            1..8: // Physical probes
                PhysPrb_tmp := TO_REAL(Libs.Math.Round((U[HMI_Sel].r + U_offset[HMI_Sel]) * 10.0)) / 10.0;
                createStringToDisp := ValueToStr(PhysPrb_tmp);
                HMIVisValue := PhysPrb_tmp;
            
            9: // Control probe
                CtlPrb_tmp := TO_REAL(Libs.Math.Round(RegProbe * 10.0)) / 10.0;
                createStringToDisp := ValueToStr(UOM_OF(RegProbe), CtlPrb_tmp);
                HMIVisValue := CtlPrb_tmp;
            
            10: // Virtual probe
                VirtPrb_tmp := TO_REAL(Libs.Math.Round(VirtualProbe * 10.0)) / 10.0;
                createStringToDisp := ValueToStr(UOM_OF(VirtualProbe), VirtPrb_tmp);
                HMIVisValue := VirtPrb_tmp;
            
            11..14: // Serial probes (without offset)
                createStringToDisp := ValueToStr(SerialInputs[HMI_Sel - 10].r);
                HMIVisValue := SerialInputs[HMI_Sel - 10].r;
            
            15: // Temperature setpoint
                createStringToDisp := ValueToStr(UOM_OF(TempSetP), TempSetP);
                HMIVisValue := TempSetP;
            
            {IF NOT DEF(MPXONE_BASIC)}
            16: //Actual superheat reading
                IF (Ain_Cfg.Arr[4].Ch > 0 AND Ain_Cfg.Arr[5].Ch > 0) OR (ValveCnf = 6) THEN
                    createStringToDisp := ValueToStr(UOM_OF(ActualSH), ActualSH);
                    HMIVisValue := ActualSH;
                ELSE
                    createStringToDisp := '----';
                    HMIVisValue := 0.0;
                END_IF;
                
            {ENDIF}
            ELSE
                createStringToDisp := '';
                HMIVisValue := 0.0;
        END_CASE;
        
        
    END_METHOD

	METHOD PUBLIC Draw
        VAR
            showErr_HMImain : BOOL;
            showErr_HMIrem : BOOL;
        END_VAR
        
        (*draw the string*)
        {REGION MAIN_VALUE_TO_SHOW}
        (*choose what is shown in the main mask*)
        (*value is replicated in two versions: 
         -REAL(with decimal point) 
        -UINT(without decimal point)*)
 
        
        // Remote HMI
        StringVal_HMIrem_TMP := createStringToDisp(HmiRemSel);
        showErr_HMIrem := showErrToDisp(HmiRemSel);
        IF showErr_HMIrem THEN
            StringVal_HMIrem_TMP := TO_STRING(999);
        END_IF;        
        
        // Main HMI
        StringVal_HMImain_TMP := createStringToDisp(HmiMainSel);
        showErr_HMImain := showErrToDisp(HmiMainSel);
        IF showErr_HMImain THEN
            StringVal_HMImain_TMP := TO_STRING(999);
        END_IF;
        
                
        // Show version during startup
        IF firstCycle THEN
            StringVal_HMImain_TMP := 'r' + TO_STRING(__PROJ_VER_MAJOR__) + '.' + TO_STRING(__PROJ_VER_MINOR__);
            StringVal_HMIrem_TMP := StringVal_HMImain_TMP;
        END_IF;
            
        // Text during defrost
        DefRT(CLK := (DfrStatus > DFR_IDLE) OR DfrNatural);
        IF DefRT.Q THEN
            DefStoredT_RemHMI := StringVal_HMIrem_TMP;
            DefStoredT := StringVal_HMImain_TMP;
         
        //TRAC #95
        // save last value shown to manage the visualization of the main value to show
        // after the end of the defrost if "d6" = 1 or 2
            IF NOT(keepHMIDef) THEN
                
                Offset_Fct2Ch();
                 CASE HmiMainSel OF
                    0: // Terminal disabled
                        DefStoredTVal := 0.0;
                    
                    1..8: // Physical probes
                        DefStoredTVal := TO_REAL(Libs.Math.Round((U[HMIMainSel].r) + U_offset[HMIMainSel] * 10.0)) / 10.0;                   
                    
                    9: // Control probe
                        DefStoredTVal := TO_REAL(Libs.Math.Round(RegProbe * 10.0)) / 10.0;
                    
                    10: // Virtual probe
                        DefStoredTVal := TO_REAL(Libs.Math.Round(VirtualProbe * 10.0)) / 10.0;
                    
                    11..14: // Serial probes (without offset)
                       DefStoredTVal := SerialInputs[HMIMainSel - 10].r;
                    
                    15: // Temperature setpoint
                        DefStoredTVal := TempSetP;
                    
                    {IF NOT DEF(MPXONE_BASIC)}
                    16: //Actual superheat reading
                        IF (Ain_Cfg.Arr[4].Ch > 0 AND Ain_Cfg.Arr[5].Ch > 0) OR (ValveCnf = 6) THEN
                            DefStoredTVal := ActualSH;
                        ELSE
                            DefStoredTVal := 0.0;
                        END_IF;
                        
                    {ENDIF}
                    ELSE
                        DefStoredTVal := 0.0;
                END_CASE;
            END_IF;
            
            
        END_IF;
        
        ShowStringDef := FALSE;
        IF DfrStatus > DFR_IDLE OR DfrNatural THEN
            CASE HmiMainDef OF
                0: 
                    StringVal_HMImain_TMP := DefStoredT;
                    StringVal_HMIrem_TMP := DefStoredT_RemHMI;
                    ShowStringDef := TRUE;
                    keepHMIDef := FALSE;
                
                1: 
                    StringVal_HMImain_TMP := DefStoredT;
                    StringVal_HMIrem_TMP := DefStoredT_RemHMI;
                    keepHMIDef := TRUE;
                
                2: 
                    StringVal_HMImain_TMP := 'DEF';
                    StringVal_HMIrem_TMP :=  'DEF';
                    keepHMIDef := TRUE;
            END_CASE;

        //TRAC #95
        ELSIF keepHMIDef THEN //if HMIMainDef (d6) =1 or 2 after the defrost keep showing the last temperature before the start of the defrost
                
                StringVal_HMImain_TMP := DefStoredT;
                StringVal_HMIrem_TMP := DefStoredT_RemHMI;

            
            // stop showing the 
            IF (RegProbe<=ActualTempSetpoint OR (TempDiff2>0 AND RegProbe<= ActualTemp2Setpoint) OR NOT(UnitOn) OR HMIVisValue<=DefStoredTVal OR DfrHiBypassEnd) THEN
                keepHMIDef := FALSE;
            END_IF;
        
        END_IF;
        
        

        {ENDREGION }
        
        ActCarosel := ActCarosel OR NOT UnitOn OR ShowStringDef;
        TON_CAROSEL(IN := ActCarosel,PT := t#3s);
        IF TON_CAROSEL.Q AND NOT firstCycle THEN 
            TON_CAROSEL(IN := FALSE,PT := t#0s);
            
            FoundAlrm := FALSE;
            startI := i;
            WHILE NOT FoundAlrm AND NOT ShowStringAlarm DO
                IF ActiveAlm[i] > 0 AND Alarms.Arr[i].StrCode <> '' THEN
                    
                    StringAlrm := Alarms.Arr[i].StrCode;
                    FoundAlrm := TRUE;
                END_IF;
                i := i + 1; 
                IF i > TO_INT(UPPER_BOUND(ActiveAlm,1)) THEN 
                    i := TO_INT(LOWER_BOUND(ActiveAlm,1));
                END_IF;
                
                // Prevent never ending loop
                IF i = startI THEN
                    IF NOT FoundAlrm THEN
                        ActCarosel := FALSE; //TRAC #117 - reset carousel if no alarms are anymore present 
                    END_IF;
                    
                    EXIT;
                END_IF;
                
            END_WHILE;
            
            IF NOT UnitOn THEN
                ShowStringAlarm := (NOT ShowStringAlarm XOR ShowStringOff) AND FoundAlrm;
                ShowStringOff := NOT ShowStringOff XOR ShowStringAlarm;
            ELSE
                ShowStringAlarm := NOT ShowStringAlarm;
                ShowStringOff := FALSE;
            END_IF;
            
        END_IF;
        
        IF ShowStringAlarm AND ActCarosel THEN
            IF ShowStringDef THEN
                DrawString('DEF', 0, 0);
            ELSE
                DrawString(StringAlrm, 0, 0);    
            END_IF;
            {IF NOT DEF(NO_MPXONE_REPEATER)}
            IF RemoteHMIAlrms THEN
                IF ShowStringDef THEN
                    mpxRepeater.SetText(1, 'DEF');
                ELSE
                    mpxRepeater.SetText(1, StringAlrm);
                END_IF;                
            END_IF;
            {ENDIF}
        ELSIF ShowStringOff  AND ActCarosel THEN
            DrawString('OFF', 0, 0);
            {IF NOT DEF(NO_MPXONE_REPEATER)}
            IF RemoteHMIAlrms THEN
                mpxRepeater.SetText(1, 'OFF');
            END_IF;
            {ENDIF}
        ELSE
            DrawString(StringVal_HMImain_TMP , 0, 0);
            
            {IF NOT DEF(NO_MPXONE_REPEATER)}
            mpxRepeater.SetText(1, StringVal_HMIrem_TMP);
            {ENDIF}
        END_IF;
    END_METHOD

END_CLASS


(**Populate U_offset array with offset present in Ain_Offset*)
FUNCTION Offset_Fct2Ch
    VAR
        i   : DINT;
    END_VAR
        
            //populate U_Offset used for channel I/O oriented logic (Vs Fct orinted)
            // (serial probe have no ofset)
    FOR i := 1 TO UPPER_BOUND(Ain_Offset.Arr,1) DO
        IF Ain_Cfg.Arr[i].Ch > 0 THEN
            U_offset[Ain_Cfg.Arr[i].Ch] := Ain_Offset.Arr[i];
        END_IF;
    END_FOR;
    
END_FUNCTION