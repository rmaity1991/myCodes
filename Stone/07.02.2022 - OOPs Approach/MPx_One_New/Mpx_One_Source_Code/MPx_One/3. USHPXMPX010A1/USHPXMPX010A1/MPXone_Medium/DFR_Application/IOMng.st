USING System;
USING System.Timer;
USING libs.AinMng;
USING libs.IOMng_Basic;
USING System.IO;
USING System.UI;


PROGRAM IOMng
    //Analog Input 1
    uConfig[1].mode_sel := LIB_IO_AIN;
    uConfig[1].mode_type := LIB_IO_PROBE_NTC;
    AnalogInputs.Fct.SuctT := u[1].r;
    Ain_Cfg.Fct.SuctT.Ch := 1;
    
    //Analog Input 4
    uConfig[4].mode_sel := LIB_IO_AIN;
    uConfig[4].mode_type := LIB_IO_PROBE_0_10V;
    AnalogInputs.Fct.EvapP := u[4].r;
    Ain_Cfg.Fct.EvapP.Ch := 4;
    
    //Analog Input 2
    
    uConfig[2].mode_sel := LIB_IO_AIN;
    uConfig[2].mode_type := LIB_IO_PROBE_NTC_0_150;
    AnalogInputs.Fct.GlassT := u[2].r;
    
    //Analog Input 3
    
    uConfig[3].mode_sel := LIB_IO_AIN;
    uConfig[3].mode_type := LIB_IO_PROBE_NTC_0_150;
    AnalogInputs.Fct.AirOn := u[3].r;
        
    
END_PROGRAM