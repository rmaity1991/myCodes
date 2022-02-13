USING System;
USING System.Math; 
USING System.Timer; 
USING System.Alarm;
USING Libs.Alarm_Mng;
USING Libs.Hysteresis;

VAR_GLOBAL CONSTANT
    {IF NOT DEF(MPXONE_BASIC)}
    (**Global number of available alarms*)
    NUM_ALARMS : USINT := 56;
    (**Global number of available warning*)
    NUM_WARN_STATUS : USINT := 7;
    NUM_PRB_BROKEN : USINT := 8;
    {ELSE}
    (**Global number of available alarms*)
    NUM_ALARMS : USINT := 45;
    (**Global number of available warning*)
    NUM_WARN_STATUS : USINT := 5;
    NUM_PRB_BROKEN : USINT := 3;
    {ENDIF}
END_VAR

VAR_GLOBAL
    ActiveAlm : ARRAY[1..NUM_ALARMS + NUM_WARN_STATUS] OF UINT;
    //LstAlrmReq : ARRAY[1..NUM_ALARMS] OF Alarm_Req;
    Alarms : AlarmsUnion;
END_VAR

NAMESPACE LibraryNamespaceAndVersion

PROGRAM AlarmsMng
    VAR
        CleanLog : AlarmLog;
        //TON_AlrmResetDetect : TON;
        
        AlValue, Al2Value : REAL;
        //Alarm, Alarm2 : MpxAlarmMng;
        
        AlDinDelayTON : TON;
        
        ContCycleTON : TON;
        ContCycleF : F_EDGE;
        
        DfrTON : TON;
        DfrF : F_EDGE;
        
        HACCP_HA_TON : TON;
        
        ResetTON : TON;
        
        HACCP_LogTON : TON;
        
        DoorBypassTON : TON;
        DoorBypassRS : RS;
        
        (**Type HA & HF HACCP alarm*)
    	Al_HA, Al_HF : Alarm_Req := (Info := ( Code := 1, Category := 1));
        
        {IF NOT DEF(MPXONE_BASIC)}
        (**R_TRIG array for generate event log for probe broken and HI/Low tem alarms *)
        R_TRIG_AlarmsToLogEvent : ARRAY[1..8] OF R_TRIG;
        {ELSE}
        R_TRIG_AlarmsToLogEvent : ARRAY[1..5] OF R_TRIG;
        {ENDIF}
        
        HiAlarmThrTemp, HiAlarm2ThrTemp     : REAL;
        LowAlarmThrTemp, LowAlarm2ThrTemp   : REAL;
        
    END_VAR
    
    VAR_TEMP
        i : DINT;
        AlrmWord : WORD;
        //AlarmCodes : ARRAY [1..NUM_ALARMS] OF STRING[3];
        
        FakeReset : BOOL;
        ActiveHAAlarms, ActiveHFAlarms : ARRAY[0..2] OF UINT;
    END_VAR
    
    
    //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
    {REGION TEMPERATURE ALARM}
    
    // Fetch probe values for alarm management
    AlValue := ReadAlarmValue(AlarmPrbConf);
    Al2Value := ReadAlarmValue(Alarm2PrbConf);
    
    // Alarms are enabled?

    // Disable low alarm after continuous cycle
    ContCycleF(In := ManContinuous, Reset := ContCycleTON.Q);
    ContCycleTON(IN := ContCycleF.Out, PT := TO_TIME(TO_DINT(ContCycleLowBypass) * 60 * 1000));
    
    // Disable high alarm during dfr and in configured also after defrost
    DfrF(In := DfrStatus >= DFR_DFR, Reset := DfrTON.Q);
    DfrTON(IN := DfrF.Out, PT := TO_TIME(TO_DINT(DfrHiBypass) * 60 * 1000));
    DfrHiBypassEnd := DfrTON.Q;
    
    // Disable High temperature alarm during door open
    DoorBypassRS(S := DigitalInputs.Fct.DoorOn OR DigitalInputs.Fct.DoorOff, R1 := DoorBypassTON.Q OR NOT DoorBypassRS.S);
    DoorBypassTON(IN := DoorBypassRS.S, PT := TO_TIME(TO_DINT(AlBypassDoor) * 60 * 1000));
    
    IF AbsAlarmThr THEN //If absolute alarm
        HiAlarmThrTemp := HiAlarmThrAbs;     //AHA
        LowAlarmThrTemp := LowAlarmThrAbs;   //ALA
    ELSE
        HiAlarmThrTemp := HiAlarmThr;        //AH
        LowAlarmThrTemp := LowAlarmThr;      //AL
    END_IF;
    
    IF AbsAlarm2Thr THEN
        HiAlarm2ThrTemp := HiAlarm2ThrAbs;   //AHA2
        LowAlarm2ThrTemp := LowAlarm2ThrAbs; //ALA2
    ELSE
        HiAlarm2ThrTemp := HiAlarm2Thr;      //AH2
        LowAlarm2ThrTemp := LowAlarm2Thr;    //AL2
    END_IF;
    
    // Check alarm condition
    TempAlarms[1](Value := AlValue, Setpoint := TempSetP,
        HighThr := HiAlarmThrTemp, LowThr := LowAlarmThrTemp, Diff := AlarmResetDiff,
        Delay := AlarmDelay, Absolute := AbsAlarmThr, Reset := AlrmRes, 
        DisHi := DoorBypassRS.Q1 OR DfrF.Out OR DfrStatus > DFR_IDLE,
        DisLow := ContCycleF.Out, Enable := UnitOn AND (AlarmPrbConf > 0));
    
    TempAlarms[2](Value := Al2Value, Setpoint := TempSetP2,
        HighThr := HiAlarm2ThrTemp, LowThr := LowAlarm2ThrTemp, Diff := AlarmResetDiff,
        Delay := Alarm2Delay, Absolute := AbsAlarm2Thr, Reset := AlrmRes, 
        DisHi := (DoorBypassRS.Q1 OR DfrF.Out OR DfrStatus > DFR_IDLE),
        DisLow := ContCycleF.Out , Enable := UnitOn AND (Alarm2PrbConf > 0));
    
    // Trigger alarms if enabled and not during clean operation
    Alarms.Al.Al_HiTemp.Info.Trigger := TempAlarms[1].AlarmHi AND NOT Alarms.Al.Status_Clean.Info.Active;
    Alarms.Al.Al_LowTemp.Info.Trigger := TempAlarms[1].AlarmLow AND NOT Alarms.Al.Status_Clean.Info.Active;
    Alarms.Al.Al_HiTemp2.Info.Trigger := TempAlarms[2].AlarmHi AND NOT Alarms.Al.Status_Clean.Info.Active;
    Alarms.Al.Al_LowTemp2.Info.Trigger := TempAlarms[2].AlarmLow AND NOT Alarms.Al.Status_Clean.Info.Active;
    
    IF HACCP_AlrmDelay > 0 THEN
        // HACCP Alarm HA, high temperature during the operation
        HACCP_HA_TON(IN := TempAlarms[1].Hi, PT := TO_TIME((TO_DINT(HACCP_AlrmDelay) + TO_DINT(AlarmDelay)) * 60 * 1000));
        Al_HA.Info.Trigger := HACCP_HA_TON.Q;
        Al_HA( AlrmRes := FakeReset,
        	Lst_ActAlrm := ActiveHAAlarms,
        	Lst_LogAlrm := LogHACCP_HA,
        	Lst_LogAlrm_Idx := LogHACCP_HA_Index);
        
        HACCP_CountHA := 0;
        FOR i := LOWER_BOUND(LogHACCP_HA, 1) TO UPPER_BOUND(LogHACCP_HA, 1) DO
            IF LogHACCP_HA[i].Code > 0 THEN
                Alarms.Al.Al_HA.Info.Trigger := TRUE;
                HACCP_CountHA := HACCP_CountHA + 1;
            END_IF;
        END_FOR;
        
        // HACCP Alarm HF, high temperature after power failure (blackout)
        Al_HF.Info.Trigger := HACCP_AlrmDelay > 0 AND BlackoutSR.Q1 AND TempAlarms[1].Hi;
        Al_HF( AlrmRes := FakeReset,
        	Lst_ActAlrm := ActiveHFAlarms,
        	Lst_LogAlrm := LogHACCP_HF,
        	Lst_LogAlrm_Idx := LogHACCP_HF_Index);
        
        HACCP_CountHF := 0;
        FOR i := LOWER_BOUND(LogHACCP_HF, 1) TO UPPER_BOUND(LogHACCP_HF, 1) DO
            IF LogHACCP_HF[i].Code > 0 THEN
                Alarms.Al.Al_HF.Info.Trigger := TRUE;
                HACCP_CountHF := HACCP_CountHF + 1;
            END_IF;
        END_FOR;
        
    ELSE
        Alarms.Al.Al_HA.Info.Trigger := FALSE;
        Alarms.Al.Al_HF.Info.Trigger := FALSE;
        
        // Clear Logs
        LogHACCP_HA_Index := 0;
        LogHACCP_HF_Index := 0;
        FOR i := 1 TO TO_DINT(UPPER_BOUND(LogHACCP_HA, 1)) DO
            LogHACCP_HA[i] := CleanLog;
            LogHACCP_HF[i] := CleanLog;
        END_FOR;
    END_IF;
    
    // Wizard alarm inhibition
    IF NOT WizDone THEN
        FOR i := LOWER_BOUND(Alarms.Arr, 1) TO UPPER_BOUND(Alarms.Arr, 1) DO
            Alarms.Arr[i].Info.Trigger := FALSE;
            Alarms.Arr[i].Info.Active := FALSE;
        END_FOR;
    END_IF;
    
    // HACCP Log save
    HACCP_LogTON(IN := NOT HACCP_LogTON.Q, PT := HACCP_Period);
    IF HACCP_LogTON.Q THEN
        HACCP_LogBuffer[HACCP_LogIndex] := AlValue;
        
        HACCP_LogIndex := HACCP_LogIndex + 1;
        IF HACCP_LogIndex > TO_USINT(UPPER_BOUND(HACCP_LogBuffer,1)) THEN
            HACCP_LogIndex := TO_USINT(LOWER_BOUND(HACCP_LogBuffer, 1));
        END_IF;
    END_IF;
    
    {ENDREGION}
    
    {REGION DIGITAL INPUT ALARMS}
    // Immediate alarm (DIN)
    Alarms.Al.AlExtDin.Info.Trigger := DigitalInputs.Fct.Alarm;
    
    // Delayed alarm (DIN)
    AlDinDelayTON(IN := DigitalInputs.Fct.DelayedAl, PT := TO_TIME( TO_DINT(AlDinDelay) * 60 * 1000));
    Alarms.Al.AlDelayExtDin.Info.Trigger := AlDinDelayTON.Q;
    {ENDREGION}
    
    {REGION ALARM REQUEST}

    // Config probe broken alarms
    {IF NOT DEF(MPXONE_BASIC)}
    FOR i := 1 TO TO_DINT(MAX_AIN_ADVANCED) DO
        Alarms.Al.Al_PrbBroken[i].StrCode := ' E' + TO_STRING(i);
        Alarms.Al.Al_PrbBroken[i].Info.Category := PRB_ALARMS_TYPE;
    END_FOR;
    {ELSE}
    FOR i := 1 TO TO_DINT(MAX_AIN_BASIC) DO
        Alarms.Al.Al_PrbBroken[i].StrCode := ' E' + TO_STRING(i);
        Alarms.Al.Al_PrbBroken[i].Info.Category := PRB_ALARMS_TYPE;
    END_FOR;
    {ENDIF}
    
    // Serial probe alarms
    FOR i := 1 TO 4 DO
        Alarms.Al.Al_SerialInputs[i].StrCode := 'E1' + TO_STRING(i);
        Alarms.Al.Al_SerialInputs[i].Info.Category := PRB_ALARMS_TYPE;
    END_FOR;
    
    // Loop all the alarm array
    FOR i := LOWER_BOUND(Alarms.Arr, 1) TO UPPER_BOUND(Alarms.Arr, 1) DO
        Alarms.Arr[i].Info.Code := TO_UINT(i);
        Alarms.Arr[i](
            //StrCode := AlarmCodes[i],   // Insert the alarm code to display in mask
        	AlrmRes := AlrmRes,
        	Lst_ActAlrm := ActiveAlm,
        	Lst_LogAlrm := LogAlarms,
        	Lst_LogAlrm_Idx := LogAlrmIdx);
    END_FOR;
    
    // Alarm for slave devices when master is not polling
    MasterOnlineTON(IN := TRUE AND NOT IsDebuggerPresent(), PT := T#60s);
    Alarms.Al.Al_MA.Info.Trigger := MasterOnlineTON.Q AND NOT isMaster;
    
    // Loop the Communication error with Slave (only on Master) alarms
    FOR i := 1 TO TO_DINT(Libs.SPV_Gateway_HPX.MAX_SLAVES) DO
        Alarms.Al.Al_u[i].StrCode := 'u' + TO_STRING(i);
        Alarms.Al.Al_u[i].Info.Category := REG_ALARMS_TYPE;
        Alarms.Al.Al_u[i].Info.Trigger := NOT Slaves[i].Info.IsOnline AND SlavesNum >= TO_USINT(i) AND isMaster;
    END_FOR;
    
    // Loop the Alarm on unit 1 to 9 in the network
    FOR i := 1 TO TO_DINT(Libs.SPV_Gateway_HPX.MAX_SLAVES) DO
        Alarms.Al.Al_n[i].StrCode := 'n' + TO_STRING(i);
        IF SlaveAlarmCheck THEN
            Alarms.Al.Al_n[i].Info.Category := REG_ALARMS_TYPE;
        ELSE
            Alarms.Al.Al_n[i].Info.Category := 0;
        END_IF;
            // chech "OrAlrm" on Slaves
        {IF NOT DEF(MPXONE_BASIC)}
        Alarms.Al.Al_n[i].Info.Trigger := Slaves[i].Info.IsOnline AND Slaves[i].myInputStatus[67] AND SlavesNum >= TO_USINT(i) AND isMaster; 
        {ELSE}
        Alarms.Al.Al_n[i].Info.Trigger := Slaves[i].Info.IsOnline AND Slaves[i].myInputStatus[055] AND SlavesNum >= TO_USINT(i) AND isMaster;
        {ENDIF}
    END_FOR;
    
    // Generic alarms
    Alarms.Al.Al_GHI_1.Info.Trigger := GenFctAlarm_Out[1].Hi;
    Alarms.Al.Al_GLO_1.Info.Trigger := GenFctAlarm_Out[1].Low;
    
    //Power failure alalrm
    {IF DEF (MPXONE_ADVANCED)}
    Alarms.Al.Al_Ultracap_EEV.Info.Trigger := PwrSupplyFailure;
    {ENDIF}
    
    {ENDREGION}
    
    {REGION CLEAR ALARMS LOG}
    IF LogAlrmRes THEN 
        LogAlrmRes := FALSE; 
        (*restart log*)
        LogAlrmIdx := 0; 
        (*clear log list*)
        FOR i := 1 TO TO_DINT(UPPER_BOUND(LogAlarms, 1)) DO
            LogAlarms[i] := CleanLog;
        END_FOR;
    END_IF;
    {ENDREGION}
    
    {REGION ALARMS COUNT}
    AlrmWord := Alarm_Mng(ActiveAlm);
    OrWarning := AlrmWord.3;
    OrAlrm := AlrmWord.0 OR AlrmWord.1 OR AlrmWord.2;
    OrStatus := AlrmWord.4;
    OrPrbAlrm := AlrmWord.1;
    OrSeriousAlrm := FALSE;// AlrmWord.2; Set to FALSE because all the alarms have automatic reset 
    
    (*COUNT TOTAL ALARM AND WARNING ACTIVE*)
    TotActAlm := 0;
    TotActWarning := 0;
    TotActStatus := 0;
    FOR i := LOWER_BOUND(ActiveAlm,1) TO TO_DINT(UPPER_BOUND(ActiveAlm, 1)) DO
        //IF ActiveAlm[i] >= CAT_ALARM THEN 
        IF ActiveAlm[i] > 0 AND ActiveAlm[i] < REG_WARNINGS_TYPE THEN
            TotActAlm := TotActAlm + 1;
        END_IF;
        IF ActiveAlm[i] > 0 AND ActiveAlm[i] = REG_WARNINGS_TYPE THEN
            TotActWarning := TotActWarning + 1;
        END_IF;
        IF ActiveAlm[i] > 0 AND ActiveAlm[i] = REG_STATUS_TYPE THEN
            TotActStatus := TotActStatus + 1;
        END_IF;
    END_FOR;
    {ENDREGION}
    
    // On alarm reset keep it to TRUE for 3 seconds
    ResetTON(IN := AlrmRes, PT := T#3s);
    IF ResetTON.Q THEN
        AlrmRes := FALSE;
    END_IF;
    
    // During startup wizard and reset keep alarms output off
    IF NOT WizDone OR StartupReset OR firstCycle THEN
        OrWarning := FALSE;
        OrAlrm := FALSE;
        OrStatus := FALSE;
        TotActAlm := 0;
        TotActWarning := 0;
        TotActStatus := 0;
    END_IF;
    
    R_TRIG_AlarmsToLogEvent[1](CLK := Alarms.Al.Al_PrbBroken[1].Info.Trigger);
    R_TRIG_AlarmsToLogEvent[2](CLK := Alarms.Al.Al_PrbBroken[2].Info.Trigger);
    R_TRIG_AlarmsToLogEvent[3](CLK := Alarms.Al.Al_PrbBroken[3].Info.Trigger);
    {IF NOT DEF(MPXONE_BASIC)}
    R_TRIG_AlarmsToLogEvent[4](CLK := Alarms.Al.Al_PrbBroken[4].Info.Trigger);
    R_TRIG_AlarmsToLogEvent[5](CLK := Alarms.Al.Al_PrbBroken[5].Info.Trigger);
    R_TRIG_AlarmsToLogEvent[6](CLK := Alarms.Al.Al_PrbBroken[6].Info.Trigger);
    R_TRIG_AlarmsToLogEvent[7](CLK := Alarms.Al.Al_HiTemp.Info.Trigger);
    R_TRIG_AlarmsToLogEvent[8](CLK := Alarms.Al.Al_LowTemp.Info.Trigger);
    {ELSE}
    R_TRIG_AlarmsToLogEvent[4](CLK := Alarms.Al.Al_HiTemp.Info.Trigger);
    R_TRIG_AlarmsToLogEvent[5](CLK := Alarms.Al.Al_LowTemp.Info.Trigger);
    {ENDIF}
    
    FOR i := LOWER_BOUND(R_TRIG_AlarmsToLogEvent,1) TO UPPER_BOUND(R_TRIG_AlarmsToLogEvent,1) DO
        IF R_TRIG_AlarmsToLogEvent[i].Q THEN
            LogsEventsCounter := LogsEventsCounter + 1;
            IF DfrPerformedCntLog <> DfrPerformedCntLog_prev THEN
                DfrPerformedCntLog_prev := DfrPerformedCntLog;
                DfrPerformed := TRUE;
            ELSE
                DfrPerformed := FALSE;
            END_IF;
            EXIT;
        END_IF;
    END_FOR;
        
END_PROGRAM

FUNCTION_BLOCK MpxAlarmMng
    VAR_INPUT
        Value, Setpoint : REAL;
        HighThr, LowThr, Diff : REAL;
        
        Delay : USINT;
        Absolute : BOOL;
        Reset : BOOL;
        (** Disable high temperature alarm*)
        DisHi : BOOL;
        (** Disable low temperature alarm*)
        DisLow : BOOL;
        
        (** Global enable *)
        Enable : BOOL;
    END_VAR
    
    VAR_OUTPUT
        AlarmHi, AlarmLow : BOOL;
        Hi, Low : BOOL;
    END_VAR
    
    VAR
        HighHYST, LowHYST : HysterAdv;
        HighTON, LowTON : TON_PAUSE;
    END_VAR
    
    VAR_TEMP
        DisableHi, DisableLow : BOOL := FALSE;
    END_VAR;
    
    IF Enable THEN
    
        // Alarm disable in case of wrong input value
        IF Absolute THEN
            DisableHi := HighThr > 49.9 AND HighThr < 50.1;
            DisableLow := LowThr > -49.9 AND LowThr < -50.1;
        ELSE
            DisableHi := HighThr > -0.1 AND HighThr < 0.1;
            DisableLow := LowThr > -0.1 AND LowThr < 0.1;
        END_IF;
        
        // Alarm conditions
        IF Absolute THEN
//            HighHYST(In := Value, Left := HighThr - Diff, Right := HighThr, Reverse := FALSE);
            HighHYST(In := Value, SetP := HighThr, DiffLeft := Diff, DiffRight := 0.0, Reverse := FALSE);
//            LowHYST(In := Value, Left := LowThr, Right := LowThr + Diff, Reverse := TRUE);
            LowHYST(In := Value, SetP := LowThr, DiffLeft := 0.0, DiffRight := Diff, Reverse := TRUE);
        ELSE
//            HighHYST(In := Value, Left := HighThr - Diff + Setpoint, Right := HighThr + Setpoint, Reverse := FALSE);
            HighHYST(In := Value, SetP := HighThr + Setpoint, DiffLeft := Diff, DiffRight := 0.0, Reverse := FALSE);
//            LowHYST(In := Value, Left := Setpoint - LowThr, Right := Setpoint - LowThr + Diff, Reverse := TRUE);
            LowHYST(In := Value, SetP := Setpoint - LowThr, DiffLeft := 0.0, DiffRight := Diff, Reverse := TRUE);
        END_IF;
        
        // Alarm logic based on TON with the possibility of pause counter
        Hi := HighHYST.Out AND NOT DisableHi;
        Low := LowHYST.Out AND NOT DisableLow;
        
        
        // Alarm delay
        HighTON(IN := Hi AND NOT Reset/* AND NOT DisableHi*/, PAUSE := DisHi, PT := TO_TIME(TO_UDINT(Delay) * 60 * 1000));
        LowTON(IN := Low AND NOT Reset/* AND NOT DisableLow*/, PAUSE := DisLow, PT := TO_TIME(TO_UDINT(Delay) * 60 * 1000));
        
        // Alarm outut
        AlarmHi := HighTON.Q;
        AlarmLow := LowTON.Q;
    ELSE
        // Reset counters
        HighTON(IN := FALSE, PAUSE := FALSE, PT := TO_TIME(TO_UDINT(Delay) * 60 * 1000));
        LowTON(IN := FALSE, PAUSE := FALSE, PT := TO_TIME(TO_UDINT(Delay) * 60 * 1000));
        
        // Alarm output
        AlarmHi := HighTON.Q;
        AlarmLow := LowTON.Q;
    END_IF;
    
END_FUNCTION_BLOCK

FUNCTION ReadAlarmValue : REAL
    VAR_INPUT
        config : USINT;
    END_VAR
    // Default value
    ReadAlarmValue := 0;
    
    // Bound check
    IF config < TO_USINT(LOWER_BOUND(RegValues, 1)) OR 
        config > TO_USINT(UPPER_BOUND(RegValues, 1)) THEN
        RETURN;
    END_IF;
    
    ReadAlarmValue := RegValues[config];
    
END_FUNCTION

(**
 *              TON_PAUSE - On-delay timing - state machine.
 *
 * Timer on delay supplies the input value IN at Q with a time delay when
 * a rising edge is detected at IN.
 * If input IN is only '1' for a short pulse(shorter than PT),
 * the timer is not started for this edge.
 * 
 * @example
 *             +--------+        +---+   +-----------+
 *        IN   |        |        |   |   |           |
 *           --+        +--------+   +---+           +-------------
 *             t0       t1       t2  t3  t4          t7
 *                                          +--+
 *     PAUSE                                |  |
 *           -------------------------------+  +----------------
 *             t0       t1       t2  t3  t4 t5 t6
 *                  +---+                        +---+
 *        Q         |   |                        |   |
 *           -------+   +------------------------+   +-------------
 *               t0+PT  t1            t4+PT-(t6-t5)   t7
 *          PT      +---+                        +---+
 *           :     /    |            +          /    |
 *        ET :    /     |           /|      +--+     |
 *           :   /      |          / |     /         |
 *           :  /       |         /  |    /          |
 *           0-+        +--------+   +---+           +-------------
 *             t0       t1       t2  t3  t4          t7
 * 
 * 
 *         2        +---+                     +---+
 * STATE   1   +----+   |        +---+   +----+   |
 *         0 --+        +--------+   +---+        +------
 *)
FUNCTION_BLOCK TON_PAUSE
    VAR_INPUT
        (** Input variable of which to detect rising edge. *)
        IN : BOOL;  
        (** Preset value (ms), duration of impulse Q. *)
        PT : TIME;
        (** Input variable to pause counter *)
        PAUSE : BOOL;
    END_VAR
    VAR_OUTPUT
        (** Impluse, his value become high if IN value is high at least for PT ms. *)
        Q : BOOL := FALSE;  
        (** Current value of time (ms). *)
        ET : TIME := T#0s;  
    END_VAR

    VAR
        MEM : UDINT;
        OLD_IN : BOOL;
        NORMA_CYCLE : BOOL;
    END_VAR

    IF NOT OLD_IN AND IN THEN
        Q := FALSE;
        MEM := GetSystemTime();
        ET := TO_TIME(0);
        NORMA_CYCLE := TRUE;
    END_IF;

    IF NORMA_CYCLE AND NOT PAUSE THEN 
        IF ET < PT THEN
            ET := TO_TIME(GetSystemTime() - MEM);
        ELSE 
            ET := PT;
            Q := TRUE;
        END_IF;
    END_IF;
    
    IF NORMA_CYCLE AND PAUSE THEN 
        MEM := GetSystemTime() - TO_UDINT(ET);
    END_IF;

    IF OLD_IN AND NOT IN THEN            
        Q := FALSE;
        ET := TO_TIME(0);
        NORMA_CYCLE := FALSE;   
    END_IF;
    OLD_IN := IN;
END_FUNCTION_BLOCK
    
END_NAMESPACE
