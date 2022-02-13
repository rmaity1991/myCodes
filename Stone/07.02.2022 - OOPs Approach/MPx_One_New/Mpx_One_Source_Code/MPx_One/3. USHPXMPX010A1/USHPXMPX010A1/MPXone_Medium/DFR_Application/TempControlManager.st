USING System;
USING System.Timer;
USING Libs.PID_Incr;

(**
    Initial Creation:
    3/5/2020
    Joshua Meduoye
    Component Level B
    Dover Food and Retail temperature Management
        ******
        This component is focused on software development on ensuring effective temperature control
        There are 2 major parts
        
        1. Features 
            Features contain software focused on creating new functionality
            
        2. Diagnostics 
            Diagnostics are focused on failure detection and troubleshooting
               
        ******
**)

VAR_GLOBAL
        C_TCM_Valvekp,  V_TCM_pc_ValveOutPID, C_TCM_pc_ValveSteadyPID : REAL;
        C_TCM_ValveRevPID : BOOL;
        C_TCM_ValveTi, C_TCM_ValveTd : UINT;
        V_TCM_ValveVoltage : REAL;
        C_TCM_SupSetP : REAL;
        V_TCM_Superheat : REAL;
        //V_TCM_CompStatus : BOOL;
        C_TCM_ValveDiag_TimePeriod : REAL;
        V_TCM_SuctionTemp_Diag : REAL;
        V_TCM_EvapPressure_Diag : REAL;
        C_TCM_DiagEvapTemp : REAL;
        V_TCM_tr_CoilTempFault : BOOL;  
        V_TCM_pr_CoilPressFault  : BOOL;
        V_TCM_tr_SHBackupAlarm : BOOL;
        Valvedutycycle : REAL;
        (*CaseSetPt, CaseSetPtOffset : REAL*)
        PulseValvePWM : DFR_PWMGenerator;
        //TempFailureDiag : DFR_MOV_AVERAGE;
        //PressureFailureDiag : DFR_MOV_AVERAGE;
        Superheat_Failure : DFR_Superheat;
        V_TCM_Superheat_Failure : REAL;
        C_TCM_FailSamples : UINT;
        ValvePID : PID_Incr; 
        SuctT_Status, EvapP_Status : INT;
END_VAR


PROGRAM PulseValveControlMng  (*Pulse Valve Control Manager for AKV*)

    VAR
        PulseValvePID : DFR_PIDController;
        PulseValvePWM : DFR_PWMGenerator;
        ValveTi, ValveTd : REAL;
        Valvedutycycle : REAL;

    END_VAR
    V_TCM_Superheat := ActualSH;
    C_TCM_SupSetP := SHSetp;                (*Assignment of Superheat and Defrost Status variables*)   
        

    IF V_OM_Defrost_Flag =FALSE AND V_OM_Solenoid_Flag= TRUE THEN  (*Check Compressor and defrost Command*)
        IF SuctT_Status =0 AND EvapP_Status =0 THEN
            ValvePID(RegVar_PID_Incr := V_TCM_Superheat, SetP_PID_Incr := C_TCM_SupSetP,  DeadBand_PID_Incr := 0, Kp_PID_Incr := C_TCM_Valvekp, Ti_PID_Incr := C_TCM_ValveTi, Td_PID_Incr := C_TCM_ValveTd, LowLim_PID_Incr := 0, HighLim_PID_Incr := 100, Period_PID_Incr := 500, CoolHeatMode_PID_Incr := FALSE, RevMode_PID_Incr := C_TCM_ValveRevPID, ManModeVal_PID_Incr := C_TCM_pc_ValveSteadyPID, En_ManMode_PID_Incr:=FALSE, En_PID_Incr:= TRUE);                        
