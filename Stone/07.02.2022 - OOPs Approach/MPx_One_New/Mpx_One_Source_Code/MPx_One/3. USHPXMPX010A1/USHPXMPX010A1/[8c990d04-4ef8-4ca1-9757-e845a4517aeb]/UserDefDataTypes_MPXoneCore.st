USING Libs.IOMng_Basic;
USING Libs.Alarm_Mng;
USING System.Alarm;
USING System;

{DEFINE EXTRA_VALUES 6}

VAR_GLOBAL
    (**Array of useful values used for regulations of different outputs*)
    RegValues: ARRAY[1..AIN_NUM+EXTRA_VALUES] OF REAL;
    (**Max number of channel phisically present on controller*)
{IF DEF(MPXONE_BASIC)}
    MAX_AIN_CH : SINT := TO_SINT(MAX_AIN_BASIC);
{ELIF DEF(MPXONE_MEDIUM)}
    MAX_AIN_CH : SINT := TO_SINT(MAX_AIN_MEDIUM);
{ELIF DEF(MPXONE_ADVANCED)}
    MAX_AIN_CH : SINT := TO_SINT(MAX_AIN_ADVANCED);
{ENDIF}    

    SuctTBroken : BOOL := FALSE;
END_VAR

VAR_GLOBAL PERSISTENT
    (**Simulation values upper limits for inputs*)
    SimMax : ARRAY [1..MAX_AIN] OF REAL := [10, 2, 18, 100, 100, 100];
    (**Simulation values lower limits for inputs*)
    SimMin : ARRAY [1..MAX_AIN] OF REAL := [-10, -20, -2, 0, 0, 0];
    (**Simulation values lower limits for inputs*)
    SimPeriod : ARRAY [1..MAX_AIN] OF TIME := [T#5m, T#5m, T#5m, T#5m, T#5m, T#5m];
    (**Channels for digital inputs functions*)
//    {METADATA MAX_VAL NUM_DIN}
//    {METADATA MIN_VAL -1}
//    DinChannels : ARRAY[1..DIN_NUM] OF SINT;
//    (**Logic settings for digital inputs functions*)
//    DinLogics : ARRAY[1..DIN_NUM] OF BOOL;
END_VAR

TYPE
{REGION Others}
    MPX_AinGroupCfg: STRUCT
        (** U Channel: AIN (PROBE), AOUT, DIN See ENUM: MODE_TYPE*)                                                                                    
        ModeType    : MODE_TYPE_AIN;
        (**Stability of the probe: P parameter of Internal PID for noise reduction*)
        Filter      : USINT := 10;
    END_STRUCT;
    
    TimeBand: STRUCT
        (**Time band day*)
    	{METADATA MIN_VAL 0}
    	{METADATA MAX_VAL 11}
        Day : USINT;
        (**Time band hour *)
        {METADATA MIN_VAL 0}
    	{METADATA MAX_VAL 23}
        Hour : USINT;
        (**Time band minute *)
        {METADATA MIN_VAL 0}
    	{METADATA MAX_VAL 59}
        Minute : USINT;
        
        (**Time datatype for APPLICA*)
        TimeAPP : TOD;
        (**Time datatype for APPLICA*)
        MirTimeAPP : TOD;
    END_STRUCT;
    
    ArrayCompactAlrmHyst: STRUCT
        Code_Str: STRING[3];
        Year    : UINT;
        Month   : UINT;
        Day     : UINT;
        Hour    : UINT;
        Minute  : UINT;
        Duration: UDINT;
    END_STRUCT;
    
    ALRMHYST_ENUM:
        (
            CODE,
            YEAR,
            MONTH,
            DAY,
            HOUR,
            MIN,
            DURATION,
            WRITE_ESC
        );
    
    UNIT_STATUS:
        (
            UNIT_ON,
            OFF_BY_ALARM,
            OFF_BY_SUPERVISOR,
            OFF_BY_TIME_BAND,
            OFF_BY_DIGITAL_INPUT,
            OFF_BY_KEYBOARD,
            STANDBY,
            CLEAN,
            DOOR_OPEN,
            DUTY_SETTINGS,
            CONTINUOS_CYCLE,
            DEFROST
        );
    
    UNIT_STATUS_GEN_FCT:
        (
            ALWAYS,
            UNIT_ON,
            UNIT_OFF, 
            DEFROST,
            CASE_CLEANING,
            CONT_CYCLE,
            DUTY_SETTINGS,
            STANDBY,
            REGULATION_ON,
            DOOR_OPEN,
            UNIT_ALARM,
            UNKNOWN
        );
{ENDREGION}
    
END_TYPE