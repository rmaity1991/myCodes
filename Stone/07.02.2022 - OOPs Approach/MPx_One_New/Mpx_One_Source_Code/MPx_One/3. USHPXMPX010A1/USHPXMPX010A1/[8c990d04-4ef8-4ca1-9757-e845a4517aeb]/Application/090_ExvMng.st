{IF NOT DEF(MPXONE_BASIC)}
USING Libs.EVD_ACU;
USING Libs.MPXone_Smoothlines;
USING System;
USING Libs.Logics;
USING Libs.Math;
USING System.Math;
USING System.Timer;
USING Libs.Hysteresis;
USING Libs.SignalGeneration;
{ENDIF}

// Use shared pressure probe and EVD regulation
{IF NOT DEF(MPXONE_BASIC)}
VAR_GLOBAL    
    MachineVars: Libs.EVD_ACU.MACHINE_DATA_VARS;
    MachineParams : Libs.EVD_ACU.MACHINE_DATA_PARAMS;
    
    {IF NOT DEF(MPXONE_ADVANCED)}
    MachineDrivingExtPosit      : MAIN_MachineDrivingExtPosit;
    ExtPosit_EVD                : System.EVD.TEEV;
	DevErr                      : UINT;
	DevErr_EVD                  : INT;
    ErrCode_EVD                 : INT;
    
    {IF NOT DEF(MPXONE_BASIC)}
    EvdMpxReg                   : Libs.EvdMPX.EvdMPXReg;
    {ENDIF}
    
	OfflineAlrm_EVD             : BOOL;
    Online_EVD                  : BOOL;
    CfgErr_EVD                  : UINT;
    {ENDIF}
    
END_VAR
{ENDIF}

{IF NOT DEF(MPXONE_BASIC)}

{IF NOT DEF(MPXONE_ADVANCED)}
VAR_GLOBAL PERSISTENT
	EVD_MB_CmdDelay : UINT(0..1000)             := 5;
    EVD_MB_Timeout : UINT(200..3000)            := 500;
    EVD_MB_DetectionTimeOut : UINT(200..5000)   := 500;        
END_VAR
{ENDIF}

NAMESPACE LibraryNamespaceAndVersion

PROGRAM ExvMng
    
    VAR
        MachineInit                 : MAIN_MachineInit;
        MachineServiceTimerUpdate   : MAIN_MachineServiceTimerUpdate;
        MachineCanGo                : MAIN_EVDCanGoMng;
        MachineController           : MAIN_MachineController;
        {IF DEF(MPXONE_ADVANCED)}
        MachineDriving              : MAIN_MachineDriving;
        {ENDIF}
        
        EVDCanGo                    : BOOL := TRUE;
        Ts                          : UDINT := 300;   
        
        ShOffset : REAL;
        GetMPXoneSmLine : MPXone_Smoothlines;
