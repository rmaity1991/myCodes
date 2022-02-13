USING libs.AinMng;
USING libs.IOMng_Basic;
USING System.IO;
USING System.UI;
USING System;



(**
    Initial Creation:
    3/5/2020
    Joshua Meduoye
    Component Level B
    Dover Food and Retail Output Management
        ******
        This component is focused on software development on getting Output out of the system
        There are 2 major parts
        
        1. Features 
            Features contain software focused on creating new functionality
            
        2. Diagnostics 
            Diagnostics are focused on failure detection and troubleshooting
               
        ******
**)

PROGRAM DFR_OutputMng
yConfig[1].mode_type := LIB_IO_OUT_0_10V;
y[1] := TO_UINT(AnalogOutputs.Fct.Valve);
    
//Outputs for EOL 

Custom_DrainHeaterOutput :=  V_OM_DRAINHEAT_FLAG;
Custom_RailHeaterOutput := V_OM_RailHeaters_Flag;
Custom_FansOutput :=  V_OM_Fans_Flag;  
Custom_LightOutput :=  V_OM_Light_Flag; 
ManDfr := V_OM_Defrost_Flag; 
CompCmd := V_OM_Solenoid_Flag;
Custom_ValveModulOutput := V_OM_pc_Valve;
Custom_HeatersModulOutput := V_OM_pc_Rails;


IF DFR_Mode.In AND NOT (T_CSM_EOL_Exit) THEN
    IF CompCmd = TRUE THEN
        CmdComp := 2;
    ELSE
        CmdComp := 0;
    END_IF;
ELSE
    CmdComp := 1;
END_IF;
    
// Digital Output
    
V_OM_Solenoid_Flag := (DFR_EOLTestMngInstance.out_solenoid_flag AND P_CompProtectionInstance.out_solenoid_flag);
V_OM_Defrost_Flag := DFR_EOLTestMngInstance.out_defrost_flag;
V_OM_DrainHeat_Flag := DFR_EOLTestMngInstance.out_drainheater_flag;
V_OM_Fans_Flag := DFR_EOLTestMngInstance.out_fans_flag;
V_OM_Light_Flag := DFR_EOLTestMngInstance.out_lights_flag;
V_OM_RailHeaters_Flag := DFR_EOLTestMngInstance.out_railheater_flag;

// Analog Output
V_OM_pc_Valve := DFR_EOLTestMngInstance.out_pc_valve;
V_OM_pc_Rails := DFR_EOLTestMngInstance.out_pc_rails;
    
END_PROGRAM