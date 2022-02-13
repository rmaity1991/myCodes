USING System.IO;
USING Libs.CustomGas;
USING System;
USING System.Timer;
USING System.Math;
USING Libs.Gas_GetCoeff;
USING Libs.Thermodynamic;
USING Libs.IOMng_Basic;

NAMESPACE LibraryNamespaceAndVersion
    
PROGRAM InputsMng
    VAR
        firstCycle_Local : BOOL := TRUE;
        
        TON_SerialBackup : TON;
        TON_SerialTimeout : ARRAY [1..4] OF TON;
        
        //Al_PrbBroken : ARRAY [1..PRB_NUM] OF Alarm.AlarmInfo;
        Al_SerialInputs : ARRAY [1..SER_AIN] OF Alarm.AlarmInfo;
        
        Sint : REAL;
        
        Simulation: ARRAY [1..MAX_AIN] OF PrbSimulation;
        F_TRIG_Simulation : F_TRIG;
        //SimVal : ARRAY [1..MAX_AIN] OF REAL;
        {IF NOT DEF(MPXONE_BASIC)}
        Coeff_PressToTemp : ARRAY[1..6] OF REAL;
        {ENDIF}
        
        EvapPBroken : BOOL := FALSE;
        
    END_VAR
    
    VAR_TEMP
        i : DINT;
        SerialAinIsUsed : ARRAY[1..4] OF BOOL;
        Ain_Max         : AinUnion;
        Ain_Min         : AinUnion;
        AinGroupCfg_arr : ARRAY [1..5]   OF MPX_AinGroupCfg;
    END_VAR
    
        //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
    {REGION PARAMETERS_TO_ARRAYS}
    IF NOT powerUp THEN
        //Reset probe settings
        FOR i := 1 TO TO_DINT(MAX_AIN_CH) DO
            uConfig[i].filter       := 5;
            uConfig[i].mode_sel     := LIB_IO_PIN_NOT_CONFIGURED;
            uConfig[i].mode_type    := LIB_IO_PROBE_NO_CONN;
        END_FOR;    
    END_IF;    
    {ENDREGION }
    
    {REGION START_UP_INPUT}
    IF firstCycle_Local THEN
        REPEATerConfig.CommandDelay := 2;
        REPEATerConfig.DetectionTimeOut := 500;
        REPEATerConfig.TimeOut := 500;
        
        (*this procedure is done every on*)
        firstCycle_Local := FALSE;
    END_IF;
    {ENDREGION }
    
    {REGION I/O configuration}
    // Convert active probe limits to union
    Ain_Max.Fct.EvapP := EvapMax;
    Ain_Min.Fct.EvapP := EvapMin;
    Ain_Max.Fct.AmbientH    := AmbHMax;
    Ain_Min.Fct.AmbientH    := AmbHMin;
    
    //Assign Probe group types
    AinGroupCfg_arr[1].ModeType := GetChannelType(Ain_Types.Group1);
{IF NOT DEF(MPXONE_BASIC)}    
    AinGroupCfg_arr[2].ModeType := GetChannelType(Ain_Types.Group2);
    AinGroupCfg_arr[3].ModeType := GetChannelType(Ain_Types.Group3);
{ENDIF}    
    {IF DEF(MPXONE_ADVANCED)}
    AinGroupCfg_arr[4].ModeType := GetChannelType(Ain_Types.Group4);
    AinGroupCfg_arr[5].ModeType := GetChannelType(Ain_Types.Group5);
    {ENDIF}
    
    //Set probe stability
    AinGroupCfg_arr[1].Filter := MAX(TO_USINT(TO_LREAL(AinStability) / 1.5), 1);
    AinGroupCfg_arr[2].Filter := MAX(TO_USINT(TO_LREAL(AinStability) / 1.5), 1);
    AinGroupCfg_arr[3].Filter := MAX(TO_USINT(TO_LREAL(AinStability) / 1.5), 1);

    FOR i := LOWER_BOUND(Ain_Cfg.Arr,1) TO UPPER_BOUND(Ain_Cfg.Arr,1) DO
        CASE Ain_Cfg.Arr[i].Ch OF
            0:
                Ain_Cfg.Arr[i].ModeType := Libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_NO_CONN;
                Ain_Cfg.Arr[i].Filter := 9;
            1,2,3:
                Ain_Cfg.Arr[i].ModeType := AinGroupCfg_arr[1].ModeType;
                Ain_Cfg.Arr[i].Filter := AinGroupCfg_arr[1].Filter;
            4,5:
                Ain_Cfg.Arr[i].ModeType := AinGroupCfg_arr[2].ModeType;
                Ain_Cfg.Arr[i].Filter := AinGroupCfg_arr[2].Filter;
            6:
                Ain_Cfg.Arr[i].ModeType := AinGroupCfg_arr[3].ModeType;
                Ain_Cfg.Arr[i].Filter := AinGroupCfg_arr[3].Filter;
            {IF DEF(MPXONE_ADVANCED)}
            7:
                Ain_Cfg.Arr[i].ModeType := AinGroupCfg_arr[4].ModeType;
                Ain_Cfg.Arr[i].Filter := AinGroupCfg_arr[4].Filter;
            8:
                Ain_Cfg.Arr[i].ModeType := AinGroupCfg_arr[5].ModeType;
                Ain_Cfg.Arr[i].Filter := AinGroupCfg_arr[5].Filter;
            {ENDIF}
        END_CASE;
        
        Ain_Cfg.Arr[i].Enable := Ain_Cfg.Arr[i].Ch <> 0;
        Ain_Cfg.Arr[i].AlrmDT := 0;//10; replace when new LibIO_mng will be ready 28/09/2020
        
    END_FOR;
    
    FOR i := LOWER_BOUND(Din_Cfg.Arr,1) TO UPPER_BOUND(Din_Cfg.Arr,1) DO
        Din_Cfg.Arr[i].Enable := Din_Cfg.Arr[i].Ch <> 0; 
    END_FOR; 
    
    FOR i := LOWER_BOUND(Dout_Cfg.Arr,1) TO UPPER_BOUND(Dout_Cfg.Arr,1) DO
            DOut_Cfg.Arr[i].Enable := DOut_Cfg.Arr[i].Ch <> 0; 
    END_FOR; 
    {ENDREGION}
    
    {REGION Ain simulated values}
    // Calc simulation data
    F_TRIG_Simulation(CLK := SimulateMode);
    
    IF SimulateMode THEN
        FOR i := LOWER_BOUND(Simulation, 1) TO UPPER_BOUND(Simulation, 1) DO
            Simulation[i].Config(SimMin[i], SimMax[i], SimPeriod[i]);
            virtU[i] := TRUE;
            U[i].r := Simulation[i].Run();
        END_FOR;
    END_IF;
    IF F_TRIG_Simulation.Q THEN
        FOR i := LOWER_BOUND(virtU, 1) TO UPPER_BOUND(virtU, 1) DO
            virtU[i] := FALSE;
        END_FOR;
    END_IF;
    {ENDREGION}

    {REGION PROBE_READING}
    // Clear alarms for unused input
    FOR i := LOWER_BOUND(Alarms.Al.Al_PrbBroken, 1) TO UPPER_BOUND(Alarms.Al.Al_PrbBroken, 1) DO
        Alarms.Al.Al_PrbBroken[i].Info.Trigger := FALSE;
    END_FOR;
    
    IO_mng.Read(
        0,
        ID,
        U,
        Din_Cfg.Arr,
        Ain_Cfg.Arr,
        Ain_Max.Arr,
        Ain_Min.Arr,
        Ain_offset.arr,
        DigitalInputs.Arr,
        Din_Err.Arr,
        AnalogInputs.Arr,
        Ain_Err.Arr,
        uConfig
        );

            // serial probe --------------------------------------------------
    FOR i :=1 TO UPPER_BOUND(Ain_Cfg.Arr,1) DO
        IF Ain_Cfg.Arr[i].Ch < 0 AND Ain_Cfg.Arr[i].Ch >= -4  THEN
            AnalogInputs.Arr[i] := SerialInputs[-Ain_Cfg.Arr[i].Ch].r;
            SerialAinIsUsed[- Ain_Cfg.Arr[i].Ch] := TRUE;
        END_IF;
    END_FOR;
    
    // Loop all AIN function block
    FOR i := LOWER_BOUND(AnalogInputs.Arr, 1) TO UPPER_BOUND(AnalogInputs.Arr, 1) DO        
        IF TO_DINT(Ain_Cfg.Arr[i].Ch) >= LOWER_BOUND(Alarms.Al.Al_PrbBroken, 1) AND TO_DINT(Ain_Cfg.Arr[i].Ch) <= UPPER_BOUND(Alarms.Al.Al_PrbBroken, 1) THEN
            Alarms.Al.Al_PrbBroken[Ain_Cfg.Arr[i].Ch].Info.Trigger := Ain_Err.Arr[i].Trigger;
        END_IF;
    END_FOR;
    
    //Pressure probe alarm management during defrost [d12]
    IF (DfrStatus > DFR_IDLE AND DfrStatus < DFR_POST_DRIPPING) AND
        (Ain_Cfg.Fct.EvapP.Ch > 0 AND TO_DINT(Ain_Cfg.Fct.EvapP.Ch) <= UPPER_BOUND(Alarms.Al.Al_PrbBroken, 1)) THEN
        Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.EvapP.Ch].Info.Trigger := Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.EvapP.Ch].Info.Trigger AND (DfrPrbAlm <> 0 AND DfrPrbAlm <> 2);
    END_IF;
    
