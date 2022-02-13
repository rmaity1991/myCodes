USING Libs.Logics;
USING System.Timer;
USING System;
USING System.Math;
USING System.Util;

// Uncomment to enable day/night logging
//{DEFINE DNLOGS 1}

VAR_GLOBAL
    MstTempRegStatus : BOOL;
END_VAR

NAMESPACE LibraryNamespaceAndVersion

PROGRAM MainRegMng
    VAR
        
        TP_s_Timed : TP;
        EEVStartSR : SR;
        
        CleanRF : RF_TRIG;
        CleanTON : TON;
        //CleanTON_R_Trig : R_TRIG;
        
        //ContStatusRT : R_TRIG;
        
        DoorTON : TON;
        DoorLigthTON : TON;
        //DoorOnUsed, DoorOffUsed : FctIsUsed;
        
        DayNightTrigger, CurtainTrigger : RF_TRIG;//, OnOffDinTrigger : RFTrig;
        DayNightScheduler : MPXScheduler;
        
        StandbyTON, AndTimeoutTON, AlarmONTON, AlarmTON : TON;
        ContCycle_Pulse : TP;
        StandBy_DIN_R_TRIG : R_TRIG;
        Standby_RS : RS;
        
        DutySetON, DutySetOFF : TON;

        // Generic function
        AlarmFct : ARRAY [1..1] OF libs.GenericFunctionMng.GenFct_Alarm;
        StageFct : ARRAY [1..1] OF Libs.GenericFunctionMng.GenFct_Stage;
        {IF NOT DEF(MPXONE_BASIC)}
        ModulFct : ARRAY [1..1] OF libs.GenericFunctionMng.GenFct_Modulating;
        {ENDIF}
        
        TempRegHyst_Left, TempRegHyst_Left2 : REAL;
        TempRegHyst_Right, TempRegHyst_Right2 : REAL;
        //SetP_On, SetP_On2 : REAL;
        //SetP_Off, SetP_Off2 : REAL;
        
        F_EDGE_firstCycle : F_EDGE;
        FirstCicle_L_Trig   : F_TRIG;
        
        
    END_VAR
    
    VAR_TEMP
        //tmpTempSetP_Offs, tmpTempSetP_Offs2 : REAL;
        AirOffBroken_Delta, AirOnBroken_Delta : REAL;
        EEVOpenOk : BOOL;
        i : DINT;
        //tmpDefCondition : BOOL;
        CompFanDelay_TIME : TIME;

        AlarmTime : TIME;
    END_VAR
    
    //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
    {REGION STARTUP DELAY}
    // Following regulation will be enabled after the startup delay
    F_EDGE_firstCycle(In := firstCycle);
    FirstCicle_L_Trig(CLK := firstCycle);   // TRAC #115: Stop regoulation at startup (first cycle) in case of startup defrost set
    IF firstCycle OR (FirstCicle_L_Trig.Q AND StartupDef)  THEN
        RETURN;
    END_IF;
    {ENDREGION}
    
    VirtualProbe := (AnalogInputs.Fct.AirOff * TO_REAL(100 - VirtualComposition) + AnalogInputs.Fct.AirOn * TO_REAL(VirtualComposition)) / 100.0;
    
    {REGION DAY / NIGHT}
    // Default DayStatus value at startup TRUE
    
    // Align TOD datatype for APPLICA
    FOR i := LOWER_BOUND(TimeBandStart, 1) TO UPPER_BOUND(TimeBandStart, 1) DO
        ALIGN_TB_TOD(TimeBandStart[i]);
    END_FOR;
    FOR i := LOWER_BOUND(TimeBandEnd, 1) TO UPPER_BOUND(TimeBandEnd, 1) DO
        ALIGN_TB_TOD(TimeBandEnd[i]);
    END_FOR;
    
    DayNightScheduler(
        CurrentDT := CurrDateTime, Today := CurrentDoW,
        StartTB := TimeBandStart,
        StopTB := TimeBandEnd);
    
    IF DayNightScheduler.StartTrigger THEN
        DayStatus := TRUE;
    END_IF;
    
    IF DayNightScheduler.StopTrigger THEN
        DayStatus := FALSE;
    END_IF;
    
    // Check the curtain switch input
    CurtainTrigger(CLK := DigitalInputs.Fct.Curtain);
    IF CurtainTrigger.Q THEN
        DayStatus := DigitalInputs.Fct.Curtain;
    END_IF;

    // Light adjustment
    DayNightTrigger(CLK := DayStatus);
    IF DayNightTrigger.Q AND Dout_Cfg.Fct.Light.Ch > 0 THEN
        LightsOn := DayStatus;
    END_IF;
    
    // Light management when door switch is configured
    IF DoorTrigger.Q AND Dout_Cfg.Fct.Light.Ch > 0 THEN
        IF DigitalInputs.Fct.DoorOn OR DigitalInputs.Fct.DoorOff THEN
            LightsOn := DigitalInputs.Fct.DoorOn OR DigitalInputs.Fct.DoorOff;
        ELSIF LightOnDoorDelay = 0 THEN
            LightsOn := FALSE;
        END_IF;
    END_IF;
    
    // Door timeout for light mng
    
    DoorLigthTON(IN := LightsOn AND Dout_Cfg.Fct.Light.Ch > 0 AND
        NOT ((DigitalInputs.Fct.DoorOn AND Din_Cfg.fct.DoorOn.Ch > 0) OR (DigitalInputs.Fct.DoorOff AND Din_Cfg.fct.DoorOff.Ch > 0)),
        PT := TO_TIME(TO_DINT(LightOnDoorDelay) * 60 * 1000));
    
    IF DoorLigthTON.Q AND (Din_Cfg.fct.DoorOff.Ch > 0 OR Din_Cfg.fct.DoorOn.Ch > 0) THEN
        LightsOn := FALSE;
    END_IF;
    
    // Master / Slave sync
    IF isMaster THEN
        // Notify the slaves on master light status
        FOR i := 1 TO TO_DINT(SlavesNum) DO
            {IF NOT DEF(MPXONE_BASIC)}
            Slaves[i].myCoilStatus[089] := LightsOn;    // set NetworkLight
            Slaves[i].myCoilStatus[079] := AuxOn;       // set NetworkAux
            {ELSE}
            Slaves[i].myCoilStatus[080] := LightsOn;    // set NetworkLight
            Slaves[i].myCoilStatus[071] := AuxOn;       // set NetworkAux
            {ENDIF}
        END_FOR;
    END_IF;
    
    // Auxiliary output
    CASE CmdAux OF
        0: AuxOn := FALSE;
        1: AuxOn := DayNightOutput AND DayStatus;
        2: AuxOn := TRUE;
    END_CASE; 
    
    {ENDREGION}
    {REGION TIMER FUNCTION}
    TP_s_Timed(IN := DigitalInputs.Fct.Timed, PT := TO_TIME(TO_UINT(TimerDelay) * 60 * 1000));
    TimedOn := TP_s_Timed.Q;
    {ENDREGION}

    {REGION TEMPERATURE REGULATION}
    // regulation probe selection
    RegProbe := VirtualProbe;
    
    // Night regulation with return temperature probe
    IF NOT DayStatus AND NightPrbReg THEN
        RegProbe := AnalogInputs.Fct.AirOn;
    END_IF;
    
    // Check setpoint limits on parameter
    TempSetP := MAX(MinTempSet, TempSetP);
    TempSetP := MIN(MaxTempSet, TempSetP);
    
    TempSetP2 := MAX(MinTempSet, TempSetP2);
    TempSetP2 := MIN(MaxTempSet, TempSetP2);

        
   //23/01/2020 Filippo Pizzo - TRAC #99: changed action from trigger to keep forced the unit off by remote off
    
    // Din remote ON/OFF --> force unit off
