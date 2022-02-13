USING System.IO;
USING System;
USING System.Timer;
USING System.Math;
USING Libs.IOMng_Basic;

{IF NOT DEF(MPXONE_BASIC)}
// Number of DO function available
{DEFINE NUM_DO 16}
{ELSE}
// Number of DO function available
{DEFINE NUM_DO 13}
{ENDIF}

VAR_GLOBAL PERSISTENT
    EOL_Test_Time : UINT := 120;
END_VAR

VAR_GLOBAL
    {IF NOT DEF(MPXONE_BASIC)}
    (**Max limit for channel configuration of analog output*)
    NUM_AOUT : USINT;
    {ENDIF}
    (**Max limit for channel configuration of digital output*)
    NUM_DOUT : USINT;
    
    pwd_EOL_Test : ARRAY[1..3] OF UINT;
    ManVal_Dout : ARRAY [1..LIB_IO_MAX_NO_CH] OF BOOL;
    ManLogic_Dout : ARRAY [1..LIB_IO_MAX_NO_CH] OF BOOL;
    {IF NOT DEF(MPXONE_BASIC)}
    ManVal_Aout : ARRAY [1..LIB_IO_MAX_Y_CH] OF REAL;
    ManType_Aout : USINT;
    {ENDIF}
END_VAR

NAMESPACE LibraryNamespaceAndVersion