{IF NOT DEF(MPXONE_BASIC)}
    //ONLY FOR DATA LOG PURPOSE
    IF ((Ain_Cfg.Fct.EvapP.ch >= 1 AND Ain_Cfg.Fct.EvapP.ch <= 3) AND Ain_Types.Group1 = 1) OR
        ((Ain_Cfg.Fct.EvapP.ch >= 4 AND Ain_Cfg.Fct.EvapP.ch <= 5) AND Ain_Types.Group2 = 1) OR    
        (Ain_Cfg.Fct.EvapP.ch = 6 AND Ain_Types.Group3 = 1) THEN
        
        EvapTempNTC_Log := AnalogInputs.Fct.EvapP;
        AnalogInputs.Fct.EvapP := 0.0;
    END_IF;
{ENDIF}
    {ENDREGION }
    
    {REGION UPDATE SLAVES PROBE}
    IF isMaster THEN
        FOR i := 1 TO TO_DINT(SlavesNum) DO
            {IF NOT DEF(MPXONE_BASIC)}
            Slaves[i].myHoldingRegisters[213] := TO_UINT(EvapSatTemp * 10.0);
            Slaves[i].myHoldingRegisters[214] := TO_UINT(AnalogInputs.Fct.EvapP * 10.0);
            Slaves[i].myHoldingRegisters[215] := TO_UINT(AnalogInputs.Fct.AmbientH * 10.0);
            Slaves[i].myHoldingRegisters[216] := TO_UINT(AnalogInputs.Fct.AmbientT * 10.0);
            Slaves[i].myHoldingRegisters[217] := TO_UINT(AnalogInputs.Fct.DewPoint * 10.0);
            {ELSE}
            Slaves[i].myHoldingRegisters[017] := TO_UINT(AnalogInputs.Fct.AmbientH * 10.0);
            Slaves[i].myHoldingRegisters[016] := TO_UINT(AnalogInputs.Fct.AmbientT * 10.0);
            Slaves[i].myHoldingRegisters[018] := TO_UINT(AnalogInputs.Fct.DewPoint * 10.0);            
            {ENDIF}
        END_FOR;
    ELSE
        // For unconfigured probe on slave take value from master
        {IF NOT DEF(MPXONE_BASIC)}
        IF Ain_Cfg.Fct.EvapP.Ch = 0 THEN AnalogInputs.Fct.EvapP := MstEvapP; EvapSatTemp := MstEvapSatTemp; END_IF;
        {ELSE}
        IF Ain_Cfg.Fct.EvapP.Ch = 0 THEN (*AnalogInputs.Fct.EvapP := MstEvapP;*) EvapSatTemp := MstEvapSatTemp; END_IF;
        {ENDIF}
        IF Ain_Cfg.Fct.AmbientH.Ch = 0 THEN AnalogInputs.Fct.AmbientH := MstAmbientH; END_IF;
        IF Ain_Cfg.Fct.AmbientT.Ch = 0 THEN AnalogInputs.Fct.AmbientT := MstAmbientT; END_IF;
        IF Ain_Cfg.Fct.DewPoint.Ch = 0 THEN AnalogInputs.Fct.DewPoint := MstDewPoint; END_IF;
        
    END_IF;
    {ENDREGION}
    
    {REGION LOCAL_CONVERSION}
    // Local DewPoint conversion
    IF  NOT (Ain_Cfg.Fct.DewPoint.ch > 0) AND isMaster AND Ain_Cfg.Fct.AmbientT.ch <> 0 AND Ain_Cfg.Fct.AmbientH.ch <> 0 THEN
        IF AnalogInputs.Fct.AmbientT + 273.15 >0 THEN //èrotyect from negativbe logatithm
            AnalogInputs.Fct.DewPoint := DewPoint(AnalogInputs.Fct.AmbientT, AnalogInputs.Fct.AmbientH);
        END_IF;
    END_IF;
    
    // Glass probe estimate
    IF NOT (Ain_Cfg.Fct.GlassT.ch <> 0) THEN
        Sint := (AnalogInputs.Fct.AirOff * (100.0 - TO_REAL(GlassEstimComp)) + AnalogInputs.Fct.AirOn * TO_REAL(GlassEstimComp)) / 100;
        AnalogInputs.Fct.GlassT := (AnalogInputs.Fct.AmbientT - GlassTEstimateA) - (TO_REAL(GlassTEstimateB) / 100.0) * 
            ((AnalogInputs.Fct.AmbientT - GlassTEstimateA) - Sint);
    END_IF;
    
    {IF NOT DEF(MPXONE_BASIC)}
    // Saturated temperature conversion
    IF RfrgTyp > 0 THEN
        Coeff_PressToTemp := GetCoeff_PressToTemp(TO_USINT(RfrgTyp - 1), ENUM_GAS_STATE#Dew);
        Alarms.Al.Al_GPE.Info.Active := FALSE;
    ELSE
        Alarms.Al.Al_GPE.Info.Active := NOT CheckCRC(CustomGasCoeff);
        Coeff_PressToTemp := ExtGasCoeff(CustomGasCoeff);
    END_IF;
    //Warning if no suction pressure probe configured
    Alarms.Al.Warn_SuctP_Prb.Info.Trigger := (ValveCnf = 1 OR ValveCnf = 2) AND Ain_Cfg.Fct.EvapP.ch = 0 AND isMaster;
    {ENDIF}
    
     // Suction pressure probe control lookup
    IF Ain_Cfg.Fct.EvapP.ch > 0 AND Ain_Cfg.Fct.EvapP.ch <= TO_SINT(MAX_AIN_CH) THEN
        EvapPBroken := Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.EvapP.ch].Info.Active;
    ELSIF Ain_Cfg.Fct.EvapP.ch < 0 AND Ain_Cfg.Fct.EvapP.ch >= -4 THEN
        EvapPBroken := Alarms.Al.Al_SerialInputs[-Ain_Cfg.Fct.EvapP.ch].Info.Active;    
    ELSE
        // Probe not configured
        EvapPBroken := FALSE;
    END_IF;
    
    // Suction temperature probe control lookup
    IF Ain_Cfg.Fct.SuctT.ch > 0 AND Ain_Cfg.Fct.SuctT.ch <= TO_SINT(MAX_AIN_CH) THEN
        SuctTBroken := Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.SuctT.ch].Info.Active;
    ELSIF Ain_Cfg.Fct.SuctT.ch < 0 AND Ain_Cfg.Fct.SuctT.ch >= -4 THEN
        SuctTBroken := Alarms.Al.Al_SerialInputs[-Ain_Cfg.Fct.SuctT.ch].Info.Active;
    ELSE
        // Probe not configured
        SuctTBroken := FALSE;
    END_IF;
    
    //Backup value (P15) is used when: unit is master and the suctP probe is not configured or in alarm
    //                                 unit is slave suctP probe is not configured and communication is lost with master
    //                                 unit is slave suctP probe is not configured and suctP value is less or equal to zero (probe in alarm or not configured on master)
    //                                 unit is slave suctP probe IS configured locally and suctP probe is in alarm 
    {IF NOT DEF(MPXONE_BASIC)}
    IF (IsMaster AND (Ain_Cfg.Fct.EvapP.ch = 0 OR EvapPBroken)) OR 
        (Alarms.Al.Al_MA.Info.Active AND (Ain_Cfg.Fct.EvapP.ch = 0)) OR
        (NOT isMaster AND (Ain_Cfg.Fct.EvapP.ch = 0 AND AnalogInputs.Fct.EvapP <= 0) OR 
                          (NOT (Ain_Cfg.Fct.EvapP.ch = 0) AND EvapPBroken)) THEN
        
        IF ValveCnf <> 6 THEN
            EvapSatTemp := ExvSatTempBackup;
        END_IF;        
        
    ELSE
        EvapSatTemp := PressToTemp(AnalogInputs.Fct.EvapP, Coeff_PressToTemp) + EvapOffset;
    END_IF;
    {ENDIF}
    
    //tGS value in case of Suct Temp on Evd driver (ValveCnf = 6)
    {IF NOT DEF(MPXONE_BASIC)}
    IF ValveCnf = 6 THEN // P1 parameter
       AnalogInputs.Fct.SuctT := MachineVars.SH_vars.SuctionTemperature;
        AnalogInputs.Fct.EvapP := EVD_EvapP;
    END_IF;        
    {ENDIF}
    
    // Copy all the values in common array for UI and Alarms
    FOR i := LOWER_BOUND(AnalogInputs.Arr, 1) TO UPPER_BOUND(AnalogInputs.Arr, 1) DO
        RegValues[i] := AnalogInputs.Arr[i];
    END_FOR;
    // Add the other value useful
    RegValues[AIN_NUM + 1] := VirtualProbe;
    RegValues[AIN_NUM + 2] := EvapSatTemp;
    {IF NOT DEF(MPXONE_BASIC)}
    RegValues[AIN_NUM + 3] := ActualSH;
    RegValues[AIN_NUM + 4] := TO_REAL(ExvVlvPosition);
    {ELIF NOT DEF(MPXONE_MEDIUM)}
    RegValues[AIN_NUM + 3] := 0.0;
    RegValues[AIN_NUM + 4] := 0.0;
    {ENDIF}
    RegValues[AIN_NUM + 5] := FansReq;
    RegValues[AIN_NUM + 6] := TO_REAL(HeatersOut);
    // !! TO ADD MORE VALUES INCREASE THE "EXTRA_VALUES" DEFINE VALUE !!
    
    {ENDREGION }
    
    {REGION DIGITAL_INPUT}    
    // Virtual Digital Input
    FOR i := LOWER_BOUND(DigitalInputs.Arr, 1) TO UPPER_BOUND(DigitalInputs.Arr, 1) DO
        IF Din_Cfg.Arr[i].Ch = -1 THEN
            DigitalInputs.Arr[i] := VirtualDI;
        END_IF;
    END_FOR;
    
    // Digital input propagation from master to slave
    IF isMaster AND VirtualDiOut <> 0 THEN
        // set VirtualDI
        FOR i := 1 TO TO_DINT(SlavesNum) DO
            {IF NOT DEF(MPXONE_BASIC)}
            CASE VirtualDiOut OF
                -1 : Slaves[i].myCoilStatus[76] := VirtualDI;
                1..5 : Slaves[i].myCoilStatus[76] := ID[VirtualDiOut];
            END_CASE;
            {ELSE}
            CASE VirtualDiOut OF
                -1 : Slaves[i].myCoilStatus[068] := VirtualDI;
                1..5 : Slaves[i].myCoilStatus[068] := ID[VirtualDiOut];
            END_CASE;
            {ENDIF}
            
        END_FOR;
    END_IF;
    
    {ENDREGION}
    
    {REGION SERIAL_PROBE_BACKUP}
    // Restore at startup
    IF firstCycle_Local THEN
        SerialInputs := BakSerialInputs;
    END_IF;
    
    // Save every 30 minutes
    TON_SerialBackup( 
        IN := NOT TON_SerialBackup.Q,
        PT := T#30m
        );
    IF TON_SerialBackup.Q THEN
        BakSerialInputs := SerialInputs;
    END_IF;
    
    FOR i := 1 TO 4 DO
        // Serial value timeout at 20 minutes
        TON_SerialTimeout[i](
            IN := (BakSerialInputs[i] = SerialInputs[i]) AND SerialAinIsUsed[i],
            PT := T#20m);
        
        Al_SerialInputs[i].Trigger := TON_SerialTimeout[i].Q;

    END_FOR;
    
    {ENDREGION}    
    
    firstCycle_Local := FALSE;

END_PROGRAM

FUNCTION GetChannelType : USINT
    VAR_INPUT
        AinChannel : USINT;
    END_VAR
    
    CASE AinChannel OF
        0: //PT1000
            GetChannelType := libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_PT1000;
        1: //NTC
            GetChannelType := libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_NTC;
        2: //0-5V
            GetChannelType := libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_0_5V;
        3: //4-20mA
            GetChannelType := libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_4_20MA;
        4: //0-10V
            GetChannelType := libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_0_10V;
        5: //NTC-HT
            GetChannelType := libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_NTC_0_150;
        6: //0.5..4.5V
            GetChannelType := libs.IOMng_Basic.MODE_TYPE_AIN#LIB_IO_PROBE_05_45V;
    ELSE
        GetChannelType := AinChannel;
    END_CASE;
    
END_FUNCTION


CLASS PrbSimulation
    VAR
        Min: REAL := 0.0;
        Max: REAL := 100.0;
        Period : TIME := T#5m;
        {METADATA HIDDEN}
        counterP : TON;
        {METADATA HIDDEN}
        degrees : REAL;
    END_VAR
    
    METHOD Config
        VAR_INPUT
            Min: REAL;
            Max: REAL;
            Period : TIME;
        END_VAR
        
        THIS.Min := Min;
        THIS.Max := Max;
        THIS.Period := Period;
    END_METHOD
    
    METHOD Run : REAL
        
        IF Period <= T#0s THEN
            RETURN;
        END_IF;
        
        counterP(IN := NOT counterP.Q, PT := Period);
        degrees := (TO_REAL(counterP.ET) / TO_REAL(Period)) * 3.14159 * 2 ;
        
        Run := (SIN(degrees) + 1) / 2 * (THIS.Max - THIS.Min) + THIS.Min;
    END_METHOD
END_CLASS

END_NAMESPACE
