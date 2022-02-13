USING System;
USING Libs.Hysteresis;
USING System.Timer;
USING System.Math;
USING Libs.GenericFunctionMng;

// Uncomment to enable defrost logging
//{DEFINE DEFLOGS 1}

{DEFINE DEFROST_ANALISYS}

{DEFINE DEFROST_TO_SKIP 3}
{DEFINE DEFROST_TO_WAIT 8}

NAMESPACE LibraryNamespaceAndVersion

PROGRAM DfrMng
    VAR
        DfrSched : MPXScheduler;
        Staggered1, Staggered2 : MPXSchedulerNew;
        CallRTRIG, DfrRTRIG : R_TRIG;
        DfrOnTON, DfrOnTON2 : TON;
        DfrDuration, DfrDuration2 : USINT;
        DfrMaxDurationT, DfrMaxDuration2T : UDINT;
        SkipCounter, SkipCounter2 : SINT := 1 - DEFROST_TO_WAIT;
        SkippedCounter : USINT;
        SkipSR : SR;
        MachineTON, startupDefTON : TON;

        startLocal, startNetwork, startupDefSR : SR;
        TempControl, TempControl2 : HysterAdv;
        
        RunningTTON : TON;
        RunningTTON_2evap : TON;
        SequentialOnTON, SequentialOffTON : TON_PAUSE;
        CurrentTBisPow : BOOL;

        SlaveDfrDelay_TON : TON;
        
        (**Used by "defrost start by delta" function*)
        DfrStartByDelta_TON : TON;
        
//      DfrOnTimer : TIME;
//      ForceTON : TON;
//      ForceWrite, ForceValue : BOOL;
//      TBRunningIndex : USINT;
//      tmpYears, tmpMonth, tmpDays, tmpHours, tmpMin, tmpSec, tmpMillis : UINT;
    END_VAR
    
    VAR_TEMP
        nullTB                          : ARRAY [0..1] OF TimeBand;
        staggeredTB1, staggeredTB2      : ARRAY [0..47] OF TimeBand;
        timeCheckEnd, tempCheckEnd      : BOOL;
        heaterType, hotGasType, multiplexHotGasType : BOOL;
        tempRegDef                      : BOOL;
        i                               : DINT;
        slavesOk                        : BOOL;
        staggeredDelay                  : TIME;
        tmpDfrEndTemp, tmpDfrEnd2Temp   : REAL;
        DfrEndedByTime, Dfr2EndedByTime : BOOL;
        tmpDailyDfrNum, tmpDailyDfrNum2 : USINT(0..48);
        
        DfrActualInterval_T             : TIME;
        EnProbe1, EnProbe2              : BOOL;
        DfrProbe                        : REAL;
    END_VAR
    
    //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
    // Following regulation will be enabled after the startup delay
    IF firstCycle THEN
        
        //SPLIT_DT(CurrDateTime, tmpYears, tmpMonth, tmpDays, tmpHours, tmpMin, tmpSec, tmpMillis);
        
        // Avoid unexpected defrost at power on
        //DfrStartedDT := CurrDateTime;
        
        // Startup defrost trigger
        startupDefSR(S1 := StartupDef, R := FALSE);
        
        RETURN;
    END_IF;
    
    // Startup defrost
    startupDefSR(S1 := FALSE, R := startupDefTON.Q);
    startupDefTON(IN := startupDefSR.Q1 AND StartupDef, PT := TO_TIME(TO_DINT(DfrPowOnDelay) * 1000 * 60));
    IF startupDefTON.Q AND StartupDef THEN
        ManDfr := TRUE;
        NetworkDfr := isMaster;
