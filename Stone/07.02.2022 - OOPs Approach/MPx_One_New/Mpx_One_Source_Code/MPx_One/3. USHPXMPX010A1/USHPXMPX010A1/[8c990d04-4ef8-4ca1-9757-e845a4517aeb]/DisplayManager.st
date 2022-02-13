{INCLUDE 'LibVer.g.st'}

USING System;
USING System.Timer;
USING System.RemoteIO;
USING System.NFC;

VAR_GLOBAL RETAIN
    RestoreDefDone:BOOL;
END_VAR

VAR_GLOBAL PERSISTENT
    (**  Display serial number (0 = SN not present)  *)
    dispSN:ULINT;
    firstDispConn:BOOL;
END_VAR

TYPE
DownloadDir : ( HMItoACU, ACUtoHMI );
END_TYPE

CLASS DisplayManager
    VAR PUBLIC
        infoHMI : Remote_HMIInfo;
        nfcInfo : System.NFC.nfcInfo;
        nfcWriteInfo : System.NFC.nfcWriteInfo;
    END_VAR
   
    VAR PRIVATE
        (** First read of NFC memory of display has been performed *)
        readOk : BOOL := FALSE;
        (** Counter to compare with the display needed to identify an interation with Applica *)
        writeCounter : INT;
        (** Display has been changed during normal working *)
        dispIsCng : BOOL;
        (** Force the local configuration (ACU) *)
        frcLocPar : bool;
        (** Display has a different NFC CRC (Different application or version?) *)
        dispCRC_KO : BOOL;
        
        F_TRIG_hmi : F_TRIG;
        skipGetData : BOOL;
        firstStartUpDone : BOOL;        
    END_VAR
    
    METHOD GetCounter : INT
        GetCounter := THIS.writeCounter;
    END_METHOD
    
    (** Check the display and NFC info *)
    METHOD Check
        VAR_INPUT
            isPanelVersion : BOOL;
            isCommToolPresent : BOOL;
        END_VAR
        
        VAR
            res : DINT;
        END_VAR
        
        GetDisplayInfo(infoHMI);
        GetNfcInfo(nfcInfo);
        GetNfcWriteInfo(nfcWriteInfo);
        
        //Wait until the infoHMI is populated with real values
        IF infoHMI.SN = 0 AND infoHMI.FWRel = 0 THEN
            RETURN;
        END_IF;
        
        //In order to jump the read after same HMI offline in case of commissioning tool connected
        F_TRIG_hmi(CLK := isCommToolPresent AND NOT infoHMI.Alive);
        IF F_TRIG_hmi.Q THEN
            skipGetData := TRUE;
        END_IF;
        
        // NFC memory needs to be initialized
        IF THIS.nfcInfo.status = LIB_NFC_ERR_NOT_INIT THEN
            res := NFC.Init(); // 0 = No error?
            RETURN;
        END_IF;
        
        // Display SN check with global persistent data
        IF infoHMI.SN <> dispSN THEN
            // A serial number has been read before?
            IF dispSN <> 0 AND (NOT isPanelVersion) THEN //Debug Log #1
                THIS.dispIsCng := TRUE;
            ELSE
                // First display connected
                dispSN := infoHMI.SN;
                firstDispConn := TRUE;
            END_IF;
        END_IF;
        
        // Normal LIVE operations
        IF (THIS.nfcInfo.status = LIB_NFC_NO_PENDING_OPERATION OR THIS.nfcInfo.status = LIB_NFC_PENDING_WRITE)
            AND nfcWriteInfo.busy = 0 THEN
            
            // Wait for user confirmation
            IF THIS.dispIsCng THEN
                NFC.Read();
                RETURN;
            END_IF;
            
            IF NOT readOk AND NOT THIS.frcLocPar THEN
                
                // Read in progress
                IF NOT THIS.skipGetData THEN
                    //NFC.Read();
                    res := NFC.GetData();
                END_IF;
                readOk := NOT(res = LIB_NFC_PENDING_READ);
                
                // Read completed
                IF (res = LIB_NFC_OK OR res = LIB_NFC_ERR_NO_OPERATION) AND (firstStartUpDone OR (NOT RestoreDefDone) OR firstDispConn) THEN
                    THIS.writeCounter := nfcWriteInfo.counter;
                    
                    IF firstDispConn THEN firstDispConn := FALSE; END_IF;
                    
                ELSE
                    firstStartUpDone := TRUE;
                END_IF;
                
                RETURN;
                
            END_IF;
                        
            // NFC has been written externally?
            // Compare the display writeCounter with the local one 
            IF nfcWriteInfo.counter <> THIS.writeCounter AND readOk AND NOT THIS.frcLocPar THEN
                
                // Read NFC memory to fetch current status
                res := NFC.GetData();
                
                // Operation not possible due to errors
                IF res <> LIB_NFC_OK AND res <> LIB_NFC_ERR_NO_OPERATION THEN //Debug Log #2
                    THIS.frcLocPar := FALSE;
                    THIS.dispIsCng := TRUE;
                    THIS.dispCRC_KO := TRUE;
                    RETURN;
                END_IF;
                
                //THIS.writeCounter := nfcWriteInfo.counter;
                NFC.Read();
                readOk := FALSE;
                RETURN;
            END_IF;
        
            // Keep updated the NFC memory with APP parameters
            res := NFC.Write();
            
            IF NOT RestoreDefDone THEN RestoreDefDone := TRUE; END_IF;
            
            // Eventually reset the flag
            THIS.frcLocPar := FALSE;
            THIS.dispCRC_KO := FALSE;
            THIS.skipGetData := FALSE; 
            
        END_IF;
        
    END_METHOD
    
    (** Start a sync procedure after an hot swap of display 
     0 = OK
     -1 = Display doesn't need syncronization
     -2 = If direction is DownloadDir#ACUtoHMI and display has different CRC
    *)
    METHOD StartSync : SINT
        VAR_INPUT
            Direction : DownloadDir;
            En_NFC_trigger : BOOL;
        END_VAR
        
        // If display is already in sync
        IF NOT THIS.dispIsCng AND NOT En_NFC_trigger THEN
            StartSync := - 1;
            RETURN;
        END_IF;
        
        // Pending operations
        IF THIS.nfcWriteInfo.busy <> 0 AND THIS.nfcInfo.status <> 0 THEN
            RETURN;
        END_IF;
        
        IF Direction = DownloadDir#ACUtoHMI THEN
            THIS.frcLocPar := TRUE;
        ELSE
            // Display has been read with errors?
            IF THIS.dispCRC_KO THEN
                StartSync := - 2;
                RETURN;
            END_IF;
        END_IF;
        
        // Confirm user action
        THIS.dispIsCng := FALSE;
        
        // Save the Serial Number
        dispSN := infoHMI.SN;
    END_METHOD
    
    METHOD isWaitingForUser : BOOL
        isWaitingForUser := THIS.dispIsCng;
    END_METHOD
    
    
//    METHOD SetNFC_Pwd : DINT
//        VAR_INPUT
//            psw : string[3];
//        END_VAR
//        IF (psw<>psw_old) AND psw_old <> '' THEN
//            psw_old := psw;
//            SetNFC_Pwd := System.NFC.SetNfcPassword(psw);
//        END_IF;
//    END_METHOD    
END_CLASS
