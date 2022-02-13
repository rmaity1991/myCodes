USING System.UI;
USING System;
USING System.Timer;
USING System.Serial;
USING System.NVRAM;
USING System.Logs;
USING Libs.Blackout;
USING Libs.Logics;
USING System.Math;
USING System.Text;
USING libs.GenericFunctionMng;

{IF DEF(MPX_LOGS)}
(* ONLY FOR DEBUG *)
VAR_GLOBAL
	LogsBuffer : ARRAY [0..1024] OF BYTE;
    myStrDebugCarel : STRING;
END_VAR
(* -------------- *)
{ENDIF}

VAR_GLOBAL
    (**Detect restarts of MPXone application*)
    powerUp : BOOL;
    (**Flag for recognize that a defrost was performed*)
    DfrPerformed : BOOL;
    (**flag for save sw_version after RetainRestoreDefault()*)
    SW_Update    : BOOL; 
    (* Backup BMS Configuration fo upgrade SW  ------*)
    BMS_Addr_bkp : USINT;
    BMS_Baud_bkp : USINT;
    BMS_Conf_bkp : USINT;
    BMS_Prot_bkp : BOOL;
END_VAR

VAR_GLOBAL RETAIN
    (**Number of restrts of MPXone application *)
    RestartsCounter : UINT;   
END_VAR

VAR_GLOBAL PERSISTENT    
    (**Start for periodic log: hour*)
    {METADATA MAX_VAL 23}
    {METADATA MIN_VAL 0}
    {ATTRIBUTE UOM HOUR}
    StartLog_Hour : USINT (0..23) := 0;
    (**Start for periodic log: minute*)
    {METADATA MAX_VAL 59}
    {METADATA MIN_VAL 0}
    {ATTRIBUTE UOM MINUTE}
    StartLog_Min : USINT (0..59) := 0;
    
    StartLog_DT : DATE_AND_TIME;
END_VAR

NAMESPACE LibraryNamespaceAndVersion