//            PulseValvePID(InValPID:=V_TCM_Superheat, Kp_PID:=C_TCM_Valvekp, Ki_PID:= C_TCM_Valveki, Kd_PID:= C_TCM_Valvekd, MinLimPID:=0, SetPointPID:= C_TCM_SupSetP, MaxLimPID:=100, InValSteadyPID:= C_TCM_pc_ValveSteadyPID, EnableTi:= FALSE, InValTi:= ValveTi, EnableTd:= FALSE, InValTd:= ValveTd, NeutralBandPID:= FALSE, LowerBandPID:= 0, UpperBandPID:= 100, ReversePID := FALSE, Cycletime := 0.5);  (*Pulse Valve Superheat PID Control*)
            V_TCM_pc_ValveOutPID := ValvePID.Req_PID_Incr; (*Superheat PID Output*)
            Valvedutycycle := (V_TCM_pc_ValveOutPID / 100);  (*Duty Cycle for pulse valve*)   
            PulseValvePWM(Enable := TRUE, Amplitude := 1000, TotTime := 6, dutycycle := Valvedutycycle, Cycletime := 0.5);
            V_TCM_ValveVoltage := PulseValvePWM.Out;  (*Pulse Valve voltage output*)            
            //TempFailureDiag(in_sample := V_IM_trc_Suction, in_count := C_TCM_FailSamples);
            //PressureFailureDiag(in_sample := V_IM_bar_Evap, in_count := C_TCM_FailSamples);
            //V_TCM_SuctionTemp_Diag := TempFailureDiag.out_mean;
           // V_TCM_EvapPressure_Diag := PressureFailureDiag.out_mean;
            
        ELSIF (SuctT_Status=0 AND EvapP_Status <>0) THEN 
            Superheat_Failure(EvapCoilTemp := AnalogInputs.Fct.SuctT, EvapPressure := V_TCM_EvapPressure_Diag, RefrigerantType := 2);            
            V_TCM_Superheat_Failure := Superheat_Failure.SuperheatTemp;
            //PulseValvePID(InValPID:= V_TCM_Superheat_Failure, Kp_PID:=C_TCM_Valvekp, Ki_PID:= C_TCM_Valveki, Kd_PID:= C_TCM_Valvekd, MinLimPID:=0, SetPointPID:= C_TCM_SupSetP, MaxLimPID:=100, InValSteadyPID:= C_TCM_pc_ValveSteadyPID, EnableTi:= FALSE, InValTi:= ValveTi, EnableTd:= FALSE, InValTd:= ValveTd, NeutralBandPID:= FALSE, LowerBandPID:= 0, UpperBandPID:= 100, ReversePID := FALSE, Cycletime := 0.5);  (*Pulse Valve Superheat PID Control*)
            ValvePID(RegVar_PID_Incr := V_TCM_Superheat_Failure, SetP_PID_Incr := C_TCM_SupSetP,  DeadBand_PID_Incr := 0, Kp_PID_Incr := C_TCM_Valvekp, Ti_PID_Incr := C_TCM_ValveTi, Td_PID_Incr := C_TCM_ValveTd, LowLim_PID_Incr := 0, HighLim_PID_Incr := 100, Period_PID_Incr := 500, CoolHeatMode_PID_Incr := FALSE, RevMode_PID_Incr := C_TCM_ValveRevPID, ManModeVal_PID_Incr := C_TCM_pc_ValveSteadyPID, En_ManMode_PID_Incr:=FALSE, En_PID_Incr:= TRUE);
            V_TCM_pc_ValveOutPID := PulseValvePID.OutValPID; (*Superheat PID Output*)
            Valvedutycycle := (V_TCM_pc_ValveOutPID / 100);  (*Duty Cycle for pulse valve*)   
            PulseValvePWM(Enable := TRUE, Amplitude := 1000, TotTime := 6, dutycycle := Valvedutycycle, Cycletime := 0.5);
            V_TCM_ValveVoltage := PulseValvePWM.Out;  (*Pulse Valve voltage output*)
            (*Set the sensor failure alarms to true*)
            //V_TCM_tr_CoilTempFault := TRUE;  
            V_TCM_pr_CoilPressFault  := TRUE;
            V_TCM_tr_SHBackupAlarm := TRUE;
        ELSIF (SuctT_Status<>0 AND EvapP_Status =0) THEN 
            Superheat_Failure(EvapCoilTemp := V_TCM_SuctionTemp_Diag, EvapPressure := AnalogInputs.Fct.EvapP, RefrigerantType := 2);            
            V_TCM_Superheat_Failure := Superheat_Failure.SuperheatTemp;
            //PulseValvePID(InValPID:= V_TCM_Superheat_Failure, Kp_PID:=C_TCM_Valvekp, Ki_PID:= C_TCM_Valveki, Kd_PID:= C_TCM_Valvekd, MinLimPID:=0, SetPointPID:= C_TCM_SupSetP, MaxLimPID:=100, InValSteadyPID:= C_TCM_pc_ValveSteadyPID, EnableTi:= FALSE, InValTi:= ValveTi, EnableTd:= FALSE, InValTd:= ValveTd, NeutralBandPID:= FALSE, LowerBandPID:= 0, UpperBandPID:= 100, ReversePID := FALSE, Cycletime := 0.5);  (*Pulse Valve Superheat PID Control*)
             ValvePID(RegVar_PID_Incr := V_TCM_Superheat_Failure, SetP_PID_Incr := C_TCM_SupSetP,  DeadBand_PID_Incr := 0, Kp_PID_Incr := C_TCM_Valvekp, Ti_PID_Incr := C_TCM_ValveTi, Td_PID_Incr := C_TCM_ValveTd, LowLim_PID_Incr := 0, HighLim_PID_Incr := 100, Period_PID_Incr := 500, CoolHeatMode_PID_Incr := FALSE, RevMode_PID_Incr := C_TCM_ValveRevPID, ManModeVal_PID_Incr := C_TCM_pc_ValveSteadyPID, En_ManMode_PID_Incr:=FALSE, En_PID_Incr:= TRUE);
            V_TCM_pc_ValveOutPID := PulseValvePID.OutValPID; (*Superheat PID Output*)
            Valvedutycycle := (V_TCM_pc_ValveOutPID / 100);  (*Duty Cycle for pulse valve*)   
            PulseValvePWM(Enable := TRUE, Amplitude := 1000, TotTime := 6, dutycycle := Valvedutycycle, Cycletime := 0.5);
            V_TCM_ValveVoltage := PulseValvePWM.Out;  (*Pulse Valve voltage output*)
            (*Set the sensor failure alarms to true*)
            V_TCM_tr_CoilTempFault := TRUE;  
            //V_TCM_pr_CoilPressFault  := TRUE;
            V_TCM_tr_SHBackupAlarm := TRUE;
        ELSIF (SuctT_Status<>0 AND EvapP_Status <>0) THEN 
            Superheat_Failure(EvapCoilTemp := V_TCM_SuctionTemp_Diag, EvapPressure := V_TCM_EvapPressure_Diag, RefrigerantType := 2);            
            V_TCM_Superheat_Failure := Superheat_Failure.SuperheatTemp;
            //PulseValvePID(InValPID:= V_TCM_Superheat_Failure, Kp_PID:=C_TCM_Valvekp, Ki_PID:= C_TCM_Valveki, Kd_PID:= C_TCM_Valvekd, MinLimPID:=0, SetPointPID:= C_TCM_SupSetP, MaxLimPID:=100, InValSteadyPID:= C_TCM_pc_ValveSteadyPID, EnableTi:= FALSE, InValTi:= ValveTi, EnableTd:= FALSE, InValTd:= ValveTd, NeutralBandPID:= FALSE, LowerBandPID:= 0, UpperBandPID:= 100, ReversePID := FALSE, Cycletime := 0.5);  (*Pulse Valve Superheat PID Control*)
             ValvePID(RegVar_PID_Incr := V_TCM_Superheat_Failure, SetP_PID_Incr := C_TCM_SupSetP,  DeadBand_PID_Incr := 0, Kp_PID_Incr := C_TCM_Valvekp, Ti_PID_Incr := C_TCM_ValveTi, Td_PID_Incr := C_TCM_ValveTd, LowLim_PID_Incr := 0, HighLim_PID_Incr := 100, Period_PID_Incr := 500, CoolHeatMode_PID_Incr := FALSE, RevMode_PID_Incr := C_TCM_ValveRevPID, ManModeVal_PID_Incr := C_TCM_pc_ValveSteadyPID, En_ManMode_PID_Incr:=FALSE, En_PID_Incr:= TRUE);
            V_TCM_pc_ValveOutPID := PulseValvePID.OutValPID; (*Superheat PID Output*)
            Valvedutycycle := (V_TCM_pc_ValveOutPID / 100);  (*Duty Cycle for pulse valve*)   
            PulseValvePWM(Enable := TRUE, Amplitude := 1000, TotTime := 6, dutycycle := Valvedutycycle, Cycletime := 0.5);
            V_TCM_ValveVoltage := PulseValvePWM.Out;  (*Pulse Valve voltage output*)
            (*Set the sensor failure alarms to true*)
            V_TCM_tr_CoilTempFault := TRUE;  
            V_TCM_pr_CoilPressFault  := TRUE;
            V_TCM_tr_SHBackupAlarm := TRUE;
        END_IF;
    ELSE
            V_TCM_ValveVoltage := 0;   (*Pulse Valve voltage output*)
    END_IF;
    
    AnalogOutputs.Fct.Valve := V_TCM_ValveVoltage;
    
    
      (*  IF AnalogInputs.Fct.AirOff > (CaseSetPt+ CaseSetPtOffset) THEN
              ELSIF AnalogInputs.Fct.AirOff < (CaseSetPt+CaseSetPtOffset) THEN
            ValveOutPID := 5.0;
            Valvedutycycle := (ValveOutPID / 100);     
          PulseValvePWM(Enable := TRUE, Amplitude := 10, TotTime := 6, dutycycle := Valvedutycycle, Cycletime := 0.3);
            ValveVoltage := PulseValvePWM.Out; 
       END_IF;*)
    
