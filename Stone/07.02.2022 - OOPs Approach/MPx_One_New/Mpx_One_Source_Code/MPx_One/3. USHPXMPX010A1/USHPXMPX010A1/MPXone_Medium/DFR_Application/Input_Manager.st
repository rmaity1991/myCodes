USING libs.AinMng;
USING System;
USING libs.IOMng_Basic;
USING System.IO;
USING System.UI;
USING Libs.IOMng_Basic_v2_0_12;

(**
    Initial Creation:
    3/5/2020
    Joshua Meduoye
    Component Level B
    Dover Food and Retail Defrost Input Management
        ******
        This component is focused on software development on getting inputs into the system
        There are 2 major parts
        
        1. Features 
            Features contain software focused on creating new functionality
            
        2. Diagnostics 
            Diagnostics are focused on failure detection and troubleshooting
               
        ******
**)




(**

    +++++++++++++++++++++++++++Analog Input Sensors Processing+++++++++++++++++++++++++

    Sensor 1: Air Off Temperature Sensor        -   V_trc_Air_Off & V_trc_Air_Off_Status
    Sensor 2: Defrost Temperature Sensor        -   V_trc_Defrost & V_trc_Defrost_Status
    Sensor 3: Air On Temperature Sensor         -   V_trc_Air_On & V_trc_Air_On_Status
    Sensor 4: Suction Temperature Sensor        -   V_trc_Suction & V_trc_Suction_Status
    Sensor 5: Ambient Temperature Probe         -   V_trc_Ambient & V_trc_Ambient_Status
    Sensor 6: Ambient Humidity Sensor           -   V_pc_Rh_Ambient & V_pc_Rh_Ambient_Status
    Sensor 7: Drain Temperature Sensor          -   V_trc_Drain & V_trc_Drain_Status
    Sensor 8: Case R Humidity Sensor            -   V_pc_Rh_Case & V_pc_Rh_Case_Status
    Sensor 9: Glass Temperature Sensor          -   V_trc_Glass & V_trc_Glass_Status
    Sensor 10: Evaporator Temperature Sensor    -   V_trc_Evap  &  V_trc_Evap_Status
    Sensor 11: Coil Outlet Pressure             -   V_prg_Coil_Out & V_prg_Coil_Out_Status
    Sensor 12: Frame Temp Sensor                -   V_trc_Frame & V_trc_Frame_Status

**)


(**

    +++++++++++++++++++++Digital Input Sensors Processing++++++++++++++++++++++

    Sensor 1: Door Switch        -  V_pt_Door_Open & V_pt_Door_Open_Status
    Sensor 2: Clean Switch       -  V_pt_Case_Clean & V_pt_Case_Clean_Status
    Sensor 3: Occupancy Sensor   -  V_pt_Occ_Detect & V_pt_Occ_Detect_Status
    Sensor 4: Service Switch     -  V_pt_Service & V_pt_Service_Status
    Sensor 5: Multi-purpose Input Functions   -   V_bt_DIn_Trigger 
    
**)

(**

    Sensor Fail Working Mechanism
    
    DFR_Sensor_Status
    
    
    Data_Valid   = 0            //means there is a sensor without any errors giving accurate values
    Data_Valid_Remote  = -1     //Means that this value is recieving input from a remote device
    Data_Error_Model_High = -2  //means that the sensor is bad but there is a model developed supplying high accuracy values
    Data_Error_Model_Low = -3   //means that the sensor is bad but there is a model that gives low confidence values
    Data_Error_Default = -4    //means that the sensor has an issue but there is an default acceptable value that meets system expectations
    Data_Error_Suspect = -5  //Means Sensor is connected but is suspected to be broadcasting wrong values
    Data_Error_Timeout = -6   //Means that a sensor is possibly not connected
    Data_Error_NotUsed =-7 //Means that a sensor is not used or configured

**)


(**



++++++++++++++++++++++++++++++++++++Analog Input Processing++++++++++++++++++++++++++++++++++++

**)


