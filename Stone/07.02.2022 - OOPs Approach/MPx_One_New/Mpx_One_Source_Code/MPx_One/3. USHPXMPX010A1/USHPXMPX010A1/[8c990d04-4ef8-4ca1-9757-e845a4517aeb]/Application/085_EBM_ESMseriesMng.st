USING System.Serial;
USING System.Timer;
USING System;
USING System.Math;
USING System.Util;
USING Libs.EbmpapstFan_Basic;

VAR_GLOBAL
    {ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
    SpeedReqPerc_EBM_1 : UINT := 0;
    
    Ebmpapst_ESM : EbmpapstFan_Basic;
    //Ebmpapst_ESM : EbmpapstFan_Basic;
    
    SpeedReq_EBM_1          : REAL;
	FW_Reebot_EBM_1         : BOOL;
	LdNewVal_EBM_1          : BOOL;
	ResAlrmInternal_EBM_1   : BOOL;
	Online_EBM_1            : BOOL;
    CtrlModeAct_EBM_1       : UINT;
    CntWorkHrsBkp_EBM_1     : UDINT;
    CurrRotDir_EBM_1        : UINT;
    MotStatus_EBM_1         : MOT_STATUS_EBM_ESM;
    Warn_EBM_1              : WARNING_EBM_ESM;
    ComStatus_EBM_1         : USINT;
    Al_Offline_EBM_1        : BOOL;
    MaxSpeed_EBM_1          : UINT;
    CurrSpeed_EBM_1         :UINT;
    SerNo_EBM_1             : SERIAL_NUM_EBM;
    LdNewAddr_EBM_1         : BOOL;
    NewAddr_EBM_1           : UINT;    
END_VAR

VAR_GLOBAL PERSISTENT
    DetectionRange          : TIME := T#2s;
    PollingDelay            : UINT(0..3000) := 50;
    Timeout                 : UINT(200..3000) := 200;
    CommandDelay            : UINT(0..1000) := 20;
    En_EbmpapstFan_1        : BOOL; 
    SerInterfaceSet_EBM_1   : CTRL_BOARD_MBM_PARAM_EBM;
    RotDir_EBM_1            : BOOl := TRUE;
    CtrlMode_EBM_1          : USINT := 1;  
END_VAR

NAMESPACE LibraryNamespaceAndVersion

PROGRAM EBMMng
    
    IF NOT firstCycle THEN
        
        Fieldbus.SerialSettings.Channel := Serial_Channel#FBUS1;
        Fieldbus.SerialSettings.Speed := 19200;
        Fieldbus.SerialSettings.Parity := Serial_Parity#Even;
        Fieldbus.SerialSettings.Stops := SERIAL_STOP_1;
        
        SerialChangeSettings(Fieldbus.SerialSettings);
    END_IF;
    
    Fieldbus.Info.DetectionRange := DetectionRange;
    Fieldbus.Info.PollingDelay := PollingDelay;
    Fieldbus.Info.Retry := 5;
    
    Ebmpapst_ESM(
    	SpeedReq_EBM        := SpeedReq_EBM_1,
    	RotDir_EBM          := RotDir_EBM_1,
    	CtrlMode_EBM        := CtrlMode_EBM_1,
    	SerInterfaceSet_EBM := SerInterfaceSet_EBM_1,
    	FW_Reebot_EBM       := FW_Reebot_EBM_1,
    	LdNewVal_EBM        := LdNewVal_EBM_1,
    	ResAlrmInternal_EBM := ResAlrmInternal_EBM_1,
        LdNewAddr_EBM       := LdNewAddr_EBM_1,
        NewAddr_EBM         := NewAddr_EBM_1,
    	En_EbmpapstFan      := En_EbmpapstFan_1,
    	Online_EBM          => Online_EBM_1,
    	MaxSpeed_EBM        => MaxSpeed_EBM_1,
    	CurrSpeed_EBM       => CurrSpeed_EBM_1,
    	CntWorkHrsBkp_EBM   => CntWorkHrsBkp_EBM_1,
    	CurrRotDir_EBM      => CurrRotDir_EBM_1,
    	SerNo_EBM           => SerNo_EBM_1,
    	MotStatus_EBM       => MotStatus_EBM_1,
    	Warn_EBM            => Warn_EBM_1,
    	Al_Offline_EBM      => Al_Offline_EBM_1
    );
       
    //Fan 2 offline, increase speed of fan 1 and fan 3
    Alarms.Al.EBM1_Offline.Info.Trigger := Al_Offline_EBM_1;
    
END_PROGRAM

END_NAMESPACE