//        ShSetPID : PID_Incr;
        
        AfterDfrTON : TON;
        AfterDfrFEDGE : F_EDGE;
        
        ManPar : RF_Trig;
        
        BlockAlarmTON: TON;
        ExvVlvBlockChk : BOOL;
        VlvBlockHiHyst, VlvBlockLowHyst : HysterAdv;
        
        SuctTDutyCycle : BlinkOnOff;
        SuctTDutyFEDGE : F_TRIG;
        Sm_VirtualPrb_PrevVal : REAL;
    END_VAR
    
    VAR_TEMP
        tmp_CoolingCapacity : UINT;
    END_VAR
    
    //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
    VlvPresent := ValveCnf > 0 AND (isMedium OR isAdvanced);
    
    IF VlvPresent THEN
        {REGION PARAMETERS}
            //ExvPIDKp_checkWoC(val_In1 := ExvKp, val_In2 := MachineParams.Engine_params.PID_PARAMS.Kp);
            //ExvPIDTi_checkWoC(val_In1 := MachineParams.Engine_params.PID_PARAMS.Ti, val_In2 := );
        
            MachineParams.Engine_params.PID_PARAMS.Kp := ExvKp;
            MachineParams.Engine_params.PID_PARAMS.Ti := TO_REAL(ExvTi);
            MachineParams.Engine_params.PID_PARAMS.Td := TO_REAL(ExvTd);
            
            // Low SH settings
            MachineParams.SH_params.SHProtection_params.LowSHAlarmDelay := LowSH_AlrmDelay;
            MachineParams.SH_params.SHProtection_params.LowSHThreshold := LowSH_Thrsh;
            MachineParams.SH_params.SHProtection_params.LowSHTi := LowSH_Ti;
            
            // Low suction temperature settings
            MachineParams.SH_params.SHProtection_params.LowSuctAlarmDelay := LowSuctAlrmDelay;
            MachineParams.SH_params.SHProtection_params.LowSuctThreshold := LowSuctThrsh;
            
            // MOP settings
            MachineParams.SH_params.SHProtection_params.MOPAlarmDelay := MOP_AlrmDelay;
            MachineParams.SH_params.SHProtection_params.MOPSuctionTemperatureThreshold := MOP_SuctTempThrsh;
            MachineParams.SH_params.SHProtection_params.MOPThreshold := MOP_Thrsh;
            MachineParams.SH_params.SHProtection_params.MOPTi := MOP_Ti;
            
            // LOP settings
            MachineParams.SH_params.SHProtection_params.LOPAlarmDelay := TO_UINT(LOP_AlrmDelay);
            MachineParams.SH_params.SHProtection_params.LOPThreshold := LOP_Thrsh;
            MachineParams.SH_params.SHProtection_params.LOPTi := LOP_Ti;
            
            // Start of valve regulation
            MachineParams.Engine_params.StartEEVOpenRatio := TO_UINT(StartEEVOpenRatio); 
            MachineParams.Engine_params.RegulationStartDelay := 0;

        {ENDREGION }

        {REGION CALCULATE_SH_SETPOINT}
        GetMPXoneSmLine(
        	VirtualProbe_SL          := VirtualProbe,
        	TempSetP_SL              := TempSetP,
        	TempDiff_SL              := TempDiff,
        	SmLineKp_SL              := SmLineKp,
        	SmLineTi_SL              := SmLineTi,
        	SmLineTd_SL              := SmLineTd,
        	SmLineSHOffset_SL        := SmLineSHOffset,
        	EnSmoothLine_SL          := EnSmoothLine,
        	SmLine_SH_thrsh_SL       := SmLine_SH_thrsh,
        	ShOffset_SL              => ShOffset,
        	Sm_VirtualPrb_PrevVal_SL := Sm_VirtualPrb_PrevVal
        );      
        
        ActualShSetP := SHSetP + ShOffset;
    
        BMS_SHSet := ActualShSetP;

        MachineParams.SH_params.SHset := SHSetP;
        {ENDREGION }
        
        {REGION EVD_ACU_CORE}
        
        (*cooling capacity sent to valve*)
        // P10 management
        tmp_CoolingCapacity := 100 - (99 * TO_UINT(Alarms.Al.Al_LSA.Info.Trigger OR Alarms.Al.Al_LSH.info.Trigger)); // TRAC #133 removed check on ExvEnCloseLsa (P10), EXV has to close independently 
        
        // PM5 management
        IF tmp_CoolingCapacity > 1 THEN
            tmp_CoolingCapacity := 100 - (99 * TO_UINT(ExvEnCloseMOP AND Alarms.Al.Al_MOP.Info.Trigger));    
        END_IF;
                
        IF tmp_CoolingCapacity < 100 THEN
            {IF NOT DEF (MPXONE_BASIC)}
                MachineVars.Engine_vars.UnitPower := 10; //close o valve during Alarm; not set=0 otherwise Alarm aren't check by EVD_ACU lib 
            {ENDIF}
        ELSE
            IF isMaster AND MstVlvConfig THEN
                MachineVars.Engine_vars.UnitPower := 100 * TO_UINT(MstTempRegStatus AND (DfrStatus = DFR_IDLE OR DfrStatus = DFR_POST_DRIPPING));
            ELSE
                MachineVars.Engine_vars.UnitPower := 100 * TO_UINT(TempRegStatus AND (DfrStatus = DFR_IDLE OR DfrStatus = DFR_POST_DRIPPING));
            END_IF;
        END_IF;
                
        (*EXV works on suction superheat*)
        IF ValveCnf = 1 OR ValveCnf = 2 OR (ValveCnf = 6 AND VlvPressPrbTyp = 14) THEN
            MachineVars.SH_vars.EvaporationTemperature := EvapSatTemp;
        ELSE
            EvapSatTemp := MachineVars.SH_vars.EvaporationTemperature;
        END_IF;

        MachineVars.SH_vars.SuctionTemperature := AnalogInputs.Fct.SuctT - ShOffset;

        // During defrost force the valve status if needed
        IF DfrStatus = DFR_DFR THEN
            CASE DfrVlvPos OF
                
                2..100: // fixed % if configured
                MachineVars.ManualPositioner_vars.ManualPositioningEnable := TRUE;
                MachineVars.ManualPositioner_vars.ManualPositionSteps := TO_UINT(TO_REAL(DfrVlvPos) / 100.0 * 480.0);
                
                1: // Keep the valve closed during defrost
                MachineVars.ManualPositioner_vars.ManualPositioningEnable := TRUE;
                MachineVars.ManualPositioner_vars.ManualPositionSteps := 0;
                
                0: // Default mng (Normal regulation)
                MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
                MachineVars.ManualPositioner_vars.ManualPositionSteps := 0;
                
            END_CASE;
        /*ELSE
            MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
            MachineVars.ManualPositioner_vars.ManualPositionSteps := 0;*/
        END_IF;
        
    
        IF DfrStatus = DFR_DRIPPING THEN
            MachineVars.ManualPositioner_vars.ManualPositioningEnable := TRUE;
            MachineVars.ManualPositioner_vars.ManualPositionSteps := 0;
        END_IF;
        
        // After the defrost keep the valve opening for Pdd time
        AfterDfrFEDGE( In := DfrStatus = DFR_DRIPPING, Reset := AfterDfrTON.Q);
        AfterDfrTON( IN := AfterDfrFEDGE.Out, PT := TO_TIME(TO_UDINT(ExvDelayDfr) * 60 * 1000));
        IF AfterDfrFEDGE.Out AND NOT AfterDfrTON.Q THEN
            MachineVars.ManualPositioner_vars.ManualPositioningEnable := TRUE;
            MachineVars.ManualPositioner_vars.ManualPositionSteps := TO_UINT(TO_REAL(StartEEVOpenRatio) / 100.0 * 480.0);
        END_IF;
        IF AfterDfrTON.Q THEN
            MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
            MachineVars.ManualPositioner_vars.ManualPositionSteps := 0;
        END_IF;
        
        IF DfrType = 1 OR DfrType = 3 THEN
            MachineVars.Engine_vars.UnitPower := 100 * TO_UINT(TempRegStatus AND ( DfrStatus <> DFR_POST_DRIPPING ));
        END_IF;
        
        
        (* Duty cycle in case of SuctT sensor broken *)
        SuctTDutyFEDGE(CLK := SuctTBroken);
        IF SuctTBroken THEN
            //Duty cycle 2 min at 0.5*cP1 (prepositioning) and 1 min at Psb (stand-by position)
            MachineVars.ManualPositioner_vars.ManualPositioningEnable := TRUE;
            SuctTDutyCycle(In := SuctTBroken, T_On := 120, T_Off := 60);
            IF SuctTDutyCycle.Out THEN
                MachineVars.ManualPositioner_vars.ManualPositionSteps := TO_UINT(0.5*(TO_REAL(StartEEVOpenRatio) / 100.0 * 480.0));
            ELSE
                MachineVars.ManualPositioner_vars.ManualPositionSteps := StandbyEEVOpenPosition;
            END_IF;
        ELSIF SuctTDutyFEDGE.Q THEN    
            MachineVars.ManualPositioner_vars.ManualPositioningEnable := FALSE;
            MachineVars.ManualPositioner_vars.ManualPositionSteps := 0;
        END_IF;

        // Manual management from SPV, APP or parameters
        ManPar(CLK := EnManExv OR Alarms.Al.Al_LSA.Info.Trigger);
        IF ManPar.Q OR EnManExv THEN
            MachineVars.ManualPositioner_vars.ManualPositioningEnable   := EnManExv OR Alarms.Al.Al_LSA.Info.Trigger;
            IF Alarms.Al.Al_LSA.Info.Trigger THEN
                 // LSA Force clousure of valve by manpos
                MachineVars.ManualPositioner_vars.ManualPositionSteps       := 0;                
            ELSE
                MachineVars.ManualPositioner_vars.ManualPositionSteps       := PosManExv;
            END_IF;
        END_IF;
                    // reset manul forcinng to allow reset of alarm same differential done in EVD_ACU lib)
        IF Alarms.Al.Al_LSA.Info.Trigger  AND AnalogInputs.Fct.SuctT >  LowSuctThrsh + 3 THEN
            MachineVars.ManualPositioner_vars.ManualPositioningEnable   := FALSE;
        END_IF;
 
            
            
        MachineInit(MachineParams := MachineParams, MachineVars := MachineVars);
        MachineServiceTimerUpdate( MachineVars := MachineVars );
           
        MachineCanGo( 
                RegulationType := 6, 
                Machine_params := MachineParams, 
                Machine_vars := MachineVars, 
                EVDCanGo := EVDCanGo
                );
           
        MachineController(MachineParams := MachineParams, MachineVars := MachineVars, Ts := Ts);

    END_IF;
    
    ActualSH := AnalogInputs.Fct.SuctT - EvapSatTemp;
    
    {IF DEF(MPXONE_ADVANCED)}
    IF PwrSupplyFailure THEN // Manage the valve closure in case of power failure
        EVDCanGo := FALSE;
        MachineVars.Engine_Vars.EEV_Vars.FastClosingSpeedEnable := 1;
        

        // If the power comes back restore the regulation
            IF  (u[9].r > 0 AND ExvVlvPosition < 1) THEN //u[9]>0 means that the power supply is present (230Vac)
            PwrSupplyFailure := FALSE; 
            MachineVars.Engine_Vars.EEV_Vars.FastClosingSpeedEnable := 0;
            EVDCanGo := TRUE;
        END_IF;
        
    END_IF;
    
    MachineDriving( ID_Driver := 1, 
        MachineVars := MachineVars, 
        MachineParams := MachineParams); 
    {ENDIF}
    {IF NOT DEF(MPXONE_ADVANCED)}
    MachineDrivingExtPosit(
        ExtPosit_CPCOE  := ExtPosit_EVD,
        MachineVars     := MachineVars,
        MachineParams   := MachineParams
    );
    {ENDIF}
    {ENDREGION }
    
    {REGION EVD_MPX}
    {IF NOT DEF(MPXONE_ADVANCED)}
    
    //EVDice and EVDmini management    
    EvdMpxReg(
        DevAddr_EVD := EvdAddr,
        En_EVD := (ValveCnf = 2 OR ValveCnf = 6) AND EVDCanGo,
        GasIndex := RfrgTyp,
                
        Online_EVD => Online_EVD,
        OfflineAlrm_EVD => OfflineAlrm_EVD,
        DevErr => DevErr_EVD,
        ErrCode => ErrCode_EVD,
        CfgErr_EVD => CfgErr_EVD,
        EVD_EvapP => EVD_EvapP,
        
        Al_S1Probe => Alarms.Al.AL_DA1_EVDmini.Info.Trigger,
        Al_S2Probe => Alarms.Al.AL_DA2_EVDmini.Info.Trigger,
        Al_EEprom_EVD => Alarms.Al.Al_DEE_EVDmini.Info.Trigger,
        Al_EmergencyClosing => Alarms.Al.Al_DE5_EVDmini.Info.Trigger,
        
        MachineVars := MachineVars,
        MachineParams := MachineParams,
        ExtPosit_EVD := ExtPosit_EVD,
        EVD_Digin1Cfg := EVD_Digin1Cfg,
        //VAR_IN_OUT CONSTANT
        VlvPressPrbTyp := VlvPressPrbTyp,
        EvaporationPressure := AnalogInputs.Fct.EvapP,
        SmoothLineOffset := ShOffset,
        ValveCnf := ValveCnf,
        MB_Timeout          := EVD_MB_Timeout,
    	MB_CmdDelay         := EVD_MB_CmdDelay,
        MB_DetectionTimeout := EVD_MB_DetectionTimeOut
    );
     Alarms.Al.Warn_EVD_Fw.Info.Trigger := CfgErr_EVD > 0;
    {ENDIF}
    {ENDREGION }
    
   
    
    IF MachineVars.Engine_vars.EEV_vars.CurrentEstimatedPosition > 1 THEN
        ExvVlvPosition := TO_USINT( TO_REAL(MachineVars.Engine_vars.EEV_vars.CurrentEstimatedPosition) / 4.8 );
    ELSE
        ExvVlvPosition := 0;
    END_IF;
    
    IF ExvVlvPosition > 100 THEN
        ExvVlvPosition := 100;
    END_IF;
    
    // check valve blocked conditions 
    VlvBlockHiHyst(In := ActualSH, SetP := ActualShSetp, DiffLeft := 0.0, DiffRight := 0.5, Reverse := FALSE);
    VlvBlockLowHyst(In := ActualSH, SetP := ActualShSetp, DiffLeft := 0.5, DiffRight := 0.0, Reverse := TRUE);
    
    ExvVlvBlockChk := (ExvVlvPosition >= 90 AND VlvBlockHiHyst.Out) OR (ExvVlvPosition <= 10 AND VlvBlockLowHyst.Out);
    BlockAlarmTON(IN := NOT EnManExv AND EnBloAlarm AND ExvVlvBlockChk, PT := T#25m);//check condition valve blocked ('bLO') too open or too closed
    
    {REGION ALARMS_MNG}
    
    IF ValveCnf = 1 OR ValveCnf = 2 OR ValveCnf = 5 THEN
        Alarms.Al.Al_LSH.Info.Trigger := MachineController.Al_LowSH;
        Alarms.Al.Al_LOP.Info.Trigger := MachineController.Al_LOP;
        Alarms.Al.Al_MOP.Info.Trigger := MachineController.Al_MOP;
        Alarms.Al.Al_LSA.Info.Trigger := MachineController.Al_LowSuct;
        
    {IF NOT DEF(MPXONE_ADVANCED)}
    ELSIF ValveCnf = 6 THEN
        Alarms.Al.Al_LSH.Info.Trigger := EvdMpxReg.Al_LowSH;
        Alarms.Al.Al_LOP.Info.Trigger := EvdMpxReg.Al_LOP;
        Alarms.Al.Al_MOP.Info.Trigger := EvdMpxReg.Al_MOP;
        Alarms.Al.Al_LSA.Info.Trigger := EvdMpxReg.Al_LowSuct;
    {ENDIF}
    END_IF;
    
    Alarms.Al.Al_bLO.Info.Trigger := BlockAlarmTON.Q AND ValveCnf > 0;
    
    {IF NOT DEF(MPXONE_ADVANCED)}
    Alarms.Al.Al_Edc.Info.Trigger := NOT Online_EVD AND (ValveCnf = 2 OR ValveCnf = 5 OR ValveCnf = 6);
    {ENDIF}
    {ENDREGION}
    
END_PROGRAM

FUNCTION_BLOCK checkWriteOnChange_REAL
    VAR_IN_OUT
        val_In1, val_In2 : REAL;
    END_VAR
    
    VAR
        changeByIn1, changeByIn2 : BOOL;
        prevVal_In1, prevValIn2 : REAL;
    END_VAR
    
    IF val_In1 <> prevVal_In1 THEN
        prevVal_In1 := val_In1;
        changeByIn1 := TRUE;
    END_IF;
    
    IF val_In2 <> prevValIn2 THEN
        prevValIn2 := val_In2;
        changeByIn2 := TRUE;
    END_IF;
    
    IF changeByIn1 THEN val_In2 := val_In1; END_IF;
        
    IF changeByIn2 THEN val_In1 := val_In2; END_IF;
    
END_FUNCTION_BLOCK
{ENDIF}
    
END_NAMESPACE