PROGRAM DFR_AnalogInputsProcessing
    /*
    uConfig[1].mode_sel := LIB_IO_AIN;
    uConfig[1].mode_type := LIB_IO_PROBE_NTC;
    AnalogInputs.Fct.SuctT := u[1].r;
    Ain_Cfg.Fct.SuctT.Ch := 1;
    //uConfig[4].mode_sel := LIB_IO_AIN;
    //uConfig[4].mode_type := LIB_IO_PROBE_0_10V;
    AnalogInputs.Fct.EvapP := u[4].r;
    Ain_Cfg.Fct.EvapP.Ch := 4;
    
    AnalogInputs.Fct.AirOff := u[2].r;
    Ain_Cfg.Fct.AirOff.Ch := 2;
    
    AnalogInputs.Fct.Defrost := u[3].r;
    Ain_Cfg.Fct.Defrost.Ch := 3;
    */
(**

    Analog Input Sensors Processing 

    Sensor 1: Air Off Temperature Sensor        -   V_IM_trc_AirOff & V_IM_trc_AirOff_Status

**)
    
    V_IM_trc_AirOff := AnalogInputs.Fct.AirOff;
    IF Ain_Cfg.Fct.AirOff.Ch=0 THEN
        V_IM_trc_AirOff_Status := -7;
    ELSIF Ain_Err.Fct.AirOff.Error>0 THEN
       V_IM_trc_AirOff_Status := TO_SINT(Ain_Err.Fct.AirOff.Error) ; 
    ELSE V_IM_trc_AirOff_Status := 0;
    END_IF;
    
    
    
    

(**

    Analog Input Sensors Processing 

    
    Sensor 2: Defrost Temperature Sensor        -   V_IM_trc_Defrost & V_IM_trc_Defrost_Status
    

**)

    V_IM_trc_Defrost := AnalogInputs.Fct.Defrost;
    IF Ain_Cfg.Fct.Defrost.Ch=0 THEN
        V_IM_trc_Defrost_Status := -7;
    ELSIF Ain_Err.Fct.Defrost.Error>0 THEN
        V_IM_trc_Defrost_Status := TO_SINT(Ain_Err.Fct.Defrost.Error);
    ELSE V_IM_trc_Defrost_Status := 0;
    
    END_IF;    
    
(**

    Analog Input Sensors Processing 


    Sensor 3: Air On Temperature Sensor         -   V_trc_Air_On & V_trc_Air_On_Status
    

**)

    V_IM_trc_AirOn := AnalogInputs.Fct.AirOn;
    IF Ain_Cfg.Fct.AirOn.Ch=0 THEN
        V_IM_trc_AirOn_Status := -7;
    ELSIF Ain_Err.Fct.AirOn.Error>0 THEN
       V_IM_trc_AirOn_Status := TO_SINT(Ain_Err.Fct.AirOn.Error);
    ELSE V_IM_trc_AirOn_Status := 0;
    
    END_IF; 
(**

    Analog Input Sensors Processing 



    Sensor 4: Suction Temperature Sensor        -   V_trc_Suction & V_trc_Suction_Status


**)

    V_IM_trc_Suction := AnalogInputs.Fct.SuctT;
    IF Ain_Cfg.Fct.SuctT.Ch=0 THEN
        V_IM_trc_Suction_Status := -7;
    ELSIF Ain_Err.Fct.SuctT.Error>0 THEN
        V_IM_trc_Suction_Status := TO_SINT(Ain_Err.Fct.SuctT.Error); 
    ELSE V_IM_trc_Suction_Status := 0;
    
    END_IF; 
    
(**

    Analog Input Sensors Processing 

    
    Sensor 5: Ambient Temperature Probe         -   V_trc_Ambient & V_trc_Ambient_Status


**)
    V_IM_trc_Ambient := AnalogInputs.Fct.AmbientT;
    IF Ain_Cfg.Fct.AmbientT.Ch=0 THEN
        V_IM_trc_Ambient_Status := -7;
    ELSIF Ain_Err.Fct.Defrost.Error>0 THEN
        V_IM_trc_Ambient_Status := TO_SINT(Ain_Err.Fct.AmbientT.Error);
    ELSE V_IM_trc_Ambient_Status := 0;
    
    END_IF; 

(**

    Analog Input Sensors Processing 

    
    Sensor 6: Ambient Humidity Sensor           -   V_IM_pc_RhAmbient & V_IM_pc_RhAmbient_Status


**)
    V_IM_pc_RhAmbient := AnalogInputs.Fct.AmbientH;
    IF Ain_Cfg.Fct.AmbientH.Ch=0 THEN
        V_IM_pc_RhAmbient_Status := -7;
    ELSIF Ain_Err.Fct.Defrost.Error>0 THEN
        V_IM_pc_RhAmbient_Status := TO_SINT(Ain_Err.Fct.AmbientH.Error);
    ELSE V_IM_pc_RhAmbient_Status := 0;
    
    END_IF; 

