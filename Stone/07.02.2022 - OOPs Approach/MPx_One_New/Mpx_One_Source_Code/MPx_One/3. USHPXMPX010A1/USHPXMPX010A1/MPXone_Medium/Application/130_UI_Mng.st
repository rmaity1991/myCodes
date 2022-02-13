USING System;
USING System.UI;
USING HEOneRow;
USING System.Timer;
USING System.Globalization;
USING System.Counter;

PROGRAM UI_Mng
    
    VAR
        TON_NO_PRESS: TON;
        Check_Key, Check_Counter : UINT;
        TotActAlm_TMP : UINT := 0;
        TotActWarning_TMP : UINT := 0;
        TotActStatus_TMP : UINT := 0;
        
        PswWrongBuzTON : TON;
    END_VAR
    
    {REGION UNIT OF MEASURE}
    IF ZoneHMI THEN
        SetUIZone(Imperial);
    ELSE
        SetUIZone(SI);
    END_IF;
    {ENDREGION}
    
//    // display change
//    IF DispMngInst.isWaitingForUser() AND NOT NewDispPrompt THEN //Debug Log #3
//        GoToLoop(LoopList#NewDisp);
//        NewDispPrompt := TRUE;
//        WizProgress := FALSE;
//        InsideLoopDirFunct := FALSE;
//        DispMngInst.StartSync(DownloadDir#ACUtoHMI);
//    END_IF;
    
    {REGION WIZARD}
    IF NOT firstCycle AND NOT WizDone AND NOT WizProgress THEN
        GoToLoop(LoopList#Wizard);
        WizProgress := TRUE;
    END_IF;
    
    {ENDREGION}
    
    {REGION NO_KEY_PRESSED}
    (*checks which keys are pressed*)
    GetKeyPressed(Check_Key, Check_Counter);
    
    (*if any key is pressed after 20s go to main mask in automatic*)
    TON_NO_PRESS(IN := Check_Key = NO_KEY AND Navigation, PT := t#60s);
    
    IF TON_NO_PRESS.Q THEN 
        (*when the cursor is in the main mask navigation = FALSE*)
        Navigation := FALSE;
        InsideLoopDirFunct := FALSE; 
        (*logout*)
        Pwd_OEM_Ok := FALSE; 
        Pwd_SERVICE_Ok := FALSE; 
        Pwd_USER_Ok := FALSE;
        
        BlockHmi := FALSE;
        LedBlinkArrow := FALSE; 
        LedOnArrow := FALSE; 
        
        BasicVisualiz := FALSE;
        
        (*Reset menu widget var*)
        currMenu := 0;
        currMenuLevel := 0;
        currMenu_SecondLev := 0;
        
        (*return to main mask*)
        GoToMask(MaskList#mMain);
    END_IF;
    {ENDREGION}
    
    {REGION WRONG PASSWORD}
    // Wrong password feedback
    PswWrongBuzTON(IN := WrongPsw, PT := T#5s);
    
    IF PswWrongBuzTON.Q THEN
        WrongPsw := FALSE;
        SetBuzzer(FALSE);
    END_IF;
    
    {ENDREGION}

    {REGION DIRECT_FUNCTION}
    (*mode direct can be activated*)
    //EnDirFunct := EnDfrUser OR EnIpdUser OR EnLightsUser OR EnStbyUser;
    EnDirFunct := TRUE;
    {ENDREGION}
    
    
    {REGION ICON MNG}
    
    IF NewDispPrompt THEN
        LedBlinkArrow := TRUE;
    END_IF;
    
    {IF DEF(MPXONE_ADVANCED)}

    IF PwrSupplyFailure THEN
         LedServiceOn :=  TRUE;   
    END_IF;    
    {ENDIF}
    
    IF StartupReset OR NewDispPrompt THEN
        LEDCompOn :=  FALSE; 
        LEDCompBlink :=  FALSE; 
        //LedOnStby := FALSE;
        LedFanOn :=  FALSE;
        LedLightsOn :=  FALSE;
        LedDfrOn :=  FALSE; 
        //LedOnIpd :=  (LedDirIpd AND InsideLoopDirFunct) OR (NOT (Navigation) AND EnIconIpd AND Run_IPD);
        LedServiceOn :=  TRUE;
        
        LedOnArrow := FALSE;
        LedBlinkArrow := TRUE;
        LEDAlmBlink := FALSE;
        
        // Don't call remaining code in wizard
        RETURN;
    END_IF;

    IF WizProgress THEN
        LEDCompOn :=  FALSE; 
        LEDCompBlink :=  FALSE; 
        //LedOnStby := FALSE;
        LedFanOn :=  FALSE;
        LedLightsOn :=  FALSE;
        LedDfrOn :=  FALSE; 
        //LedOnIpd :=  (LedDirIpd AND InsideLoopDirFunct) OR (NOT (Navigation) AND EnIconIpd AND Run_IPD);
        LedServiceOn :=  NOT wizCanEnd;
        
        LedOnArrow := TRUE;
        LedBlinkArrow := FALSE;
        
        // Wizard ended by APPLICA
        IF WizDone THEN
            GoToLoop(LoopList#Main);
            WizProgress := FALSE;
        END_IF;
        
        // Don't call remaining code in wizard
        RETURN;
    END_IF;
    
    // Direct Function
    IF InsideLoopDirFunct THEN
        LEDCompOn := (UnitOn AND GetCurrentMask() = TO_UINT(MaskList#Dir_OnOff)) OR 
            (ManContinuous AND GetCurrentMask() = TO_UINT(MaskList#Dir_ContCycl));
        LEDCompBlink :=  FALSE; 
        //LedOnStby := (LedDirStby AND InsideLoopDirFunct) OR (NOT(Navigation) AND EnIconStby AND (MachineStatus = STAND_BY));
        LedFanOn := FALSE;
        LedLightsOn := LightsOn AND GetCurrentMask() = TO_UINT(MaskList#Dir_Light);
        LedAuxOn := FALSE;
        LedEcoOn := ManClean AND GetCurrentMask() = TO_UINT(MaskList#Dir_Clean);
        LedClockOn := (ManContinuous AND GetCurrentMask() = TO_UINT(MaskList#Dir_ContCycl)) OR 
            (ManClean AND GetCurrentMask() = TO_UINT(MaskList#Dir_Clean));
        LedDfrOn :=  DfrStatus > DFR_IDLE AND 
                    (GetCurrentMask() = TO_UINT(MaskList#Dir_Defrost) OR GetCurrentMask() = TO_UINT(MaskList#Dir_NetDefrost)); 
        LedHACCPOn := FALSE;
        /*LedOnIpd :=  (LedDirIpd AND InsideLoopDirFunct) OR (NOT (Navigation) AND EnIconIpd AND Run_IPD);*/
        LedServiceOn :=  NOT (Navigation) AND FALSE;
    END_IF;
    
    // Normal operation
    IF NOT Navigation OR PrbVisualiz THEN
        LEDCompOn := CompOn OR ManContinuous;
        LEDCompBlink := (TempRegStatus AND NOT CntDwnSafT.DevReq) OR (DutySettings AND NOT TempRegStatus);
        LedFanOn := FansOn OR FansReq > 0;
        LedLightsOn :=  LightsOn OR NetworkLight;
        
        {IF NOT DEF(MPXONE_BASIC)}
        LedAuxOn := DigitalOutputs.Fct.Auxiliary OR DigitalOutputs.Fct.MasterAuxiliary OR 
                    DigitalOutputs.Fct.GenericStage1 OR (AnalogOutputs.Fct.GenericModul1 > 0);
        LedEcoOn := EnSmoothLine OR ManClean OR DigitalOutputs.Fct.GenericStage1 OR 
                    (AnalogOutputs.Fct.GenericModul1 > 0); //OR Dbg_CommisisoningEvent; //ONLY FOR DEBUG
        {ELSE}
        LedAuxOn := DigitalOutputs.Fct.Auxiliary OR DigitalOutputs.Fct.MasterAuxiliary OR 
                    DigitalOutputs.Fct.GenericStage1;
        LedEcoOn := EnSmoothLine OR ManClean OR DigitalOutputs.Fct.GenericStage1; //OR Dbg_CommisisoningEvent; //ONLY FOR DEBUG
        {ENDIF}
        
        LedClockOn := FALSE OR ManContinuous OR ManClean;
        LedDfrOn :=  DfrStatus > DFR_CALL OR DfrNatural;
        LedDfrFlash := DfrStatus = DFR_CALL OR DfrBook; // For pending defrost
        LedHACCPOn := FALSE;
        /*LedOnIpd :=  (LedDirIpd AND InsideLoopDirFunct) OR (NOT (Navigation) AND EnIconIpd AND Run_IPD);*/
        {IF NOT DEF(MPXONE_BASIC)}
        LedServiceOn :=  SlvUpdFW OR OrPrbAlrm OR Alarms.Al.Al_Edc.Info.Active;
        {ELSE}
        LedServiceOn :=  SlvUpdFW OR OrPrbAlrm;
        {ENDIF}
        LedBlinkArrow := FALSE;
    END_IF;
    
    {IF NOT DEF(NO_MPXONE_REPEATER)}
    // Remote HMI Led management
    mpxRepeater.SetLed(1, TO_USINT(LEDCompOn));
    mpxRepeater.SetLed(2, TO_USINT(LedFanOn));
    mpxRepeater.SetLed(3, TO_USINT(LedLightsOn));
    mpxRepeater.SetLed(4, TO_USINT(LedAuxOn));
    mpxRepeater.SetLed(5, TO_USINT(LedServiceOn));
    mpxRepeater.SetLed(6, TO_USINT(LedEcoOn));
    mpxRepeater.SetLed(7, TO_USINT(LedClockOn));
    mpxRepeater.SetLed(8, TO_USINT(LedDfrOn));
    mpxRepeater.SetLed(9, TO_USINT(LedHACCPOn));
    
    mpxRepeater.SetLed(15, TO_USINT(NOT ZoneHMI));
    mpxRepeater.SetLed(16, TO_USINT(ZoneHMI));
    {ENDIF}
    {ENDREGION}
    
    
    {REGION LED AND BUZZER ALARM}

    
    // activation of led ONLY for warnings
    IF TotActWarning > TotActWarning_TMP THEN
        LEDAlmBlink := TRUE; 
        LEDAlmOn := FALSE;
        AckAlm := FALSE;
        //ActCarosel := TRUE;
    END_IF;
    
    // activation of carousel ONLY for status
    IF TotActStatus > TotActStatus_TMP THEN
        //LEDAlmBlink := TRUE; 
        //LEDAlmOn := FALSE;
        AckAlm := FALSE;
        ActCarosel := TRUE;
    END_IF;
    
    (*activation of led and carosel*)
    IF TotActAlm > TotActAlm_TMP THEN
        LEDAlmBlink := TRUE; 
        LEDAlmOn := FALSE;
        AckAlm := FALSE;
        ActCarosel := TRUE;
    END_IF;
    
    (*buzzer used only for alarm not for warning*)
    IF (TotActAlm > TotActAlm_TMP OR WrongPsw OR Alarms.Al.Al_GLO_1.Info.Active OR Alarms.Al.Al_GHI_1.Info.Active) 
        AND UnitStatus <> UNIT_STATUS#OFF_BY_DIGITAL_INPUT THEN
        LEDAlmBlink := TRUE;
        SetBuzzer(EnBuzzer);
        //mpxRepeater.SetBuzzer(EnBuzzer AND RemoteHMIAlrms);
    END_IF;
    
    (*ack alarm*)
    IF AckAlm OR (NOT OrAlrm AND NOT OrWarning AND NOT OrStatus AND NOT WrongPsw) THEN
        SetBuzzer(FALSE); 
        {IF NOT DEF(NO_MPXONE_REPEATER)}
        mpxRepeater.SetBuzzer(FALSE);
        {ENDIF}
        LEDAlmBlink := FALSE; 
        LEDAlmOn := OrAlrm OR OrWarning;
        ActCarosel := OrAlrm;
    END_IF;
    {IF NOT DEF(NO_MPXONE_REPEATER)}
    mpxRepeater.SetLed(17, TO_USINT(LEDAlmOn AND RemoteHMIAlrms) + TO_USINT(LEDAlmBlink AND RemoteHMIAlrms) * 2);
    {ENDIF}
    
    TotActWarning_TMP := TotActWarning;
    TotActAlm_TMP := TotActAlm;
    TotActStatus_TMP := TotActStatus;
    {ENDREGION}       
    
END_PROGRAM

FUNCTION REAL_TO_DISPLAY : STRING[5]
    VAR_INPUT
        realVal : REAL;
    END_VAR
//    VAR
//        varTemp : UINT;
        
//    //    STrDebug : STRING[5];
//    END_VAR
    
    //varTemp := TO_UINT(realVal * 10.0);             //TO_REAL(TRUNC((realVal + 0.05) * 10.0)) / 10.0;
    
    IF realVal < 1.0 AND realVal >= 0.0 THEN
        REAL_TO_DISPLAY := '  ' + TO_STRING(realVal);
    ELSIF realVal < 10.0 AND realVal >= 0.0 THEN
        REAL_TO_DISPLAY := '  ' + TO_STRING(realVal);
    ELSIF realVal < 100.0 AND realVal >= 0.0 THEN
        REAL_TO_DISPLAY := ' ' + TO_STRING(realVal);
    ELSIF realVal < 0.0 AND realVal > -10.0 THEN
        REAL_TO_DISPLAY := ' ' + TO_STRING(realVal);
    ELSE
        REAL_TO_DISPLAY := TO_STRING(realVal);
    END_IF;

    //STrDebug := REAL_TO_DISPLAY;
    
END_FUNCTION 



