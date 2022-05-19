{INCLUDE "../ProtocolOptions.g.st"}
USING SlaveCommon;
USING System;
USING System.Serial;
{IF NOT DEF(NO_TCP_SUPPORT)}
USING System.Net.TcpIp;
{ENDIF}
{DEFINE USER_EVENT_DATA UDINT#1234}
VAR_GLOBAL
	Display : SlaveConfigurations.Display;
END_VAR

NAMESPACE SlaveConfigurations

//Registers
{DEFINE _MIN_INPUT_REGISTERS	0}
{DEFINE _MAX_INPUT_REGISTERS	0}
{DEFINE _MIN_HOLDING_REGISTERS	0}
{DEFINE _MAX_HOLDING_REGISTERS	0}
//Coils
{DEFINE _MIN_INPUT_STATUS	0}
{DEFINE _MAX_INPUT_STATUS	0}
{DEFINE _MIN_COIL_STATUS	0}
{DEFINE _MAX_COIL_STATUS	0}

CLASS Display_ModbusSlaveDevice
    USING ModbusSlave;
    VAR PUBLIC
        Mutex : Mutex;
        Data : ModbusSlaveData;
    END_VAR
    VAR INTERNAL
        Input_Register		: ARRAY [_MIN_INPUT_REGISTERS.._MAX_INPUT_REGISTERS] OF WORD;
        Holding_Register	: ARRAY [_MIN_HOLDING_REGISTERS.._MAX_HOLDING_REGISTERS] OF WORD;
        Input_Status		: ARRAY [_MIN_INPUT_STATUS/8.._MAX_INPUT_STATUS/8] OF BYTE;
        Coil_Status			: ARRAY [_MIN_COIL_STATUS/8.._MAX_COIL_STATUS/8] OF BYTE;

        Changed_Holding_Register : ARRAY [_MIN_HOLDING_REGISTERS.._MAX_HOLDING_REGISTERS] OF BOOL;
        Changed_Coil_Status : ARRAY [_MIN_COIL_STATUS.._MAX_COIL_STATUS] OF BOOL;
    END_VAR

    METHOD Init
        VAR_INPUT
            Ident : USINT;
        END_VAR

        THIS.Data.Ident := Ident;

        THIS.Data.MIN_INPUT_REGISTERS   := _MIN_INPUT_REGISTERS;
        THIS.Data.MAX_INPUT_REGISTERS   := _MAX_INPUT_REGISTERS;
        THIS.Data.MIN_HOLDING_REGISTERS := _MIN_HOLDING_REGISTERS;
        THIS.Data.MAX_HOLDING_REGISTERS := _MAX_HOLDING_REGISTERS;

        THIS.Data.MIN_INPUT_STATUS	:= _MIN_INPUT_STATUS;
        THIS.Data.MAX_INPUT_STATUS	:= _MAX_INPUT_STATUS;
        THIS.Data.MIN_COIL_STATUS	:= _MIN_COIL_STATUS;
        THIS.Data.MAX_COIL_STATUS	:= _MAX_COIL_STATUS;


        THIS.Data.Input_Register	:= REF(THIS.Input_Register);
        THIS.Data.Holding_Register	:= REF(THIS.Holding_Register);
        THIS.Data.Input_Status		:= REF(THIS.Input_Status);
        THIS.Data.Coil_Status		:= REF(THIS.Coil_Status);

        THIS.Data.Changed_Holding_Register	:= REF(THIS.Changed_Holding_Register);
        THIS.Data.Changed_Coil_Status 		:= REF(THIS.Changed_Coil_Status);

        System.InitMutex(THIS.Mutex);
    END_METHOD

    METHOD ManageSerialPacket : BOOL
        VAR_INPUT
            count : DINT;
        END_VAR

        ManageSerialPacket := ProcessRequest(THIS.Data, count);

    END_METHOD

    METHOD GetVariable : WORD
        USING System.Math;
        VAR_INPUT
            _type : ModbusKind;
            index : UINT;
        END_VAR

        CASE _type OF
        ModbusKind#CoilStatus:
            IF index >= THIS.Data.MIN_COIL_STATUS AND index <= THIS.Data.MAX_COIL_STATUS THEN
                GetVariable := TO_WORD(SHR(THIS.Coil_Status[(index-1)/8], (index - 1) MOD 8) AND 1);
                THIS.Changed_Coil_Status[index] := FALSE;
            END_IF;
        ModbusKind#InputStatus:
            IF index >= THIS.Data.MIN_INPUT_STATUS AND index <= THIS.Data.MAX_INPUT_STATUS THEN
                GetVariable := TO_WORD(SHR(THIS.Input_Status[(index-1)/8], (index - 1) MOD 8) AND 1);
            END_IF;
        ModbusKind#HoldingRegister:
            IF index >= THIS.Data.MIN_HOLDING_REGISTERS AND index <= THIS.Data.MAX_HOLDING_REGISTERS THEN
                GetVariable := THIS.Holding_Register[index];
                THIS.Changed_Holding_Register[index] := FALSE;
            END_IF;
        ModbusKind#InputRegister:
            IF index >= THIS.Data.MIN_INPUT_REGISTERS AND index <= THIS.Data.MAX_INPUT_REGISTERS THEN
                GetVariable := THIS.Input_Register[index];
            END_IF;
        END_CASE;

    END_METHOD

    METHOD SetVariable
        VAR_INPUT
            _type : ModbusKind;
            index : UINT;
            value : WORD;
        END_VAR

        THIS.SetVariable(_type, index, value, FALSE);
    END_METHOD

    METHOD PRIVATE SetVariable
        USING System.Math;
        VAR_INPUT
            _type : ModbusKind;
            index : UINT;
            value : WORD;
            force : BOOL;
        END_VAR

        CASE _type OF
        ModbusKind#CoilStatus:
            IF index >= THIS.Data.MIN_COIL_STATUS AND index <= THIS.Data.MAX_COIL_STATUS THEN
                IF THIS.GetVariable(_type, index) <> value THEN
                    THIS.Coil_Status[(index-1)/8] := THIS.Coil_Status[(index-1)/8] XOR SHL(BYTE#1, (index-1) MOD 8);
                END_IF;
                IF force THEN
                    THIS.Changed_Coil_Status[index] := TRUE;
                END_IF;
            END_IF;
        ModbusKind#InputStatus:
            IF index >= THIS.Data.MIN_INPUT_STATUS AND index <= THIS.Data.MAX_INPUT_STATUS THEN
                IF THIS.GetVariable(_type, index) <> value THEN
                    THIS.Input_Status[(index-1)/8] := THIS.Input_Status[(index-1)/8] XOR SHL(BYTE#1, (index-1) MOD 8);
                END_IF;
            END_IF;
        ModbusKind#HoldingRegister:
            IF index >= THIS.Data.MIN_HOLDING_REGISTERS AND index <= THIS.Data.MAX_HOLDING_REGISTERS THEN
                THIS.Holding_Register[index] := value;
                IF force THEN
                    THIS.Changed_Holding_Register[index] := TRUE;
                END_IF;
            END_IF;
        ModbusKind#InputRegister:
            IF index >= THIS.Data.MIN_INPUT_REGISTERS AND index <= THIS.Data.MAX_INPUT_REGISTERS THEN
                THIS.Input_Register[index] := value;
            END_IF;
        END_CASE;
    END_METHOD

    METHOD RWVariable : WORD
        VAR_INPUT
            _type : ModbusKind;
            index : UINT;
            (** Write mode: TRUE = W & R / FALSE = R only *)
            rw : BOOL;
            (** Override mode: if TRUE overrides Supervisor value,
            if a write request was received between last read and
            this function call. *)
            overrideSupervisor : BOOL;
            value : WORD;
        END_VAR

        IF rw THEN
            IF overrideSupervisor OR (NOT THIS.IsVariableChanged(_type, index)) THEN
                THIS.SetVariable(_type, index, value);
            END_IF;
        END_IF;
        RWVariable := THIS.GetVariable(_type, index);
    END_METHOD

    (**
     *  Gets if a variable at specified index (1-based) is changed.
     *)
    METHOD IsVariableChanged : BOOL
        VAR_INPUT
            _type : ModbusKind;
            index : UINT;
        END_VAR

        CASE _type OF
        ModbusKind#CoilStatus:
            IF index >= THIS.Data.MIN_COIL_STATUS AND index <= THIS.Data.MAX_COIL_STATUS THEN
                IsVariableChanged := THIS.Changed_Coil_Status[index];
            END_IF;
        ModbusKind#HoldingRegister:
            IF index >= THIS.Data.MIN_HOLDING_REGISTERS AND index <= THIS.Data.MAX_HOLDING_REGISTERS THEN
                IsVariableChanged := THIS.Changed_Holding_Register[index];
            END_IF;
        END_CASE;
    END_METHOD
END_CLASS

//Undefine Registers
{UNDEF _MIN_INPUT_REGISTERS	 }
{UNDEF _MAX_INPUT_REGISTERS	 }
{UNDEF _MIN_HOLDING_REGISTERS}
{UNDEF _MAX_HOLDING_REGISTERS}
//Undefine Coils
{UNDEF _MIN_INPUT_STATUS}
{UNDEF _MAX_INPUT_STATUS}
{UNDEF _MIN_COIL_STATUS	}
{UNDEF _MAX_COIL_STATUS	}


{DEFINE PROTOCOL_Modbus}
PROGRAM Program_Display
    VAR PUBLIC
        slave : Display_ModbusSlaveDevice;
        Info : REF_TO SlaveInfo;
    END_VAR
    VAR
        lastPoll : UDINT;
{IF NOT DEF(PROTOCOL_Carel) AND NOT DEF(NO_TCP_SUPPORT)}
        msgid : UINT;
		session: SINT;
		clientId: USINT;
{ENDIF}
    END_VAR
    VAR_TEMP
        count : DINT;
        currentEvent : Event;
        start : UDINT;
    END_VAR
	
    LockMutex(THIS.slave.Mutex);

    GetCurrentEvent(currentEvent);
	
	{IF NOT DEF(PROTOCOL_Carel) AND NOT DEF(NO_TCP_SUPPORT)}
	IF slave.Data.TcpIpSettings <> 0 THEN
		GetTcpEventInfo(currentEvent,msgid,session,clientId);
		IF IsANewConnection(msgid) THEN
     		AcceptConnection(currentEvent.Data,TRUE);
     		UnlockMutex(THIS.slave.Mutex);
			RETURN;
		END_IF;
		slave.Data.session := session;
		slave.Data.clientId := clientId;
    END_IF;
	{ENDIF}

    CASE currentEvent.Data OF
        USER_EVENT_DATA:
            Info^.Online := FALSE;
{IF DEF(PROTOCOL_CAREL) AND NOT DEF(CONTROL_FORCE)}
			slave.Data.DataManageAllowed := FALSE;
{ENDIF}
        ELSE
			{IF NOT DEF(PROTOCOL_Carel) AND NOT DEF(NO_TCP_SUPPORT)}
				IF slave.Data.TcpIpSettings <> 0 THEN
					 count:=SessionRead(currentEvent.Data,slave.Data.request,0);
				ELSE
					count := System.Serial.SerialRead(slave.Data.SerialSettings^.Channel, slave.Data.request, 0);
				END_IF;
			{ELSE}
				count := System.Serial.SerialRead(slave.Data.SerialSettings^.Channel, slave.Data.request, 0);
			{ENDIF}

			IF count > 0 THEN
				start := GetSystemTime();
				IF slave.ManageSerialPacket(count) THEN
					IF lastPoll <> 0 THEN
						Info^.PollInterval := GetSystemTime() - lastPoll;
					END_IF;
					lastPoll := GetSystemTime();
					Info^.ExecutionTime := GetSystemTime() - start;
					Info^.Online := TRUE;
					Info^.PollsCount := Info^.PollsCount + 1;
					//Update Timeout to mark device online/offline
{IF NOT DEF(PROTOCOL_Carel) AND NOT DEF(NO_TCP_SUPPORT)}
				    IF slave.Data.TcpIpSettings <> 0 THEN
					    SignalDynamicEvent(USER_EVENT_DATA, Info^.TimeOut, slave.Data.TcpIpSettings^.EventMask, SignalDynamicEventMode#OVERRIDE_MODE);
                    ELSE
						SignalDynamicEvent(USER_EVENT_DATA, Info^.TimeOut, slave.Data.SerialSettings^.MaskEvent, SignalDynamicEventMode#OVERRIDE_MODE);
					END_IF;
{ELSE}
					SignalDynamicEvent(USER_EVENT_DATA, Info^.TimeOut, slave.Data.SerialSettings^.MaskEvent, SignalDynamicEventMode#OVERRIDE_MODE);
{ENDIF}
			END_IF;
			{IF DEF(DEBUG_PROTO)}
			ELSE
				System.WriteLog(System.LogLevel#Error_Level, System.Text.FORMAT('Display: Serial Error %d reading data', count));
			{ENDIF}
			END_IF;
    END_CASE;
    UnlockMutex(THIS.slave.Mutex);
END_PROGRAM
{UNDEF PROTOCOL_Modbus}

{DEFINE PROTOCOL_MODBUS}

CLASS Display EXTENDS MODBUSSlaveConfigurationBase
    (**
     * Initialises the protocol and starts it.
     * If the protocol is already initialised, does nothing.
     * Returns 0 if success, serial error otherwise.
     *)
    METHOD Init : DINT
        Init := THIS.Init(TRUE);
    END_METHOD

    (**
     * Initialises the protocol and starts it, if Start is TRUE.
     * If the protocol is already initialised, does nothing.
     * Returns 0 if success, serial error otherwise, if Start is TRUE.
     *)
    METHOD Init : DINT
        VAR_INPUT
            Start : BOOL;
        END_VAR
        IF NOT THIS.Init THEN
            THIS.Init := TRUE;

            THIS.CurrentIdent := REF(DisplayInstance.slave.Data.Ident);
            DisplayInstance.Info := REF(THIS.Info);
            THIS.ID := 0;
            THIS.Info.TimeOut := 2000;
            THIS.Info.Zone := 0;
            DisplayInstance.slave.Data.SerialSettings := REF(THIS.SerialPort.Settings);
{IF DEF(PROTOCOL_MODBUS)}
            DisplayInstance.slave.Data.ReportSlaveID := REF(THIS.Info.ReportSlaveID);
{ELIF DEF(PROTOCOL_CAREL)}
            DisplayInstance.slave.Data.PeripheralInfo := REF(THIS.Info.PeripheralInfo);
{ENDIF}
            DisplayInstance.slave.Init(1);

            THIS.SerialSettings.Speed := 57600;
            THIS.SerialSettings.Channel := Serial_Channel#Serial0;
            THIS.SerialSettings.Bits := 8;
            THIS.SerialSettings.Parity := Serial_Parity#None;
            THIS.SerialSettings.Stops := 1;
            THIS.SerialSettings.Mode := Serial_Mode#ModbusShared;

            ModbusSetAdditionalInfo(THIS.SerialSettings.Channel, THIS.Info.Zone,  System.TO_UDINT(THIS.GetID()));
            Init := SUPER.ProtocolInitBase(Start, System.GetTaskId(Display_Task));
        END_IF;
    END_METHOD

    (**
     * Reads Data from the protocol.
     *)
    METHOD Read
        USING System;

        IF THIS.Init = FALSE THEN
            SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
        ELSE
            IF NOT THIS.Running THEN
                RETURN;
            END_IF;
            LockMutex(DisplayInstance.slave.Mutex);


            ModbusSetAdditionalInfo(THIS.SerialSettings.Channel, THIS.Info.Zone,  System.TO_UDINT(THIS.GetID()));
            UnlockMutex(DisplayInstance.slave.Mutex);
        END_IF;
    END_METHOD

    (**
     * Writes Data to the protocol.
     *)
    METHOD Write
        USING System;
        IF THIS.Init = FALSE THEN
            SYSTEM.RaiseException(SYSTEM.ERR_INVALID_CALL_SEQUENCE);
        ELSE
            IF NOT THIS.Running THEN
                RETURN;
            END_IF;
            LockMutex(DisplayInstance.slave.Mutex);


            UnlockMutex(DisplayInstance.slave.Mutex);
        END_IF;
    END_METHOD
END_CLASS

{UNDEF PROTOCOL_MODBUS}


END_NAMESPACE

CONFIGURATION __CONFIGURATION__
 	RESOURCE __RESOURCE__ ON RUNTIMETARGET
        TASK Display_Task (EVENT:=DYNAMIC_EVENT, PRIORITY := TASKS_PRIORITY);
        PROGRAM DisplayInstance WITH Display_Task : SlaveConfigurations.Program_Display;

 	END_RESOURCE
END_CONFIGURATION