(**

    Analog Input Sensors Processing 

    
    Sensor 7: Glass Temperature Sensor         -   V_IM_trc_Drain & V_IM_trc_Drain_Status


**)
    V_IM_trc_Glass := AnalogInputs.Fct.GlassT;
    IF Ain_Cfg.Fct.GlassT.Ch=0 THEN
        V_IM_trc_Glass_Status := -7;
    ELSIF Ain_Err.Fct.GlassT.Error>0 THEN
         V_IM_trc_Glass_Status := TO_SINT(Ain_Err.Fct.GlassT.Error);
    ELSE V_IM_trc_Glass_Status := 0;
    
    END_IF; 
(**

    Analog Input Sensors Processing 


    Sensor 8: Evaporator Pressure in Bar            -   V_IM_bar_Evap & V_IM_bar_Evap_Status

**)

    V_IM_bar_Evap := AnalogInputs.Fct.EvapP;
    IF Ain_Cfg.Fct.EvapP.Ch=0 THEN
        V_IM_bar_Evap_Status := -7;
    ELSIF Ain_Err.Fct.EvapP.Error>0 THEN
        V_IM_bar_Evap_Status := TO_SINT(Ain_Err.Fct.EvapP.Error);
    ELSE V_IM_bar_Evap_Status := 0;
    END_IF; 
(**

    Analog Input Sensors Processing 


    Sensor 9: Dewpoint Temperature Sensor in Celcius         -   V_IM_trc_DewPoint & V_IM_trc_DewPoint_Status

    
**)
    V_IM_trc_DewPoint := AnalogInputs.Fct.DewPoint;
    IF Ain_Cfg.Fct.DewPoint.Ch=0 THEN
        V_IM_trc_DewPoint_Status := -7;
    ELSIF Ain_Err.Fct.DewPoint.Error>0 THEN
        V_IM_trc_DewPoint_Status := TO_SINT(Ain_Err.Fct.DewPoint.Error); 
    ELSE V_IM_trc_DewPoint_Status := 0;
    
    END_IF;
(**

    Analog Input Sensors Processing 

    
    Sensor 10: Defrost II Temperature Sensor    -   V_IM_trc_Defrost2  &  V_IM_trc_Defrost2_Status


**)
    V_IM_trc_Defrost2 := AnalogInputs.Fct.Defrost2;
    IF Ain_Cfg.Fct.Defrost2.Ch=0 THEN
        V_IM_trc_Defrost2_Status := -7;
    ELSIF Ain_Err.Fct.Defrost2.Error>0 THEN
        V_IM_trc_Defrost2_Status := TO_SINT(Ain_Err.Fct.Defrost2.Error);
    ELSE V_IM_trc_Defrost2_Status := 0;
    
    END_IF;    
    
(**

    Analog Input Sensors Processing 


    Sensor 11: Auxiliary Temp Probe             -   V_IM_trc_Aux & V_IM_trc_Aux_Status


**)
    V_IM_trc_Aux := AnalogInputs.Fct.Auxiliary;
    IF Ain_Cfg.Fct.Auxiliary.Ch=0 THEN
        V_IM_trc_Aux_Status := -7;
    ELSIF Ain_Err.Fct.Auxiliary.Error>0 THEN
        V_IM_trc_Aux_Status := TO_SINT(Ain_Err.Fct.Auxiliary.Error);
    ELSE V_IM_trc_Aux_Status := 0;
    
    END_IF;    
    
(**

    Analog Input Sensors Processing 


    Sensor 12: Auxiliary Temp Probe 2           -   V_IM_trc_Aux2 & V_IM_trc_Aux2_Status

**)
    V_IM_trc_Aux2 := AnalogInputs.Fct.Auxiliary2;
    IF Ain_Cfg.Fct.Auxiliary2.Ch=0 THEN
        V_IM_trc_Aux2_Status := -7;
    ELSIF Ain_Err.Fct.Auxiliary2.Error>0 THEN
        V_IM_trc_Aux2_Status := TO_SINT(Ain_Err.Fct.Auxiliary2.Error);
    ELSE V_IM_trc_Aux2_Status := 0;
    
    END_IF;

