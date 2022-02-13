USING System;
USING Libs.Math;
USING System.Timer;
USING Libs.Hysteresis;

NAMESPACE LibraryNamespaceAndVersion

PROGRAM FanRegMng
    
    VAR
        FansRegValues : ARRAY [1..2] OF REAL;
        i : INT;
        FansHyst, CutOffHyst : HysterAdv;
        RegVal, tmpReq : REAL;
        FansRegTON, FansPeekTON : TON;
        //FansPeekTOF             : TOF;
        FansStarting            : R_EDGE;
        FansMinOut_tmp          : REAL;
        DelayAfterFirstCycle    : TON;
        
    END_VAR

     //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
    IF firstCycle THEN
        RETURN;
    END_IF;
    
    CASE FanMngConfig OF
        0: // Always ON
        FansOn := UnitOn AND NOT WaitForUpdate ;
        
        1: // Modulating on Sa - Sb
        
        // Get regulation values
        FOR i := 1 TO 2 DO
            IF FansRegCnf[i] > 0 AND FansRegCnf[i] <= TO_USINT(UPPER_BOUND(RegValues,1)) THEN
                FansRegValues[i] := RegValues[FansRegCnf[i]];
            ELSE
                FansRegValues[i] := 0.0;
            END_IF;
        END_FOR;
        
        RegVal := FansRegValues[1] - FansRegValues[2];
        
        2: // Modulating on Sa
        IF FansRegCnf[1] > 0 AND FansRegCnf[1] <= TO_USINT(UPPER_BOUND(RegValues,1)) THEN
            FansRegValues[1] := RegValues[FansRegCnf[1]];
        ELSE
            FansRegValues[1] := 0.0;
        END_IF;
        FansRegValues[2] := 0.0;
        
        RegVal := FansRegValues[1] - FansRegValues[2];
                
        3: // Always ON except with door open and DIP configured and active - if DIP is not configured it works as F0 (FanMngConfig) = 0
        FansOn := UnitOn AND NOT WaitForUpdate AND (NOT(Din_Cfg.Fct.DoorOn.Ch > 0 AND DigitalInputs.Fct.DoorOn) OR Din_Cfg.Fct.DoorOn.Ch = 0) ;
        
    END_CASE;
    {IF NOT DEF(MPXONE_BASIC)}
    FansMinOut_tmp := FansMinOut;
    {ELSE}
    FansMinOut_tmp := 0.0;
    {ENDIF}

    IF UnitOn AND (FanMngConfig > 0 AND FanMngConfig<3) THEN
        FansHyst(In := RegVal, 	SetP := FansSet, DiffLeft := FansDiff, DiffRight := 0.0, Reverse := TRUE);
        
        FansOn := FansHyst.Out;
        
        tmpReq := (FansSet - RegVal) / FansDiff * 100;
        // Limit the request
        IF tmpReq < 0 THEN
            tmpReq := 0;
        END_IF;
        IF tmpReq > 100 THEN
            tmpReq := 100;
        END_IF;
        
        // Cut-Off if FansMinOut is > 0
        CutOffHyst( In := RegVal, SetP := FansCutOff, DiffLeft := 0.0, DiffRight := 1.0, Reverse := FALSE);
    ELSE
        FansMinOut_tmp := 0.0;
        tmpReq := 0.0;
        CutOffHyst( In := 999.9, SetP := FansCutOff, DiffLeft := 0.0, DiffRight := 1.0, Reverse := FALSE);
    END_IF;
    
    CASE DfrStatus OF
        DFR_IDLE, DFR_CALL: 
            IF NOT CntDwnSafT.DevOn AND RegFanConfig AND NOT DfrNatural THEN
                FansOn := FALSE;
                tmpReq := 0.0;
            END_IF;
        
        DFR_DFR, DFR_CHECK_END:
            IF DfrFanCfg THEN
                FansOn := FALSE;
                tmpReq := 0.0;
                FansMinOut_tmp := 0.0;                
            END_IF;
        
        DFR_DRIPPING:
            FansOn := FALSE;
            tmpReq := 0.0;
            FansMinOut_tmp := 0.0;
        
        DFR_POST_DRIPPING:
            IF DfrPDFanCfg THEN
                FansOn := FALSE;
                tmpReq := 0.0;
                FansMinOut_tmp := 0.0;
            END_IF;
    END_CASE;
    
    {IF NOT DEF(MPXONE_BASIC)}
    FansReq := Scaler(tmpReq, 0, 100, FansMinOut_tmp, FansMaxOut);
    {ELSE}
    FansReq := Scaler(tmpReq, 0, 100, FansMinOut_tmp, 100.0);
    {ENDIF}
    
    // Modulating fan cut-off
    IF CutOffHyst.Out THEN
        FansReq := 0.0;
    END_IF;
    
    // Periodic or startup speedup
    
    FansRegTON(IN := FansReq > 0 AND FansSpeedupTime > 0 AND NOT FansRegTON.Q, PT := TO_TIME( TO_DINT(FansSpeedupTime) * 60 * 1000 ));
    
    IF FansRegTON.Q AND FansPeekTime > 0 THEN
        FansStarting(In := FALSE, Reset := TRUE);
    END_IF;
    
    FansStarting(In := FansReq > 0 AND FansPeekTime > 0, Reset := FansPeekTON.Q);
    FansPeekTON(IN := FansStarting.Out, PT := TO_TIME(TO_DINT(FansPeekTime) * 1000));
    
    IF FansStarting.Out THEN
        FansOn := TRUE;
        FansReq := 100.0;
    END_IF;
    
    // Alarm management
    IF (Alarms.Al.AlExtDin.Info.Active OR (Alarms.Al.AlDelayExtDin.Info.Active AND AlDinDelay>0)) AND RegFanConfig 
        //TRAC #111: if AlDinDelay (param.DIb) = 0 --> only warning
        //Fan off if F2 is set as "always off", else fan's behavior depends on F0
            OR GenFctAlarm_Serious THEN //ISSUE #35
        FansOn := FALSE;
        tmpReq := 0;
    END_IF;
    // Issue #22 added exit for UnitOn=False
    IF (DigitalInputs.Fct.DoorOff AND Din_Cfg.fct.DoorOff.Ch <> 0 AND NOT Alarms.Al.Al_Door.Info.Active) OR NOT UnitOn THEN
        FansOn := FALSE;
        FansReq := 0.0;
    END_IF;
    
    CASE CmdFans OF
        0: // Forced OFF
        FansOn := FALSE;
        FansReq := 0;
        1:  
            DelayAfterFirstCycle(IN := TRUE, PT := T#3s);
            CompFanDelay_TON();          //Trac #143 Fan spike on startup with C0>0 (delay on startup) --> recall FB for UPD ET
            IF CompFanDelay_TON.ET > T#0ms  THEN                                 
                FansOn := FALSE;
                FansReq := 0.0;
            END_IF;
        2: // Forced ON
        FansOn := TRUE;
        FansReq := 100;
    END_CASE;
    
    //Used for ebmpapst fans ESM series - Modbus communication    
    SpeedReq_EBM_1 := FansReq * TO_REAL(En_EbmpapstFan_1);
    
END_PROGRAM
    
END_NAMESPACE
