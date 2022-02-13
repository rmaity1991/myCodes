USING Libs.IOMng_Basic;
USING Libs.Alarm_Mng;
USING System.Alarm;

VAR_GLOBAL CONSTANT
	(**Number of functions that can be assigned to Analog Inputs*)
	AIN_NUM : USINT := 12;
	(**Number of function that can be assignet to an Analog Output*)
	AOUT_NUM : USINT := 4;
	(**Number of functions that can be assigned to Digital Inputs*)
	DIN_NUM : USINT := 16;
    (**Number of functions that can be assigned to Digital Outputs*)
{IF NOT DEF(MPXONE_BASIC)}
    DOUT_NUM : USINT := 17;
{ELSE}
    DOUT_NUM : USINT := 14;
{ENDIF}
END_VAR

TYPE 
    
    
    
{REGION AnalogInputs}
    
    AinUnion: UNION
        Fct : AinStruct;
        Arr : ARRAY[1..AIN_NUM] OF REAL;
    END_UNION;
    
    AinStruct: STRUCT
        // Index 1 = AirOff
        (**Outlet temperature probe (Sm)*)
        {ATTRIBUTE UOM CELSIUS}
        AirOff      : REAL;
        // Index 2 = Defrost
        (**Defrost temperature probe (Sd)*)
        {ATTRIBUTE UOM CELSIUS}
        Defrost     : REAL;
        // Index 3 = AirOn
        (**Intake temperature probe (Sr)*)
        {ATTRIBUTE UOM CELSIUS}
        AirOn       : REAL;
        // Index 4 = SuctT
        (**Suction temperature probe (tGs)*)
        {ATTRIBUTE UOM CELSIUS}
        SuctT       : REAL;
        // Index 5 = EvapP
        (**Evaporator pressure probe (PEu)*)
        {ATTRIBUTE UOM BAR}
        EvapP       : REAL;
        // Index 6 = Defrost2
        (**Defrost temperature probe 2 (Sd2)*)
        {ATTRIBUTE UOM CELSIUS}
        Defrost2    : REAL;
        // Index 7 = Auxiliary
        (**Auxiliary temperature probe (Aux)*)
        {ATTRIBUTE UOM CELSIUS}
        Auxiliary   : REAL;
        // Index 8 = Auxiliary2
        (**Auxiliary temperature probe 2 (Aux2)*)
        {ATTRIBUTE UOM CELSIUS}
        Auxiliary2  : REAL;
        // Index 9 = AmbientT
        (**Ambient temperature probe (SA)*)
        {ATTRIBUTE UOM CELSIUS}
        AmbientT    : REAL;
        // Index 10 = AmbientH
        (**Ambient humidity probe (SU)*)
        {ATTRIBUTE UOM PERCENT_rH}
        AmbientH    : REAL;
        // Index 11 = GlassT
        (**Glass temperature probe (Svt)*)
        {ATTRIBUTE UOM CELSIUS}
        GlassT      : REAL;
        // Index 12 = DewPoint
        (**Dewpoint value (Sdp)*)
        {ATTRIBUTE UOM CELSIUS}
        DewPoint    : REAL;
        
        // ADD HERE ANY ADDICTIONAL PROBE THEN :
        // 1) INCREASE THE VALUE OF DEFINITON PRB_NUM
        // 2) ADD DEFAULT VALUE OF CHANNEL CONFIGURATION IN PrbChannels DEFLARATION
        // 3) FROM GLOBAL VARIABLE VIEW FLAG THE NEW PROBE AS PARAMETER AND NFC
        
    END_STRUCT;
    
    AinCfgUnion: UNION
        Fct : AinCfgStruct;
        Arr : ARRAY [1..AIN_NUM]  OF AinConfig;//AinCfg;
    END_UNION;
    
    AinCfgStruct: STRUCT
        // Index 1 = AirOff
        (**Outlet temperature probe (Sm)*)
        AirOff      : AinConfig;
        // Index 2 = Defrost
        (**Defrost temperature probe (Sd)*)
        Defrost     : AinConfig;
        // Index 3 = AirOn
        (**Intake temperature probe (Sr)*)
        AirOn       : AinConfig;
        // Index 4 = SuctT
        (**Suction temperature probe (tGs)*)
        SuctT       : AinConfig;
        // Index 5 = EvapP
        (**Evaporator pressure probe (PEu)*)
        EvapP       : AinConfig;
        // Index 6 = Defrost2
        (**Defrost temperature probe 2 (Sd2)*)
        Defrost2    : AinConfig;
        // Index 7 = Auxiliary
        (**Auxiliary temperature probe (Aux)*)
        Auxiliary   : AinConfig;
        // Index 8 = Auxiliary2
        (**Auxiliary temperature probe 2 (Aux2)*)
        Auxiliary2  : AinConfig;
        // Index 9 = AmbientT
        (**Ambient temperature probe (SA)*)
        AmbientT    : AinConfig;
        // Index 10 = AmbientH
        (**Ambient humidity probe (SU)*)
        AmbientH    : AinConfig;
        // Index 11 = GlassT
        (**Glass temperature probe (Svt)*)
        GlassT      : AinConfig;
        // Index 12 = DewPoint
        (**Dewpoint value (Sdp)*)
        DewPoint    : AinConfig;
    END_STRUCT;
    
    AinErrUnion: UNION
        (**Funtcions list*)
        Fct : AinErrSturct;
        Arr : ARRAY[1..AIN_NUM] OF ErrConfig;
    END_UNION;
    
    (**The structure lists all the function's error that can be associated TO Ain.*)
    AinErrSturct: STRUCT 
        // Index 1 = AirOff
        (**Outlet temperature probe (Sm)*)
        AirOff      : ErrConfig;
        // Index 2 = Defrost
        (**Defrost temperature probe (Sd)*)
        Defrost     : ErrConfig;
        // Index 3 = AirOn
        (**Intake temperature probe (Sr)*)
        AirOn       : ErrConfig;
        // Index 4 = SuctT
        (**Suction temperature probe (tGs)*)
        SuctT       : ErrConfig;
        // Index 5 = EvapP
        (**Evaporator pressure probe (PEu)*)
        EvapP       : ErrConfig;
        // Index 6 = Defrost2
        (**Defrost temperature probe 2 (Sd2)*)
        Defrost2    : ErrConfig;
        // Index 7 = Auxiliary
        (**Auxiliary temperature probe (Aux)*)
        Auxiliary   : ErrConfig;
        // Index 8 = Auxiliary2
        (**Auxiliary temperature probe 2 (Aux2)*)
        Auxiliary2  : ErrConfig;
        // Index 9 = AmbientT
        (**Ambient temperature probe (SA)*)
        AmbientT    : ErrConfig;
        // Index 10 = AmbientH
        (**Ambient humidity probe (SU)*)
        AmbientH    : ErrConfig;
        // Index 11 = GlassT
        (**Glass temperature probe (Svt)*)
        GlassT      : ErrConfig;
        // Index 12 = DewPoint
        (**Dewpoint value (Sdp)*)
        DewPoint    : ErrConfig;
    END_STRUCT;
    
    AinOffsetUnion: UNION
        Fct : AinOffsetStruct;
        Arr : ARRAY[1..AIN_NUM] OF REAL;
    END_UNION;
    
    AinOffsetStruct: STRUCT
        // Index 1 = AirOff
        (**Outlet temperature probe (Sm)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        AirOff      : REAL;
        // Index 2 = Defrost
        (**Defrost temperature probe (Sd)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        Defrost     : REAL;
        // Index 3 = AirOn
        (**Intake temperature probe (Sr)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        AirOn       : REAL;
        // Index 4 = SuctT
        (**Suction temperature probe (tGs)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        SuctT       : REAL;
        // Index 5 = EvapP
        (**Evaporator pressure probe (PEu)*)
        {ATTRIBUTE UOM BAR}
        EvapP       : REAL;
        // Index 6 = Defrost2
        (**Defrost temperature probe 2 (Sd2)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        Defrost2    : REAL;
        // Index 7 = Auxiliary
        (**Auxiliary temperature probe (Aux)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        Auxiliary   : REAL;
        // Index 8 = Auxiliary2
        (**Auxiliary temperature probe 2 (Aux2)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        Auxiliary2  : REAL;
        // Index 9 = AmbientT
        (**Ambient temperature probe (SA)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        AmbientT    : REAL;
        // Index 10 = AmbientH
        (**Ambient humidity probe (SU)*)
        {ATTRIBUTE UOM PERCENT_rH}
        AmbientH    : REAL;
        // Index 11 = GlassT
        (**Glass temperature probe (Svt)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        GlassT      : REAL;
        // Index 12 = DewPoint
        (**Dewpoint value (Sdp)*)
        {ATTRIBUTE UOM DELTACELSIUS}
        DewPoint    : REAL;
        
        // ADD HERE ANY ADDICTIONAL PROBE THEN :
        // 1) INCREASE THE VALUE OF DEFINITON PRB_NUM
        // 2) ADD DEFAULT VALUE OF CHANNEL CONFIGURATION IN PrbChannels DEFLARATION
        // 3) FROM GLOBAL VARIABLE VIEW FLAG THE NEW PROBE AS PARAMETER AND NFC
        
    END_STRUCT;
    
    (* TYPE OF probe:
        0 = PT1000 Standard Range
        1 = NTC Standard Range
        2 = 0-5 V
        3 = 4-20 mA
        4 = 0-10V
    *)    
    AinType: STRUCT
        // NTC Default
        (**Type of probe, group 1 (S1, S2, S3)*)
        {METADATA MIN_VAL 0}
        {METADATA MAX_VAL 1}
        Group1 : USINT := 1;
        // 0-5V Default
        (**Type of probe, group 2 (S4, S5)*)
        {METADATA MIN_VAL 1}
        {METADATA MAX_VAL 3}
        Group2 : USINT := 2;
        (**Type of probe, group 3 (S6)*)
        {METADATA MIN_VAL 0}
        {METADATA MAX_VAL 4}
        Group3 : USINT := 1;
        (**Type of probe, group 4 (S7)*)
        {METADATA MIN_VAL 1}
        {METADATA MAX_VAL 1}
        Group4 : USINT := 1;
        (**Type of probe, group 5 (S8)*)
        {METADATA MIN_VAL 1}
        {METADATA MAX_VAL 2}
        Group5 : USINT := 1;
        
    END_STRUCT;
    
{ENDREGION}
    
{REGION DigitalInputs}
    
    DinUnion: UNION
        Fct : DinStruct;
        Arr : ARRAY [1..DIN_NUM] OF BOOL;
    END_UNION;
        
    DinStruct: STRUCT
        // Index 1 = Immediate external alarm
        (**Immediate external alarm*)
        Alarm           : BOOL;
        // Index 2 = Delayed external alarm
        (**Delayed external alarm*)
        DelayedAl    : BOOL;
        // Index 3 = Enable defrost
        (**Enable defrost*)
        EnDfr       : BOOL;
        // Index 4 = Call defrost
        (**Call defrost*)
        CallDfr     : BOOL;
        // Index 5 = Door status - Regulation OFF
        (** Door status - Regulation OFF*)
        DoorOff         : BOOL;
        // Index 6 = Remote ON/OFF
        (**Remote ON/OFF*)
        RemoteOff           : BOOL;
        // Index 7 = Curtain switch
        (**Curtain switch*)
        Curtain         : BOOL;
        // Index 8 = Continuous cycle start/stop
        (**Continuous cycle start/stop*)
        ContCycle       : BOOL;
        // Index 9 = Auxiliary DI
        (**Auxiliary DI*)
        Auxiliary         : BOOL;
        // Index 10 = Timed digital input
        (**Timed digital input*)
        Timed           : BOOL;
        // Index 11 = Stand by switch
        (**Stand by switch*)
        Standby         : BOOL;
        // Index 12 = Clean switch
        (**Clean switch*)
        Clean           : BOOL;
        // Index 13 = Change configuration
        (**Change configuration*)
        Config          : BOOL;
        // Index 14 = Door status - Regulation ON
        (**Regulation ON*)
        DoorOn          : BOOL;
        // Index 15 = Defrost aligned with DI status
        (**Defrost aligned with DI status*)
        DefrostMirror   : BOOL;
        // Index 16 = Digital input for generic function alarm
        (**Digital input for generic function alarm*)
        GenFctAlrm   : BOOL;        
    END_STRUCT;
    
    DinCfgUnion: UNION
        Fct : DinCfgStruct;
        Arr : ARRAY [1..DIN_NUM] OF DinConfig;
    END_UNION;
    
    DinCfgStruct: STRUCT
        // Index 1 = Immediate external alarm
        (**Immediate external alarm*)
        Alarm           : DinConfig;
        // Index 2 = Delayed external alarm
        (**Delayed external alarm*)
        DelayedAl    : DinConfig;
        // Index 3 = Enable defrost
        (**Enable defrost*)
        EnDfr       : DinConfig;
        // Index 4 = Call defrost
        (**Call defrost*)
        CallDfr     : DinConfig;
        // Index 5 = Door status - Regulation OFF
        (** Door status - Regulation OFF*)
        DoorOff         : DinConfig;
        // Index 6 = Remote ON/OFF
        (**Remote ON/OFF*)
        RemoteOff           : DinConfig;
        // Index 7 = Curtain switch
        (**Curtain switch*)
        Curtain         : DinConfig;
        // Index 8 = Continuous cycle start/stop
        (**Continuous cycle start/stop*)
        ContCycle       : DinConfig;
        // Index 9 = Auxiliary DI
        (**Auxiliary DI*)
        Auxiliary         : DinConfig;
        // Index 10 = Timed digital input
        (**Timed digital input*)
        Timed           : DinConfig;
        // Index 11 = Stand by switch
        (**Stand by switch*)
        Standby         : DinConfig;
        // Index 12 = Clean switch
        (**Clean switch*)
        Clean           : DinConfig;
        // Index 13 = Change configuration
        (**Change configuration*)
        Config          : DinConfig;
        // Index 14 = Door status - Regulation ON
        (**Regulation ON*)
        DoorOn          : DinConfig;
        // Index 15 = Defrost aligned with DI status
        (**Defrost aligned with DI status*)
        DefrostMirror   : DinConfig;
        // Index 16 = Digital input for generic function alarm
        (**Digital input for generic function alarm*)
        GenFctAlrm   : DinConfig;   
    END_STRUCT;
    
    (**It is used to store Din configuration errors*)
    DinErrUnion: UNION
        (**Funtcions list*)
        Fct : DinErrSturct;
        Arr : ARRAY[1..DIN_NUM] OF ErrConfig;
    END_UNION;
    
    DinErrSturct: STRUCT
        // Index 1 = Immediate external alarm
        (**Immediate external alarm*)
        Alarm           : ErrConfig;
        // Index 2 = Delayed external alarm
        (**Delayed external alarm*)
        DelayedAl    : ErrConfig;
        // Index 3 = Enable defrost
        (**Enable defrost*)
        EnDfr       : ErrConfig;
        // Index 4 = Call defrost
        (**Call defrost*)
        CallDfr     : ErrConfig;
        // Index 5 = Door status - Regulation OFF
        (** Door status - Regulation OFF*)
        DoorOff         : ErrConfig;
        // Index 6 = Remote ON/OFF
        (**Remote ON/OFF*)
        RemoteOff           : ErrConfig;
        // Index 7 = Curtain switch
        (**Curtain switch*)
        Curtain         : ErrConfig;
        // Index 8 = Continuous cycle start/stop
        (**Continuous cycle start/stop*)
        ContCycle       : ErrConfig;
        // Index 9 = Auxiliary DI
        (**Auxiliary DI*)
        Auxiliary         : ErrConfig;
        // Index 10 = Timed digital input
        (**Timed digital input*)
        Timed           : ErrConfig;
        // Index 11 = Stand by switch
        (**Stand by switch*)
        Standby         : ErrConfig;
        // Index 12 = Clean switch
        (**Clean switch*)
        Clean           : ErrConfig;
        // Index 13 = Change configuration
        (**Change configuration*)
        Config          : ErrConfig;
        // Index 14 = Door status - Regulation ON
        (**Regulation ON*)
        DoorOn          : ErrConfig;
        // Index 15 = Defrost aligned with DI status
        (**Defrost aligned with DI status*)
        DefrostMirror   : ErrConfig;
        // Index 16 = Digital input for generic function alarm
        (**Digital input for generic function alarm*)
        GenFctAlrm   : ErrConfig;   
    END_STRUCT;
    
{ENDREGION}
    
{REGION DigitalOutputs}
    
    DOUnion: UNION
        Fct : DOStruct;
        Arr : ARRAY[1..DOUT_NUM] OF BOOL;
    END_UNION;
        
    DOStruct: STRUCT
        // Index 1 = Solenoid
        Solenoid        : BOOL;
        // Index 2 = Alarm
        Alarm           : BOOL;
        // Index 3 = Auxiliary
        Auxiliary       : BOOL;
        // Index 4 = MasterAuxiliary
        MasterAuxiliary : BOOL;
        // Index 5 = Light
        Light           : BOOL;
        // Index 6 = MasterLight
        MasterLight     : BOOL;
        // Index 7 = Defrost
        Defrost         : BOOL;
        // Index 8 = Defrost2
        Defrost2        : BOOL;
        // Index 9 = Fans
        Fans            : BOOL;
{IF NOT DEF(MPXONE_BASIC)}    
        // Index 10 = SuctVlv
        SuctVlv         : BOOL;
        // Index 11 = EqualizVlv
        EqualizVlv      : BOOL;
        // Index 12 = LiquidVlv
        LiquidVlv       : BOOL;
        // Index 13 = Timed
        Timed           : BOOL;
        // Index 14 = DrainHeat
        DrainHeat       : BOOL;
        // Index 15 = Rail Heaters
        RailHeaters     : BOOL;
        // Index 16 = Generic stage 1
        GenericStage1   : BOOL;
        // Index 17 = HotGas valve for defrost
        (**HotGas digital output current status*)
        HotGas          : BOOL;        
{ELSE}
        // Index 11 = Timed
        Timed           : BOOL;
        // Index 12 = DrainHeat
        DrainHeat       : BOOL;
        // Index 13 = Rail Heaters
        RailHeaters     : BOOL;
        // Index 14 = Generic stage 1
        GenericStage1   : BOOL;
{ENDIF}
    END_STRUCT;
    
    DOutCfgUnion: UNION
        Fct : DoutCfgStruct;
        Arr : ARRAY [1..DOUT_NUM] OF DoutConfig;
    END_UNION;
    
    DOutCfgStruct: STRUCT
        // Index 1 = Solenoid
        Solenoid        : DoutConfig;
        // Index 2 = Alarm
        Alarm           : DoutConfig;
        // Index 3 = Auxiliary
        Auxiliary       : DoutConfig;
        // Index 4 = MasterAuxiliary
        MasterAuxiliary : DoutConfig;
        // Index 5 = Light
        Light           : DoutConfig;
        // Index 6 = MasterLight
        MasterLight     : DoutConfig;
        // Index 7 = Defrost
        Defrost         : DoutConfig;
        // Index 8 = Defrost2
        Defrost2        : DoutConfig;
        // Index 9 = Fans
        Fans            : DoutConfig;
{IF NOT DEF(MPXONE_BASIC)}    
        // Index 10 = SuctVlv
        SuctVlv         : DoutConfig;
        // Index 11 = EqualizVlv
        EqualizVlv      : DoutConfig;
        // Index 12 = LiquidVlv
        LiquidVlv       : DoutConfig;
        // Index 13 = Timed
        Timed           : DoutConfig;
        // Index 14 = DrainHeat
        DrainHeat       : DoutConfig;
        // Index 15 = Rail Heaters
        RailHeaters     : DoutConfig;
        // Index 16 = Generic stage 1
        GenericStage1   : DoutConfig;
        // Index 17 = HotGas valve for defrost
        HotGas          : DoutConfig;        
{ELSE}
        // Index 11 = Timed
        Timed           : DoutConfig;
        // Index 12 = DrainHeat
        DrainHeat       : DoutConfig;
        // Index 13 = Rail Heaters
        RailHeaters     : DoutConfig;
        // Index 14 = Generic stage 1
        GenericStage1   : DoutConfig;
{ENDIF}
        END_STRUCT;
    
    (**It is used to store Dout configuration errors*)
    DoutErrUnion: UNION
        (**Funtcions list*)
        Fct : DoutErrSturct;
        Arr : ARRAY[1..DOUT_NUM] OF ErrConfig;
    END_UNION;
    
    DoutErrSturct: STRUCT
        // Index 1 = Solenoid
        Solenoid        : ErrConfig;
        // Index 2 = Alarm
        Alarm           : ErrConfig;
        // Index 3 = Auxiliary
        Auxiliary       : ErrConfig;
        // Index 4 = MasterAuxiliary
        MasterAuxiliary : ErrConfig;
        // Index 5 = Light
        Light           : ErrConfig;
        // Index 6 = MasterLight
        MasterLight     : ErrConfig;
        // Index 7 = Defrost
        Defrost         : ErrConfig;
        // Index 8 = Defrost2
        Defrost2        : ErrConfig;
        // Index 9 = Fans
        Fans            : ErrConfig;
{IF NOT DEF(MPXONE_BASIC)}    
        // Index 10 = SuctVlv
        SuctVlv         : ErrConfig;
        // Index 11 = EqualizVlv
        EqualizVlv      : ErrConfig;
        // Index 12 = LiquidVlv
        LiquidVlv       : ErrConfig;
        // Index 13 = Timed
        Timed           : ErrConfig;
        // Index 14 = DrainHeat
        DrainHeat       : ErrConfig;
        // Index 15 = Rail Heaters
        RailHeaters     : ErrConfig;
        // Index 16 = Generic stage 1
        GenericStage1   : ErrConfig;
        // Index 17 = HotGas valve for defrost
        HotGas          : ErrConfig;        
{ELSE}
        // Index 11 = Timed
        Timed           : ErrConfig;
        // Index 12 = DrainHeat
        DrainHeat       : ErrConfig;
        // Index 13 = Rail Heaters
        RailHeaters     : ErrConfig;
        // Index 14 = Generic stage 1
        GenericStage1   : ErrConfig;
{ENDIF}
        END_STRUCT;
  
{ENDREGION}
    
{REGION AnalogOutputs}
    
    {IF NOT DEF(MPXONE_BASIC)}
    AOUnion: UNION
        Fct : AOStruct;
        Arr : ARRAY[1..AOUT_NUM] OF REAL;
    END_UNION;
        
    AOStruct: STRUCT
        // Index 1 = Fans
        Fans          : REAL;
        // Index 2 = Valve
        Valve         : REAL;
        // Index 3 = Rails
        Rails         : REAL;
        // Index 4 = Generic modulation 1
        GenericModul1 : REAL;
    END_STRUCT;
    
    AOutCfgUnion: UNION
        Fct : AOutCfgStruct;
        Arr : ARRAY [1..AOUT_NUM]   OF AoutConfig;
    END_UNION;
    
    AOutCfgStruct: STRUCT
        // Index 1 = Fans
        Fans          : AoutConfig;
        // Index 2 = Valve
        Valve         : AoutConfig;
        // Index 3 = Rails
        Rails         : AoutConfig;
        // Index 4 = Generic modulation 1
        GenericModul1 : AoutConfig;
    END_STRUCT;
    {ELSE}
    AOUnion: UNION
        Fct : AOStruct;
        Arr : ARRAY[1..1] OF REAL;
    END_UNION;
        
    AOStruct: STRUCT
        // Index 1 = Fans
        dummy          : REAL;
    END_STRUCT;
    
    AOutCfgUnion: UNION
        Fct : AOutCfgStruct;
        Arr : ARRAY [1..1]   OF AoutConfig;
    END_UNION;
    
    AOutCfgStruct: STRUCT
        // Index 1 = Fans
        dummy          : AoutConfig;
    END_STRUCT; 
    {ENDIF}
    
    AoutErrUnion: UNION
        Fct : AoutErrStruct;
        Arr : ARRAY [1..AOUT_NUM] OF ErrConfig;
    END_UNION;
    
    AoutErrStruct: STRUCT
        // Index 1 = Fans
        Fans          : ErrConfig;
        // Index 2 = Valve
        Valve         : ErrConfig;
        // Index 3 = Rails
        Rails         : ErrConfig;
        // Index 4 = Generic modulation 1
        GenericModul1 : ErrConfig;
    END_STRUCT;
    
{ENDREGION}
    
{REGION Alarms}
    
    AlarmsUnion: UNION
        Al : AlarmStruct;
        Arr : ARRAY[1..NUM_ALARMS + NUM_WARN_STATUS] OF Alarm_Req;
    END_UNION;
        
    AlarmStruct : STRUCT
        (**Control probe fault*)
    	Al_Reg : Alarm_Req := (StrCode := ' rE', Info := ( Category := REG_ALARMS_TYPE));
        (**Array of probe alarms*)
    	Al_PrbBroken : ARRAY[1..NUM_PRB_BROKEN] OF Alarm_Req;
    	(**Alarm of serial inpus for timeout expired*)
    	Al_SerialInputs : ARRAY[1..4] OF Alarm_Req;
    	(**Low temperature alarm*)
    	Al_LowTemp : Alarm_Req := (StrCode := ' LO', Info := ( Category := REG_ALARMS_TYPE));
    	(**High temperature alarm*)
    	Al_HiTemp : Alarm_Req := (StrCode := ' HI', Info := ( Category := REG_ALARMS_TYPE));
    	(**Low temperature alarm 2*)
    	Al_LowTemp2 : Alarm_Req := (StrCode := 'LO2', Info := ( Category := REG_ALARMS_TYPE));
    	(**High temperature alarm 2*)
    	Al_HiTemp2 : Alarm_Req := (StrCode := 'HI2', Info := ( Category := REG_ALARMS_TYPE));
    	(**Immediate alarm from external contact*)
    	AlExtDin : Alarm_Req := (StrCode := ' IA', Info := ( Category := REG_ALARMS_TYPE));
    	(**Delayed alarm from external contact*)
    	AlDelayExtDin : Alarm_Req := (StrCode := ' dA', Info := ( Category := REG_ALARMS_TYPE));
        (**Door open for too long alarm*)
    	Al_Door : Alarm_Req := (StrCode := 'dor', Info := ( Category := REG_ALARMS_TYPE));
    	(**Real time clock fault*)
    	Al_RTC : Alarm_Req := (StrCode := 'Etc', Info := ( Category := REG_ALARMS_TYPE));
    	{IF NOT DEF(MPXONE_BASIC)}
        (**Low superheat alarm*)
    	Al_LSH : Alarm_Req := (StrCode := 'LSH', Info := ( Category := REG_ALARMS_TYPE));
    	(**Low suction temperature alarm*)
    	Al_LSA : Alarm_Req := (StrCode := 'LSA', Info := ( Category := REG_ALARMS_TYPE));
    	(**Maximum evaporation pressure alarm*)
    	Al_MOP : Alarm_Req := (StrCode := 'MOP', Info := ( Category := REG_ALARMS_TYPE));
    	(**Low evaporation temperature alarm*)
    	Al_LOP : Alarm_Req := (StrCode := 'LOP', Info := ( Category := REG_ALARMS_TYPE));
    	(**Valve blocked alarm*)
    	Al_bLO : Alarm_Req := (StrCode := 'bLo', Info := ( Category := REG_ALARMS_TYPE));
        (**Communication error with stepper driver*)
    	Al_Edc : Alarm_Req := (StrCode := 'Edc', Info := ( Category := REG_ALARMS_TYPE));
        {ENDIF}
        (**Type HA HACCP alarm*)
    	Al_HA : Alarm_Req := (StrCode := ' HA', Info := ( Category := REG_ALARMS_TYPE, Reset := AlarmResetType#Manual));
        (**Type HF HACCP alarm*)
    	Al_HF : Alarm_Req := (StrCode := ' HF', Info := ( Category := REG_ALARMS_TYPE, Reset := AlarmResetType#Manual));
        (**Communication error with Master (only on Slave)*)
    	Al_MA : Alarm_Req := (StrCode := ' MA', Info := ( Category := REG_ALARMS_TYPE));
        (**Communication error with Slave (only on Master)*)
    	Al_u : ARRAY[1..Libs.SPV_Gateway_HPX.MAX_SLAVES] OF Alarm_Req;
        (**Alarm on unit 1 to 9 in the network*)
    	Al_n : ARRAY[1..Libs.SPV_Gateway_HPX.MAX_SLAVES] OF Alarm_Req;
        {IF NOT DEF(MPXONE_BASIC)}
        (**Error in custom gas parameters*)
    	Al_GPE : Alarm_Req := (StrCode := 'GPE', Info := ( Category := REG_ALARMS_TYPE));
        {ENDIF}
        (**Generic alarm 1 high*)
    	Al_GHI_1 : Alarm_Req := (StrCode := 'GHI', Info := ( Category := REG_STATUS_TYPE));
        (**Generic alarm 1 low*)
    	Al_GLO_1 : Alarm_Req := (StrCode := 'GLO', Info := ( Category := REG_STATUS_TYPE));
        {IF NOT DEF(MPXONE_BASIC)}
        (**EVDmini/ice : probe S1 faulty or set alarm range exceeded *)
        AL_DA1_EVDmini : Alarm_Req := (StrCode := 'dA1', Info := ( Category := REG_ALARMS_TYPE));
        (**EVDmini/ice : probe S2 faulty or set alarm range exceeded *)
        Al_DA2_EVDmini : Alarm_Req := (StrCode := 'dA2', Info := ( Category := REG_ALARMS_TYPE));
        (**EVDmini/ice : EEPROM operating and/or unit parameters damaged *)
        Al_DEE_EVDmini : Alarm_Req := (StrCode := 'dEE', Info := ( Category := REG_ALARMS_TYPE));
        (**EVDmini/ice : Emergency closing*)
        Al_DE5_EVDmini : Alarm_Req := (StrCode := 'dE5', Info := ( Category := REG_ALARMS_TYPE));
        (**Evaporators fan [ESM series]: offline*)
        EBM1_Offline: Alarm_Req := (StrCode := 'EF1', Info := ( Category := REG_ALARMS_TYPE));
       
        {IF DEF (MPXONE_ADVANCED)}
        (**Power failure alarm, fast closing enabled for the valve - Ultracap keeping the controller alive*)
        Al_Ultracap_EEV : Alarm_Req := (StrCode := 'PSF', Info := ( Category := REG_ALARMS_TYPE));
        {ENDIF}
        
        {ENDIF}
        
        // Insert addictional alarms here and update the constant NUM_ALARMS on top of this page accordingly
        
        (**Warning for door open*)
    	Warn_Door : Alarm_Req := (Info := ( Category := REG_WARNINGS_TYPE));
        (**Warning for Standby status*)
    	Status_Standby : Alarm_Req := (StrCode := 'Stb', Info := ( Category := REG_STATUS_TYPE));
        (**Warning for Clean status*)
    	Status_Clean : Alarm_Req := (StrCode := 'CLn', Info := ( Category := REG_STATUS_TYPE));
        (**Warning for timeout of defrost 1*)
        DfrTout1 : Alarm_Req := (StrCode := 'Ed1', Info := ( Category := REG_STATUS_TYPE));
        (**Warning for timeout of defrost 2*)
        DfrTout2 : Alarm_Req := (StrCode := 'Ed2', Info := ( Category := REG_STATUS_TYPE));
        {IF NOT DEF(MPXONE_BASIC)}
        (**Warning for suction pressure probe missing*)
        Warn_SuctP_Prb : Alarm_Req := (StrCode := 'Mss', Info := ( Category := REG_WARNINGS_TYPE));
        (**Warning for EVD firmware version less than 1.7*)
        Warn_EVD_Fw : Alarm_Req := (StrCode := 'AFr', Info := ( Category := REG_WARNINGS_TYPE));
        {ENDIF}
    END_STRUCT;
{ENDREGION}

END_TYPE