END_PROGRAM


(**



++++++++++++++++++++++++++++++++++++Digital Input Processing++++++++++++++++++++++++++++++++++++

**)

PROGRAM DFR_Digital_Inputs_Processing
    

    V_IM_Alarm_Flag := DigitalInputs.Fct.Alarm;
    
    IF  Din_Cfg.Fct.Alarm.Ch=0 THEN
        V_IM_Alarm_Flag_Status := -7;
    ELSIF Din_Err.Fct.Auxiliary.Error>0 THEN
        V_IM_Alarm_Flag_Status := TO_SINT(Din_Err.Fct.Alarm.Error);
    ELSE V_IM_Alarm_Flag_Status := 0;
    
    END_IF;
    
    V_IM_Auxiliary_Flag := DigitalInputs.Fct.Auxiliary;
    
    IF  Din_Cfg.Fct.Auxiliary.Ch=0 THEN
        V_IM_Auxiliary_Flag_Status := -7;
    ELSIF Din_Err.Fct.Auxiliary.Error>0 THEN
        V_IM_Auxiliary_Flag_Status := TO_SINT(Din_Err.Fct.Auxiliary.Error);
    ELSE V_IM_Auxiliary_Flag_Status := 0;
    
    END_IF;
    
    V_IM_CallDfr_Flag := DigitalInputs.Fct.CallDfr;
    
    IF  Din_Cfg.Fct.CallDfr.Ch=0 THEN
        V_IM_CallDfr_Flag_Status := -7;
    ELSIF Din_Err.Fct.CallDfr.Error >0 THEN
        V_IM_CallDfr_Flag_Status := TO_SINT(Din_Err.Fct.CallDfr.Error);
    ELSE V_IM_CallDfr_Flag_Status := 0;
    
    END_IF;
    
    V_IM_Clean_Flag := DigitalInputs.Fct.Clean;

    IF  Din_Cfg.Fct.Clean.Ch=0 THEN
        V_IM_Clean_Flag_Status := -7;
    ELSIF Din_Err.Fct.Clean.Error >0 THEN
        V_IM_Clean_Flag_Status := TO_SINT(Din_Err.Fct.Clean.Error);
    ELSE V_IM_Clean_Flag_Status := 0;
    
    END_IF;

    
    V_IM_Config_Flag := DigitalInputs.Fct.Config;
    
    IF  Din_Cfg.Fct.Config.Ch=0 THEN
        V_IM_Config_Flag_Status := -7;
    ELSIF Din_Err.Fct.Config.Error >0 THEN
        V_IM_Config_Flag_Status := TO_SINT(Din_Err.Fct.Config.Error);
    ELSE V_IM_Config_Flag_Status := 0;
    
    END_IF;
    
    V_IM_ContCycle_Flag := DigitalInputs.Fct.ContCycle;

    IF  Din_Cfg.Fct.ContCycle.Ch=0 THEN
        V_IM_ContCycle_Flag_Status := -7;
    ELSIF Din_Err.Fct.ContCycle.Error >0 THEN
        V_IM_ContCycle_Flag_Status := TO_SINT(Din_Err.Fct.ContCycle.Error);
    ELSE V_IM_ContCycle_Flag_Status := 0;
    
    END_IF;

    V_IM_Curtain_Flag := DigitalInputs.Fct.Curtain;

    IF  Din_Cfg.Fct.Curtain.Ch=0 THEN
        V_IM_Curtain_Flag_Status := -7;
    ELSIF Din_Err.Fct.Curtain.Error >0 THEN
        V_IM_Curtain_Flag_Status := TO_SINT(Din_Err.Fct.Curtain.Error);
    ELSE V_IM_Curtain_Flag_Status := 0;
    
    END_IF;
    
    V_IM_DefrostMirror_Flag := DigitalInputs.Fct.DefrostMirror;
    
    IF  Din_Cfg.Fct.DefrostMirror.Ch=0 THEN
        V_IM_DefrostMirror_Flag_Status := -7;
    ELSIF Din_Err.Fct.DefrostMirror.Error >0 THEN
        V_IM_DefrostMirror_Flag_Status := TO_SINT(Din_Err.Fct.DefrostMirror.Error);
    ELSE V_IM_DefrostMirror_Flag_Status := 0;
    
    END_IF;
    
    V_IM_DelayedAl_Flag := DigitalInputs.Fct.DelayedAl;

    IF  Din_Cfg.Fct.DelayedAl.Ch=0 THEN
        V_IM_DelayedAl_Flag_Status := -7;
    ELSIF Din_Err.Fct.DelayedAl.Error >0 THEN
        V_IM_DelayedAl_Flag_Status := TO_SINT(Din_Err.Fct.DelayedAl.Error);
    ELSE V_IM_DelayedAl_Flag_Status := 0;
    
    END_IF;

    V_IM_DoorOff_Flag  := DigitalInputs.Fct.DoorOff;
    
    IF  Din_Cfg.Fct.DoorOff.Ch=0 THEN
        V_IM_DoorOff_Flag_Status := -7;
    ELSIF Din_Err.Fct.DoorOff.Error >0 THEN
        V_IM_DoorOff_Flag_Status := TO_SINT(Din_Err.Fct.DoorOff.Error);
    ELSE V_IM_DoorOff_Flag_Status := 0;
    
    END_IF;
    
    V_IM_DoorOn_Flag := DigitalInputs.Fct.DoorOn;
    
    IF  Din_Cfg.Fct.DoorOn.Ch=0 THEN
        V_IM_DoorOn_Flag_Status := -7;
    ELSIF Din_Err.Fct.DoorOn.Error >0 THEN
        V_IM_DoorOn_Flag_Status := TO_SINT(Din_Err.Fct.DoorOn.Error);
    ELSE V_IM_DoorOn_Flag_Status := 0;
    
    END_IF;
    
    V_IM_EnDfr_Flag := DigitalInputs.Fct.EnDfr;
    
    IF  Din_Cfg.Fct.EnDfr.Ch=0 THEN
        V_IM_EnDfr_Flag_Status := -7;
    ELSIF Din_Err.Fct.EnDfr.Error >0 THEN
        V_IM_EnDfr_Flag_Status := TO_SINT(Din_Err.Fct.EnDfr.Error);
    ELSE V_IM_EnDfr_Flag_Status := 0;
    
    END_IF;
    
    V_IM_GenFctAlrm_Flag := DigitalInputs.Fct.GenFctAlrm;
    
    IF  Din_Cfg.Fct.GenFctAlrm.Ch=0 THEN
        V_IM_GenFctAlrm_Flag_Status := -7;
    ELSIF Din_Err.Fct.GenFctAlrm.Error >0 THEN
        V_IM_GenFctAlrm_Flag_Status := TO_SINT(Din_Err.Fct.GenFctAlrm.Error);
    ELSE V_IM_GenFctAlrm_Flag_Status := 0;
    
    END_IF;
    
    V_IM_RemoteOff_Flag := DigitalInputs.Fct.RemoteOff;
    
    IF  Din_Cfg.Fct.RemoteOff.Ch=0 THEN
        V_IM_RemoteOff_Flag_Status := -7;
    ELSIF Din_Err.Fct.RemoteOff.Error >0 THEN
        V_IM_RemoteOff_Flag_Status := TO_SINT(Din_Err.Fct.RemoteOff.Error);
    ELSE V_IM_RemoteOff_Flag_Status := 0;
    
    END_IF;
    
    V_IM_Standby_Flag := DigitalInputs.Fct.Standby;

    IF  Din_Cfg.Fct.Standby.Ch=0 THEN
        V_IM_Standby_Flag_Status := -7;
    ELSIF Din_Err.Fct.Standby.Error >0 THEN
        V_IM_Standby_Flag_Status := TO_SINT(Din_Err.Fct.Standby.Error);
    ELSE V_IM_Standby_Flag_Status := 0;
    
    END_IF;
    
    V_IM_Timed_Flag := DigitalInputs.Fct.Timed;
    
    IF  Din_Cfg.Fct.Timed.Ch=0 THEN
        V_IM_Timed_Flag_Status := -7;
    ELSIF Din_Err.Fct.Timed.Error >0 THEN
        V_IM_Timed_Flag_Status := TO_SINT(Din_Err.Fct.Timed.Error);
    ELSE V_IM_Timed_Flag_Status := 0;
    
    END_IF;
    
END_PROGRAM