PROGRAM GeneralMng
    
    VAR
        BMS_BaudPrec, BMS_ConfPrec, BMS_AddrPrec : USINT;
        FB_BaudPrec : USINT;
        
        FirsCheckBlackout : BOOL := FALSE;
        BlackoutCtl : Blackout;
        MyLastOffDate : DATE_AND_TIME;
        NVRAM_Array : DWORD;
        myPwrOffDate_NVRAM_BLKO : UDINT;
        
        CngCnfRT                : RF_TRIG;
        R_Trig_enNFC : R_TRIG;
        
        TON_WAIT_DOWNLOAD : TON;
        
        FirstRun : BOOL := TRUE;
        
        prevZoneHmi : BOOL;        
        pCOType, boardType, machineType, hwCode : UINT;

        SPV_DT : DT;
        prevSPV_DT : DT := DATE_AND_TIME#2017-01-01-00:00:00;
        DisSpvUpdF_APP : BOOL;
        
        cfgId : SINT;
        cfgOk : BOOL;
        {IF NOT DEF(MPXONE_BASIC)}
        cfgName : STRING[16];
        {ELSE}
        cfgName : STRING[4];
        {ENDIF}
        UniqueId : LWORD;        
    END_VAR
    
    VAR_TEMP
        ProdCode_HwID : USINT;
        ProdCode_ProdVers : USINT;
        tmp_Startlog : DateTime;
        tmp_CurrTime : DateTime;
        lastDfrTime_DWORD : DWORD;
        swVersion_tmp           : UINT;
    END_VAR
    
    {REGION HARDWARE INFO}
    GetHardwareDescription(HwDesc);
    GetModel(pCOType, boardType, machineType, hwCode);
    GetProductInfo(Product_Info);
    
    IF firstCycle THEN
        UniqueId := TO_LWORD(GetUniqueId());
        Split_UniqueId(UniqueId, UniqueID_SPV);
        
        {IF DEF(MPXONE_ADVANCED)}
        PwrSupplyFailure := FALSE;
        uConfig[9].mode_sel := 0; // U9 set as analog input to manageultracap control
        {ENDIF}
        
    END_IF;
        
    IF Product_Info.ProductCode <> '' THEN
        ProdCode_HwID := TO_USINT(MID(Product_Info.ProductCode, 2, 10));
        isPanelVersion := (ProdCode_HwID >= 5) AND (ProdCode_HwID <= 8);
        ProdCode_ProdVers := TO_USINT(MID(Product_Info.ProductCode, 1, 6));
        isCustomBasicRU := (ProdCode_ProdVers < 3) AND (ProdCode_HwID = 5);
        isProdBasicVersion := (ProdCode_ProdVers <= 4) AND (ProdCode_HwID <= 6);
    ELSE
        isPanelVersion := FALSE;
    END_IF;  
    
    IF isCustomBasicRU THEN
        Ain_Types.Group1 := 1;
    END_IF;
    {ENDREGION}
    
    
    {REGION RESET TO DEFAULT IF SW VERSION IS DIFFERET OR MANUAL RESET}
                // Compose version variable for BMS and for reeset for update SW
    swVersion_tmp := __PROJ_VER_MAJOR__ * 1000 + __PROJ_VER_MINOR__ * 100 + __PROJ_VER_BUILD__;
    
    IF SW_Update THEN                   // at restart after RetainRestoreDefault() (below)
        swVersion := swVersion_tmp;     // save SW version
        SW_Update := FALSE;             // Stop reset time
        
            //Restore BMS settings only on change version (NOT on Manual Default request)
        IF NOT ResCarelSets THEN    
            BMS_Addr :=BMS_Addr_bkp;
            BMS_Baud :=BMS_Baud_bkp;
            BMS_Conf :=BMS_Conf_bkp;
            BMS_Prot :=BMS_Prot_bkp;
        END_IF;
        
        DispMngInst.StartSync(DownloadDir#ACUtoHMI, FALSE); //Force param from ACU to NFC
        //RetainForceBackup();
        ResCarelSets := FALSE;
    END_IF;
    IF (swVersion <> swVersion_tmp AND NOT(SW_Update)) OR ResCarelSets THEN
        // Backup BMS configuration only
        BMS_Addr_bkp :=BMS_Addr;
        BMS_Baud_bkp :=BMS_Baud;
        BMS_Conf_bkp :=BMS_Conf;
        BMS_Prot_bkp :=BMS_Prot;
        RetainRestoreDefault(); //keep one program loop to be executed
        SW_Update    := TRUE;
    END_IF;
    {ENDREGION}
    
    
    {REGION Set DEFAULT values for analog input channels}

    // wiz done from Applica
    // for wiz done from HMI see: WIZ_ENDPRG.st
    IF WizDone AND WizProgress THEN
        WizDone_Action();   
    END_IF;
    {ENDREGION}
    
    {REGION RESTART COUNTER}
    IF NOT powerUp THEN
        //poerUp := FALSE in PROGRAM OutputsMng
        RestartsCounter     := RestartsCounter + 1;
        LogsEventsCounter   := LogsEventsCounter + 1;
    END_IF;
    {ENDREGION}
    
    {REGION NFC and DISPLAY CHANGE management}
    R_Trig_enNFC(CLK := EnNfc);
    IF EnNfc THEN //AND NOT firstCycle THEN
        //DispMngInst.Check(isPanelVersion, IsCommissioningToolPresent() OR NOT(MasterOnlineTON.Q));
        IF NOT R_Trig_enNFC.Q OR NOT powerUp THEN
            DispMngInst.Check(FALSE, IsCommissioningToolPresent() OR NOT(MasterOnlineTON.Q));
        ELSE
            DispMngInst.StartSync(DownloadDir#ACUtoHMI, R_Trig_enNFC.Q);
        END_IF;

        //forcing parameter values from ACU to HMI in case of display change
        IF DispMngInst.isWaitingForUser() THEN
            NewDispPrompt := FALSE;
            DispMngInst.StartSync(DownloadDir#ACUtoHMI, FALSE);
        END_IF;
    END_IF;
    {ENDREGION}
    
    {IF DEF(NO_SEV_SUPPORT)}
	OneRow.Init();
	OneRow.Read();
    {ENDIF}    
    
    // Find related compilation DEFINES
    {IF DEF(MPXONE_BASIC)}
    isBasic := TRUE;
    isMedium := FALSE;
    isAdvanced := FALSE;
    {ENDIF}
    
    {IF DEF(MPXONE_MEDIUM)}
    isBasic := TRUE;
    isMedium := TRUE;
    isAdvanced := FALSE;
    {ENDIF}
    
    {IF DEF(MPXONE_ADVANCED)}
    isBasic := TRUE;
    isMedium := TRUE;
    isAdvanced := TRUE;
    {ENDIF}
    

    
    
    {REGION CHANGE BMS SETTINGS}
    
    SpvTable.SerialPort.Settings.Channel := Serial_Channel#BMS1;
    (*change of BMS supervisor baudrate*)
    SpvTable.SerialPort.Settings.Speed := SetSerialSpeed(BMS_Baud);
    
    (*change of BMS supervisor settings*)
    SpvTable.SerialPort.Settings.Bits := 8;
    IF BMS_Conf > 5 THEN
        BMS_Conf := 0;
    END_IF;
    CASE BMS_Conf OF
        0:  
            SpvTable.SerialPort.Settings.Parity := Serial_Parity#None;
            SpvTable.SerialPort.Settings.Stops := 1;
            (*8 NONE 1*)
        
        1:  
            SpvTable.SerialPort.Settings.Parity := Serial_Parity#None;
            SpvTable.SerialPort.Settings.Stops := 2;
            (*8 NONE 2*)
        
        2:  
            SpvTable.SerialPort.Settings.Parity := Serial_Parity#Even;
            SpvTable.SerialPort.Settings.Stops := 1;
            (*8 EVEN 1*)
        
        3:  
            SpvTable.SerialPort.Settings.Parity := Serial_Parity#Even;
            SpvTable.SerialPort.Settings.Stops := 2;
            (*8 EVEN 2*)
        
        4:  
            SpvTable.SerialPort.Settings.Parity := Serial_Parity#Odd;
            SpvTable.SerialPort.Settings.Stops := 1;
            (*8 ODD 1*)
        
        5:  
            SpvTable.SerialPort.Settings.Parity := Serial_Parity#Odd;
            SpvTable.SerialPort.Settings.Stops := 2;
            (*8 ODD 2*)
    END_CASE;
    
    // Carel protocol works only at 19200 8n2
    IF NOT BMS_Prot AND ( BMS_Baud <> 4 OR BMS_Conf <> 1 ) THEN
        BMS_Baud := 4;
        BMS_Conf := 1;
    END_IF;
        
    (*change setting of supervisor port, just in case of modifications*)
    IF BMS_Baud <> BMS_BaudPrec OR BMS_Conf <> BMS_ConfPrec OR BMS_Addr <> BMS_AddrPrec THEN 
        (* Set ID to allow STone communication *)
        SetModbusDebugID(BMS_Addr, SpvTable.serialPort.Settings.Channel);
        (* Adjust settings *)
        SerialChangeSettings(SpvTable.serialPort.Settings);
        
        IF BMS_Prot THEN
            MB_Slave.ChangeIdent(BMS_Addr);
        END_IF;
        
        BMS_BaudPrec := BMS_Baud;
        BMS_ConfPrec := BMS_Conf;
        BMS_AddrPrec := BMS_Addr;
        
        // Set the same settings for BMS port on Default app (In case of FW ugrade the device will be reachable with the same settings)
        SaveIdePortSettings(SpvTable.SerialPort.Settings.Channel, SpvTable.SerialPort.Settings.Speed, 
            SpvTable.SerialPort.Settings.Bits, SpvTable.SerialPort.Settings.Parity, SpvTable.SerialPort.Settings.Stops, BMS_Addr);
    END_IF;
    
    IF FB_Baud <> FB_BaudPrec OR Fieldbus.SerialSettings.Speed <> SetSerialSpeed(FB_Baud) THEN
        
        Fieldbus.SerialSettings.Speed := SetSerialSpeed(FB_Baud);
        SerialChangeSettings(Fieldbus.SerialSettings);
        //Fieldbus.ChangeSettings();
        
        FB_BaudPrec := FB_Baud;
    END_IF;
    
    IF ZoneHMI THEN
        SpvTable.Info.Zone := System.Globalization.Imperial;
    ELSE
        SpvTable.Info.Zone := System.Globalization.SI;
    END_IF;
    
    IF ZoneHMI <> prevZoneHmi THEN
        prevZoneHmi := ZoneHMI;
        ChangedUoM := TRUE;
    ELSE
        ChangedUoM := FALSE;
    END_IF;
    
    Libs.SPV_Gateway_HPX.InitProtocols();
        
    IF WizDone AND NOT SlvUpdFW THEN
    
        SpvTable.Read(ChangedUoM, BMS_Prot);
        FieldBus.Read();
        {IF NOT DEF(NO_MPXONE_REPEATER)}
        mpxRepeater.Init(198, repeaterConfig);
        mpxRepeater.Check(HmiRemSel > 0);
        {ENDIF}
    END_IF;
    
    {ENDREGION }
    
    {REGION RTC WRITE}
    
    (*sets the time from app through NFC*)
    IF ToggleSetTimeAPP THEN
        
        SetTime(DateTimeToSet);
        SetTimeZone(Posix);
        
        // Avoid unexpected defrost changing RTC time
        GetLocalTime(CurrDateTime);
        //DfrStartedDT := CurrDateTime;
        
        ToggleSetTimeAPP := FALSE;
        //DisSpvUpdF := TRUE;
        DisSpvUpdF_APP := TRUE;
        
        // Reset alarm if any
        Alarms.Al.Al_RTC.Info.Trigger := FALSE;
    END_IF;
    
    // Update SPV Variables
    SPV_DT := CONCAT_DT(TO_UINT(SPV_Year) + 2000, TO_UINT(SPV_Month), TO_UINT(SPV_Day), TO_UINT(SPV_Hour), TO_UINT(SPV_Min), 0, 0);
    IF SPV_DT <> prevSPV_DT AND NOT FirstRun THEN
                
        // SPV has updated date/time of controller
        SetLocalTime(SPV_DT);
        
        // Avoid unexpected defrost changing RTC time
        GetLocalTime(CurrDateTime);
        //DfrStartedDT := CurrDateTime;
        
        // Reset alarm if any
        Alarms.Al.Al_RTC.Info.Trigger := FALSE;        
    END_IF;
    prevSPV_DT := SPV_DT;
    
    (*return the local time of the control*)
    GetLocalTime(CurrDateTime);
    CurrentDoW := DAY_OF_WEEK(CurrDateTime);
    
    IF FirstRun THEN
        SPV_DoW := CurrentDoW;
        updateDateTimeVar(CurrDateTime, SPV_Day, SPV_Month, SPV_Year, SPV_Hour, SPV_Min);
        SPV_DT := CONCAT_DT(TO_UINT(SPV_Year) + 2000, TO_UINT(SPV_Month), TO_UINT(SPV_Day), TO_UINT(SPV_Hour), TO_UINT(SPV_Min), 0, 0);
        prevSPV_DT := SPV_DT;
    END_IF;    
    
    // WARNING: Current Date 
    // Normal time flow
    IF NOT DisSpvUpdF_APP THEN
        SPV_CurrDoW := TO_USINT(CurrentDoW);
        updateDateTimeVar(CurrDateTime, SPV_CurrDay, SPV_CurrMonth, SPV_Curryear, SPV_CurrHour, SPV_CurrMin);
//        SPLIT_DT(CurrDateTime, tmpYear, tmpMonth, tmpDay, tmpHour, tmpMin, tmpSec, tmpMillis);
//        SPV_CurrYear := TO_REAL(tmpYear - 2000);
//        SPV_CurrMonth := TO_REAL(tmpMonth);
//        SPV_CurrDay := TO_REAL(tmpDay);
//        SPV_CurrHour := TO_REAL(tmpHour);
//        SPV_CurrMin := TO_REAL(tmpMin);
    ELSE
        DisSpvUpdF_APP := FALSE;
    END_IF;
       
    IF NOT WizDone THEN
        Alarms.Al.Al_RTC.Info.Trigger := FALSE;
    END_IF;
    
    
    {ENDREGION}
    
    {REGION LOGS management}
    
    IF NOT FirstRun THEN
        
        
        SPLIT_DT(StartLog_DT, tmp_Startlog);
        IF ((StartLog_Hour <> 0) OR (StartLog_Min <> 0)) AND
            ((StartLog_Hour <> TO_USINT(tmp_Startlog.Hour)) OR (StartLog_Min <> TO_USINT(tmp_Startlog.Minute))) THEN
            
            SPLIT_DT(CurrDateTime, tmp_CurrTime);
            StartLog_DT := CONCAT_DT(tmp_CurrTime.Year, tmp_CurrTime.Month, tmp_CurrTime.Day,
                            TO_UINT(StartLog_Hour), TO_UINT(StartLog_Min), 0, 0);
        ELSIF (StartLog_DT > DT#2000-01-01-00:00:00) AND 
            ((StartLog_Hour <> 0) OR (StartLog_Min <> 0))THEN
            IF (CurrDateTime >= StartLog_DT) THEN
                Logs.Check();
            END_IF;
        ELSE
            StartLog_DT := DT#2000-01-01-00:00:00;
        END_IF;
    END_IF;
    
//    IF SamplingTime > 0 THEN    
//        RS_StartLogs(S := (StartLog_DT > T#0ms) AND (CurrTime_Logs >= StartLog_DT), R1 := StopPeriodicsLogs);

//        IF RS_StartLogs.Q1 THEN
//           AND ((CurrDateTime - prevCurrDateTime) >= TO_TIME(TO_UDINT(SamplingTime) * 3600 * 1000)) THEN
//            prevCurrDateTime := CurrDateTime;
//            LogsEventsCounter := LogsEventsCounter + 1;
        
            
//            IF DfrPerformedCntLog <> DfrPerformedCntLog_prev THEN
//                DfrPerformedCntLog_prev := DfrPerformedCntLog;
//                DfrPerformed := TRUE;
//            ELSE
//                DfrPerformed := FALSE;
//            END_IF;
    
    {ENDREGION}
    
    /* **************************************************************************************/
    /*                                                                                      */
    /* MPXone NVRAM STRUCTURE:                                                              */
    /* from byte 0 to byte 3 --> Blackout management                                        */
    /* from byte 4 to byte 7 --> Management of the saving of the last defrost starting      */
    /*                                                                                      */
    /* ************************************************************************************ */
    
    {REGION READ LAST DEFROST TIME}
    NVRAM_ReadVar(4, lastDfrTime_DWORD);
    IF lastDfrTime_DWORD <> 0 THEN
        DfrStartedDT := TO_DT(lastDfrTime_DWORD);    
        IF CurrDateTime - DfrStartedDT < T#0h THEN //if different is out of range (too big)
            SetLastDfrTime_RTC_MEM(CurrDateTime);
        END_IF;
    END_IF;    
    {ENDREGION}
    
    {REGION BLACKOUT}
    
//    CurrentDate_UDINT := TO_UDINT(CurrDateTime);
    IF NOT FirsCheckBlackout THEN 
        //read
        NVRAM_ReadVar(0, NVRAM_Array);
        myPwrOffDate_NVRAM_BLKO := TO_UDINT(NVRAM_Array);
        FirsCheckBlackout := TRUE; 
    ELSE 
        NVRAM_Array := TO_DWORD(TO_UDINT(CurrDateTime));//TO_DWORD(CurrentDate_UDINT);
        NVRAM_WriteVar(0, NVRAM_Array);
        //read 
        NVRAM_ReadVar(0, NVRAM_Array);
        myPwrOffDate_NVRAM_BLKO := TO_UDINT(NVRAM_Array);
    END_IF;
    BlackoutCtl(PwrOffDate_NVRAM_BLKO := myPwrOffDate_NVRAM_BLKO);
    MyLastOffDate := CONCAT_DT(BlackoutCtl.LastOnYear_BLKO,
                               BlackoutCtl.LastOnMonth_BLKO,
                               BlackoutCtl.LastOnDay_BLKO,
                               BlackoutCtl.LastOnHour_BLKO,
                               BlackoutCtl.LastOnMin_BLKO,
                               BlackoutCtl.LastOnSec_BLKO, 0);
    
    BlackoutSR(S1 := MyLastOffDate <> MyLastOffDate_Saved, R := NOT firstCycle);
    
    //IF MyLastOffDate_Saved > CurrDateTime THEN 
    IF (CurrDateTime >= DT#1970-01-01-00:00:00) AND (CurrDateTime < DT#1970-01-02-00:00:00) THEN
        Alarms.Al.Al_RTC.Info.Trigger := TRUE;
    END_IF;
    
    MyLastOffDate_Saved := MyLastOffDate;
    
    {ENDREGION}
    
    
    {REGION SAFE DOWNLOAD}
    
    IF GetFullDownloadRequest() THEN (*catch the request of fulldownload*)
        // Close solenoid
        WaitForUpdate := TRUE; (*switch off the unit*)
        
        // Close EEV
        {IF NOT DEF(MPXONE_BASIC)}
        EnManExv := FALSE;
        MachineVars.ManualPositioner_vars.ManualPositioningEnable := TRUE;
        MachineVars.ManualPositioner_vars.ManualPositionSteps := 0;
        
        TON_WAIT_DOWNLOAD(IN := TRUE,PT := T#1s);
        IF MachineVars.Engine_vars.EEV_vars.CurrentEstimatedPosition = 0 AND NOT CompOn OR hwCode = 312 THEN // TODO Verify that 312 is only PC symulator
            //UnitStatus := FALSE; (*switch off the unit*)
            /*IF Info_PWRP.Info_RotorSpeed_Perc = 0 THEN    
                (*when the compressor is off, the full download can be done*)
                SetIDESema(TO_INT(IDESEMA_FULLDOWNLOAD),TO_INT(SEMA_STATUS_GO));
            ELSE
                (*waiting the compressor switch off*)
                SetIDESema(TO_INT(IDESEMA_FULLDOWNLOAD),TO_INT(SEMA_STATUS_WAIT)); 
            END_IF;*/
            // Conferma
            SetIDESema(TO_INT(IDESEMA_FULLDOWNLOAD),TO_INT(SEMA_STATUS_GO));
        END_IF;
        {ENDIF}
        
        {IF NOT DEF(MPXONE_MEDIUM)}
        TON_WAIT_DOWNLOAD(IN := TRUE,PT := T#1s);
        IF NOT CompOn OR hwCode = 312 THEN // TODO Verify that 312 is only PC symulator
            //UnitStatus := FALSE; (*switch off the unit*)
            /*IF Info_PWRP.Info_RotorSpeed_Perc = 0 THEN    
                (*when the compressor is off, the full download can be done*)
                SetIDESema(TO_INT(IDESEMA_FULLDOWNLOAD),TO_INT(SEMA_STATUS_GO));
            ELSE
                (*waiting the compressor switch off*)
                SetIDESema(TO_INT(IDESEMA_FULLDOWNLOAD),TO_INT(SEMA_STATUS_WAIT)); 
            END_IF;*/
            // Conferma
            SetIDESema(TO_INT(IDESEMA_FULLDOWNLOAD),TO_INT(SEMA_STATUS_GO));
        END_IF;
        {ENDIF}
    ELSE
        TON_WAIT_DOWNLOAD(IN := FALSE,PT := T#0s);
        SetIDESema(TO_INT(IDESEMA_FULLDOWNLOAD),TO_INT(SEMA_STATUS_WAIT));
        WaitForUpdate := FALSE; (*switch off the unit*)
    END_IF;
    
    {ENDREGION}
    
    {IF DEF(NO_SEV_SUPPORT)}
    Libs.ReportSlaveID.ReportSlaveID(OneRow.Info.ReportSlaveID, OneRow.GetID(), OneRow.Info.Zone); 
	OneRow.Write();
    {ENDIF}
    
	(* Refresh UI *)
	SendVirtualKey(NO_KEY, 1);
    

    
    // Visual store configuration (APP) management
    IF FirstRun THEN
        
        // Prepare the controller to store log messages	    
        {IF DEF(MPX_LOGS)}InitLog(LogsBuffer);{ENDIF}
        
        IF DfrStartedDT <= DT#1970-01-01-00:00:00 THEN
            DfrStartedDT := CurrDateTime;
        END_IF;
        
        // Reset the quick commands retained in NFC
        
        FirstRun := FALSE;
    END_IF;
    
    // Passthrough timeout
    PassThroughTON(IN := SlvUpdFW, PT := T#30s);
    IF PassThroughTON.Q THEN
        SlvUpdFW := FALSE;
    END_IF;
    
    // Configuration lookup
    //FOR cfgId := 0 TO 6 DO
        cfgOk := GetConfigurationName(TO_USINT(cfgId), cfgName);
    //END_FOR;
    
    // Change config by DI
    CngCnfRT(CLK := DigitalInputs.Fct.Config);
    IF CngCnfRT.Q AND NOT firstCycle THEN
        IF DigitalInputs.Fct.Config THEN
            cfgOk := SetConfiguration('C1');
        ELSE
            cfgOk := SetConfiguration('C2');
        END_IF;
        cfgOk := cfgOk;
    END_IF;
    
    // Applica profile recognition
    isUser := TRUE;
    isService := TRUE;
    isManufacturer := TRUE;
END_PROGRAM

FUNCTION_BLOCK StoreConfigSave
    VAR_IN_OUT
        ExtConfig : ARRAY[*] OF USINT;
        Config : ARRAY[*] OF WORD;
    END_VAR
    VAR
        index, ArrayOffset : DINT;
        tmpVal : WORD;
    END_VAR
    
    FOR ArrayOffset := 0 TO UPPER_BOUND(Config, 1) DO
    	Config[ArrayOffset] := 0;
    	FOR	index := 0 TO 7 DO
    		IF index + ArrayOffset * 8 <= UPPER_BOUND(ExtConfig, 1) THEN
    			tmpVal := SHL(TO_WORD(ExtConfig[index + ArrayOffset * 8]), index * 2);
    			Config[ArrayOffset] := TO_WORD(Config[ArrayOffset]) OR tmpVal;
    		END_IF;
    	END_FOR;
    END_FOR;
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK StoreConfigRead
    VAR_IN_OUT
        ExtConfig : ARRAY[*] OF USINT;
        Config : ARRAY[*] OF WORD;
    END_VAR
    VAR
        index, ArrayOffset : DINT;
        tmpVal : WORD;
    END_VAR
    
    FOR ArrayOffset := 0 TO UPPER_BOUND(Config, 1) DO
    	//Config[ArrayOffset] := 0;
    	FOR	index := 0 TO 7 DO
    		IF index + ArrayOffset * 8 <= UPPER_BOUND(ExtConfig, 1) THEN
    			tmpVal := SHR(TO_WORD(Config[ArrayOffset]), index * 2);
    			ExtConfig[index + ArrayOffset * 8] := TO_USINT(tmpVal AND 2#11);
    		END_IF;
    	END_FOR;
    END_FOR;
    
END_FUNCTION_BLOCK

FUNCTION SetSerialSpeed : UDINT
    VAR_INPUT
        Index : USINT;
    END_VAR
    CASE Index OF
        0: SetSerialSpeed :=1200;
        1: SetSerialSpeed :=2400;
        2: SetSerialSpeed :=4800;
        3: SetSerialSpeed :=9600;
        4: SetSerialSpeed :=19200;
        5: SetSerialSpeed :=38400;
        6: SetSerialSpeed :=57600;
        7: SetSerialSpeed :=115200;
        8: SetSerialSpeed :=375000; 
    END_CASE;
END_FUNCTION

FUNCTION updateDateTimeVar
    VAR_IN_OUT CONSTANT
        varCurrDateTime : DATE_AND_TIME;
    END_VAR
    
    VAR_IN_OUT
        varDay, varMonth, varYear, varHour, varMin : USINT;
    END_VAR
    
    VAR
        tmpYear, tmpMonth, tmpDay, tmpHour, tmpMin, tmpSec, tmpMillis : UINT;
    END_VAR
    
    SPLIT_DT(varCurrDateTime, tmpYear, tmpMonth, tmpDay, tmpHour, tmpMin, tmpSec, tmpMillis);
    varYear := TO_USINT(tmpYear - 2000);
    varMonth := TO_USINT(tmpMonth);
    varDay := TO_USINT(tmpDay);
    varHour := TO_USINT(tmpHour);
    varMin := TO_USINT(tmpMin);
END_FUNCTION

FUNCTION updateDateTimeVar
    VAR_IN_OUT CONSTANT
        varCurrDateTime : DATE_AND_TIME;
    END_VAR
    
    VAR_IN_OUT
        varDay, varMonth, varYear, varHour, varMin : REAL;
    END_VAR
    
    VAR
        tmpYear, tmpMonth, tmpDay, tmpHour, tmpMin, tmpSec, tmpMillis : UINT;
    END_VAR
    
    SPLIT_DT(varCurrDateTime, tmpYear, tmpMonth, tmpDay, tmpHour, tmpMin, tmpSec, tmpMillis);
    varYear := TO_REAL(tmpYear - 2000);
    varMonth := TO_REAL(tmpMonth);
    varDay := TO_REAL(tmpDay);
    varHour := TO_REAL(tmpHour);
    varMin := TO_REAL(tmpMin);
END_FUNCTION

FUNCTION Split_UniqueId
    VAR_IN_OUT CONSTANT
        UniqueID : LWORD;
    END_VAR
    
    VAR_IN_OUT
        UniqueID_splitted : ARRAY[*] OF USINT;
    END_VAR
    
    VAR
        i : DINT;    
    END_VAR
    
    FOR i := LOWER_BOUND(UniqueID_splitted,1) TO UPPER_BOUND(UniqueID_splitted,1) DO
        UniqueID_splitted[i] := TO_USINT(SHR(UniqueID, i * 8));
    END_FOR;
    
END_FUNCTION
    
    
    /**
        Set DfrStartedDT
        Store on NVRAM DfrStartedDT
    */
FUNCTION SetLastDfrTime_RTC_MEM
    VAR_INPUT
        LastDfrTime : DT;
    END_VAR

    DfrStartedDT := LastDfrTime;
    NVRAM.NVRAM_WriteVar(4, TO_DWORD(DfrStartedDT));
END_FUNCTION

END_NAMESPACE