END_PROGRAM

PROGRAM P_CompProtection
    VAR
        fb_CompProt             : DFR_FB_CompressorProtection;
        init_flag               : bool      := FALSE;
    END_VAR
    VAR_OUTPUT
        out_solenoid_flag : BOOL;
    END_VAR
    
    IF NOT init_flag THEN
        fb_CompProt.in_Count1   := C_TCM_Comp_Count_X1;
        fb_CompProt.in_Count2   := C_TCM_Comp_Count_X2;
        fb_CompProt.in_T1Mins   := C_TCM_Timer_Comp_T1;
        fb_CompProt.in_T2Mins   := C_TCM_Timer_Comp_T2;
        init_flag               := TRUE;
    END_IF;
    
    fb_CompProt(in_CompressorStatus         := V_IM_Comp_Pressure_Status,
                in_Reset                    := C_TCM_Comp_Reset,
                in_CompShutdownOn           := C_TCM_Comp_Shutdown_On,
                out_WarningLow              => V_TCM_pr_Comp_LowAlarm,
                out_WarningMedium           => V_TCM_pr_Comp_MediumAlarm,
                out_WarningSevere           => V_TCM_pr_Comp_SevereAlarm
                );
    out_solenoid_flag := NOT(fb_CompProt.out_ShutdownCommand);
END_PROGRAM
