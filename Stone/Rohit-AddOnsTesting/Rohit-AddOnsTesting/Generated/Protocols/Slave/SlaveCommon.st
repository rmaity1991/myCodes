
NAMESPACE SlaveCommon
    USING Protocols;

    CLASS SlaveInfo
        VAR PUBLIC
            Online : BOOL;
            TimeOut : UDINT;
            PollInterval : UDINT;
            ExecutionTime : UDINT;
            PollsCount : UDINT;
            Zone : System.Globalization.Zone;
        END_VAR
    END_CLASS

    CLASS ModbusSlaveInfo EXTENDS SlaveInfo
        VAR PUBLIC
            ReportSlaveID : ReportSlaveID;
        END_VAR
    END_CLASS

    CLASS CarelSlaveInfo EXTENDS SlaveInfo
        VAR PUBLIC
            PeripheralInfo : PeripheralInfo;
        END_VAR
    END_CLASS

    {METADATA SUPPRESS_WARNINGS}
	{IF NOT DEF(NO_TCP_SUPPORT)}
	    CLASS ServerConfigurationBase
        VAR PUBLIC
            (** Protocol Serial Line Settings. *)
            TCPSettings : System.Net.TcpIp.TcpIpSettings;
        END_VAR
        VAR PROTECTED
            {METADATA HIDDEN}
            NetPort : System.Net.TcpIp.NetPort;
            {METADATA HIDDEN}
            Running : BOOL;
            {METADATA HIDDEN}
            Init	: BOOL;
            {METADATA HIDDEN}
            CurrentIdent : REF_TO USINT;
            {METADATA HIDDEN}
            ID : UINT;
        END_VAR

        {METADATA HIDDEN}
        METHOD PROTECTED InitBase : DINT
            VAR_INPUT
                Start  : BOOL;
                TaskID : UINT;
            END_VAR
           
        	THIS.TCPSettings.EventMask := System.CreateDynamicEvent();
            THIS.NetPort.Settings := THIS.TCPSettings;
            
            IF System.SubscribeEvent(TaskID, THIS.TCPSettings.EventMask) <> 1 THEN
                InitBase := -1;
            ELSIF Start THEN
                InitBase := THIS.Start();
            END_IF;
            
        END_METHOD

        (**
         * Starts the protocol.
         * If the protocol is already running, does nothing.
         * Returns 0 if success, serial error otherwise.
         *)
        METHOD Start : DINT
            VAR
                SessionID : SINT;
            END_VAR
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF NOT THIS.Running THEN
            	    SessionID := System.Net.TcpIp.SessionOpen(THIS.NetPort.Settings,THIS.NetPort.Buffer,THIS.NetPort.Memory);
                    THIS.Running := TRUE;
                    Start := 0; /*check errors*/
                END_IF;
            END_IF;
        END_METHOD

        (**
         * Stops the protocol.
         * If the protocol is not running, does nothing.
         * Returns 0 if success, serial error otherwise.
         *)
        METHOD Stop : DINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF THIS.Running THEN
                    THIS.Running := FALSE;
                END_IF;
            END_IF;
        END_METHOD

        METHOD IsRunning : BOOL
            IsRunning := THIS.Running;
        END_METHOD

        (**
         * Changes the settings of the Serial Line, and restarts the protocol.
         * Returns 0 if success, serial error otherwise.
         *)
        METHOD ChangeSettings : DINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF THIS.TcpSettings <> THIS.NetPort.Settings THEN
                    THIS.Stop();
                    THIS.NetPort.Settings := THIS.TcpSettings;
                    ChangeSettings := THIS.Start();
                END_IF;
            END_IF;
        END_METHOD

        (**
         * Changes the current slave Ident.
         *)
        METHOD ChangeIdent
            VAR_INPUT
                NewIdent : USINT;
            END_VAR
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF THIS.CurrentIdent^ <> NewIdent THEN
                    THIS.CurrentIdent^ := NewIdent;
                END_IF;
            END_IF;
        END_METHOD

        METHOD GetIdent : USINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                GetIdent := THIS.CurrentIdent^;
            END_IF;
        END_METHOD

        METHOD GetID : UINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                GetID := THIS.ID;
            END_IF;
        END_METHOD

    END_CLASS
	{ENDIF}
    
    {METADATA SUPPRESS_WARNINGS}
    CLASS SlaveConfigurationBase
        VAR PUBLIC
            (** Protocol Serial Line Settings. *)
            SerialSettings : System.Serial.SerialSettings;
        END_VAR
        VAR PROTECTED
            {METADATA HIDDEN}
            SerialPort : System.Serial.SerialPort;
            {METADATA HIDDEN}
            Running : BOOL;
            {METADATA HIDDEN}
            Init	: BOOL;
            {METADATA HIDDEN}
            CurrentIdent : REF_TO USINT;
            {METADATA HIDDEN}
            ID : UINT;
        END_VAR

        {METADATA HIDDEN}
        METHOD PROTECTED InitBase : DINT
            VAR_INPUT
                Start  : BOOL;
                TaskID : UINT;
            END_VAR

            THIS.SerialSettings.MaskEvent := System.CreateDynamicEvent();
            THIS.SerialPort.Settings := THIS.SerialSettings;

            IF System.SubscribeEvent(TaskID, THIS.SerialSettings.MaskEvent) <> 1 THEN
                InitBase := -1;
            ELSIF Start THEN
                InitBase := THIS.Start();
            END_IF;
        END_METHOD

        (**
         * Starts the protocol.
         * If the protocol is already running, does nothing.
         * Returns 0 if success, serial error otherwise.
         *)
        METHOD Start : DINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF NOT THIS.Running THEN
{IF NOT DEF(NO_PLAN_SUPPORT)}
                    IF THIS.SerialPort.Settings.Channel = System.Serial.Serial_Channel#Serial0 AND System.Net.Plan.IsPlanRunning() THEN
                        IF System.Net.Plan.StopPlan() <> 0 THEN
                            Start := System.Serial.LIB_SERIAL_ERR_COM_ALREADY_OPEN;
{IF DEF(DEBUG_PROTO)}
                            System.WriteLog(System.LogLevel#Error_Level, 'Error stopping pLan');
{ENDIF}
                            RETURN;
                        END_IF;
                    END_IF;
{ENDIF}
                    Start := System.Serial.SerialOpen(THIS.SerialPort);
                    IF Start = 0 THEN
                        THIS.CheckDebugPort();
                        THIS.Running := TRUE;
{IF DEF(DEBUG_PROTO)}
                    ELSE
                        System.WriteLog(System.LogLevel#Error_Level, 'Serial Error ' + System.TO_STRING(Start) + ' opening port ' + System.TO_STRING(THIS.SerialPort.Settings.Channel));
{ENDIF}
                    END_IF;
                END_IF;
            END_IF;
        END_METHOD

        (**
         * Stops the protocol.
         * If the protocol is not running, does nothing.
         * Returns 0 if success, serial error otherwise.
         *)
        METHOD Stop : DINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF THIS.Running THEN
                    Stop := System.Serial.SerialClose(THIS.SerialPort.Settings.Channel);
                    THIS.Running := FALSE;

{IF DEF(DEBUG_PROTO)}
                    IF Stop < 0 THEN
                        System.WriteLog(System.LogLevel#Error_Level, 'Serial Error ' + System.TO_STRING(Stop) + ' closing port ' + System.TO_STRING(THIS.SerialPort.Settings.Channel));
                    END_IF;
{ENDIF}

{IF NOT DEF(NO_PLAN_SUPPORT)}
                    IF THIS.SerialPort.Settings.Channel = System.Serial.Serial_Channel#Serial0 THEN
                        IF System.Net.Plan.RestartPlan() <> 0 THEN
                            Stop := System.Serial.LIB_SERIAL_ERR_INTERNAL_ERROR2;
{IF DEF(DEBUG_PROTO)}
                            System.WriteLog(System.LogLevel#Error_Level, 'Error restarting pLan');
{ENDIF}
                        END_IF;
                    END_IF;
{ENDIF}
                END_IF;
            END_IF;
        END_METHOD

        METHOD IsRunning : BOOL
                IsRunning := THIS.Running;
        END_METHOD

        (**
         * Changes the settings of the Serial Line, and restarts the protocol.
         * Returns 0 if success, serial error otherwise.
         *)
        METHOD ChangeSettings : DINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF THIS.SerialSettings <> THIS.SerialPort.Settings THEN
                    THIS.Stop();
                    THIS.SerialPort.Settings := THIS.SerialSettings;
                    ChangeSettings := THIS.Start();
                END_IF;
            END_IF;
        END_METHOD

        (**
         * Changes the current slave Ident.
         *)
        METHOD ChangeIdent
            VAR_INPUT
                NewIdent : USINT;
            END_VAR
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                IF THIS.CurrentIdent^ <> NewIdent THEN
                    THIS.CurrentIdent^ := NewIdent;
                    THIS.CheckDebugPort();
                END_IF;
            END_IF;
        END_METHOD

        METHOD GetIdent : USINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                GetIdent := THIS.CurrentIdent^;
            END_IF;
        END_METHOD

        METHOD GetID : UINT
            IF Init = FALSE THEN
                SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
            ELSE
                GetID := THIS.ID;
            END_IF;
        END_METHOD

        METHOD PRIVATE CheckDebugPort
            IF System.Serial.SerialIsDebug(THIS.SerialPort.Settings.Channel) AND THIS.SerialPort.Settings.Mode = System.Serial.Serial_Mode#ModbusShared THEN
                System.Serial.SetModbusDebugID(THIS.CurrentIdent^, THIS.SerialPort.Settings.Channel);
            END_IF;
        END_METHOD
    END_CLASS

{IF NOT DEF(NO_TCP_SUPPORT)}
    CLASS ModbusServerConfigurationBase EXTENDS ServerConfigurationBase
	        VAR PUBLIC
            (** Modbus Protocol Diagnostic Informations. *)
            Info : ModbusSlaveInfo;
        END_VAR

        {METADATA HIDDEN}
        METHOD PROTECTED ProtocolInitBase : DINT
            VAR_INPUT
                Start : BOOL;
                TaskID : UINT;
            END_VAR

            ProtocolInitBase := SUPER.InitBase(Start, TaskID);
        END_METHOD
    END_CLASS
{ENDIF}

    CLASS ModbusSlaveConfigurationBase EXTENDS SlaveConfigurationBase
        VAR PUBLIC
            (** Modbus Protocol Diagnostic Informations. *)
            Info : ModbusSlaveInfo;
        END_VAR

        {METADATA HIDDEN}
        METHOD PROTECTED ProtocolInitBase : DINT
            VAR_INPUT
                Start : BOOL;
                TaskID : UINT;
            END_VAR

            ProtocolInitBase := SUPER.InitBase(Start, TaskID);
        END_METHOD
    END_CLASS

    CLASS CarelSlaveConfigurationBase EXTENDS SlaveConfigurationBase
        VAR PUBLIC
            (** Modbus Protocol Diagnostic Informations. *)
            Info : CarelSlaveInfo;
        END_VAR

        {METADATA HIDDEN}
        METHOD PROTECTED ProtocolInitBase : DINT
            VAR_INPUT
                Start : BOOL;
                TaskID : UINT;
            END_VAR
            VAR
                (** device model *)
                deviceType:UINT;
                (** board type *)
                boardType:UINT;
                (** Target machine type *)
                machineType:UINT;
                (** Target hardware code *)
                hwCode:UINT;
            END_VAR

            System.GetModel(deviceType, boardType, machineType, hwCode);

            THIS.Info.PeripheralInfo.PeripheralType := machineType;
            THIS.Info.PeripheralInfo.HWCode := hwCode;

            ProtocolInitBase := SUPER.InitBase(Start, TaskID);
        END_METHOD
    END_CLASS

END_NAMESPACE