//        StartupDef := FALSE;
    END_IF;
    
    // Align TOD datatype for APPLICA
    FOR i := LOWER_BOUND(DfrStart, 1) TO UPPER_BOUND(DfrStart, 1) DO
        ALIGN_TB_TOD(DfrStart[i]);
    END_FOR;
    
    // Call the scheduler
    DfrSched(
        CurrentDT := CurrDateTime, Today := CurrentDoW,
        StartTB := DfrStart, StopTB := nullTB);
    
    
    // Staggered defrost
    
    CASE DailyDfrNum OF //calculate the number of defrost events 
            1..12:  tmpDailyDfrNum := DailyDfrNum;
            13 :    tmpDailyDfrNum := 24;
            14 :    tmpDailyDfrNum := 48;          
    END_CASE;
    
    //tmpDailyDfrNum := DailyDfrNum;
    //DailyDfrNum := tmpDailyDfrNum;
    
    IF tmpDailyDfrNum > 0 THEN
        CASE tmpDailyDfrNum OF
            1..12: staggeredDelay := T#24h / tmpDailyDfrNum;
            24 : staggeredDelay := T#1h;
            48 : staggeredDelay := T#30m;
        END_CASE;        
        
        FOR i := 0 TO TO_DINT(tmpDailyDfrNum - 1) DO
            staggeredTB1[i] := ADD_TO_TB(DfrStart[1], staggeredDelay * (i + 1) );
        END_FOR;
        
        Staggered1(CurrentDT := CurrDateTime, Today := CurrentDoW,
            StartTB := staggeredTB1, StopTB := nullTB);
    END_IF;
    
    //tmpDailyDfrNum2 := DailyDfrNum2;
    //DailyDfrNum2 := tmpDailyDfrNum2;
  
    CASE DailyDfrNum2 OF //calculate the number of defrost events 
            1..12:  tmpDailyDfrNum2 := DailyDfrNum2;
            13 :    tmpDailyDfrNum2 := 24;
            14 :    tmpDailyDfrNum := 48;          
    END_CASE;
    
    
    IF tmpDailyDfrNum2 > 0 THEN        
        CASE DailyDfrNum2 OF
            1..12: staggeredDelay := T#24h / tmpDailyDfrNum2;
            24 : staggeredDelay := T#1h;
            48 : staggeredDelay := T#30m;
        END_CASE;  
        
        FOR i := 0 TO TO_DINT(tmpDailyDfrNum2 - 1) DO
            staggeredTB2[i] := ADD_TO_TB(DfrStart[2], staggeredDelay * (i + 1) );
        END_FOR;
        
        Staggered2(CurrentDT := CurrDateTime, Today := CurrentDoW,
            StartTB := staggeredTB2, StopTB := nullTB);
    END_IF;
    
    // Running time defrost
    IF Ain_Cfg.Fct.Defrost.ch > 0 THEN
        RunningTTON(IN := AnalogInputs.Fct.Defrost < DfrTempRun AND NOT (DfrStatus > DFR_IDLE) AND DfrTimeRun > 0 AND NOT Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.Defrost.ch].Info.Active,
                    PT := TO_TIME(TO_DINT(DfrTimeRun) * 1000 * 60));
        IF RunningTTON.Q THEN
            ManDfr := TRUE;
        END_IF;
    END_IF;
    
    // Running time defrost evaporator 2
    IF Ain_Cfg.Fct.Defrost2.ch > 0 THEN
        RunningTTON_2evap(IN := AnalogInputs.Fct.Defrost2 < DfrTempRun AND NOT (DfrStatus > DFR_IDLE) AND DfrTimeRun > 0 AND NOT Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.Defrost2.ch].Info.Active,
                            PT := TO_TIME(TO_DINT(DfrTimeRun) * 1000 * 60));
        IF RunningTTON_2evap.Q THEN
            ManDfr := TRUE;
        END_IF;
    END_IF;
    
    {REGION DEFROST START BY DELTA}
    //  (issue #16) ------------------------------------------------
    IF  DfrStartByDeltaThrsh>0 AND DfrStartByDeltaPrb1 > 0 AND DfrStartByDeltaPrb2 > 0 THEN 
        IF TO_USINT(DfrStartByDeltaPrb1) <= AIN_NUM THEN //real probe
                // Probe 1 is correctly configured and not in Alarm
            IF  (Ain_Cfg.Arr[DfrStartByDeltaPrb1].Ch>0 AND Ain_Cfg.Arr[DfrStartByDeltaPrb1].Ch <= TO_SINT(MAX_AIN_CH) AND 
                NOT Alarms.Al.Al_PrbBroken[Ain_Cfg.Arr[DfrStartByDeltaPrb1].Ch].Info.Active) THEN 
                EnProbe1 := TRUE;
            END_IF;
        ELSE 
            EnProbe1 := TRUE;  // virtual or calculated probe
        END_IF;
        
        IF TO_USINT(DfrStartByDeltaPrb2) <= AIN_NUM THEN //real probe
                 // Probe 2 is correctly configured and not in Alarm
            IF (Ain_Cfg.Arr[DfrStartByDeltaPrb2].Ch>0 AND Ain_Cfg.Arr[DfrStartByDeltaPrb2].Ch <= TO_SINT(MAX_AIN_CH) AND 
                NOT Alarms.Al.Al_PrbBroken[Ain_Cfg.Arr[DfrStartByDeltaPrb2].Ch].Info.Active) THEN 
                EnProbe2 := TRUE;
            END_IF;
        ELSE 
            EnProbe2 := TRUE;  // virtual or calculated probe
        END_IF;
        
        DfrStartByDelta_TON(
            IN := DfrStatus=DFR_IDLE AND // If not defrosting right now,
                EnProbe1 AND EnProbe2 AND
                RegValues[DfrStartByDeltaPrb1]-RegValues[DfrStartByDeltaPrb2] > DfrStartByDeltaThrsh, // Difference is greather than threshold
            PT := TO_TIME(TO_DINT(DfrStartByDeltaT)*60*1000)
        );
        IF DfrStartByDelta_TON.Q THEN
            ManDfr := TRUE;
        END_IF;
    ELSE
        DfrStartByDelta_TON(IN := FALSE, PT := T#0s);
    END_IF;
    
    {ENDREGION}
    
    
    // Sequential stop defrost
    SequentialOffTON(IN := UnitOn AND NOT SequentialOffTON.Q AND NOT SequentialOnTON.Q,
                    PT := TO_TIME(TO_DINT(DfrOffTimeSeq) * 1000 * 60), PAUSE := CompOn);
    SequentialOnTON(IN := UnitOn AND NOT SequentialOffTON.Q AND NOT SequentialOnTON.Q,
                    PT := TO_TIME(TO_DINT(DfrOnTimeSeq) * 1000 * 60), PAUSE := NOT CompOn);
    
    IF SequentialOnTON.Q AND (DfrOffTimeSeq > 0) THEN
        DfrNatural := TRUE;
    END_IF;
    IF SequentialOffTON.Q AND DfrNatural THEN
        DfrNatural := FALSE;
    END_IF;
    
    // Reset defrost if finished manually
    IF DfrStatus > DFR_IDLE AND NOT ManDfr AND startLocal.Q1 THEN
        DfrStatus := DFR_IDLE;
        ManDfr := FALSE;
        //Allows to stop the Defrost on the slave
        IF NOT isMaster THEN
            NetworkDfr := FALSE;    
        END_IF;        
        DfrOnTON(IN := FALSE, PT := T#0s);
        DfrOnTON2(IN := FALSE, PT := T#0s);
        {IF DEF(MPXONE_MEDIUM)}
        MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
        {ENDIF}        
    END_IF;
    
    // Finish defrost by the Disable of DI or Unit off
    IF DfrStatus > DFR_IDLE AND (DigitalInputs.Fct.EnDfr OR NOT UnitOn OR DigitalInputs.Fct.DefrostMirror) THEN //TRAC #120 stop defrost by "dir" input
        
        IF DigitalInputs.Fct.EnDfr THEN // If defrost is disabled by digital input  book a new defrost waiting for the re-enable
        DfrBook := TRUE;
        END_IF;
        
        DfrStatus := DFR_IDLE;
        ManDfr := FALSE;
        NetworkDfr := FALSE;
        DfrOnTON(IN := FALSE, PT := T#0s);
        DfrOnTON2(IN := FALSE, PT := T#0s);
        {IF DEF(MPXONE_MEDIUM)}
        MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
        {ENDIF}
    END_IF;
    
    // Also if i'm the slave and is manually ended on master stop the local defrost
    // and if the master stop the network 
    IF DfrStatus > DFR_IDLE AND NOT NetworkDfr AND startNetwork.Q1 THEN
        DfrStatus := DFR_IDLE;
        ManDfr := FALSE;
        DfrOnTON(IN := FALSE, PT := T#0s);
        DfrOnTON2(IN := FALSE, PT := T#0s);
        {IF DEF(MPXONE_MEDIUM)}
        MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
        {ENDIF}
        
        // Notify the slave to stop the defrost
        IF isMaster AND NOT DisNetworkDfr AND SlavesNum > 0 THEN
            FOR i := 1 TO TO_DINT(SlavesNum) DO
                {IF NOT DEF(MPXONE_BASIC)}
                Slaves[i].myCoilStatus[059] := FALSE; // ManDfr in BMS table ManDfr
                {ELSE}
                Slaves[i].myCoilStatus[053] := FALSE; // ManDfr in BMS table ManDfr
                {ENDIF}
                Slaves[i].myCoilStatus[029] := FALSE; // Reset network Defrost
            END_FOR;
        END_IF;
        //ForceWrite := TRUE;
        //ForceValue := FALSE;
    END_IF;
    
    // In case of network and a manual stop of the local only
    IF DfrStatus > DFR_IDLE AND NOT ManDfr AND startNetwork.Q1 THEN
        DfrStatus := DFR_IDLE;
        ManDfr := FALSE;
        NetworkDfr := FALSE;
        DfrOnTON(IN := FALSE, PT := T#0s);
        DfrOnTON2(IN := FALSE, PT := T#0s);
        {IF DEF(MPXONE_MEDIUM)}
        MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
        {ENDIF}        
    END_IF;
    
    // Start cause memory reset on IDLE
    startLocal(S1 := FALSE, R := DfrStatus = DFR_IDLE);
    startNetwork(S1 := FALSE, R := DfrStatus = DFR_IDLE);
    
    // Check the configuration
    CASE DfrType OF
        0: // HEATER BY TEMPERATURE
        // Defrost end condition
        timeCheckEnd := TRUE; tempCheckEnd := TRUE;
        // Type of defrost
        heaterType := TRUE; hotGasType := FALSE; multiplexHotGasType := FALSE;
        1: // HOT GAS BY TEMPERATURE
        // Defrost end condition
        timeCheckEnd := TRUE; tempCheckEnd := TRUE;
        // Type of defrost
        heaterType := FALSE; hotGasType := TRUE; multiplexHotGasType := FALSE;
        2: // heater by time
        // Defrost end condition
        timeCheckEnd := TRUE; tempCheckEnd := FALSE;
        // Type of defrost
        heaterType := TRUE; hotGasType := FALSE; multiplexHotGasType := FALSE;
        3: // hot gas by time
        // Defrost end condition
        timeCheckEnd := TRUE; tempCheckEnd := FALSE;
        // Type of defrost
        heaterType := FALSE; hotGasType := TRUE; multiplexHotGasType := FALSE;
        4: // heater by time with temp. control
        // Defrost end condition
        timeCheckEnd := TRUE; tempCheckEnd := FALSE;
        // Type of defrost
        heaterType := TRUE; hotGasType := FALSE; multiplexHotGasType := FALSE;
        tempRegDef := TRUE;
        5: // multiplexed hot gas by temperature
        // Defrost end condition
        timeCheckEnd := TRUE; tempCheckEnd := TRUE;
        // Type of defrost
        heaterType := FALSE; hotGasType := FALSE; multiplexHotGasType := TRUE;
        6: // multiplexed hot gas by time
        // Defrost end condition
        timeCheckEnd := TRUE; tempCheckEnd := FALSE;
        // Type of defrost
        heaterType := FALSE; hotGasType := FALSE; multiplexHotGasType := TRUE;
    END_CASE;
       
    // Defrost alarm management
    IF Alarms.Al.AlExtDin.Info.Active OR (Alarms.Al.AlDelayExtDin.Info.Active AND AlDinDelay>0)   //TRAC #111: if AlDinDelay (param.DIb) = 0 --> only warning
            OR GenFctAlarm_Serious THEN //ISSUE #35
        DfrStatus := DFR_IDLE;
        ManDfr := FALSE;
        NetworkDfr := FALSE;
    END_IF;
    
    // Master controller align status of slaves: used for defrost can end in the slaves
    IF isMaster AND SlavesNum > 0 THEN
        FOR i := 1 TO TO_DINT(SlavesNum) DO
            {IF NOT DEF(MPXONE_BASIC)}
            Slaves[i].myHoldingRegisters[212] := TO_UINT(DfrStatus); // DfrMstStatus in BMS table
            {ELSE}
            Slaves[i].myHoldingRegisters[166] := TO_UINT(DfrStatus); // DfrMstStatus in BMS table
            {ENDIF}
        END_FOR;
    END_IF;
    
    // Multiplexed defrost on offline slave with safety
    DfrHotGasSafetyActive := Alarms.Al.Al_MA.Info.Active AND DfrStatus > DFR_IDLE AND DfrHotGasSafety;
    
    //Logs Info
    DfrInProgress := DfrStatus > DFR_IDLE;
    
    // Defrost request by digital input- TRAC #89
    IF Din_Cfg.Fct.CallDfr.Ch <> 0 THEN
        CallRTRIG(CLK := NOT( DigitalInputs.Fct.CallDfr) AND NOT(DigitalInputs.Fct.EnDfr)); //TRAC #120 acivate defrost by "Dir" input   
    ELSE
        CallRTRIG(CLK := FALSE);
    END_IF;
          
    
    CASE DfrStatus OF
        DFR_IDLE : //------------- DEFROST IDLE STATUS
        
            // Conditions to start Dfr
        
            // Check if configured DI allow a Dfr
            IF NOT DigitalInputs.Fct.EnDfr AND UnitOn  THEN
               
                // Call Defrost by digital input  
                IF CallRTRIG.Q OR DfrBook OR (Din_Cfg.Fct.DefrostMirror.Ch>0 AND NOT DigitalInputs.Fct.DefrostMirror) THEN //start defrost by digital input of by re-enable - TRAC #89 #120
                    DfrStatus := DFR_CALL;
                    DfrBook := FALSE;
                END_IF;
                    
                // Schedulers
                IF DfrSched.StartTrigger AND NOT Alarms.Al.Al_RTC.Info.Active THEN
                    DfrStatus := DFR_CALL;
                    IF DfrSched.StartIndex >= TO_USINT(LOWER_BOUND(PowDfrConf, 1)) AND DfrSched.StartIndex <= TO_USINT(LOWER_BOUND(PowDfrConf, 1)) THEN
                        CurrentTBisPow := PowDfrConf[DfrSched.StartIndex];
                    ELSE
                        CurrentTBisPow := FALSE;
                    END_IF;
                END_IF;
                IF Staggered1.StartTrigger THEN
                    DfrStatus := DFR_CALL;
                    CurrentTBisPow := PowDfrConf[1];
                END_IF;
                IF Staggered2.StartTrigger THEN
                    DfrStatus := DFR_CALL;
                    CurrentTBisPow := PowDfrConf[2];
                END_IF;
                
                // Power defrost on night
                CurrentTBisPow := CurrentTBisPow OR NOT DayStatus;
                
                // Maximum time between Dfr start
                DfrActualInterval_T := CurrDateTime - DfrStartedDT;
                IF (DfrInterval > 0) AND DfrActualInterval_T >= TO_TIME(TO_DINT(DfrInterval) * 1000 * 3600) THEN
                    DfrStatus := DFR_CALL;
                END_IF;
                
                // Only if defrost is called by Inputs, scheduler or DI start a network defrost
                IF isMaster AND DfrStatus = DFR_CALL THEN
                    NetworkDfr := TRUE;
                END_IF;
                
                // Master call network defrost
                IF NetworkDfr AND NOT DisNetworkDfr THEN
                    DfrStatus := DFR_CALL;
                    startNetwork(S1 := TRUE, R := FALSE);
                    
                    // Notify the slave to start the defrost
                    IF isMaster AND NOT DisNetworkDfr AND SlavesNum > 0 THEN
                        FOR i := 1 TO TO_DINT(SlavesNum) DO
                            Slaves[i].myCoilStatus[29] := TRUE; // NetworkDfr in BMS table
                        END_FOR;
                    END_IF;
                    //ForceWrite := TRUE;
                    //ForceValue := TRUE;
                END_IF;
                
                // Skip defrost check
                SkipSR(S1 := DfrSkipEn AND (SkipCounter >= DEFROST_TO_SKIP OR SkipCounter2 >= DEFROST_TO_SKIP), R := NOT DfrSkipEn OR SkippedCounter <= 0 );
                IF SkipSR.Q1 AND DfrStatus > DFR_IDLE THEN
                    
                    DfrStatus := DFR_IDLE;
                    SkippedCounter := SkippedCounter + 1;
                    
                    IF SkippedCounter >= DEFROST_TO_SKIP THEN
                        SkipCounter := 1;
                        SkipCounter2 := 1;
                        SkippedCounter := 0;
                    END_IF;

                END_IF;

            END_IF;
            
            // Always force the DO to off
            DfrOn := FALSE;
            DfrOn2 := FALSE;
            DfrCompOff := FALSE;
            
            // Reset service timer
            MachineTON(IN := FALSE, PT := T#10s); // Reset TIMER
            
            IF ManDfr THEN
                DfrStatus := DFR_CALL;
                startLocal(S1 := TRUE, R := FALSE);
            END_IF;
            
            // Align manual command from SPV or APP  
            IF DfrStatus = DFR_CALL THEN
                ManDfr := TRUE;
            END_IF;
            
            {IF NOT DEF(MPXONE_BASIC)}
            // Multiplexed hot gas normal operating mode
            IF multiplexHotGasType THEN
                // Suction solenoid valve for Multiplexed Hot Gas Defrost
                S_VlvOn := TRUE;
                // Equalizing solenoid valve for Multiplexed Hot Gas Defrost
                E_VlvOn := FALSE;
            ELSE
                S_VlvOn := FALSE;
                E_VlvOn := FALSE;
            END_IF;
            {ENDIF}
        
        DFR_CALL : //------------- DEFROST CALL STATUS
            {IF NOT DEF(MPXONE_BASIC)}
            IF multiplexHotGasType THEN
                // Suction solenoid valve for Multiplexed Hot Gas Defrost
                S_VlvOn := TRUE;
                // Equalizing solenoid valve for Multiplexed Hot Gas Defrost
                E_VlvOn := FALSE;
            ELSE
                S_VlvOn := FALSE;
                E_VlvOn := FALSE;
            END_IF;
            {ENDIF}
            
            //Allows to stop local defrost
            IF ManDfr AND NOT isMaster THEN
                startLocal(S1 := TRUE, R := FALSE);
            END_IF;
            
            // Count PD time
           MachineTON(IN := TRUE, PT := TO_TIME(DfrPmpDwnDuration * 1000)); // Count
            
            // Defrost start conditions
            DfrStatus := DFR_DFR;
            // Safety conditions to start Dfr (Timing)
            IF ( CompOn AND multiplexHotGasType ) OR NOT MachineTON.Q THEN 
                DfrStatus := DFR_CALL; 
            END_IF;
            // Continuous cycle
            IF ManContinuous AND NOT DfrPriorityCont THEN 
                DfrStatus := DFR_CALL; 
            END_IF;
            // Compressor timing
            IF NOT DfrSafetyTime AND CntDwnSafT.DevOn AND NOT CntDwnSafT.AbleToOff THEN
                 DfrStatus := DFR_CALL; 
            END_IF;
        
            IF NOT isMaster AND DfrPowOnDelay > 0 AND NetworkDfr THEN
                SlaveDfrDelay_TON(IN := TRUE, PT := TO_TIME(TO_UDINT(DfrPowOnDelay) * 60 * 1000));
                IF NOT  SlaveDfrDelay_TON.Q THEN
                    DfrStatus := DFR_CALL;
                ELSE
                    SlaveDfrDelay_TON(IN := FALSE, PT := T#0s);
                    DfrStatus := DFR_DFR;
                END_IF;
            END_IF;
        
            // Defrost will start next execution
            IF DfrStatus = DFR_DFR THEN
                // Perform the Dfr action
                DfrCompOff := heaterType OR multiplexHotGasType;
                
                DfrOn := timeCheckEnd;
                DfrOn2 := Ain_Cfg.Fct.Defrost2.ch > 0;
////                DfrOn := DoutChannels[7] > 0;
////                DfrOn2 := DoutChannels[8] > 0;
            END_IF;
        
        DFR_DFR : //------------- DEFROST ON STATUS
        
            {IF NOT DEF(MPXONE_BASIC)}
            IF multiplexHotGasType THEN
                // Suction solenoid valve for Multiplexed Hot Gas Defrost
                S_VlvOn := FALSE;
                // Equalizing solenoid valve for Multiplexed Hot Gas Defrost
                E_VlvOn := FALSE;
            ELSE
                S_VlvOn := FALSE;
                E_VlvOn := FALSE;
            END_IF;
        
//            IF DfrType = 1 OR DfrType = 3 THEN
//                TempRegStatus := TRUE;
//            END_IF;
            {ENDIF}
        
        
            // Timer to count Dfr duration
            DfrRTRIG(CLK := TRUE);
            IF DfrRTRIG.Q THEN
                LibraryNamespaceAndVersion.SetLastDfrTime_RTC_MEM(CurrDateTime);
            END_IF;
                
            //DfrOnTimer := CurrDateTime - DfrStartedDT;
            DfrMaxDurationT := TO_UDINT(DfrMaxDuration + DfrPowTime * TO_USINT(CurrentTBisPow)) * 1000 * 60;
            DfrOnTON(
            	IN := TRUE,
            	PT := TO_TIME(DfrMaxDurationT)
            );
            DfrMaxDuration2T := TO_UDINT(DfrMaxDuration2 + DfrPowTime * TO_USINT(CurrentTBisPow)) * 1000 * 60;
            DfrOnTON2(
            	IN := TRUE,
            	PT := TO_TIME(DfrMaxDuration2T)
            );
            
            // BY TIME
            //IF DfrOnTimer >= TO_TIME(TO_DINT(DfrMaxDuration) * 1000 * 60) AND DfrOn AND timeCheckEnd AND DoutChannels[7] > 0 THEN // Convert minutes UINT to TIME
            IF DfrOnTON.Q AND (DfrOn OR DfrType = 4) AND timeCheckEnd THEN //AND PrbChannels[2] > 0 DoutChannels[7] > 0 THEN 
                DfrOn := FALSE;
                DfrEndedByTime := TRUE;
                //DfrStatus := DFR_CHECK_END;
                IF tempRegDef AND (Dfr2EndedByTime OR (Ain_Cfg.Fct.Defrost2.ch = 0)) THEN
                    DfrStatus := DFR_CHECK_END;
                END_IF;
                
                // Signal end by timeout
                IF tempCheckEnd AND DfrEndAlTimeout THEN
                    Alarms.Al.DfrTout1.Info.Trigger := TRUE;
                END_IF;
            END_IF;
            
            // BY TIME EVAPORATOR 2
            //IF DfrOnTimer >= TO_TIME(TO_DINT(DfrMaxDuration2) * 1000 * 60) AND DfrOn2 AND timeCheckEnd AND DoutChannels[8] > 0 THEN // Convert minutes UINT to TIME
            IF DfrOnTON2.Q AND (DfrOn2 OR DfrType = 4) AND timeCheckEnd THEN //AND PrbChannels[6] > 0 DoutChannels[8] > 0 THEN
                DfrOn2 := FALSE;
                Dfr2EndedByTime := TRUE;
                //DfrStatus := DFR_CHECK_END;
                IF tempRegDef AND (DfrEndedByTime  OR (Ain_Cfg.Fct.Defrost.ch = 0)) THEN
                    DfrStatus := DFR_CHECK_END;
                END_IF;
                
                // Signal end by timeout
                IF tempCheckEnd AND DfrEndAlTimeout THEN
                    Alarms.Al.DfrTout2.Info.Trigger := TRUE;
                END_IF;
            END_IF;
            
            // BY TEMPERATURE
        
            // Power Defrost offset
            tmpDfrEndTemp := DfrEndTemp + DfrPowTemp * TO_REAL(CurrentTBisPow);
            tmpDfrEnd2Temp := DfrEnd2Temp + DfrPowTemp * TO_REAL(CurrentTBisPow);
        
            IF (AnalogInputs.Fct.Defrost > tmpDfrEndTemp AND Ain_Cfg.Fct.Defrost.ch > 0 
                AND Ain_Cfg.Fct.Defrost.ch <= MAX_AIN_CH 
                AND NOT Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.Defrost.ch].Info.Active) AND 
                DfrOn AND tempCheckEnd THEN //DoutChannels[7] > 0 THEN

                DfrOn := FALSE;
                // Reset timeout
                Alarms.Al.DfrTout1.Info.Trigger := FALSE;
                //DfrStatus := DFR_CHECK_END;
                
                // Skip defrost counter check
                DfrDuration := TO_USINT(TO_REAL(DfrOnTON.ET) / TO_REAL(DfrMaxDurationT) * 100.0);
                IF DfrDuration < DfrSkipDuration AND DfrSkipEn THEN 
                    SkipCounter := SkipCounter + 1;
                END_IF;
                
            END_IF;
            
            // BY TEMPERATURE EVAPORATOR 2
            IF (AnalogInputs.Fct.Defrost2 > tmpDfrEnd2Temp AND Ain_Cfg.Fct.Defrost2.ch > 0 
                AND Ain_Cfg.Fct.Defrost.ch <= MAX_AIN_CH 
                AND NOT Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.Defrost2.ch].Info.Active) AND 
                DfrOn2 AND tempCheckEnd THEN //DoutChannels[8] > 0 THEN
                
                DfrOn2 := FALSE;
                // Reset timeout
                Alarms.Al.DfrTout2.Info.Trigger := FALSE;
                //DfrStatus := DFR_CHECK_END;
                
                // Skip defrost counter check
                DfrDuration2 := TO_USINT(TO_REAL(DfrOnTON2.ET) / TO_REAL(DfrMaxDuration2T) * 100.0); 
                IF DfrDuration2 < DfrSkipDuration AND DfrSkipEn THEN
                    SkipCounter2 := SkipCounter2 + 1;
                END_IF;
                
            END_IF;
            
            // Finish the defrost on unconfigured evaporators DO (won't work anyway)
//            IF NOT (PrbChannels[2] > 0) AND tempCheckEnd THEN //(DoutChannels[7] > 0) THEN
//                DfrOn := FALSE;
//            END_IF;
//            IF NOT (PrbChannels[6] > 0) AND tempCheckEnd THEN //(DoutChannels[8] > 0) THEN
//                DfrOn2 := FALSE;
//            END_IF;
        
            // Temperature regulation
            IF tempRegDef AND Ain_Cfg.Fct.Defrost.ch > 0 AND NOT DfrEndedByTime THEN
                TempControl(
                	In      := AnalogInputs.Fct.Defrost,
                	SetP      := tmpDfrEndTemp,
                	DiffLeft  := 1.0,
                	DiffRight := 0.0,
                	Reverse   := TRUE,
                    Out       => DfrOn
                );
            END_IF;
        
            IF tempRegDef AND  Ain_Cfg.Fct.Defrost2.ch > 0 AND NOT Dfr2EndedByTime THEN
                TempControl2(
                	In      := AnalogInputs.Fct.Defrost2,
                	SetP      := tmpDfrEnd2Temp,
                	DiffLeft  := 1.0,
                	DiffRight := 0.0,
                	Reverse   := TRUE,
                    Out       => DfrOn2
                );
            END_IF;
            
            // Finish the defrost status only when both evaporators are OK and slaves are ok
            IF NOT tempRegDef AND NOT DfrOn AND NOT DfrOn2 THEN
                DfrStatus := DFR_CHECK_END;
            END_IF;
        
        DFR_CHECK_END : //------------- DEFROST CHECK END CONDITIONS STATUS
        
            DfrCompOff := TRUE;
            // Wait for other controllers on the network
            DfrOn := FALSE;
            DfrOn2 := FALSE;
        
            // Get feedback for slaves defrost status
            IF NOT isMaster THEN
                // Slaves controllers can finish + check if master was not in sync
                slavesOk := DfrMstStatus > DFR_CHECK_END OR DfrMstStatus <= DFR_IDLE OR NOT DfrMasterEndSync OR Alarms.Al.Al_MA.Info.Active;
            ELSE
                slavesOk := TRUE;
                FOR i := 1 TO TO_DINT(SlavesNum) DO
                    {IF NOT DEF(MPXONE_BASIC)}
                    slavesOk := slavesOk AND (Slaves[i].myInputRegisters[017] >= TO_UINT(DFR_CHECK_END) OR Slaves[i].myInputRegisters[17] <= TO_UINT(DFR_IDLE) ) OR NOT Slaves[i].Info.IsOnline; // DfrStatus on slaves
                    {ELSE}
                    slavesOk := slavesOk AND (Slaves[i].myInputRegisters[011] >= TO_UINT(DFR_CHECK_END) OR Slaves[i].myInputRegisters[011] <= TO_UINT(DFR_IDLE) ) OR NOT Slaves[i].Info.IsOnline; // DfrStatus on slaves
                    {ENDIF}
                END_FOR;
                // Optionally ignore the sync by parameter
                slavesOk := slavesOk OR NOT DfrMasterEndSync;
            END_IF;
            
            {IF NOT DEF(MPXONE_BASIC)}
            // Multiplexed valves management
            IF multiplexHotGasType THEN
                // Suction solenoid valve for Multiplexed Hot Gas Defrost
                S_VlvOn := TRUE;
                // Equalizing solenoid valve for Multiplexed Hot Gas Defrost
                E_VlvOn := FALSE;
            ELSE
                S_VlvOn := FALSE;
                E_VlvOn := FALSE;
            END_IF;
            {ENDIF}
            
            // Clean Dfr temorary vars
            DfrRTRIG(CLK := FALSE);
            //DfrOnTimer := T#0s;
            DfrOnTON(
            	IN := FALSE,
            	PT := T#0s
            );
            DfrOnTON2(
            	IN := FALSE,
            	PT := T#0s
            );
            DfrEndedByTime  := FALSE;
            Dfr2EndedByTime := FALSE;
            MachineTON(IN := FALSE, PT := T#10s); // Reset TIMER
                
            IF slavesOk THEN
                DfrStatus := DFR_DRIPPING;
                DfrPerformedCntLog := DfrPerformedCntLog + 1;
            END_IF;

            
        DFR_DRIPPING : //------------- DEFROST DRIPPING STATUS
            
            DfrCompOff := TRUE;
            
            {IF NOT DEF(MPXONE_BASIC)}
            // Multiplexed valves management
            IF multiplexHotGasType THEN
                // Suction solenoid valve for Multiplexed Hot Gas Defrost
                S_VlvOn := FALSE;
                // Equalizing solenoid valve for Multiplexed Hot Gas Defrost
                E_VlvOn := TRUE;
            ELSE
                S_VlvOn := FALSE;
                E_VlvOn := FALSE;
            END_IF;
            {ENDIF}
            
            // Dripping time counter
            MachineTON(IN := TRUE, 
                    PT := TO_TIME(TO_UDINT(DripTime) * 1000 * 60));
                
            IF MachineTON.Q THEN
                DfrStatus := DFR_POST_DRIPPING;
                MachineTON(IN := FALSE, PT := T#10s); // Reset TIMER
            END_IF;
        
        DFR_POST_DRIPPING : //------------- DEFROST POST DRIPPING STATUS
            
            // Restart the cooling
            DfrCompOff := FALSE;
            
            {IF NOT DEF(MPXONE_BASIC)}
            // Multiplexed valves management
            IF multiplexHotGasType THEN
                // Suction solenoid valve for Multiplexed Hot Gas Defrost
                S_VlvOn := TRUE;
                // Equalizing solenoid valve for Multiplexed Hot Gas Defrost
                E_VlvOn := FALSE;
            ELSE
                S_VlvOn := FALSE;
                E_VlvOn := FALSE;
            END_IF;
            {ENDIF}
            
            // POST Dripping time
            MachineTON(IN := TRUE, 
                    PT := TO_TIME(TO_UDINT(PostDripTime) * 1000 * 60));
                
            IF MachineTON.Q THEN
                
                DfrStatus := DFR_IDLE;
                ManDfr := FALSE;
                NetworkDfr := FALSE;
                MachineTON(IN := FALSE, PT := T#10s); // Reset TIMER
                CurrentTBisPow := FALSE;
            END_IF;
        
    END_CASE;
        
    // Force command on slave devices
    //ForceTON(IN := ForceWrite, PT := T#10s);
    //IF ForceWrite THEN
    //    IF isMaster AND NOT DisNetworkDfr AND SlavesNum > 0 THEN
    //        FOR i := 1 TO TO_DINT(SlavesNum) DO
    //            Slaves[i].myCoilStatus[59] := ForceValue; // ManDfr in BMS table
    //        END_FOR;
    //    END_IF;
    //END_IF;
    //IF ForceTON.Q THEN
    //    ForceWrite := FALSE;
    //END_IF;
    
END_PROGRAM

END_NAMESPACE