//    IF DigitalInputs.Fct.RemoteOff THEN
//        UnitStatus := FALSE;
//    END_IF;
    /*
    OnOffDinTrigger(In := DigitalInputs.Fct.RemoteOff);
    IF OnOffDinTrigger.Out THEN
        UnitStatus := NOT DigitalInputs.Fct.RemoteOff;
    END_IF;
    */
    
    
    IF UnitOn AND NOT WaitForUpdate THEN 
        // Regulation not in alarm
        IF NOT Alarms.Al.AlExtDin.Info.Active AND (NOT(Alarms.Al.AlDelayExtDin.Info.Active AND AlDinDelay>0)) //TRAC #111: if AlDinDelay (param.DIb) = 0 --> only warning
                AND NOT GenFctAlarm_Serious THEN //ISSUE #35
        
            {REGION TEMPERATURE REGULATION}
            TempRegHyst_Right := TempSetP; 
            TempRegHyst_Left := TempSetP;
            TempRegHyst_Right2 := TempSetP2;
            TempRegHyst_Left2 := TempSetP2;
            
//            SetP_On := TempSetP; 
//            SetP_Off := TempSetP;
//            SetP_On2 := TempSetP2;
//            SetP_Off2 := TempSetP2;
            
            // Control probe lookup 
            IF Ain_Cfg.Fct.AirOn.Ch > 0 AND Ain_Cfg.Fct.AirOn.Ch <= TO_SINT(MAX_AIN_CH) THEN
                AirOnBroken := Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.AirOn.Ch].Info.Active;
            ELSIF Ain_Cfg.Fct.AirOn.Ch < 0 AND Ain_Cfg.Fct.AirOn.Ch >= -4 THEN
                AirOnBroken := Alarms.Al.Al_SerialInputs[-Ain_Cfg.Fct.AirOn.Ch].Info.Active;
            ELSE
                // Probe not configured
                AirOnBroken := TRUE;
            END_IF;

            IF Ain_Cfg.Fct.AirOff.Ch > 0 AND Ain_Cfg.Fct.AirOff.Ch <= TO_SINT(MAX_AIN_CH) THEN                

            AirOffBroken := Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.AirOff.Ch].Info.Active;
            ELSIF Ain_Cfg.Fct.AirOff.Ch < 0 AND Ain_Cfg.Fct.AirOff.Ch >= -4 THEN
                AirOffBroken := Alarms.Al.Al_SerialInputs[-Ain_Cfg.Fct.AirOff.Ch].Info.Active;
            ELSE
                // Probe not configured
                AirOffBroken := TRUE;
            END_IF;
            
            // Both probe broken or disconnected or not configured
            DutySettings := AirOffBroken AND AirOnBroken;
            
            // Probe error compensation for AIR OFF broken
            AirOffBroken_Delta := (PrbErrorOffset *  ((100 - TO_REAL(VirtualComposition)) / 100)) * TO_REAL(AirOffBroken); 
            
            // Probe error compensation for AIR ON broken
            AirOnBroken_Delta := (PrbErrorOffset * (TO_REAL( VirtualComposition) / 100)) * TO_REAL(AirOnBroken);
                      
            IF AirOffBroken THEN
                IF VirtualComposition = 0 THEN
                    DutySettings := TRUE;
                ELSE
                     // Switch on other regulation probe
                    RegProbe := AnalogInputs.Fct.AirOn;
                END_IF;
            END_IF;
            
            IF AirOnBroken THEN
                IF VirtualComposition = 100 THEN
                    DutySettings := TRUE;
                ELSE
                     // Switch on other regulation probe
                    RegProbe := AnalogInputs.Fct.AirOff;
                END_IF;
            END_IF;   
            
            TempRegHyst_Right := TempRegHyst_Right + AirOffBroken_Delta - AirOnBroken_Delta;
            TempRegHyst_Left := TempRegHyst_Left + AirOffBroken_Delta - AirOnBroken_Delta;
            
            TempRegHyst_Right2 := TempRegHyst_Right2 + AirOffBroken_Delta - AirOnBroken_Delta;
            TempRegHyst_Left2 := TempRegHyst_Left2 + AirOffBroken_Delta - AirOnBroken_Delta;
            
            IF TempCtrl_DirRev THEN
                                //Standard regulation + Day/Night delta + Smoothline offset + Probe broken offset
                TempRegHyst_Right := TempRegHyst_Right - (SetpNightOffset * TO_REAL( NOT DayStatus ))
                            + (SmLineTempOffset * TO_REAL(EnSmoothLine));
                TempRegHyst_Left := TempRegHyst_Left - TempDiff - (SetpNightOffset * TO_REAL(NOT DayStatus));
                
                TempRegHyst_Right2 := TempRegHyst_Right2- (SetpNightOffset * TO_REAL( NOT DayStatus ))
                            + (SmLineTempOffset * TO_REAL(EnSmoothLine));
                
                TempRegHyst_Left2 := TempRegHyst_Left2 - TempDiff2  - (SetpNightOffset * TO_REAL( NOT DayStatus ));
            
                // Update BMS variables
                ActualTempSetpoint := TempRegHyst_Right;
                ActualTemp2Setpoint := TempRegHyst_Right2;
            ELSE
                //Standard regulation + Day/Night delta + Smoothline offset + Probe broken offset
                TempRegHyst_Right := TempRegHyst_Right + TempDiff + (SetpNightOffset * TO_REAL(NOT DayStatus));
                TempRegHyst_Left := TempRegHyst_Left + (SetpNightOffset * TO_REAL( NOT DayStatus ))
                            - (SmLineTempOffset * TO_REAL(EnSmoothLine));
                
                TempRegHyst_Right2 := TempRegHyst_Right2 + TempDiff2  + (SetpNightOffset * TO_REAL( NOT DayStatus ));
                TempRegHyst_Left2 := TempRegHyst_Left2 + (SetpNightOffset * TO_REAL( NOT DayStatus ))
                            - (SmLineTempOffset * TO_REAL(EnSmoothLine));
            
                // Update BMS variables
                ActualTempSetpoint := TempRegHyst_Left;
                ActualTemp2Setpoint := TempRegHyst_Left2;
            END_IF;

            // Double thermostat logic
            IF TempDiff2 > 0.0 THEN
                
                TempReg(
                	In        := AnalogInputs.Fct.AirOff,
                	SetP      := TempRegHyst_Left,
                	DiffLeft  := 0.0,
                	DiffRight := TempRegHyst_Right - TempRegHyst_Left,
                	Reverse   := TempCtrl_DirRev
                );
                
                TempReg2(
                	In        := AnalogInputs.Fct.AirOn,
                	SetP      := TempRegHyst_Left2,
                	DiffLeft  := 0.0,
                	DiffRight := TempRegHyst_Right2 - TempRegHyst_Left2,
                	Reverse   := TempCtrl_DirRev
                );
