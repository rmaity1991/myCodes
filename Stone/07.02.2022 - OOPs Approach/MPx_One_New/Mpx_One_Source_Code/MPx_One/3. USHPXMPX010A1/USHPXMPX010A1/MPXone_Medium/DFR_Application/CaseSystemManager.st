(**
    Initial Creation:
    3/5/2020
    Joshua Meduoye
    Component Level A
    Dover Food and Retail Overall Case System Management
        ******
        This component is focused on Overall Case System Management
        There are 2 major parts
        
        1. Features 
            Features contain software focused on creating new functionality
            
        2. Diagnostics 
            Diagnostics are focused on failure detection and troubleshooting
               
        ******
**)

    
(**
    Case Identification Number for DFR Cases CIN
    3 categories of information
    
    A. General Case Information - DFR_CINCaseSystemComponent()
        1: Case date
        2: Case month
        3: Case year
        4: Case Series
        5: Refrigerant : 1-R-22, 2-R-404A, 3-R-407A, 4-R-410A, 5-R-422D, 6-R-507A, 7-R-448A, 8-R-449A, 9-CO2 DX, 10-CO2 SC, 11-Glycol SC
        6: Doors : 0,1,2,3,4,5,6
        7: Length in feet : 0,4,6,8,10,12
        8: Evaporator : 0-Standard , 1- NRG
        9: Control Temp : 0 -Dual,1-LT ,2-MT
        10: Defrost Type : 0-Off-time, 1-Electric, 2-Hotgas
        11: Metering Device Type : 0-None, 1-TXV, 2-PWM, 3-Stepper
        12: Temperature Control Type : 1-Self Contained, 2-Remote
        13: Controller Type : 1- Dixell, 2- MPXOne, 3 – Cpco Mini 
        
    B. Features Selection Code (Bitmapped) - DFR_CINControlComponent()
    
        1. AirOff Sensor  / 2. AirOn Sensor / 3.Rh Sensor 
        4. Ambient Temp Probe  / 5. Auxillary 1 / 6. Auxillary 2 
        7. Defrost Temp Probe  / 8. Coil 2 Sensor / 9. Dew Point Sensor
        10. Coil Outlet Pressure Probe / 11. Glass Temp Sensor / 12. Coil Outlet Temp Probe
        13. Alarm Input / 14. Auxiliary input / 15. Call Defrost input
        16. Case Clean Input / 17. Config input / 18. Continuous cycle input
        19. Night Curtain Input / 20. Defrost Mirror input / 21. Delay Alarm input
        22. Door Sensor Off Input / 23. Door Sensor on input / 24. Enable defrost input
        25. Generic Function Input / 26. Remote on/off input / 27. Standby input
        28. Timer Input / 29. Rail Heater Analog Flag / 30. Analog Fans flag
        31. Generic Flag / 32. Analog Valve flag (EEV) / 33. Alarm flag
        34. Auxillary Flag / 35. Master Auxilliary flag / 36. Generic stage flag
        37. Digital Fans Flag / 38. Timed Output flag / 39. Drain Heater flag
        40. Solenoid/CDU Flag / 41. Light flag / 42. Master light flag
        43. Rail Heater Digital Flag / 44. Defrost O/P Coil 1 flag / 45. Defrost O/P Coil 2 flag
        
    C. Serial Number - DFR_CINSerialNumber()
    
        1. Serial Number
    **)
    
USING System.Math;
USING System;
USING System.Timer;
USING system.Text;

VAR_GLOBAL
    EOL_Full_Enab         : System.Timer.R_TRIG;
    EOL_IO_Enab           : System.Timer.R_TRIG;
    EOL_Run_Enab          : System.Timer.R_TRIG;
    EOL_Abort             : System.Timer.R_TRIG;
    EOL_Reset             : System.Timer.R_TRIG;
    EOL_Ack               : System.Timer.R_TRIG;
    ASHeater              : DFR_DiagAntiSweatHeater;
    Lights                : DFR_DiagLights;
    DrainHeater           : DFR_DiagDrainheater;
    PullDown1             : DFR_Feature_PullDownTest;
    PullDown2             : DFR_Feature_PullDownTest;
    DefrostCycle          : DFR_Feature_DefrostCycleTest;
    DFRHeater             : DFR_DefrostHeater;
    Diag_CoilOutletTemp   : DFR_Sensor_Diag;
    Diag_DefrostTemp      : DFR_Sensor_Diag;
    Diag_DischargeAirTemp : DFR_Sensor_Diag;
    Diag_SuctionPressure  : DFR_Sensor_Diag;
    EEVCheck1             : DFR_EEV_Check;                      // To Close the EEV Valve
    EEVCheck2             : DFR_EEV_Check;                      // To Open the EEV Valve
    SensorSwap2           : DFR_Diag_SensorSwap_RegEEV;
    SensorSwap1           : DFR_Diag_SensorSwap_DfrOn;
    Fans                  : DFR_DiagFans;
    
    /*
    Here We are Going to Test the DFR Class 
    */
    
    Sample : DFR_LIBRARY;
    
END_VAR

