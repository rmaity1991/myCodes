USING Libs.PID_Incr;
USING System.Timer;
USING System;
USING Libs.Hysteresis;

NAMESPACE LibraryNamespaceAndVersion

PROGRAM HeatersMng
    VAR
        HeatersPID : PID_Incr;
        
        ActiveTON, PeriodTON : TON;
        ActiveTIME, PeriodTIME : TIME;
        
        MinOut, MaxOut, SafeKP : REAL;
        
        Ti_RailHeaters : UINT;
        
        {ATTRIBUTE UOM CELSIUS}
        CutOff : REAL;
        CutOffHyst : HysterAdv;
    END_VAR
    
    VAR_TEMP
        ManModePID_en : BOOL;
        ManModePID_val : REAL;
    END_VAR
    
    //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;    
    
    IF firstCycle THEN
        RETURN;
    END_IF;

    IF UnitOn THEN
        MaxOut := 100.0;
        MinOut := 10.0;
        CutOff := 5.0;
        
        // Avoid division by Zero
        IF HeatersDiff > 0 THEN
            
            IF Ain_Cfg.Fct.GlassT.ch <> 0 THEN
                Ti_RailHeaters := 600;
            ELSE
                Ti_RailHeaters := 0;
            END_IF;            
            
            SafeKP := (MaxOut - MinOut) / HeatersDiff;
            
//            HeatersPID(RegVar_PID_Incr := Probes.Prb.GlassT, SetP_PID_Incr := Probes.Prb.DewPoint + HeaterOffs,
//                DeadBand_PID_Incr := 0.0, Kp_PID_Incr := SafeKP, Ti_PID_Incr := Ti_RailHeaters, Td_PID_Incr := 0,
//                LowLim_PID_Incr := MinOut, HighLim_PID_Incr := MaxOut, Period_PID_Incr := 500, CoolHeatMode_PID_Incr := TRUE,
//                RevMode_PID_Incr := FALSE, ManModeVal_PID_Incr := 100.0, En_ManMode_PID_Incr := Probes.Prb.GlassT <= Probes.Prb.DewPoint + HeaterOffs,
//                En_PID_Incr := TRUE);
            
            IF AnalogInputs.Fct.GlassT <= AnalogInputs.Fct.DewPoint + HeaterOffs THEN
                ManModePID_en := TRUE;
                ManModePID_val := 100.0;
            ELSIF (AnalogInputs.Fct.GlassT >= AnalogInputs.Fct.DewPoint + HeaterOffs + HeatersDiff) AND
                    (AnalogInputs.Fct.GlassT <= AnalogInputs.Fct.DewPoint + HeaterOffs + HeatersDiff + 5) THEN
                ManModePID_en := TRUE;
                ManModePID_val := 10.0;
            ELSE
                ManModePID_en := FALSE;                
            END_IF;
            
            HeatersPID(RegVar_PID_Incr := AnalogInputs.Fct.GlassT, SetP_PID_Incr := AnalogInputs.Fct.DewPoint + HeaterOffs,
                DeadBand_PID_Incr := 0.0, Kp_PID_Incr := SafeKP, Ti_PID_Incr := Ti_RailHeaters, Td_PID_Incr := 0,
                LowLim_PID_Incr := MinOut, HighLim_PID_Incr := MaxOut, Period_PID_Incr := 500, CoolHeatMode_PID_Incr := FALSE,
                RevMode_PID_Incr := TRUE, ManModeVal_PID_Incr := ManModePID_val, En_ManMode_PID_Incr := ManModePID_en,
                En_PID_Incr := TRUE);
            
            HeatersOut := TO_USINT(HeatersPID.Req_PID_Incr);
            
            CutOffHyst(
                In        := AnalogInputs.Fct.GlassT,
            	SetP      := AnalogInputs.Fct.DewPoint + HeaterOffs + HeatersDiff + CutOff,
            	DiffLeft  := 1.0,
            	DiffRight := 0.0,
            	Reverse   := TRUE
            );
            
            IF NOT CutOffHyst.Out THEN
                HeatersOut := 0;
            END_IF;
        ELSE
            
            ActiveTIME := TO_TIME(TO_REAL(TO_DINT(ManHeaterPeriod) * 1000 * 60) * TO_REAL(ManHeaterPerc) / 100.0);
            ActiveTON(IN := NOT PeriodTON.Q, PT := ActiveTIME);
            PeriodTIME := TO_TIME(TO_DINT(ManHeaterPeriod) * 1000 * 60);
            PeriodTON(IN := NOT PeriodTON.Q, PT := PeriodTIME);
            
            IF NOT ActiveTON.Q THEN
                HeatersOut := 100;
            ELSE
                HeatersOut := 0;
            END_IF;
//            SafeKP := 999;
        END_IF;      
    ELSE
        // Turn OFF
        HeatersOut := 0;
    END_IF;    
END_PROGRAM
    
END_NAMESPACE