//                TempReg(In := AnalogInputs.Fct.AirOff,
//                    Left := TempRegHyst_Left,
//                    Right := TempRegHyst_Right,
//                    Reverse := TempCtrl_DirRev);
                
//                TempReg2(In := AnalogInputs.Fct.AirOn,
//                    Left := TempRegHyst_Left2,
//                    Right := TempRegHyst_Right2,
//                    Reverse := TempCtrl_DirRev);
                
                IF DoubleThermostatConf THEN
                    // OR Condition
                    TempRegStatus := TempReg.Out OR TempReg2.Out;
                    MstTempRegStatus := TempRegStatus;
                ELSE
                    // AND Condition
                    AndTimeoutTON(IN := (TempReg.Out XOR TempReg2.Out) AND DoubleThermSafety > 0, PT := TO_TIME(TO_UINT(DoubleThermSafety) * 60 * 1000));
                        (*Regolation starts if there are request from Sm AND Sr   OR   if there are only one of those AND DoubleThermSafety (dbS) time setted*)
                    TempRegStatus := (TempReg.Out AND TempReg2.Out) OR (AndTimeoutTON.Q AND DoubleThermSafety > 0);
                    MstTempRegStatus := TempRegStatus;
                END_IF;
          ELSE
                TempReg(
                	In        := RegProbe,
                	SetP      := TempRegHyst_Left,
                	DiffLeft  := 0.0,
                	DiffRight := TempRegHyst_Right - TempRegHyst_Left,
                	Reverse   := TempCtrl_DirRev
                );