PROGRAM DFR_EOLTestMng
    
    VAR
        
        init_flag               : BOOL;
        temp_coil_outlet_prev   : REAL;
        temp_discharge_air_prev : REAL;
        temp_defrost_term_prev  : REAL;
        press_suction_prev      : REAL;
        suction_diff            : REAL;
        defrost_diff            : REAL;
        airoff_diff             : REAL;
        EOL_Full_Test           : DFR_LATCH_WITH_RESET;
        EOL_IO_Test             : DFR_LATCH_WITH_RESET;
        EOL_Run_Test            : DFR_LATCH_WITH_RESET;
        EOL_Blinker             : DFR_FB_Blinker;
        DefTemp1                : REAL;
        EOL_HoldTimer           : ARRAY [1..6] OF DFRTimer;
        EOL_SkipTimer           : ARRAY [1..15] OF DFRTimer;
        CoilOut_Diag            : BOOL;
        Defrost_Diag            : BOOL;
        Discharge_Diag          : BOOL;
        
    END_VAR
    
    VAR_OUTPUT
        out_solenoid_flag    : BOOL;
        out_defrost_flag     : BOOL;
        out_drainheater_flag : BOOL;
        out_railheater_flag  : BOOL;
        out_lights_flag      : BOOL;
        out_fans_flag        : BOOL;
        out_pc_valve         : REAL;
        out_pc_rails         : REAL;
    END_VAR
    
    
    (*CIN Modbus Assignment*)
    V_CSM_CaseSystemInfo1 := C_CSM_CaseSystemInfo1;
    V_CSM_CaseSystemInfo2 := C_CSM_CaseSystemInfo2;
    V_CSM_CaseSystemInfo3 := C_CSM_CaseSystemInfo3;
    V_CSM_CaseSystemInfo4 := C_CSM_CaseSystemInfo4;
    V_CSM_CaseSystemInfo5 := C_CSM_CaseSystemInfo5;
    V_CSM_CaseSystemInfo6 := C_CSM_CaseSystemInfo6;
    V_CSM_FeatureInfo1    := C_CSM_FeatureInfo1;
    V_CSM_FeatureInfo2    := C_CSM_FeatureInfo2;
    V_CSM_FeatureInfo3    := C_CSM_FeatureInfo3;
    V_CSM_FeatureInfo4    := C_CSM_FeatureInfo4;
    V_CSM_SerialNumber1   := C_CSM_SerialNumber1;
    V_CSM_SerialNumber2   := C_CSM_SerialNumber2;
    (*CIN Modbus Assignment*)
    
    IF NOT init_flag THEN
        //EEV Parameters //
        EEVCheck1.Inp       := 0;
        EEVCheck1.TotTime   := C_CSM_Timer_EEV1;
        // Drain Heater Parameters //
        DrainHeater.Trigger := C_CSM_ManAck;
        // Coil Outlet Temp Probe Parameters //
        Diag_CoilOutletTemp.Inp                         := V_IM_trc_Suction;
        Diag_CoilOutletTemp.Inp_LowerThreshold          := C_CSM_trc_Suction_LowerThreshold;
        Diag_CoilOutletTemp.Inp_HighThreshold           := C_CSM_trc_Suction_HighThreshold;
        Diag_CoilOutletTemp.ProbeTime                   := C_CSM_Timer_CoilOutTemp ;
        // Defrost Temp Parameters //
        Diag_DefrostTemp.Inp                            := V_IM_trc_Defrost;
        Diag_DefrostTemp.Inp_LowerThreshold             := C_CSM_trc_Defrost_LowerThreshold;
        Diag_DefrostTemp.Inp_HighThreshold              := C_CSM_trc_Defrost_HighThreshold;
        Diag_DefrostTemp.ProbeTime                      := C_CSM_Timer_DefTermTemp;
        // Sensor Swap -1 Parameters //
        SensorSwap1.TotTime                             := C_CSM_Timer_SwapSensor1;
        // Discharge Air Temp Parameters // 
        Diag_DischargeAirTemp.Inp                       := V_IM_trc_AirOff;
        Diag_DischargeAirTemp.Inp_LowerThreshold        := C_CSM_trc_Air_Off_LowerThreshold;
        Diag_DischargeAirTemp.Inp_HighThreshold         := C_CSM_trc_Air_Off_HighThreshold;
        Diag_DischargeAirTemp.ProbeTime                 := C_CSM_Timer_DischTemp;
        // Condensing Unit Parameters //
        EEVCheck2.Inp                                   := 100;
        EEVCheck2.TotTime                               := C_CSM_Timer_EEV2;
        Diag_SuctionPressure.Inp                        := V_IM_bar_Evap;
        Diag_SuctionPressure.ProbeTime                  := C_CSM_Timer_SuctionPress;
        // Sensor Swap -2 Parameters //
        SensorSwap2.TotTime                             := C_CSM_Timer_SwapSensor2;
        // Suction Pressure Parameters //
        V_CSM_bar_Evap_InRange                          := DFR_RANGE_REAL(V_IM_bar_Evap, 45, 55);
        // Anti-Sweat Heater Parameters // 
        ASHeater.Trigger                                := C_CSM_ManAck;
        // Lights Parameters //
        Lights.TotTime                                  := C_CSM_Timer_Light;
        // Pull Down -1 Parameters //
        PullDown1.CycleTime                             := 0.5;
        PullDown1.Preset_RegTime                        := C_CSM_Timer_PullDownOn;
        PullDown1.Preset_RegFailTime                    := C_CSM_Timer_PullDownFail;
        PullDown1.In1                                   := V_IM_trc_AirOff;
        PullDown1.In2                                   := V_IM_trc_Defrost;
        PullDown1.Reg_SP                                := C_CSM_SP_Regulation;
        PullDown1.FanSP                                 := C_CSM_SP_Fan;
        PullDown1.FanHystSP                             := FansDiff;
        //Defrost Cycle Parameters //
        DefrostCycle.CycleTime                          := 0.5;
        DefrostCycle.Preset_DefFailTime                 := C_CSM_Timer_DefrostCycleFail;
        DefrostCycle.SetPoint                           := DfrEndTemp;
        // Pull Down -2 Parameters //
        PullDown2.CycleTime                             := 0.5;
        PullDown2.Preset_RegTime                        := C_CSM_Timer_PullDownOn;
        PullDown2.Preset_RegFailTime                    := C_CSM_Timer_PullDownFail;
        PullDown2.In1                                   := V_IM_trc_AirOff;
        PullDown2.In2                                   := V_IM_trc_Defrost;
        PullDown2.Reg_SP                                := C_CSM_SP_Regulation;
        PullDown2.FanSP                                 := C_CSM_SP_Fan;
        PullDown2.FanHystSP                             := FansDiff;
        
    END_IF;
    
    
    //// EOL Triggers ////
    
    EOL_Full_Enab(CLK := T_CSM_EOL_Enab);
    EOL_IO_Enab(CLK := T_CSM_EOL_IO_Enab);
    EOL_Run_Enab(CLK := T_CSM_EOL_Run_Enab);
    EOL_Abort(CLK := T_CSM_EOL_Abort);
    EOL_Reset(CLK := T_CSM_EOL_Reset);
    EOL_Ack(CLK := C_CSM_ManAck);
    
    
    IF T_CSM_EOL_Exit THEN
        En_GlobalSwitch_Override := FALSE;
        En_DrainHeaterOverwrite  := FALSE;
        En_RailHeaterOverwrite   := FALSE;
        En_LightOverwrite        := FALSE;
        En_FansOverwrite         := FALSE;
        En_FansModulOverwrite    := FALSE;
        En_ValveModulOverwrite   := FALSE;
        En_HeatersModulOverwrite := FALSE;
        T_CSM_EOL_Abort          := TRUE;
    END_IF;
    IF T_CSM_EOL_Enab  THEN
        EOL_Full_Test(In := T_CSM_EOL_Enab, Rst := (T_CSM_EOL_IO_Enab OR T_CSM_EOL_Run_Enab OR T_CSM_EOL_Abort));
        EOL_IO_Test(Rst := TRUE);
        EOL_Run_Test(Rst := TRUE);
    ELSIF T_CSM_EOL_IO_Enab  THEN
        EOL_IO_Test(In := T_CSM_EOL_IO_Enab, Rst := (T_CSM_EOL_Enab OR T_CSM_EOL_Run_Enab OR T_CSM_EOL_Abort));
        EOL_Full_Test(Rst := TRUE);
        EOL_Run_Test(Rst := TRUE);
    ELSIF T_CSM_EOL_Run_Enab  THEN
        EOL_Run_Test(In := T_CSM_EOL_Run_Enab, Rst := (T_CSM_EOL_Enab OR T_CSM_EOL_IO_Enab OR T_CSM_EOL_Abort));
        EOL_IO_Test(Rst := TRUE);
        EOL_Full_Test(Rst := TRUE);
    END_IF;
    
    IF EOL_Full_Test.Out THEN
        V_CSM_EOL_Test_Type := 1; // Full EOL Test is Active
    END_IF;
    IF EOL_IO_Test.Out  THEN
        V_CSM_EOL_Test_Type := 2; // EOL IO Test is Active
    END_IF;
    IF EOL_Run_Test.Out THEN
        V_CSM_EOL_Test_Type := 3; // EOL Run Test is Active
    END_IF;
    
    /// EOL Abort Test ///
    IF EOL_Abort.Q THEN
        DfrEndTemp := DefTemp1;
    END_IF;
    
    IF EOL_Abort.Q OR EOL_Full_Enab.Q OR EOL_IO_Enab.Q OR EOL_Run_Enab.Q  THEN   /// Abort Command ensures the Test to return at Initial State and all triggers are set to False
        V_CSM_EOL_Test_Type := 0;
        V_CSM_EOL_Test_Status := 0;
        T_CSM_EOL_IO_Enab := FALSE;
        T_CSM_EOL_Run_Enab := FALSE;
        T_CSM_EOL_Enab := FALSE;
        T_CSM_EOL_Abort := FALSE;
        T_CSM_EOL_Reset := FALSE;
        T_CSM_EOL_Exit := FALSE;
        out_solenoid_flag := FALSE;
        out_defrost_flag := FALSE;
        out_drainheater_flag := FALSE;
        out_fans_flag := FALSE;
        //out_lights_flag := FALSE;
        out_railheater_flag := FALSE;
        out_pc_rails := 0;
        out_pc_valve := 0;
        EEVCheck1(Ena := FALSE);
        EEVCheck2(Ena := FALSE);
        SensorSwap1(In_Status := FALSE); 
        SensorSwap2(In_Status := FALSE); 
        DrainHeater(Inp := FALSE);
        C_CSM_ManAck := FALSE;
        DFRHeater(Inp := FALSE);
        ASHeater(Inp := FALSE);
        Lights(Inp := FALSE);
        Fans(Inp := FALSE);
        Diag_CoilOutletTemp(In_Status := FALSE);
        Diag_DefrostTemp(In_Status := FALSE);
        Diag_DischargeAirTemp(In_Status := FALSE);
        Diag_SuctionPressure(In_Status := FALSE);
        PullDown1(Enable := FALSE);
        PullDown2(Enable := FALSE);
        DefrostCycle(Enable := FALSE);
        EOL_Blinker(InSignal := FALSE);
    END_IF;
     
    (* Resetting Functions*)
    IF DFR_Mode.In AND ((V_CSM_EOL_Test_Result = (1 OR 2 OR 4 OR 5)) OR (V_CSM_EOL_Test_Result = 3 AND V_CSM_EOL_Test_Type = 2))  THEN
        T_CSM_EOL_Reset := TRUE;
    ELSE
        T_CSM_EOL_Reset := FALSE;
    END_IF;
    
    IF EOL_Reset.Q THEN
        DfrEndTemp := DefTemp1;
        out_solenoid_flag := FALSE;
        out_defrost_flag := FALSE;
        out_drainheater_flag := FALSE;
        out_fans_flag := FALSE;
        out_lights_flag := FALSE;
        out_railheater_flag := FALSE;
        out_pc_rails := 0;
        out_pc_valve := 0;
        EEVCheck1(Ena := FALSE);
        EEVCheck2(Ena := FALSE);
        SensorSwap1(In_Status := FALSE); 
        SensorSwap2(In_Status := FALSE); 
        DrainHeater(Inp := FALSE);
        C_CSM_ManAck := FALSE;
        DFRHeater(Inp := FALSE);
        ASHeater(Inp := FALSE);
        Lights(Inp := FALSE);
        Fans(Inp := FALSE);
        Diag_CoilOutletTemp(In_Status := FALSE);
        Diag_DefrostTemp(In_Status := FALSE);
        Diag_DischargeAirTemp(In_Status := FALSE);
        Diag_SuctionPressure(In_Status := FALSE);
        T_CSM_EOL_IO_Enab := FALSE;
        T_CSM_EOL_Run_Enab := FALSE;
        T_CSM_EOL_Enab := FALSE;
        EOL_Blinker(InSignal := FALSE);
        DFR_Mode(In := FALSE);
    END_IF;
    
    CoilOut_Diag   := DFR_RANGE_REAL(V_IM_trc_Suction, C_CSM_trc_Suction_LowerThreshold, C_CSM_trc_Suction_HighThreshold);
    Defrost_Diag   := DFR_RANGE_REAL(V_IM_trc_Defrost, C_CSM_trc_Defrost_LowerThreshold, C_CSM_trc_Defrost_HighThreshold);
    Discharge_Diag := DFR_RANGE_REAL(V_IM_trc_AirOff, C_CSM_trc_Air_Off_LowerThreshold, C_CSM_trc_Air_Off_HighThreshold);
    
    IF NOT V_CSM_InvalidCIN_Flag AND WizDone THEN
    CASE V_CSM_EOL_Test_Status OF
        0: // No Test Active 
        (* This Step checks the Sesnor Diagnostics, turns On the Lights Output and based on the type of trigger jumps to the EOL IO/Run Test  *)
        IF (EOL_Full_Enab.Q OR EOL_IO_Enab.Q)  THEN 
            DFR_Mode(In := TRUE);
            out_lights_flag := TRUE;
            V_CSM_EOL_Test_Result := 0;
            V_CSM_EOL_Test_Type := 0;
            IF (DFR_CINControlComponent(12) AND (NOT CoilOut_Diag)) OR (DFR_CINControlComponent(7) AND (NOT Defrost_Diag)) OR (DFR_CINControlComponent(1) AND (NOT Discharge_Diag))  THEN
                V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL     
            ELSE 
                V_CSM_EOL_Test_Status := 1; // Go to EOL CDU Config Check Functional Test
            END_IF;
        ELSIF EOL_Run_Enab.Q THEN
            DFR_Mode(In := TRUE);
            out_lights_flag := TRUE;
            //DfrEndTemp := DefTemp1;
            V_CSM_EOL_Test_Result := 0;
            V_CSM_EOL_Test_Type := 0;
            PullDown1.DFR_Regulation_Sts := 'NA';
            PullDown2.DFR_Regulation_Sts := 'NA';
            DefrostCycle.DFR_DefrostCycle_Sts := 'NA';
            IF (DFR_CINControlComponent(12) AND (NOT CoilOut_Diag)) OR (DFR_CINControlComponent(7) AND (NOT Defrost_Diag)) OR (DFR_CINControlComponent(1) AND (NOT Discharge_Diag))  THEN
                V_CSM_EOL_Test_Result := 2; // Run Test Function is FAIL     
            ELSE 
                V_CSM_EOL_Test_Status := 13; // Go to Pull Down Test Function
            END_IF;
        ELSE
            V_CSM_EOL_Test_Status := 0; // No Test Active
            DFR_Mode(In := FALSE);
        END_IF;
        
        1: // Initialize the CDU Config Check
        (* This Test check the status of CDU and turns it off*)
        DefTemp1 := DfrEndTemp;
        IF DFR_CINControlComponent(43) THEN // CIN Status for CDU 
            
            out_solenoid_flag := FALSE;
               
        END_IF;
        EOL_HoldTimer[1](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 5);
        IF EOL_HoldTimer[1].Q THEN
            V_CSM_EOL_Test_Status := 2; // Go to EOL EEV Cycle Test 
        END_IF;
        
        2: // Initialize the EEV Check 
        (* This Test check the status of EEV and closes the EEV Valve*)
        IF DFR_CINControlComponent(32) AND NOT (DFR_CINCaseSystemComponent(11) = 1)  THEN // CIN Status for EEV (* DFR_CINCaseSystemComponent(5) : 1-TXV,2-Pulse,3-Stepper *)
            (* CALL DFR EEV Check Function*)
            IF V_CSM_EOL_Test_Result = 0 THEN
            EEVCheck1(Ena:= TRUE,Inp := 0, Out => out_pc_valve);
            END_IF;
            IF EEVCheck1.TimerDone THEN
                IF NOT EEVCheck1.OutStatus THEN
                    V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                    V_CSM_EOL_Test_Status := 2;
                    EEVCheck1.TimerDone := FALSE;
                ELSE 
                    V_CSM_EOL_Test_Status := 3; // Jump to Drain Heater Test
                    EEVCheck1.TimerDone := FALSE;
                END_IF;               
            END_IF;
        ELSE
            EOL_SkipTimer[1](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[1].Q THEN
                V_CSM_EOL_Test_Status := 3; // Skip and Jump to Drain Heater Test
            END_IF;
        END_IF;

        3: // Initialize the EOL Drain Heater Test 
        (* This Test check the status of Drain Heater and turns it ON*)
        IF DFR_CINControlComponent(39) THEN // CIN Status for Drain Heater 
            (*CALL Drain Heater Test Function*)
            IF V_CSM_EOL_Test_Result = 0 THEN
            DrainHeater(Inp := TRUE, Output => out_drainheater_flag);
            END_IF;
            EOL_HoldTimer[2](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 5);
            IF EOL_HoldTimer[2].Q THEN
                V_CSM_EOL_Test_Status := 4; //Move to Defrost Heater Test
            END_IF;
        ELSE
            EOL_SkipTimer[2](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[2].Q THEN
                V_CSM_EOL_Test_Status := 4; // Skip and Jump to Defrost Heater Test
            END_IF;
        END_IF;
        
        4: // Initialize the EOL Defrost Heater Test
        (* This Test check the status of Defrost Heater and turns it ON and effect on Coil Outlet Temp Probe*)
        DfrEndTemp := 32.23; // Temp in Deg Celsius == 90 Deg Fahreheit
        
        IF  DFR_CINControlComponent(44) THEN // CIN Status for Defrost Heater
            (*CALL Defrost Heater Test Function*)
            IF V_CSM_EOL_Test_Result = 0 THEN
                DFRHeater(Inp := TRUE, Out => out_defrost_flag);
                IF DFR_CINControlComponent(12) THEN // Check CIN Status for Coil Outlet Probe
                (*CALL Sensor Diagnostic function and Diag Probe Rate Function*)
                    IF V_CSM_EOL_Test_Result = 0 THEN
                        IF NOT Diag_CoilOutletTemp.In_Status THEN
                            temp_coil_outlet_prev           := V_IM_trc_Suction;
                            Diag_CoilOutletTemp.In_Status   := TRUE;
                        END_IF;
                
                        Diag_CoilOutletTemp();
              
                        IF Diag_CoilOutletTemp.TimerDone THEN
                        suction_diff := ABS(V_IM_trc_Suction - temp_coil_outlet_prev);
                            IF (Diag_CoilOutletTemp.Out_Status) AND (suction_diff > C_CSM_Delta_Suction) THEN
                                V_CSM_EOL_Test_Status := 5; //Go to Defrost Termination Temp Probe Check
                            ELSE
                                V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                                V_CSM_EOL_Test_Status := 4;
                            END_IF;
                        END_IF;
                    END_IF;
                ELSE
                    EOL_HoldTimer[3](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 5);
                    IF EOL_HoldTimer[3].Q THEN
                        V_CSM_EOL_Test_Status := 5; //Go to Defrost Termination Temp Probe Check
                    END_IF;
                END_IF;
            END_IF; 
        ELSE
            EOL_SkipTimer[3](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[3].Q THEN
                V_CSM_EOL_Test_Status := 6; // Skip and Jump to Fan Test
            END_IF;
        END_IF;
            
        5: // Check for Doors and then Check for Change in EOL Defrost Termination Temp Probe
        (* This Test check the status of Doors and Defrost Temp Probe and the effect on Probe with Time*)
        IF NOT (DFR_CINCaseSystemComponent(6) = 0) OR out_fans_flag THEN //System Info for number of Doors : 0,1,2,3,4,5,6 or if Fans are On
            IF DFR_CINControlComponent(7) THEN // CIN Status for Defrost Temp Probe
                (*CALL Sensor Diagnostic function and Diag Probe Rate Function*)
                IF V_CSM_EOL_Test_Result = 0 THEN
                    IF NOT Diag_DefrostTemp.In_Status THEN
                        temp_defrost_term_prev       := V_IM_trc_defrost;
                        Diag_DefrostTemp.In_Status   := TRUE;
                    END_IF;
                
                    Diag_DefrostTemp();
                
                    IF Diag_DefrostTemp.TimerDone THEN
                        defrost_diff := ABS(V_IM_trc_Defrost - temp_defrost_term_prev);
                        IF (Diag_DefrostTemp.Out_Status) AND (defrost_diff > C_CSM_Delta_Defrost) AND (NOT out_fans_flag) THEN
                            V_CSM_EOL_Test_Status := 6; //Go to Fan Test
                        ELSIF out_fans_flag THEN
                            V_CSM_EOL_Test_Status := 7; //Go to Swap Sensor Test
                        ELSE
                            V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                            V_CSM_EOL_Test_Status := 5;
                        END_IF;
                    END_IF;
                END_IF;
            ELSIF (NOT DFR_CINControlComponent(7)) AND out_fans_flag THEN
                V_CSM_EOL_Test_Status := 7; //Go to Swap Sensor Test
            ELSE
                EOL_SkipTimer[4](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
                IF EOL_SkipTimer[4].Q THEN
                    V_CSM_EOL_Test_Status := 6; // Skip and Jump to Fan Test
                END_IF;
            END_IF; 
        ELSE
            EOL_SkipTimer[5](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[5].Q THEN
                V_CSM_EOL_Test_Status := 6; // Skip and Jump to Fan Test
            END_IF;
        END_IF;
        
        6: // Initialize the EOL Fan Test
        (* This Test check the status of Fan and turns it ON*)
        IF  (DFR_CINControlComponent(37) AND DFR_CINControlComponent(1)) THEN // CIN Status for Fan and AirOff Temp
            (*CALL Fan Test Function*)
            IF V_CSM_EOL_Test_Result = 0 THEN
            Fans(Inp := TRUE,Out => out_fans_flag);         
            END_IF; 
        END_IF;
        IF (DFR_CINCaseSystemComponent(6) = 0) AND DFR_CINControlComponent(7) THEN // If Doors are present then move to next step else move back to Defrost Probe Test
            V_CSM_EOL_Test_Status := 5; // Defrost Termination Probe Test
        ELSE
            EOL_HoldTimer[4](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 5);
            IF EOL_HoldTimer[4].Q THEN
                V_CSM_EOL_Test_Status := 7; // Skip and Jump to Sensor Swap-1 Test
            END_IF;
        END_IF;
        
        7: // Initialize the Sensor Swap-1 Test
        (* This Test performs the Swap Sensor Test between Discharge Temp Vs Defrost Temp Probe*)
        IF (DFR_CINControlComponent(1) AND DFR_CINControlComponent(7)) THEN // CIN Status for Discharge Air Temp Probe And Defrost Temp
            (*CALL Sensor Swap Test-1 Function*)
            IF V_CSM_EOL_Test_Result = 0 THEN
                IF NOT SensorSwap1.In_Status THEN
                    temp_defrost_term_prev  := V_IM_trc_Defrost;
                    temp_discharge_air_prev := V_IM_trc_AirOff;
                    SensorSwap1.In_Status := TRUE;
                END_IF;
            IF (DFR_CINCaseSystemComponent(9) = 1) THEN // FOR LT TYPE CASES FAN TURNED OFF DURING TEST
                Fans(Inp := FALSE,Out => out_fans_flag);
            END_IF;
            SensorSwap1();
            
            IF SensorSwap1.TimerDone THEN
                defrost_diff := ABS(V_IM_trc_Defrost - temp_defrost_term_prev);
                airoff_diff  := ABS(V_IM_trc_AirOff - temp_discharge_air_prev);
                IF (DFR_CINCaseSystemComponent(9) = 1) THEN // FOR LT TYPE CASES
                    IF defrost_diff < airoff_diff THEN
                        V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                        V_CSM_EOL_Test_Status := 7;
                    ELSE
                        Fans(Inp := TRUE,Out => out_fans_flag); // FOR LT CASE TURN FAN BACK ON
                        V_CSM_EOL_Test_Status := 8; // Jump to Discharge Air Temp Probe Check 
                    END_IF;
                ELSIF (DFR_CINCaseSystemComponent(9) = 2) THEN // FOR MT TYPE CASES
                    IF defrost_diff > airoff_diff THEN
                        V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                        V_CSM_EOL_Test_Status := 7;
                    ELSE
                        V_CSM_EOL_Test_Status := 8; // Jump to Discharge Air Temp Probe Check 
                    END_IF;
                ELSE                                // FOR DUAL TEMP CASES
                    IF defrost_diff < airoff_diff THEN
                        V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                        V_CSM_EOL_Test_Status := 7;
                    ELSE
                        Fans(Inp := TRUE,Out => out_fans_flag); // FOR LT CASE TURN FAN BACK ON
                        V_CSM_EOL_Test_Status := 8; // Jump to Discharge Air Temp Probe Check 
                    END_IF;
                END_IF;
            END_IF; 
            END_IF;
        ELSE
            EOL_SkipTimer[6](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[6].Q THEN
                V_CSM_EOL_Test_Status := 8; // Skip and Jump to Discharge Air Temp Probe Check 
            END_IF;
        END_IF;
         
        8://  Check Change in EOL Discharge Air Temp Probe
        (* This Test check the status of Discharge Temp Probe and the effect on Probe with Time*)
        
        IF DFR_CINControlComponent(1) THEN // CIN Status for Discharge Air Temp Probe
            (*CALL Sensor Diagnostic function and Diag Probe Rate Function*)
            IF V_CSM_EOL_Test_Result = 0 THEN
                IF NOT Diag_DischargeAirTemp.In_Status THEN
                    temp_discharge_air_prev    := V_IM_trc_AirOff;
                    Diag_DischargeAirTemp.In_Status   := TRUE;
                END_IF;
                
                Diag_DischargeAirTemp();
                
                IF Diag_DischargeAirTemp.TimerDone THEN
                    airoff_diff := ABS(V_IM_trc_AirOff - temp_discharge_air_prev);
                    IF (Diag_DischargeAirTemp.Out_Status) AND (airoff_diff > C_CSM_Delta_AirOff) THEN
                        V_CSM_EOL_Test_Status := 9; ////Go to CDU Function & EEV Cycle Check
                        out_defrost_flag := FALSE;
                        out_fans_flag := FALSE;
                    ELSE
                        V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                        V_CSM_EOL_Test_Status := 8;
                    END_IF;
                END_IF;
            END_IF;
        ELSE 
            EOL_SkipTimer[7](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[7].Q THEN
                V_CSM_EOL_Test_Status := 9; // Skip and Jump to CDU Config Check
            END_IF;
            out_defrost_flag := FALSE;
            out_fans_flag := FALSE;
            
        END_IF; 
        
        9:  // CDU Function & EEV Cycle Test
        (* This Test check the status of CDU and EEV , and Runs the Sensor Swap Test between Discharge Temp Vs Coil Out Temp*)
        IF DFR_CINControlComponent(43)  THEN // CIN Status for CDU AND EEV 
            out_solenoid_flag := TRUE;
            (*CALL Sensor Swap Test-2 Function*)
            IF V_CSM_EOL_Test_Result = 0 THEN
            SensorSwap2(In_Status := TRUE,Out=>out_pc_valve);
                IF DFR_CINControlComponent(32) AND DFR_CINControlComponent(10) AND NOT (DFR_CINCaseSystemComponent(11) = 1) THEN // DFR_CINCaseSystemComponent(5) : 1-TXV,2-Pulse,3-Stepper
                (* CALL DFR EEV Check Function*)
                EEVCheck2(Ena:= TRUE,Inp := 100, Out => out_pc_valve);
                    IF NOT Diag_SuctionPressure.In_Status THEN
                        press_suction_prev   := V_IM_bar_Evap;
                        Diag_SuctionPressure.In_Status  := TRUE;
                    END_IF;
                    Diag_SuctionPressure();
                
                    IF EEVCheck2.TimerDone AND Diag_SuctionPressure.TimerDone AND SensorSwap2.TimerDone THEN
                        IF  (EEVCheck2.OutStatus AND V_IM_bar_Evap <= press_suction_prev) AND (V_IM_trc_AirOff > V_IM_trc_Suction) THEN
                            V_CSM_EOL_Test_Status := 11; // Jump to A/S Heater
                            out_solenoid_flag := FALSE;
                            EEVCheck2.TimerDone := FALSE;
                        ELSE 
                            V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                            V_CSM_EOL_Test_Status := 9;
                        END_IF;
                    END_IF;
                ELSE
                    IF SensorSwap2.TimerDone THEN
                        IF (V_IM_trc_AirOff > V_IM_trc_Suction) THEN
                            V_CSM_EOL_Test_Status := 10; // Jump to Suction Pressure Probe Check
                            out_solenoid_flag := FALSE;
                        ELSE
                            V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                            V_CSM_EOL_Test_Status := 9; 
                        END_IF;
                    END_IF;
                END_IF; 
            END_IF;
        ELSE
            EOL_SkipTimer[8](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[8].Q THEN
                V_CSM_EOL_Test_Status := 10; // Skip and Jump to Suction Pressure Probe Check
            END_IF;
            
        END_IF;
        
        
        10:// Check Suction Pressure is 50 psig +/- 5
        (* This Test check the Range of Suction Pressure Probe *)
        IF DFR_CINControlComponent(10) THEN // CIN Status for Suction Pressure Probe 
            (*CALL Sensor Diagnostic function and Diag Probe Rate Function*)
            V_CSM_bar_Evap_InRange := DFR_RANGE_REAL(V_IM_bar_Evap, 0, 5);
            IF V_CSM_EOL_Test_Result = 0 THEN
                IF V_CSM_bar_Evap_InRange THEN
                    EOL_HoldTimer[5](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 5);
                    IF EOL_HoldTimer[5].Q THEN
                        V_CSM_EOL_Test_Status := 11; //Go to A/S Heater Test
                    END_IF;
                ELSE
                    V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL
                    V_CSM_EOL_Test_Status := 10; 
                END_IF;    
            ELSE
                EOL_SkipTimer[9](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
                IF EOL_SkipTimer[9].Q THEN
                    V_CSM_EOL_Test_Status := 11; // Skip and Jump to A/S Heater Test
                END_IF;
            END_IF;
        END_IF;
        
        11:// Initialize the EOL A/S Heater Test
        (* This Test check the status of A/S Heater and turns it ON*)
        IF DFR_CINControlComponent(40) OR DFR_CINControlComponent(29)  THEN // CIN Status for Anti Sweat Heater flag OR Anti Sweat Heater Modulating Output
            (*CALL AntiSweat Heater Test Function*)    
            IF V_CSM_EOL_Test_Result = 0 THEN
                IF DFR_CINControlComponent(40) THEN
                    ASHeater(Inp := TRUE, Out1 => out_railheater_flag); // In case Anti Sweat Htr Flag is present
                ELSIF DFR_CINControlComponent(29)  THEN
                    ASHeater(Inp := TRUE, Out2=>out_pc_rails); // In case Anti Sweat Htr Modulating Output is present
                ELSIF DFR_CINControlComponent(40) AND DFR_CINControlComponent(29)  THEN
                    ASHeater(Inp := TRUE, Out1 => out_railheater_flag, Out2=>out_pc_rails); // In case Anti Sweat Htr Modulating Output is present
                END_IF;
            END_IF;
            EOL_HoldTimer[6](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 5);
            IF EOL_HoldTimer[6].Q THEN
                V_CSM_EOL_Test_Status := 12; //Move to to Lights Test
            END_IF;
        ELSE
            EOL_SkipTimer[10](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[10].Q THEN
                V_CSM_EOL_Test_Status := 12; // Skip and Jump to Lights Test
            END_IF;
        END_IF;
        
        12:// Initialize the EOL Light Test
        
        IF DFR_Mode.In THEN
            DfrEndTemp := DefTemp1;
        END_IF;
        
        (* This Test check the status of Lights , Runs Lights Diagnostic test and then Manually Acknowledge to end the IO Test*)
        IF DFR_CINControlComponent(41) THEN // CIN Status for Lights
            (*CALL Light Test Function*)
            Lights.TimerDone := FALSE;
            IF V_CSM_EOL_Test_Result = 0 THEN
            Lights(Inp := TRUE, Out => out_lights_flag);
            END_IF;    
            IF Lights.TimerDone THEN
                IF NOT C_CSM_ManAck THEN
                    V_CSM_EOL_Test_Result := 1; // IO Test Function is FAIL ( Failure of either Drain Htr,Anti Sweat Htr or Lights)
                    V_CSM_EOL_Test_Status := 12;
                    Lights.TimerDone := FALSE; 
                END_IF;
            out_drainheater_flag := FALSE;
            out_railheater_flag := FALSE;
            out_pc_rails := 0;
            ELSIF C_CSM_ManAck THEN
                V_CSM_EOL_Test_Result := 3; // IO Test Function is PASS 
                Lights(Inp := FALSE);
                out_drainheater_flag := FALSE;
                out_railheater_flag := FALSE;
                out_pc_rails := 0;
                out_lights_flag := FALSE;
                IF(V_CSM_EOL_Test_Type=1) THEN
                    V_CSM_EOL_Test_Status := 13; //Move to PULL Down Test
                    C_CSM_ManAck := FALSE;
                END_IF;
            END_IF;

        ELSIF (V_CSM_EOL_Test_Type = 1) AND C_CSM_ManAck THEN // If Lights are absent and EOL Full Test is enabled then check for Manual Ack and Jump to Pull Down Test
            EOL_SkipTimer[11](Ena := TRUE, PLCCycletime := 0.5, ProgramTime := 2);
            IF EOL_SkipTimer[11].Q THEN
                V_CSM_EOL_Test_Status := 13; // Skip and Jump to Pull Down Test
                C_CSM_ManAck := FALSE;
            END_IF;
            V_CSM_EOL_Test_Result := 3; // IO Test has Passed 
            out_drainheater_flag := FALSE;
            out_railheater_flag := FALSE;
            out_pc_rails := 0;
        ELSIF C_CSM_ManAck THEN
            V_CSM_EOL_Test_Status := 12; // End Of EOL IO Test 
            V_CSM_EOL_Test_Result := 3; // IO Test has Passed 
            out_drainheater_flag := FALSE;
            out_railheater_flag := FALSE;
            out_pc_rails := 0;
        END_IF;
        
        13:// Initialize the EOL Pull Down Test-1
        //DfrEndTemp := 32.23; // Temp in Deg Celsius == 90 Deg Fahreheit
        IF  (DFR_CINControlComponent(1))  THEN // CIN Status for Air Off Temp 
            (*CALL EOL Pull Down Test Function*)
            
            IF NOT (PullDown1.DFR_Regulation_Sts = 'FAL') THEN
            PullDown1(Enable := TRUE,Out1=>out_solenoid_flag,Out2=>out_fans_flag);
            out_defrost_flag := FALSE;
            out_pc_valve := 100.0; // Valve Output
            END_IF;
            IF PullDown1.DFR_Regulation_Sts = 'PAS' THEN
                V_CSM_EOL_Test_Status := 14; //Move to Defrost Cycle Test
                EOL_Blinker(InSignal := FALSE);
            ELSIF PullDown1.DFR_Regulation_Sts = 'FAL' THEN
                V_CSM_EOL_Test_Result := 2; // Run Test Function is FAIL
                V_CSM_EOL_Test_Status := 13;;
                PullDown1(Enable := FALSE);
                out_solenoid_flag := FALSE;
                out_fans_flag := FALSE;
                out_pc_valve := 0.0;
            END_IF;
            
        ELSE
            (*CALL EOL Pull Down Test Function*)
            V_CSM_EOL_Test_Result := 2; // Run Test Function is FAIL
            V_CSM_EOL_Test_Status := 13;
        END_IF;
        
        
        EOL_Blinker(InSignal := TRUE, DelaySecs := 1, Count := 1, Out => out_lights_flag);
        
        14:// Initialize the EOL Defrost Cycle Test 
        
        IF  (DFR_CINControlComponent(1)) OR (DFR_CINControlComponent(7)) THEN // CIN Status for Discharge Air Temp OR Defrost Temp
            (*CALL EOL Defrost Cycle Test Function*)
            out_solenoid_flag := FALSE;
            out_pc_valve := 0; // Valve Output
            IF NOT ((DefrostCycle.DFR_DefrostCycle_Sts = 'FAL') OR (V_CSM_EOL_Test_Result = 5)) THEN
                IF (DFR_CINControlComponent(7)) THEN // If Defrost Temp Probe Present
                    DefrostCycle(Enable := TRUE,In1 := V_IM_trc_Defrost,Out1=>out_solenoid_flag,Out2=>out_defrost_flag,Out3=>out_fans_flag,Out4=>out_drainheater_flag);
                ELSIF ((DFR_CINControlComponent(1)) AND NOT (DFR_CINControlComponent(7))) THEN // If Only Discharge Air Probe Present 
                    DefrostCycle(Enable := TRUE,In1 := V_IM_trc_AirOff,Out1=>out_solenoid_flag,Out2=>out_defrost_flag,Out3=>out_fans_flag,Out4=>out_drainheater_flag);
                END_IF;
            IF DefrostCycle.DFR_DefrostCycle_Sts = 'PAS' THEN
                EOL_Blinker(InSignal := FALSE);
                V_CSM_EOL_Test_Result := 5; // Run Test Function is PASS and EOL Test is Completed Succesfully
                V_CSM_EOL_Test_Status := 14; //END EOL Run Test
                out_solenoid_flag := FALSE;
                out_defrost_flag := FALSE;
                out_fans_flag := FALSE;
                out_drainheater_flag := FALSE;
                out_lights_flag := FALSE;
                out_pc_valve := 0.0; // Valve Output
                DefrostCycle(Enable := FALSE);
                //V_CSM_EOL_Test_Status := 15; //Go to Pull Down Test-2    
            ELSIF DefrostCycle.DFR_DefrostCycle_Sts = 'FAL' THEN
                V_CSM_EOL_Test_Result := 2; // Run Test Function is FAIL
                V_CSM_EOL_Test_Status := 14;
                DefrostCycle(Enable := FALSE);
                out_defrost_flag := FALSE;
                out_fans_flag := FALSE;
                out_drainheater_flag := FALSE;
            END_IF;
            END_IF;
        ELSE
            V_CSM_EOL_Test_Result := 2; // Run Test Function is FAIL
            V_CSM_EOL_Test_Status := 14;
            out_solenoid_flag := FALSE;
            out_fans_flag := FALSE;
            out_drainheater_flag := FALSE;
        END_IF;
        
        EOL_Blinker(InSignal := TRUE, DelaySecs := 1, Count := 2, Out => out_lights_flag);
        
        
        /* 15:// Initialize the EOL Pull Down Test-2
        
        IF  DFR_CINControlComponent(1) THEN // CIN Status for Air Off Temp 
            (*CALL EOL Pull Down Test Function*)
            IF (PullDown2.DFR_Regulation_Sts = 'NA') THEN
                PullDown2(Enable := TRUE,Out1=>out_solenoid_flag,Out2=>out_fans_flag);
                out_defrost_flag := FALSE;
                out_pc_valve := 100.0; // Valve Output
            END_IF;
            IF PullDown2.DFR_Regulation_Sts = 'PAS' THEN
                V_CSM_EOL_Test_Result := 5; // Run Test Function is PASS and EOL Test is Completed Succesfully
                V_CSM_EOL_Test_Status := 15; //END EOL Run Test
                out_solenoid_flag := FALSE;
                out_defrost_flag := FALSE;
                out_fans_flag := FALSE;
                out_lights_flag := FALSE;
                out_pc_valve := 0.0; // Valve Output
                PullDown2(Enable := FALSE);
                EOL_Blinker(InSignal := FALSE);
            ELSIF PullDown2.DFR_Regulation_Sts = 'FAL' THEN
                V_CSM_EOL_Test_Result := 2; // Run Test Function is FAIL
                V_CSM_EOL_Test_Status := 15;  
                PullDown2.Enable := FALSE;
                out_solenoid_flag := FALSE;
                out_fans_flag := FALSE;
                out_pc_valve := 0.0; // Valve Output
                out_lights_flag := FALSE;
            END_IF;
            
        ELSE
            V_CSM_EOL_Test_Result := 2; // Run Test Function is FAIL
            V_CSM_EOL_Test_Status := 15;
            out_solenoid_flag := FALSE;
            out_fans_flag := FALSE;
            out_pc_valve := 0.0; // Valve Output
            out_lights_flag := FALSE;
        END_IF; 
        
        EOL_Blinker(InSignal := TRUE, DelaySecs := 1, Count := 1, Out => out_lights_flag); *///TEST 15 COMMENTED OUT
    END_CASE;
    END_IF;    
END_PROGRAM

// To test the EOL Log Manager
PROGRAM DFR_EOLLogMng

IF T_CSM_EOL_Enab OR T_CSM_EOL_IO_Enab OR T_CSM_EOL_Run_Enab THEN
    
    Logs.Check();
ELSE
    RETURN;
END_IF;

END_PROGRAM

/////////////////////////////////////(* Case Standarization *)/////////////////////////////////////


(*************************************Variable Mapping ******************************************)

PROGRAM DFR_CaseStandardization
    
    (*Case System Info*)
    
    V_CSM_bs.System.info.arr[0]  := Alarms.Al.Status_Clean.Info.Active;                               
    V_CSM_bs.System.info.arr[1]  := DigitalOutputs.Fct.Defrost;
    V_CSM_bs.System.info.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[3]  := DayNightOutput;
    V_CSM_bs.System.info.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[10] := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[11] := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[12] := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[13] := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[14] := V_CSM_binRsev;
    V_CSM_bs.System.info.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.system.infoflag := TO_BOOL(V_CSM_bs.system.info.i);
    
    (* Case System Alarms *)
    
    V_CSM_bs.System.alarm.arr[0]  := Alarms.Al.Al_LowTemp.Info.Active;
    V_CSM_bs.System.alarm.arr[1]  := Alarms.Al.Al_HiTemp.Info.Active;
    V_CSM_bs.System.alarm.arr[2]  := Alarms.Al.Al_LSH.Info.Active;
    V_CSM_bs.System.alarm.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[4]  := Alarms.Al.Al_Door.Info.Active;
    V_CSM_bs.System.alarm.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[10] := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[11] := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[12] := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[13] := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[14] := V_CSM_binRsev;
    V_CSM_bs.System.alarm.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.system.alarmflag := TO_BOOL(V_CSM_bs.system.alarm.i);
    
    (*Case Sensor/Actuator Info*)
    
    V_CSM_bs.Device.info.arr[0]  := DigitalOutputs.Fct.DrainHeat;
    V_CSM_bs.Device.info.arr[1]  := DigitalOutputs.Fct.RailHeaters;
    V_CSM_bs.Device.info.arr[2]  := DigitalOutputs.Fct.Fans;
    V_CSM_bs.Device.info.arr[3]  := DigitalOutputs.Fct.Light;
    V_CSM_bs.Device.info.arr[4]  := DigitalInputs.Fct.DoorOn;
    V_CSM_bs.Device.info.arr[5]  := DigitalOutputs.Fct.Solenoid;
    V_CSM_bs.Device.info.arr[6]  := DigitalOutputs.Fct.Auxiliary;
    V_CSM_bs.Device.info.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[10] := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[11] := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[12] := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[13] := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[14] := V_CSM_binRsev;
    V_CSM_bs.Device.info.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.device.infoflag := TO_BOOL(V_CSM_bs.device.info.i);
    
    (* Case Sensor/Actuator Alarms *)
    
    V_CSM_bs.Device.alarm.arr[0]  := Alarms.Al.Al_PrbBroken[1].Info.Active; // Probe Broken Error -1
    V_CSM_bs.Device.alarm.arr[1]  := Alarms.Al.Al_PrbBroken[2].Info.Active; // Probe Broken Error -2
    V_CSM_bs.Device.alarm.arr[2]  := Alarms.Al.Al_PrbBroken[3].Info.Active; // Probe Broken Error -3
    V_CSM_bs.Device.alarm.arr[3]  := Alarms.Al.Al_PrbBroken[4].Info.Active; // Probe Broken Error -4
    V_CSM_bs.Device.alarm.arr[4]  := Alarms.Al.Al_PrbBroken[5].Info.Active; // Probe Broken Error -5
    V_CSM_bs.Device.alarm.arr[5]  := Alarms.Al.Al_PrbBroken[6].Info.Active; // Probe Broken Error -6
    V_CSM_bs.Device.alarm.arr[6]  := Alarms.Al.Al_PrbBroken[7].Info.Active; // Probe Broken Error -7
    V_CSM_bs.Device.alarm.arr[7]  := Alarms.Al.Al_PrbBroken[8].Info.Active; // Probe Broken Error -8
    V_CSM_bs.Device.alarm.arr[8]  := Alarms.Al.Al_SerialInputs[1].Info.Active; // Serial Input Error -1
    V_CSM_bs.Device.alarm.arr[9]  := Alarms.Al.Al_SerialInputs[2].Info.Active; // Serial Input Error -2
    V_CSM_bs.Device.alarm.arr[10] := Alarms.Al.Al_SerialInputs[3].Info.Active; // Serial Input Error -3
    V_CSM_bs.Device.alarm.arr[11] := Alarms.Al.Al_SerialInputs[4].Info.Active; // Serial Input Error -4
    V_CSM_bs.Device.alarm.arr[12] := V_CSM_binRsev;
    V_CSM_bs.Device.alarm.arr[13] := V_CSM_binRsev;
    V_CSM_bs.Device.alarm.arr[14] := V_CSM_binRsev;
    V_CSM_bs.Device.alarm.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.device.alarmflag := TO_BOOL(V_CSM_bs.device.alarm.i);
    
    (*Case Compressor Info*)
    
    V_CSM_bs.comp.info.arr[0]  := DigitalOutputs.Fct.Solenoid;
    V_CSM_bs.comp.info.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[10] := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[11] := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[12] := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[13] := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[14] := V_CSM_binRsev;
    V_CSM_bs.comp.info.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.comp.infoflag := TO_BOOL(V_CSM_bs.comp.info.i);
    
    (* Case Compressor Alarms *)
    
    V_CSM_bs.comp.alarm.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[10] := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[11] := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[12] := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[13] := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[14] := V_CSM_binRsev;
    V_CSM_bs.comp.alarm.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.comp.alarmflag := TO_BOOL(V_CSM_bs.comp.alarm.i);
    
    (*Case Condensor Info*)
    
    V_CSM_bs.cond.info.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[10] := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[11] := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[12] := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[13] := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[14] := V_CSM_binRsev;
    V_CSM_bs.cond.info.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.cond.infoflag := TO_BOOL(V_CSM_bs.cond.info.i);
    
    (* Case Condensor Alarms *)
    
    V_CSM_bs.cond.alarm.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[10] := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[11] := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[12] := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[13] := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[14] := V_CSM_binRsev;
    V_CSM_bs.cond.alarm.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.cond.alarmflag := TO_BOOL(V_CSM_bs.cond.alarm.i);
    
    (*Case Evaporator Info*)
    
    V_CSM_bs.evap.info.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[10] := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[11] := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[12] := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[13] := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[14] := V_CSM_binRsev;
    V_CSM_bs.evap.info.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.evap.infoflag := TO_BOOL(V_CSM_bs.evap.info.i);
    
    (* Case Evaporator Alarms *)
    
    V_CSM_bs.evap.alarm.arr[0]  := Alarms.Al.Al_LowTemp2.Info.Active;
    V_CSM_bs.evap.alarm.arr[1]  := Alarms.Al.Al_HiTemp2.Info.Active;
    V_CSM_bs.evap.alarm.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[10] := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[11] := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[12] := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[13] := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[14] := V_CSM_binRsev;
    V_CSM_bs.evap.alarm.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.evap.alarmflag := TO_BOOL(V_CSM_bs.evap.alarm.i);
    
    (*Case Metering Info*)
    
    V_CSM_bs.Metering.info.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[10] := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[11] := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[12] := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[13] := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[14] := V_CSM_binRsev;
    V_CSM_bs.Metering.info.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.metering.infoflag := TO_BOOL(V_CSM_bs.metering.info.i);
    
    (* Case Metering Alarms *)
    
    V_CSM_bs.Metering.alarm.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[10] := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[11] := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[12] := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[13] := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[14] := V_CSM_binRsev;
    V_CSM_bs.Metering.alarm.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.metering.alarmflag := TO_BOOL(V_CSM_bs.metering.alarm.i);
    
    (*Case Communication Info*)
    
    V_CSM_bs.Comm.info.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[10] := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[11] := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[12] := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[13] := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[14] := V_CSM_binRsev;
    V_CSM_bs.Comm.info.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.comm.infoflag := TO_BOOL(V_CSM_bs.comm.info.i);
    
    (* Case Communication Alarms *)
    
    V_CSM_bs.Comm.alarm.arr[0]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[1]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[2]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[3]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[4]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[5]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[6]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[7]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[8]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[9]  := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[10] := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[11] := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[12] := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[13] := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[14] := V_CSM_binRsev;
    V_CSM_bs.Comm.alarm.arr[15] := V_CSM_binRsev;
    
    V_CSM_bs.comm.alarmflag := TO_BOOL(V_CSM_bs.comm.alarm.i);
    
END_PROGRAM
   