PROGRAM OutputsMng
    VAR
        TON_EOL_Test : TON;
        RS_EOL_test : RS;
        En_EOL_Test : BOOL;
    END_VAR
    
    VAR_TEMP
        i : DINT;
        PT_ton : TIME;
    END_VAR
    
    //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
    {REGION END OF LINE TEST}
    En_EOL_Test := (pwd_EOL_Test[1] = 16#4D50) AND (pwd_EOL_Test[2] = 16#586F) AND (pwd_EOL_Test[3] = 16#6E65);
    RS_EOL_test(S := En_EOL_Test, R1 := FALSE);
    PT_ton := TO_TIME(LIMIT(1,TO_UDINT(EOL_Test_Time), 600) * 60 * 1000);
    TON_EOL_Test(IN := RS_EOL_test.Q1, PT := PT_ton);
    IF NOT(TON_EOL_Test.Q) AND TON_EOL_Test.ET > T#0s THEN
        MachineStatus := MPX_MACHINE_STATUS_TEST;
    ELSE
        MachineStatus := MPX_MACHINE_STATUS_REGULATION;
    END_IF;
    {ENDREGION}
    
//    // Fetch the number of Ain&Din from hardware description
//    NUM_DOUT := TO_USINT(HwDesc.DoutNumber);
//    {IF NOT DEF(MPXONE_BASIC)}
//    NUM_AOUT := TO_USINT(HwDesc.AoutNumber);
//    {ENDIF}
    
    CASE MachineStatus OF
        (*---------------------    TEST STATE           ---------------------*)
        MPX_MACHINE_STATUS_TEST:
            //Loop all digital output forced value
            FOR i := 1 TO UPPER_BOUND(ManVal_Dout, 1) DO
                NO[i] := ManVal_Dout[i] XOR ManLogic_Dout[i];
            END_FOR;
            {IF NOT DEF(MPXONE_BASIC)}
            FOR i := 1 TO UPPER_BOUND(ManVal_Aout, 1) DO
                yConfig[i].mode_type := ManType_Aout;
                Y[i] := TO_UINT(ManVal_Aout[i] * 10);
            END_FOR;
            {ENDIF}
            
        (*---------------------    REGULATION STATE     ---------------------*)
        MPX_MACHINE_STATUS_REGULATION:
        
        {REGION DIGITAL_OUTPUT}
        // Set output values
        DigitalOutputs.Fct.Solenoid := CompOn;
        DigitalOutputs.Fct.Alarm := SetOverwriteOutput(En_GlobalSwitch_Override, En_AlarmOverwrite, NOT OrAlrm, Custom_AlarmOutput);
        DigitalOutputs.Fct.Auxiliary := SetOverwriteOutput(En_GlobalSwitch_Override, En_AuxOutputOverwrite, AuxOn, Custom_AuxOutput);
        DigitalOutputs.Fct.MasterAuxiliary := SetOverwriteOutput(En_GlobalSwitch_Override, En_MstAuxOutputOverwrite, 
                                                NetworkAux AND (Dout_Cfg.Arr[4].Ch > 0) AND (NOT isMaster), Custom_MstAuxOutput);
        DigitalOutputs.Fct.Light := SetOverwriteOutput(En_GlobalSwitch_Override, En_LightOverwrite, LightsOn, Custom_LightOutput);
        DigitalOutputs.Fct.MasterLight := SetOverwriteOutput(En_GlobalSwitch_Override, En_MstLightOverwrite, NetworkLight, Custom_MstLightOutput);
        DigitalOutputs.Fct.Defrost := (DfrOn OR (DfrOn2 AND Dout_Cfg.Arr[6].Ch > 0 AND (Dout_Cfg.Arr[7].Ch = Dout_Cfg.Arr[8].Ch))) AND NOT DfrNatural;
        DigitalOutputs.Fct.Defrost2 := (DfrOn2 AND NOT DfrNatural) OR (DfrOn AND (Dout_Cfg.Arr[7].Ch = Dout_Cfg.Arr[8].Ch));
        DigitalOutputs.Fct.Fans := SetOverwriteOutput(En_GlobalSwitch_Override, En_FansOverwrite, FansOn, Custom_FansOutput);
{IF NOT DEF(MPXONE_BASIC)}
            // Added HotGas valve command
        DigitalOutputs.Fct.HotGas := DfrOn;
        DigitalOutputs.Fct.SuctVlv := S_VlvOn;
        DigitalOutputs.Fct.EqualizVlv := E_VlvOn;
        DigitalOutputs.Fct.LiquidVlv := UnitOn;
{ENDIF}        
        DigitalOutputs.Fct.Timed := SetOverwriteOutput(En_GlobalSwitch_Override, En_TimedOutOverwrite, TimedOn, Custom_TimedOutput);
        DigitalOutputs.Fct.DrainHeat := SetOverwriteOutput(En_GlobalSwitch_Override, En_DrainHeaterOverwrite, DfrStatus > DFR_IDLE, Custom_DrainHeaterOutput);
{IF NOT DEF(MPXONE_BASIC)}
        DigitalOutputs.Fct.RailHeaters := SetOverwriteOutput(En_GlobalSwitch_Override, En_RailHeaterOverwrite, HeatersOut = 100 AND (Dout_Cfg.Arr[15].Ch > 0), Custom_RailHeaterOutput);
{ELSE}
        DigitalOutputs.Fct.RailHeaters := HeatersOut = 100 AND (Dout_Cfg.Arr[13].Ch > 0);
{ENDIF}
        DigitalOutputs.Fct.GenericStage1 := SetOverwriteOutput(En_GlobalSwitch_Override, En_GenFctStageOverwrite, GenFctStages_Out[1], Custom_GenFctStageOutput);
        
        {ENDREGION}
        
        {IF NOT DEF(MPXONE_BASIC)}
        {REGION ANALOG_OUTPUT}        
        // Set output values
        
        FOR i := LOWER_BOUND(Aout_Cfg.Arr,1) TO UPPER_BOUND(Aout_Cfg.Arr,1) DO
            IF Aout_Cfg.Arr[i].Ch > 0 AND TO_DINT(Aout_Cfg.Arr[i].Ch) >=LOWER_BOUND(yConfig,1)
                AND TO_DINT(Aout_Cfg.Arr[i].Ch) <= UPPER_BOUND(yConfig,1) THEN
                Aout_Cfg.Arr[i].Enable := TRUE;
                yConfig[Aout_Cfg.Arr[i].Ch].mode_type := 0;
            END_IF;
        END_FOR;
        
        AnalogOutputs.Fct.Fans := SetOverwriteOutput_Modul(En_GlobalSwitch_Override, En_FansModulOverwrite, FansReq, Custom_FansModulOutput);
        AnalogOutputs.Fct.Valve := SetOverwriteOutput_Modul(En_GlobalSwitch_Override, En_ValveModulOverwrite, USINT_TO_REAL(ExvVlvPosition), Custom_ValveModulOutput);
        AnalogOutputs.Fct.Rails := SetOverwriteOutput_Modul(En_GlobalSwitch_Override, En_HeatersModulOverwrite, TO_REAL(HeatersOut), Custom_HeatersModulOutput);         
        AnalogOutputs.Fct.GenericModul1 := SetOverwriteOutput_Modul(En_GlobalSwitch_Override, En_GenFctModulOverwrite, GenFctModul_Out[1], Custom_GenFctModulOutput);
        {ENDREGION}
        {ENDIF}
        
        {REGION Output write}      
        
        IO_mng.Write(
            0,
            DOut_Cfg.Arr,
            DigitalOutputs.Arr,
            AOut_Cfg.Arr,
            AnalogOutputs.Arr,
            DOut_Err.Arr,
            Aout_Err.Arr,
            NO,
            noConfig,
            Y,
            yConfig,
            uConfig,
            Uout
        );
        {ENDREGION}

        // keep of if during wizard
        IF NOT WizDone THEN
            FOR i := 1 TO UPPER_BOUND(NO, 1) DO
                NO[i] := FALSE;
            END_FOR;
            {IF NOT DEF(MPXONE_BASIC)}
            FOR i := 1 TO UPPER_BOUND(Y, 1) DO
                Y[i] := 0;
            END_FOR;
            {ENDIF}
        END_IF;        
    END_CASE;
    
    {REGION SERIAL_OUTPUT}
    
    IF WizDone AND NOT SlvUpdFW THEN
        FieldBus.Write();
        SpVTable.Write(ChangedUoM);
    END_IF;
    
    {ENDREGION}
    
    //Reset powerUp state
    IF NOT powerUp THEN
        powerUp := TRUE;
    END_IF;
    
END_PROGRAM
    
FUNCTION SetOverwriteOutput : BOOL
    VAR_INPUT
        EnGlobalOverwrite   : BOOL;
        EnActualOverwrite   : BOOL;
        
        Carel_OutputValue   : BOOL;
        Custom_OutputValue  : BOOL;
    END_VAR
    
    IF EnGlobalOverwrite AND EnActualOverwrite THEN
        SetOverwriteOutput := Custom_OutputValue;
    ELSE
        SetOverwriteOutput := Carel_OutputValue;
    END_IF;
    
END_FUNCTION
    
FUNCTION SetOverwriteOutput_Modul : REAL
    VAR_INPUT
        EnGlobalOverwrite   : BOOL;
        EnActualOverwrite   : BOOL;
        
        Carel_OutputValue   : REAL;
        Custom_OutputValue  : REAL;
    END_VAR
    
    IF EnGlobalOverwrite THEN
        SetOverwriteOutput_Modul := TO_REAL(EnActualOverwrite) * Custom_OutputValue;
    ELSE
        SetOverwriteOutput_Modul := Carel_OutputValue;
    END_IF;
    
END_FUNCTION
    
END_NAMESPACE
