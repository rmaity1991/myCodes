USING System;
USING Protocols;

NAMESPACE ModbusMaster

    NAMESPACE DataTypes

        TYPE Modbus_Sizes:
            STRUCT
                MIN_INPUT_STATUS : UINT;
                MAX_INPUT_STATUS : UINT;
                MIN_COIL_STATUS  : UINT;
                MAX_COIL_STATUS  : UINT;
                MIN_INPUT_REGISTERS   : UINT;
                MAX_INPUT_REGISTERS   : UINT;
                MIN_HOLDING_REGISTERS : UINT;
                MAX_HOLDING_REGISTERS : UINT;
            END_STRUCT;
        END_TYPE

        TYPE ModbusQuestion:
            STRUCT
                reqType	: USINT;
                ndata	: UINT;
                start	: UINT;

                question	: ARRAY[0..270] OF BYTE;
            END_STRUCT;
        END_TYPE

        TYPE ModbusSlaveDevice :
            STRUCT
                Info : REF_TO ProtocolDeviceInfo;

                (** Pointer to Modbus Question buffer (use always same buffer for each device to decrease memory usage). *)
                ModbusQuestion : REF_TO ModbusQuestion;

                (** Serial channel where Slave Device is. *)
                serialChannel : REF_TO System.Serial.Serial_Channel;

                (** Check if it is possible to poll next device. *)
                CanPollNextDevice : BOOL;

                (** Mask Event attached to the current slave device. *)
                EventMask : DWORD;
                (** Device's master Task ID where it is attached. *)
                MasterTaskID : UINT;
                (** Slave Device Unique ID. *)
                ID : UINT;
                (** Slave Device Master's Array Index. *)
                Index : UINT;
                (** Template ID *)
                Template : UINT;
                (** Slave Device Poll Step. *)
                CurrentPollStep : UINT;
                (** Slave Device Poll Steps Count. *)
                PollStepsCount : UINT;
                (** Get if current poll loop is a poll loop after an online return: poll loop to do ReadOnline and WriteOnline *)
                IsFirstPollLoopAfterOnline : BOOL;
                (** Current command retry status. *)
                CurrentRetryCount : UINT;
                (** Last offline detection time *)
                LastOfflineDetection : UDINT;
                (** Skips Write On Change Commands *)
                SkipWriteOnChange : BOOL := TRUE;
				
				LastIndex : UINT;
                Mutex : REF_TO System.Mutex;
                IsUnderPolling : REF_TO BOOL;
                RequestedRefresh : REF_TO USINT;
                IdentChanged : REF_TO USINT;
                Ident : USINT(1..247);

                Sizes : REF_TO Modbus_Sizes;

                Input_Status        : REF_TO BYTE;
                Coil_Status         : REF_TO BYTE;
                Input_Registers     : REF_TO WORD;
                Holding_Registers   : REF_TO WORD;

                Changed_Coil_Status      : REF_TO BOOL;
                Changed_Holding_Register : REF_TO BOOL;

                pChanged_Input_Status     : REF_TO BOOL;
                pChanged_Coil_Status      : REF_TO BOOL;
                pChanged_Input_Register   : REF_TO BOOL;
                pChanged_Holding_Register : REF_TO BOOL;

                ReportSlaveID : REF_TO ReportSlaveID;

                TemplateReference : REF_TO BYTE;
            END_STRUCT;
        END_TYPE

        TYPE DecodeAnswerError :
            (
            NoError,
            BadPDU,
            CRCError,
            WrongID,
            Exception,
            (** Packet with correct ID and CRC but with wrong function code or data *)
            InvalidPacket
            );
        END_TYPE
    END_NAMESPACE

    CLASS CustomModbusCommand
        VAR INTERNAL
            buffer : REF_TO ARRAY [0..255] OF BYTE;
            dataCount : UINT;
            questionSent : BOOL;
            answerReceived : BOOL;
            pendingRequest   : BOOL;
            timeOut   : UINT;
        END_VAR

        METHOD PUBLIC SendCustomCommand
            VAR_IN_OUT
                v : ARRAY [0..255] OF BYTE;
            END_VAR
            VAR_INPUT
                dataCount : UINT(0..253);
                timeOut   : UINT(200..3000);
            END_VAR
            VAR
                crc_packet : WORD;
                l, h : BYTE;
            END_VAR

            IF THIS.pendingRequest THEN
                RETURN;
            END_IF;

            IF System.CheckAddressIsGlobal(System.REF(v)) THEN
                THIS.buffer := System.REF(v);
            ELSE
                RETURN;
            END_IF;

            IF dataCount > 0 THEN
                THIS.dataCount := dataCount;
                THIS.timeOut := timeOut;

                crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(System.Serial.Algorithm#CRC, THIS.buffer^, 0, System.TO_UDINT(THIS.dataCount)));

                System.Util.SplitWord(crc_packet, l, h);

                THIS.buffer^[  THIS.dataCount  ] := l;
                THIS.buffer^[THIS.dataCount + 1] := h;

                THIS.dataCount := THIS.dataCount + 2;

                pendingRequest := TRUE;
                questionSent := FALSE;
                answerReceived := FALSE;
            END_IF;
        END_METHOD

        METHOD INTERNAL SendQuestion
            VAR_INPUT
                channel : System.Serial.Serial_Channel;
            END_VAR
            VAR
                error : DINT;
            END_VAR

            IF THIS.buffer = 0 THEN
                RETURN;
            END_IF;

            error := System.Serial.SerialWrite(channel, THIS.buffer^, 0, System.TO_UDINT(THIS.dataCount));

            IF error < 0 THEN
                {IF DEF(DEBUG_PROTO)}
                WriteLog(LogLevel#Error_Level, System.Text.FORMAT('Serial Error %d sending custom Modbus Command', error));
                {ENDIF}
            ELSE
                THIS.questionSent := TRUE;
            END_IF;
        END_METHOD

        METHOD INTERNAL OnAnswerReceived
            VAR_IN_OUT
                v : ARRAY [0..270] OF BYTE;
            END_VAR
            VAR_INPUT
                dataCount : UINT;
            END_VAR

            IF THIS.buffer = 0 THEN
                RETURN;
            END_IF;

            System.Util.ByteArrayCopy(v, THIS.buffer^, 0, System.TO_DINT(dataCount) - 1, 0);

            THIS.dataCount := dataCount;

            THIS.pendingRequest := FALSE;
            THIS.answerReceived := TRUE;

        END_METHOD

        METHOD PUBLIC AnswerReceived : BOOL
            VAR_IN_OUT
                dataCount : UINT;
            END_VAR

            IF THIS.buffer = 0 THEN
                RETURN;
            END_IF;

            IF THIS.answerReceived THEN
                AnswerReceived := TRUE;

                dataCount := 0;

                IF THIS.dataCount > 0 THEN
                    dataCount := THIS.dataCount;
                END_IF;

                THIS.Reset();
            END_IF;

        END_METHOD

        METHOD INTERNAL Reset
            THIS.questionSent    := FALSE;
            THIS.answerReceived  := FALSE;
            THIS.pendingRequest  := FALSE;
        END_METHOD
    END_CLASS
    
    TYPE INTERNAL PollStepInfo :
        STRUCT
            Index : UINT;
            DataCount : UINT;
        END_STRUCT;
    END_TYPE
END_NAMESPACE

NAMESPACE CarelMaster

    NAMESPACE DataTypes

        TYPE CAREL_Sizes:
            STRUCT
                MAX_A : INT;
                MIN_A : INT;
                MAX_I  : INT;
                MIN_I  : INT;
                MAX_D   : INT;
                MIN_D   : INT;
            END_STRUCT;
        END_TYPE
        
        TYPE CarelMasterLineInfo:
            STRUCT
                (** Detection Range (s) *)
                DetectionRange : TIME;
                (** Retry if device is online *)
                Retry          : UINT(1..10);
                (** Polling Delay (ms) *)
                PollingDelay   : UINT(0..3000);
                (** Polling Loops Number *)
                PollingLoopsNumber : UDINT;
                (** Last Polling Loop Time (ms) *)
                LastPollingLoopTime : UDINT;
            END_STRUCT;
        END_TYPE
        
        TYPE PollStepInfo :
            STRUCT
                Index : INT;
                DataCount : INT;
            END_STRUCT;
        END_TYPE
        
    END_NAMESPACE
END_NAMESPACE