//                TempReg(In := RegProbe,
//                    Left := TempRegHyst_Left,
//                    Right := TempRegHyst_Right,
//                    Reverse := TempCtrl_DirRev);
                
                // No double thermostat
                TempRegStatus := TempReg.Out;
                MstTempRegStatus := TempRegStatus;
            END_IF;
            
            {ENDREGION}
            
            {REGION CONTINUOUS CYCLE}
            /* Alesssandro Balzan 03/07/2020 changed logic of activation Used TP and added control from disply */

            
            ContCycle_Pulse(
            	IN := DigitalInputs.Fct.ContCycle OR ManContCycle_byDisplay OR ManContCycle_bySuperv,
            	PT := TO_TIME(TO_DINT(ContCycleTout) * 1000 * 3600)
            ); 
            
            IF (DigitalInputs.Fct.ContCycle OR ManContCycle_byDisplay OR ManContCycle_bySuperv) AND ContCycle_Pulse.Q THEN
                ManContinuous := TRUE;
            ELSE
                ContCycle_Pulse(PT := T#0ms); // reset TP
                ManContinuous           := FALSE;
                ManContCycle_byDisplay  := FALSE; 
                ManContCycle_bySuperv   := FALSE;
            END_IF;

            //stopped by Alarm
            IF ManContinuous AND ( TempAlarms[1].Low OR TempAlarms[2].Low) AND ContCycleTout > 0 THEN
                ManContinuous           := FALSE;
                ManContCycle_byDisplay  := FALSE; 
                ManContCycle_bySuperv   := FALSE;                
            END_IF;
            
            // Defrost priority
            IF ManContinuous AND DfrStatus > DFR_IDLE AND DfrPriorityCont THEN
                ManContinuous           := FALSE;
                ManContCycle_byDisplay  := FALSE; 
                ManContCycle_bySuperv   := FALSE;                   
            END_IF;            
            
            // Keep the regulation active until temperature reach Low temperature alarm threshold
            TempRegStatus := TempRegStatus OR ManContinuous;
            MstTempRegStatus := MstTempRegSTatus OR ManContinuous;
      
            {ENDREGION}
            
            {REGION DUTY SETTINGS}
            // Act like a slave for temperature regulation
            IF NOT isMaster AND DutySettings AND NOT Alarms.Al.Al_MA.Info.Active THEN
                TempRegStatus := MstRegStatus;
                RegProbe := MstRegTemp;
                DutySettings := FALSE;
            END_IF;
            
            IF DutySettings THEN
                DutySetON(IN := NOT DutySetOFF.Q, PT := TO_TIME(TO_DINT(DutySetOnTime) * 60 * 1000));
                DutySetOFF(IN := DutySetON.Q, PT := T#15m);
                
                TempRegStatus := NOT DutySetON.Q AND NOT DutySetOFF.Q;
                
                TempRegStatus := TempRegStatus AND DutySetOnTime > 0;

            END_IF;
            
            // Regulation alarm trigger
            Alarms.Al.Al_Reg.Info.Trigger := DutySettings;
            {ENDREGION}
            
            {REGION DOOR MANAGEMENT}
            /*DoorOnUsed(FunctionValue := DIN_DOOR_INDEX, Fct := DinFct);
            DoorOffUsed(FunctionValue := DIN_DOOR_ON_INDEX, Fct := DinFct);*/
            
            DoorTrigger(CLK := DigitalInputs.Fct.DoorOff OR DigitalInputs.Fct.DoorOn);
            
            Alarms.Al.Warn_Door.Info.Trigger := DigitalInputs.Fct.DoorOff OR DigitalInputs.Fct.DoorOn;
            
            DoorTON(IN := DigitalInputs.Fct.DoorOff OR DigitalInputs.Fct.DoorOn, PT := TO_TIME(TO_DINT(HighTempBypDoor) * 60 * 1000));
            Alarms.Al.Al_Door.Info.Trigger := DoorTON.Q;
            
            IF DigitalInputs.Fct.DoorOff AND NOT DoorTON.Q THEN
                TempRegStatus := FALSE;
            END_IF;
            
//            {IF NOT DEF(MPXONE_BASIC)}
//            myVarTest := FALSE;
//            {ENDIF}

            {ENDREGION}
            
            {REGION STANDBY}
            StandBy_DIN_R_TRIG(CLK := DigitalInputs.Fct.Standby);
            Standby_RS(S := StandBy_DIN_R_TRIG.Q,
                        R1 := StartupTimeTON.ET > T#0ms OR NOT DigitalInputs.Fct.Standby OR StbyTout = 0);
            
            Alarms.Al.Status_Standby.Info.Trigger := Standby_RS.Q1 AND NOT StandbyTON.Q;
            StandbyTON(IN := Standby_RS.Q1, PT := TO_TIME(TO_DINT(StbyTout) * 60 * 1000));
            IF Standby_RS.Q1 AND NOT StandbyTON.Q AND StbyTout > 0 THEN
                TempRegStatus := FALSE;
            END_IF;
            
            {ENDREGION}
            
            {REGION CLEAN STATUS}
            Alarms.Al.Status_Clean.Info.Trigger := ManClean AND NOT CleanTON.Q;
            
            CleanRF(CLK := DigitalInputs.Fct.Clean);
            IF CleanRF.Q THEN
                ManClean := DigitalInputs.Fct.Clean;
            END_IF;
            
            CleanTON(IN := ManClean AND CleanTout > 0, PT := TO_TIME(TO_UDINT(CleanTout) * 60 * 1000));
            IF ManClean AND NOT CleanTON.Q THEN
                TempRegStatus := FALSE;
            END_IF;
            
            IF (CleanTout > 0 AND CleanTON.ET >= TO_TIME(TO_UDINT(CleanTout) * 60 * 1000)) THEN
                ManClean := FALSE;
            END_IF;
            
            {ENDREGION}
                      
            // Stop regulation with Natural defrost by running time, 
            IF DfrNatural OR DfrCompOff OR           // with compressor=off and defrost until post dripping Ticket TRAC 115)
                (NOT(CompOn) AND DfrStatus>DFR_IDLE AND DfrStatus<DFR_POST_DRIPPING AND DfrType<>1 AND DfrType<>3) THEN
                
                TempRegStatus := FALSE;
                
                // Added for hotgas: compON = ON during defrost (not dripping) Independently from request
            ELSIF (DfrType=1 OR DfrType=3) AND DfrStatus>DFR_IDLE AND DfrStatus<DFR_DRIPPING THEN
                TempRegStatus := TRUE;
            END_IF;
            
            {IF NOT DEF(MPXONE_BASIC)} 
            // P10 management
            IF ExvEnCloseLsa AND (Alarms.Al.Al_LSA.Info.Trigger OR Alarms.Al.Al_LSH.Info.Trigger) AND NOT(isMaster AND MstVlvConfig) THEN
                TempRegStatus := FALSE;
//                MstTempRegStatus := FALSE;
            END_IF;
            // PM5 management
            IF ExvEnCloseMOP AND Alarms.Al.Al_MOP.Info.Trigger AND NOT(isMaster AND MstVlvConfig) THEN
                TempRegStatus := FALSE;
//                MstTempRegStatus := FALSE;
            END_IF;
            {ENDIF}
            
            {REGION Network compressor/solenoid valve output on the Master}
            SlavesTempReq := FALSE;
            // check "TempRegStatus"
            IF isMaster AND SlavesNum > 0 AND MstVlvConfig THEN
                FOR i := 1 TO UPPER_BOUND(Slaves, 1) DO
                    {IF NOT DEF(MPXONE_BASIC)}
                    IF Slaves[i].myInputStatus[87]  THEN
                        SlavesTempReq := TRUE;
                        EXIT;
                    END_IF;
                    {ELSE}
                    IF Slaves[i].myInputStatus[72]  THEN
                        SlavesTempReq := TRUE;
                        EXIT;
                    END_IF;
                    {ENDIF}
                END_FOR;
            END_IF;
            
            TempRegStatus := TempRegStatus OR SlavesTempReq;
            {ENDREGION}
            
            {REGION Safety time}
            MinOnT := LIMIT(MinOnT, 0, 15);
            MinOnOnSameT := LIMIT(MinOnOnSameT, 0, 15);
            MinOffT := LIMIT(MinOffT, 0, 15);
            {ENDREGION }
            
            // Valve has reached the startup opening?
            {IF NOT DEF(MPXONE_BASIC)}
            IF ValveCnf = 6 AND Alarms.Al.Al_Edc.Info.Active THEN
                EEVOpenOk := TRUE;
            ELSE
                EEVOpenOk := (MachineVars.Engine_vars.EEV_vars.CurrentEstimatedPosition > MachineParams.Engine_params.EEV_PARAMS.MinSteps) AND 
                            NOT Alarms.Al.Al_Edc.Info.Active;    
            END_IF;
            {ELSE}
                EEVOpenOk := TRUE;
            {ENDIF}
            
            EEVStartSR(
                S1 := TempRegStatus AND (EEVOpenOk OR ValveCnf = 0 OR (isMaster AND SlavesTempReq)),
                R := NOT TempRegStatus 
                );

            {REGION Compressor safety times}
            // Comp off during some phase of defrost
            //tmpDefCondition := DfrStatus = DFR_IDLE OR DfrStatus = DFR_POST_DRIPPING ;
            
            // Allow pump down (NOT AVAILABLE IN CASE OF LIQUID SOLENOID VALVE)
            /*IF DfrPmpDwnDuration > MinOnT THEN
                tmpDefCondition := tmpDefCondition OR DfrStatus = DFR_CALL;
            END_IF;*/
            
            CntDwnSafT(
                DevReq := EEVStartSR.Q1, 
                DevStatus := CompOn, 
                MinOnT := MinOnT * 60,
                MinOffT := MinOffT * 60, 
                MinOnOnSameT := MinOnOnSameT * 60,
                ResSafT := DfrSafetyTime AND DfrStatus > DFR_CALL, 
                DevAlrm := CompAllAlrm,
                En_FB := TRUE
                
        //        DevOn => BOOL, 
        //        FrcdOffByT => ShowCntDwnOff, 
        //        FrcdOnByT => ShowCntDwnOn, 
        //        CntDwnTSaf => CntDwnT_FrcdOff, 
        //        CntDwnTMinOn => CntDwnT_FrcdOn
        //        AbleToOn => BOOL, 
        //        AbleToOff => BOOL
                );
            
            // Function output
            CASE CmdComp OF
                0: // Forced OFF
                    CompOn := FALSE;
                    CompFanDelay_TON(IN := FALSE, PT := T#0ms);
                1: // Automatic
                    IF CompFanDelay > 0 THEN
                        CompFanDelay_TIME := TO_TIME(TO_UDINT(CompFanDelay) * 60 * 1000);
                        CompFanDelay_TON();
                        IF F_EDGE_firstCycle.Out AND CntDwnSafT.DevOn THEN
                            F_EDGE_firstCycle.Reset := TRUE;
                            CompFanDelay_TON(IN := TRUE, PT := CompFanDelay_TIME);
                        ELSIF NOT (CompFanDelay_TON.ET > T#0ms) THEN
                            CompOn := CntDwnSafT.DevOn;
                        ELSIF CompFanDelay_TON.ET >= CompFanDelay_TIME THEN
                            CompFanDelay_TON(IN := FALSE, PT := T#0ms);
                        END_IF;
                    ELSE
                        CompOn := CntDwnSafT.DevOn;
                    END_IF;                    
                2: // Forced ON
                    CompOn := TRUE;
                    CompFanDelay_TON(IN := FALSE, PT := T#0ms);
            END_CASE;
            
            // Align slaves about current regulation status
            IF isMaster THEN
                FOR i:=1 TO TO_DINT(SlavesNum) DO
                    {IF NOT DEF(MPXONE_BASIC)}
                    Slaves[i].myCoilStatus[77] := CompOn;   //Set MstRegStatus
                    Slaves[i].myHoldingRegisters[239] := TO_UINT(RegProbe * 10); //Set MstRegTemp
                    {ELSE}
                    Slaves[i].myCoilStatus[069] := CompOn;  //Set MstRegStatus
                    Slaves[i].myHoldingRegisters[178] := TO_UINT(RegProbe * 10); //Set MstRegTemp
                    {ENDIF}
                END_FOR;
            END_IF;
            {ENDREGION }
        ELSE
            // Regulation in alarm with A10 config
            AlarmTime := TO_TIME(TO_REAL(CmpAlConfig) / 100.0 * 15 * 60 * 1000);
            
            AlarmONTON(IN := NOT AlarmTON.Q, PT := AlarmTime);
            AlarmTON(IN := NOT AlarmTON.Q, PT := T#15m);
            
            TempRegStatus := NOT AlarmONTON.Q;
            
            CntDwnSafT(
                DevReq := TempRegStatus, 
                DevStatus := CompOn, 
                MinOnT := MinOnT * 60,
                MinOffT := MinOffT * 60, 
                MinOnOnSameT := MinOnOnSameT * 60,
                ResSafT := FALSE, 
                DevAlrm := CompAllAlrm,
                En_FB := TRUE                
        //        DevOn => BOOL, 
        //        FrcdOffByT => ShowCntDwnOff, 
        //        FrcdOnByT => ShowCntDwnOn, 
        //        CntDwnTSaf => CntDwnT_FrcdOff, 
        //        CntDwnTMinOn => CntDwnT_FrcdOn
        //        AbleToOn => BOOL, 
        //        AbleToOff => BOOL
                );
            
            CompOn := CntDwnSafT.DevOn;
        END_IF;
    ELSE
        // Keep the regulation disabled
        TempReg(
        	In        := -999.9,
        	SetP      := TempSetP,
        	DiffLeft  := 0.0,
        	DiffRight := TempDiff,
        	Reverse   := FALSE
        );
        
        TempReg2(
        	In        := -999.9,
        	SetP      := TempSetP2,
        	DiffLeft  := 0.0,
        	DiffRight := TempDiff2,
        	Reverse   := FALSE
        );
        
        TempRegStatus := FALSE;
        CompOn := FALSE;
        
        //reset Clean Status
        ManClean := FALSE;
        Alarms.Al.Status_Clean.Info.Trigger := FALSE;
        
        //Keep stand-by status disabled
        Standby_RS(S := FALSE, R1 := TRUE);
        StandBy_DIN_R_TRIG(CLK := TRUE);
        Alarms.Al.Status_Standby.Info.Trigger := FALSE;        
    END_IF;
    {ENDREGION}
    
    {REGION Generic funtions}
    // Staged generic functions
    FOR i:= LOWER_BOUND(GenFctStages_Cfg, 1) TO UPPER_BOUND(GenFctStages_Cfg, 1) DO
        StageFct[i](
        	Stage     := GenFctStages_Cfg[i],
        	EnGenFct  := UnitStatus_WorkingMode = GenFctStages_EnableOn[i] OR
                            (GenFctStages_EnableOn[i] = UNIT_STATUS_GEN_FCT#UNIT_ON AND (UnitStatus_WorkingMode >= UNIT_STATUS_GEN_FCT#DEFROST ) AND (UnitStatus_WorkingMode <= UNIT_STATUS_GEN_FCT#DOOR_OPEN)) OR             
//                            (GenFctStages_EnableOn[i] = UNIT_STATUS_GEN_FCT#UNIT_ON AND UnitStatus_WorkingMode = UNIT_STATUS_GEN_FCT#REGULATION_ON) OR
                            GenFctStages_EnableOn[i] = UNIT_STATUS_GEN_FCT#ALWAYS,
        	PrbValues := RegValues
        );
        
        GenFctStages_Out[i] := StageFct[i].Q;
    END_FOR;
    
    {IF NOT DEF(MPXONE_BASIC)}
    // Modulating generic functions
    FOR i:= LOWER_BOUND(GenFctModul_Cfg, 1) TO UPPER_BOUND(GenFctModul_Cfg, 1) DO
        ModulFct[i](
        	EnGenFct  := UnitStatus_WorkingMode = GenFctModul_EnableOn[i] OR 
                            (GenFctModul_EnableOn[i] = UNIT_STATUS_GEN_FCT#UNIT_ON AND (UnitStatus_WorkingMode >= UNIT_STATUS_GEN_FCT#DEFROST ) AND (UnitStatus_WorkingMode <= UNIT_STATUS_GEN_FCT#DOOR_OPEN)) OR 
                            //(GenFctModul_EnableOn[i] = UNIT_STATUS_GEN_FCT#UNIT_ON AND UnitStatus_WorkingMode = UNIT_STATUS_GEN_FCT#REGULATION_ON) OR
                            GenFctModul_EnableOn[i] = UNIT_STATUS_GEN_FCT#ALWAYS,
        	Modul     := GenFctModul_Cfg[i],
        	PrbValues := RegValues            
        );
        
        GenFctModul_Out[i] := ModulFct[i].Q_Modul;
    END_FOR;
    {ENDIF}
    
    // Alarm generic functions
    GenFctAlarm_Serious := FALSE;
    FOR i:= LOWER_BOUND(GenFctAlarm_Cfg, 1) TO UPPER_BOUND(GenFctAlarm_Cfg, 1) DO
        AlarmFct[i](
            AlarmT          := GenFctAlarm_Cfg[i],
        	EnGenFct        := UnitStatus_WorkingMode = GenFctAlarm_EnableOn[i] OR
                                (GenFctAlarm_EnableOn[i] = UNIT_STATUS_GEN_FCT#UNIT_ON AND (UnitStatus_WorkingMode >= UNIT_STATUS_GEN_FCT#DEFROST ) AND (UnitStatus_WorkingMode <= UNIT_STATUS_GEN_FCT#DOOR_OPEN)) OR 
//                                (GenFctAlarm_EnableOn[i] = UNIT_STATUS_GEN_FCT#UNIT_ON AND UnitStatus_WorkingMode = UNIT_STATUS_GEN_FCT#REGULATION_ON) OR
                                GenFctAlarm_EnableOn[i] = UNIT_STATUS_GEN_FCT#ALWAYS,
            PosDinChannel   := Din_Cfg.Fct.GenFctAlrm.Ch,
            ValDinChannel   := DigitalInputs.Fct.GenFctAlrm,
        	PrbValues       := RegValues

        );
        GenFctAlarm_Out[i] := AlarmFct[i].Q;
        IF (GenFctAlarm_Out[i].Hi OR GenFctAlarm_Out[i].Low) AND GenFctAlarm_Out[i].Serious THEN
            GenFctAlarm_Serious := TRUE;
        END_IF;
    END_FOR;
    {ENDREGION}
    
END_PROGRAM

FUNCTION TimeBandIsToday : BOOL
    VAR_INPUT
        Today : DayOfWeek;
        TimeBandVar : TimeBand;
    END_VAR
    
    TimeBandIsToday := FALSE;  // Current time band is disabled
    IF TimeBandVar.Day <= 0 THEN
        RETURN;
    END_IF;
    
    TimeBandIsToday := TimeBandIsToday OR (TimeBandVar.Day = Today OR (TimeBandVar.Day = 7 AND Today = DayOfWeek#Sunday)); // Current time band is only for this day of week
    TimeBandIsToday := TimeBandIsToday OR (TimeBandVar.Day = 8 AND Today >= DayOfWeek#Monday AND Today <= DayOfWeek#Friday); // Current time band is only for monday to friday
    TimeBandIsToday := TimeBandIsToday OR (TimeBandVar.Day = 9 AND Today >= DayOfWeek#Monday); // Current time band is only for monday to saturday
    TimeBandIsToday := TimeBandIsToday OR (TimeBandVar.Day = 10 AND (Today = DayOfWeek#Saturday OR Today = DayOfWeek#Sunday)); // Current time band is only for saturday and sunday
    TimeBandIsToday := TimeBandIsToday OR TimeBandVar.Day = 11; // Current time band is for everyday
END_FUNCTION

FUNCTION TB_TO_INT : INT
    VAR_INPUT
        TimeBandVar : TimeBand;
    END_VAR
    
    TB_TO_INT := TO_INT(TimeBandVar.Hour) * 60 + TO_INT(TimeBandVar.Minute);
    
END_FUNCTION

FUNCTION TB_TO_TOD : TOD
    VAR_INPUT
        TimeBandVar : TimeBand;
    END_VAR
    
    TB_TO_TOD := TO_TOD(TO_DINT(TimeBandVar.Hour) * 3600 + TO_DINT(TimeBandVar.Minute) *60);
    
END_FUNCTION

FUNCTION TB_TO_TOD_TODAY : TOD
    VAR_INPUT
        TimeBandVar : TimeBand;
        today : DayOfWeek;
    END_VAR
    
    IF TimeBandIsToday(today, TimeBandVar) THEN
        TB_TO_TOD_TODAY := TB_TO_TOD(TimeBandVar);// TO_TOD(TO_DINT(TimeBandVar.Hour) * 3600 + TO_DINT(TimeBandVar.Minute) * 60);
    ELSE
        TB_TO_TOD_TODAY := TOD#23:59:59;
    END_IF;
    
END_FUNCTION

FUNCTION ALIGN_TB_TOD
    VAR_IN_OUT
        TimeBandVar : TimeBand;
    END_VAR
    
    IF TimeBandVar.TimeAPP <> TimeBandVar.MirTimeAPP THEN
        
        TimeBandVar.Hour := TO_USINT( TO_DINT( TimeBandVar.TimeAPP ) / 3600 );
        TimeBandVar.Minute := TO_USINT( TO_DINT( TimeBandVar.TimeAPP ) / 60 - TO_DINT( TimeBandVar.Hour ) * 60 );
        
        TimeBandVar.MirTimeAPP := TimeBandVar.TimeAPP;
    ELSE
        TimeBandVar.TimeAPP := TB_TO_TOD( TimeBandVar );
        TimeBandVar.MirTimeAPP := TimeBandVar.TimeAPP;
    END_IF;
    
END_FUNCTION

FUNCTION ADD_TO_TB : TimeBand
    VAR_INPUT
        tb : TimeBand;
        time : TIME;
    END_VAR
    VAR
        Minutes, Hours : USINT;
        outTb : TimeBand;
    END_VAR
    
    Hours := TO_USINT(time / (3600 * 1000) );
    Minutes := TO_USINT(time / (60 * 1000) - TO_TIME(TO_DINT(Hours) * 60));
    
    outTb.Day := tb.Day;
    outTb.Hour := tb.Hour + Hours;
    outTb.Minute := tb.Minute + Minutes;
    
    // Check time bounds
    IF outTb.Hour > 23 THEN
        outTb.Hour := outTb.Hour - 24;
    END_IF;
    
    IF outTb.Minute > 59 THEN
        outTb.Minute := outTb.Minute - 60;
    END_IF;
    
    ADD_TO_TB := outTb;
END_FUNCTION

FUNCTION TBINT_TO_TOD : TOD
    VAR_INPUT
        TimeBandINTVar : INT;
    END_VAR
    VAR
        Minutes, Hours : UINT;
    END_VAR
    
    Hours := TO_UINT(TimeBandINTVar / 60);
    Minutes := TO_UINT(TimeBandINTVar) - Hours * 60;
    TBINT_TO_TOD := CONCAT_TOD(Hours, Minutes, 0, 0);
    
END_FUNCTION

FUNCTION_BLOCK MPXScheduler
    
    VAR_INPUT
        CurrentDT : DATE_AND_TIME;
        Today : DayOfWeek;
    END_VAR
    
    VAR_IN_OUT
        StartTB : ARRAY [*] OF TimeBand;
        StopTB : ARRAY [*] OF TimeBand;
    END_VAR
    
    VAR_OUTPUT
        StartTrigger, StopTrigger : BOOL;
        StartIndex : USINT := 0;
    END_VAR
    
    VAR
        i : DINT;
        
        now : TOD;
        StartTimeR_TRIG, StopTimeR_TRIG : ARRAY [0..14] OF R_TRIG;

        firstCycle : BOOL := TRUE;
        tmpTOD : TOD;
    END_VAR
    
    // Get current status from RTC
    now := TO_TOD(CurrentDT);
    
    // Initial clean of time containers
    StartTrigger := FALSE;
    StopTrigger := FALSE;
    
    // Check triggers of time bands
    FOR i := LOWER_BOUND(StartTB, 1) TO UPPER_BOUND(StartTB, 1) DO
        tmpTOD := TB_TO_TOD_TODAY(StartTB[i], Today);
        StartTimeR_TRIG[i](CLK := TO_TIME( now - tmpTOD ) < T#5m  AND now > tmpTOD);
        IF StartTimeR_TRIG[i].Q AND NOT firstCycle THEN
            StartTrigger := TRUE;
            StartIndex := TO_USINT(i);
        END_IF;
    END_FOR;
    FOR i := LOWER_BOUND(StopTB, 1) TO UPPER_BOUND(StopTB, 1) DO
        tmpTOD := TB_TO_TOD_TODAY(StopTB[i], Today);
        StopTimeR_TRIG[i](CLK := TO_TIME( now - tmpTOD ) < T#5m AND now > tmpTOD );
        IF StopTimeR_TRIG[i].Q AND NOT firstCycle THEN
            StopTrigger := TRUE;
        END_IF;
    END_FOR;
    
    firstCycle := FALSE;
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK MPXSchedulerNew
        
    VAR_INPUT
        CurrentDT : DATE_AND_TIME;
        Today : DayOfWeek;
    END_VAR
    
    VAR_IN_OUT
        StartTB : ARRAY [*] OF TimeBand;
        StopTB : ARRAY [*] OF TimeBand;
    END_VAR
    
    VAR_OUTPUT
        StartTrigger, StopTrigger : BOOL;
        StartIndex : USINT := 0;
    END_VAR
    
    VAR
        i : DINT;
        
        now : TOD;
        StartTimeR_TRIG, StopTimeR_TRIG : ARRAY [0..48] OF R_TRIG;

        firstCycle : BOOL := TRUE;
        tmpTOD : TOD;
    END_VAR
    
    // Get current status from RTC
    now := TO_TOD(CurrentDT);
    
    // Initial clean of time containers
    StartTrigger := FALSE;
    StopTrigger := FALSE;
    
    // Check triggers of time bands
    FOR i := LOWER_BOUND(StartTB, 1) TO UPPER_BOUND(StartTB, 1) DO
        tmpTOD := TB_TO_TOD_TODAY(StartTB[i], Today);
        StartTimeR_TRIG[i](CLK := TO_TIME( now - tmpTOD ) < T#5m  AND now > tmpTOD);
        IF StartTimeR_TRIG[i].Q AND NOT firstCycle THEN
            StartTrigger := TRUE;
            StartIndex := TO_USINT(i);
        END_IF;
    END_FOR;
    FOR i := LOWER_BOUND(StopTB, 1) TO UPPER_BOUND(StopTB, 1) DO
        tmpTOD := TB_TO_TOD_TODAY(StopTB[i], Today);
        StopTimeR_TRIG[i](CLK := TO_TIME( now - tmpTOD ) < T#5m AND now > tmpTOD );
        IF StopTimeR_TRIG[i].Q AND NOT firstCycle THEN
            StopTrigger := TRUE;
        END_IF;
    END_FOR;
    
    firstCycle := FALSE;
    
END_FUNCTION_BLOCK
    
END_NAMESPACE
