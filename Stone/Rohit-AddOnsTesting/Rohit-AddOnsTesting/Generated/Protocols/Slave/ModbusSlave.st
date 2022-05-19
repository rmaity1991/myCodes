{INCLUDE "ProtocolOptions.g.st"}

{DEFINE MAX_MODBUS_MSG_LEN	270}

{DEFINE MAX_SEND_COILS		2000}
{DEFINE MAX_SEND_REGISTERS	125}
{DEFINE STC_FILE_NUMBER        11}
{DEFINE LOG_FILE_NUMBER        1000}
{DEFINE ALARM_INFO_FILE_NUMBER 2999}
{DEFINE ALARM_LOG_FILE_NUMBER  3000}
{DEFINE APP_UPDATE_FILE_NUMBER 5000}


{REGION MODBUS COMMANDS}
(** READ_OUTPUT_STATUS : 0x01 *)
{DEFINE READ_OUTPUT_STATUS		16#01}
(** READ_INPUT_STATUS : 0x02 *)
{DEFINE READ_INPUT_STATUS		16#02}
(** READ_HOLDING_REGISTERS : 0x03 *)
{DEFINE READ_HOLDING_REGISTERS 	16#03}
(** READ_INPUT_REGISTERS : 0x04 *)
{DEFINE READ_INPUT_REGISTERS	16#04}
(** WRITE_SINGLE_COIL : 0x05 *)
{DEFINE WRITE_SINGLE_COIL		16#05}
(** WRITE_SINGLE_REGISTER : 0x06 *)
{DEFINE WRITE_SINGLE_REGISTER	16#06}
(** WRITE_MULTIPLE_COILS : 0x0F *)
{DEFINE WRITE_MULTIPLE_COILS	16#0F}
(** WRITE_MULTIPLE_REGISTER : 0x10 *)
{DEFINE WRITE_MULTIPLE_REGISTER 16#10}
(** REPORT_SLAVE_ID : 0x11 *)
{DEFINE REPORT_SLAVE_ID			16#11}
(** READ_FILE_RECORD : 0x14 *)
{DEFINE READ_FILE_RECORD			16#14}
(** REPORT_DATETIME : 0x69 *)
{DEFINE REPORT_DATETIME			16#69}
{ENDREGION }
{REGION EXCEPTIONS}
{DEFINE ILLEGAL_FUNCTION     		16#01}
{DEFINE ILLEGAL_DATA_ADDRESS 		16#02}
{DEFINE ILLEGAL_DATA_VALUE 			16#03}
{DEFINE MAX_BYTE_PER_FILE           20000}
{ENDREGION }

NAMESPACE ModbusSlave
	USING Protocols;
	USING ProtocolsCommon;

    TYPE ModbusKind:
        (
            CoilStatus,
            InputStatus,
            HoldingRegister,
            InputRegister
        );
    END_TYPE
    
    TYPE CommissioningBlockType:
        (
            SubBlockUnused,
            SubBlockParam,
            SubBlockProfiling,
            SubBlockNfcGeometry,
            SubBlockDesc,
			SubBlockBinCfg,		
			SubBlockTxtCfg,    		
			SubBlockStcGeometry, 		
			SubBlockProfileGeometry, 	
			SubBlockDescrGeometry,	
			SubBlockBinCfgGeometry,	
			SubBlockTxtCfgGeometry 
        );
    END_TYPE

    TYPE _ModbusUnion :
        UNION
            BYTE   : BYTE;
            WORD   : WORD;
            DWORD  : DWORD;
            LWORD  : LWORD;

            USINT   : USINT;
            UINT    : UINT;
            UDINT   : UDINT;
            ULINT   : ULINT;

            SINT    : SINT;
            INT     : INT;
            DINT    : DINT;
            LINT    : LINT;

            REAL    : REAL;
            LREAL   : LREAL;

            registers : ARRAY [1..4] OF WORD;
        END_UNION;
    END_TYPE

    TYPE ModbusSlaveData :
        STRUCT
            SerialSettings  : REF_TO System.Serial.SerialSettings;
{IF NOT DEF(NO_TCP_SUPPORT)}
            TcpIpSettings : REF_TO System.Net.TcpIp.TcpIpSettings;
{ENDIF}
        
    		session:SINT;
    		clientID:USINT;
            Ident       : USINT;

            request : ARRAY [0..270] OF BYTE;
            answer  : ARRAY [0..270] OF BYTE;

            MIN_INPUT_REGISTERS   : UINT;
            MAX_INPUT_REGISTERS   : UINT;
            MIN_HOLDING_REGISTERS : UINT;
            MAX_HOLDING_REGISTERS : UINT;

            MIN_INPUT_STATUS    : UINT;
            MAX_INPUT_STATUS    : UINT;
            MIN_COIL_STATUS     : UINT;
            MAX_COIL_STATUS     : UINT;

            Input_Register      : REF_TO WORD;
            Holding_Register    : REF_TO WORD;
            Input_Status        : REF_TO BYTE;
            Coil_Status         : REF_TO BYTE;

            Changed_Holding_Register    : REF_TO BOOL;
            Changed_Coil_Status         : REF_TO BOOL;

            ReportSlaveID   : REF_TO ReportSlaveID;
        END_STRUCT;
    END_TYPE

    FUNCTION SendException
        USING System.Serial;
        VAR_IN_OUT
            data : ModbusSlaveData;
        END_VAR
        VAR_INPUT
            exceptionCode: BYTE;
        END_VAR
        VAR
            crc_packet: WORD;
            h,l: BYTE;
        END_VAR

        data.answer[0] := USINT_TO_BYTE(data.Ident);
        data.answer[1] := USINT_TO_BYTE(BYTE_TO_USINT(data.request[1]) + 16#80);
        data.answer[2] := exceptionCode;

        crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, 3));

        System.Util.SplitWord(crc_packet, l, h);

        data.answer[3] := l;
        data.answer[4] := h;

        MS_SerialWrite(data, 5);
{IF DEF(DEBUG_PROTO)}
        System.WriteLog(System.LogLevel#Debug_Level,
            System.Text.FORMAT('Slave Device %d ', data.Ident) +
            System.Text.FORMAT('sent exception 0x%02X ', exceptionCode) +
            System.Text.FORMAT('for command 0x%02X', data.request[1]));
{ENDIF}
    END_FUNCTION

    FUNCTION ProcessRequest : BOOL
        USING System.Serial;
        USING System.Util;
        USING System.Timer;
        VAR_IN_OUT
            data : ModbusSlaveData;
        END_VAR
        VAR_INPUT
            packetCount : DINT;
        END_VAR
        VAR
            crc, crc_packet, value : WORD;
            I, J : INT;
            payload, dst_from, byte_count, nbyte, nvalue : UINT;
            start_adr, ndata : DINT;
            h, l : BYTE;
            pRegisters : REF_TO WORD;
            pCoils : REF_TO BYTE;
            rshift, lshift : UINT;
            LOWER_LIMIT, UPPER_LIMIT : UINT;
            tmpByte : ByteBits;
            {IF NOT DEF(NO_TCP_SUPPORT)}
            Offset : INT := 0;
            {ENDIF}
			s:STRING;
        END_VAR

        {IF DEF(NO_TCP_SUPPORT)}
            VAR CONSTANT
                Offset : INT := 0;
            END_VAR
        {ENDIF}

        //crc check
        IF data.SerialSettings<>0 THEN
			IF packetCount >= 4 THEN
				crc := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.request, 0, DINT_TO_UDINT(packetCount) - 2));
				crc_packet := MakeWord(data.request[packetCount - 2], data.request[packetCount - 1]);
			ELSE
				RETURN;
			END_IF;
        END_IF;

        IF crc <> crc_packet THEN
            //wrong crc
            RETURN;
        END_IF;

        {IF NOT DEF(NO_TCP_SUPPORT)}
        IF data.SerialSettings = 0 THEN
            Offset := 6;
        END_IF;
        {ENDIF}
        
        //not for me
        IF USINT_TO_BYTE(data.Ident) <> data.request[0+Offset] THEN
{IF DEF(WRONG_ADDRESS_CALLBACK)}
            OnWrongAddress(data.answer, packetCount);
{ENDIF}
            RETURN;
        END_IF;

        ProcessRequest := TRUE;

        CASE data.request[1+Offset] OF
            READ_INPUT_STATUS:
                pCoils := data.Input_Status;
                LOWER_LIMIT := data.MIN_INPUT_STATUS;
                UPPER_LIMIT := data.MAX_INPUT_STATUS;

            READ_OUTPUT_STATUS,
            WRITE_SINGLE_COIL,
            WRITE_MULTIPLE_COILS:
                pCoils := data.Coil_Status;
                LOWER_LIMIT := data.MIN_COIL_STATUS;
                UPPER_LIMIT := data.MAX_COIL_STATUS;

            READ_INPUT_REGISTERS:
                pRegisters := data.Input_Register;
                LOWER_LIMIT := data.MIN_INPUT_REGISTERS;
                UPPER_LIMIT := data.MAX_INPUT_REGISTERS;

            READ_HOLDING_REGISTERS,
            WRITE_SINGLE_REGISTER,
            WRITE_MULTIPLE_REGISTER:
                pRegisters := data.Holding_Register;
                LOWER_LIMIT := data.MIN_HOLDING_REGISTERS;
                UPPER_LIMIT := data.MAX_HOLDING_REGISTERS;
            REPORT_SLAVE_ID:
            READ_FILE_RECORD:
            REPORT_DATETIME:
            ELSE
                SendException(data, ILLEGAL_FUNCTION);
                RETURN;
        END_CASE;

        //clear answer
        data.answer := voidBuffer;

        CASE data.request[1+Offset] OF

        READ_OUTPUT_STATUS,READ_INPUT_STATUS:
            ndata := System.TO_DINT(MakeWord(data.request[5+Offset], data.request[4+Offset]));
            start_adr := System.TO_DINT(MakeWord(data.request[3+Offset], data.request[2+Offset]));
            data.answer[0+Offset] := USINT_TO_BYTE(data.Ident);
            data.answer[1+Offset] := data.request[1+Offset];
            IF ndata = 0 OR ndata > MAX_SEND_COILS THEN
                SendException(data, ILLEGAL_DATA_VALUE);
    {IF DEF(EXCEP_ON_INVALID_ADDRESS)}
            ELSIF start_adr < System.TO_DINT(LOWER_LIMIT) OR start_adr > System.TO_DINT(UPPER_LIMIT) OR (start_adr + ndata - 1) > System.TO_DINT(UPPER_LIMIT) THEN
                SendException(data, ILLEGAL_DATA_ADDRESS);
    {ENDIF}
            ELSE
                rshift := System.TO_UINT(start_adr MOD 8);
                lshift := 8-rshift;
                FOR I := System.TO_INT(start_adr/8) TO System.TO_INT((start_adr + ndata - 1)/8 - 1) DO
                    IF I + 1 = UINT_TO_INT(LOWER_LIMIT/8) THEN
                        data.answer[Offset+3+I-System.TO_INT(start_adr/8)] := data.answer[Offset+3+I-System.TO_INT(start_adr/8)] OR System.Math.SHL(pCoils[I - System.TO_INT(LOWER_LIMIT/8) + 1]^, lshift);
                    END_IF;
                    IF I >= UINT_TO_INT(LOWER_LIMIT/8) AND (I + 1) <= UINT_TO_INT(UPPER_LIMIT/8) THEN
                        data.answer[Offset+3+I-System.TO_INT(start_adr/8)] := data.answer[Offset+3+I-System.TO_INT(start_adr/8)] OR (System.Math.SHR(pCoils[I - UINT_TO_INT(LOWER_LIMIT/8)]^, rshift) OR System.Math.SHL(pCoils[I - UINT_TO_INT(LOWER_LIMIT/8) + 1]^, lshift));
                    END_IF;
                    IF I = UINT_TO_INT(UPPER_LIMIT/8) THEN
                        data.answer[Offset+3+I-System.TO_INT(start_adr/8)] := data.answer[Offset+3+I-System.TO_INT(start_adr/8)] OR System.Math.SHR(pCoils[I - UINT_TO_INT(LOWER_LIMIT/8)]^, rshift);
                    END_IF;
                    IF I > UINT_TO_INT(UPPER_LIMIT/8) THEN
                        I := System.TO_INT((start_adr + ndata - 1)/8 - 1);
                        EXIT;
                    END_IF;
                END_FOR;

                IF I <= UINT_TO_INT(UPPER_LIMIT/8) AND I >= UINT_TO_INT(LOWER_LIMIT/8) THEN
                    data.answer[Offset+3+I-System.TO_INT(start_adr/8)] := data.answer[Offset+3+I-System.TO_INT(start_adr/8)] OR System.Math.SHR(pCoils[I - UINT_TO_INT(LOWER_LIMIT/8)]^, rshift);
                END_IF;

                data.answer[Offset+2] := System.TO_BYTE(ndata/8);

                IF ndata MOD 8 <> 0 THEN
                    data.answer[Offset+3+I-System.TO_INT(start_adr/8)] := data.answer[Offset+3+I-System.TO_INT(start_adr/8)] AND System.Math.SHR(BYTE#16#FF, 7 - (ndata MOD 8));
                    data.answer[Offset+2]:=INT_TO_BYTE(BYTE_TO_INT(data.answer[Offset+2])+1);
                END_IF;
                payload := 3 + BYTE_TO_UINT(data.answer[Offset+2]);
                crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, UINT_TO_UDINT(payload)));
                SplitWord(crc_packet, l, h);
                data.answer[system.To_UINT(Offset)+payload] := l;
                data.answer[system.To_UINT(Offset)+payload + 1] := h;
                MS_SerialWrite(data, UINT_TO_UDINT(payload) + 2);
            END_IF;

        WRITE_SINGLE_COIL:
            ndata := System.TO_DINT(MakeWord(data.request[3+Offset], data.request[2+Offset]));
            IF System.TO_UINT(ndata) >= LOWER_LIMIT AND System.TO_UINT(ndata) <= UPPER_LIMIT THEN
                tmpByte.data := pCoils[System.TO_UINT(ndata)/8-LOWER_LIMIT/8]^;
                tmpByte.bits[ndata MOD 8] := BYTE_TO_BOOL(data.request[4+Offset]);
                pCoils[System.TO_UINT(ndata)/8-LOWER_LIMIT/8]^ := tmpByte.data;
                data.Changed_Coil_Status[System.TO_UINT(ndata) - LOWER_LIMIT]^ := TRUE;
    {IF DEF(EXCEP_ON_INVALID_ADDRESS)}
            ELSE
                SendException(data, ILLEGAL_DATA_ADDRESS);
    {ENDIF}
            END_IF;
            data.answer := data.request;
            MS_SerialWrite(data, DINT_TO_UDINT(packetCount));


        READ_HOLDING_REGISTERS, READ_INPUT_REGISTERS:
            start_adr := System.TO_DINT(MakeWord(data.request[3+Offset], data.request[2+Offset]));
            ndata := System.TO_DINT(MakeWord(data.request[5+Offset], data.request[4+Offset]));

            data.answer[0+Offset] := USINT_TO_BYTE(data.Ident);
            data.answer[1+Offset] := data.request[1+Offset];

            IF ndata = 0 OR ndata > MAX_SEND_REGISTERS THEN
                SendException(data, ILLEGAL_DATA_VALUE);
    {IF DEF(EXCEP_ON_INVALID_ADDRESS)}
            ELSIF start_adr < System.TO_DINT(LOWER_LIMIT) OR start_adr > System.TO_DINT(UPPER_LIMIT) OR (start_adr + ndata - 1) > System.TO_DINT(UPPER_LIMIT) THEN
                SendException(data, ILLEGAL_DATA_ADDRESS);
    {ENDIF}
            ELSE
                data.answer[2+Offset] := System.TO_BYTE(ndata * 2);
                payload := System.TO_UINT(ndata) * 2;

                dst_from := 3;

                IF System.TO_UINT(start_adr) < LOWER_LIMIT THEN
                    dst_from := LOWER_LIMIT - System.TO_UINT(start_adr);
                    ndata := ndata - System.TO_DINT(dst_from);
                    IF ndata < 0 THEN
                        ndata := 0;
                    END_IF;
                    start_adr := System.TO_DINT(LOWER_LIMIT);
                    dst_from := dst_from*2 + 3;
                END_IF;

                IF start_adr + ndata - 1 > System.TO_DINT(UPPER_LIMIT) THEN
                    ndata := System.TO_DINT(UPPER_LIMIT) - start_adr + 1;
                END_IF;

                //0-base indexes for pointers
                start_adr := start_adr - System.TO_DINT(LOWER_LIMIT);

                IF ndata > 0 THEN
                    Utils.ByteArrayCopy.WordToByte.ByteArrayCopy(pRegisters, data.answer, start_adr, start_adr + ndata - 1, UINT_TO_DINT(dst_from)+ System.To_Dint(Offset));
                END_IF;

                crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, UINT_TO_UDINT(payload) + 3));
                SplitWord(crc_packet, l, h);
                data.answer[payload + 3 + System.To_UInt(Offset)] := l;
                data.answer[payload + 4 + System.To_UInt(Offset)] := h;
                MS_SerialWrite(data, UINT_TO_UDINT(payload) + 5);
            END_IF;


        WRITE_SINGLE_REGISTER:
            ndata := System.TO_DINT(MakeWord(data.request[3+Offset], data.request[2+Offset]));
            value := MakeWord(data.request[5+Offset], data.request[4+Offset]);
            IF ndata >= System.TO_DINT(LOWER_LIMIT) AND ndata <= System.TO_DINT(UPPER_LIMIT) THEN
                pRegisters[ndata - System.TO_DINT(LOWER_LIMIT)]^ := value;
                data.Changed_Holding_Register[ndata - System.TO_DINT(LOWER_LIMIT)]^ := TRUE;
    {IF DEF(EXCEP_ON_INVALID_ADDRESS)}
            ELSE
                SendException(data, ILLEGAL_DATA_ADDRESS);
    {ENDIF}
            END_IF;
            data.answer := data.request;
            MS_SerialWrite(data, DINT_TO_UDINT(packetCount));

        WRITE_MULTIPLE_COILS:
            start_adr := System.TO_DINT(MakeWord(data.request[3+Offset], data.request[2+Offset]));
            ndata := System.TO_DINT(MakeWord(data.request[5+Offset], data.request[4+Offset]));
            byte_count := System.TO_UINT(data.request[6+Offset]);
            nbyte := System.TO_UINT(ndata/8);
            IF (ndata MOD 8) <> 0 THEN
                nbyte := nbyte +1;
            END_IF;
{IF NOT DEF(NO_TCP_SUPPORT)}
			IF data.TcpIpSettings <> 0 THEN
                nvalue := DINT_TO_UINT(packetCount-13);
            ELSE
{ENDIF}
                nvalue := DINT_TO_UINT(packetCount-9);

{IF NOT DEF(NO_TCP_SUPPORT)}
            END_IF;
{ENDIF}
            IF ndata = 0 OR ndata > MAX_SEND_COILS  OR byte_count <> nbyte OR byte_count <> nvalue THEN
                SendException(data, ILLEGAL_DATA_VALUE);
    {IF DEF(EXCEP_ON_INVALID_ADDRESS)}
            ELSIF start_adr < System.TO_DINT(LOWER_LIMIT) OR start_adr > System.TO_DINT(UPPER_LIMIT) OR (start_adr + ndata - 1) > System.TO_DINT(UPPER_LIMIT) THEN
                SendException(data, ILLEGAL_DATA_ADDRESS);
    {ENDIF}
            ELSE
                J:=0;
                FOR I := System.TO_INT(start_adr) TO System.TO_INT(start_adr + ndata - 1) DO
                    IF i >= UINT_TO_INT(LOWER_LIMIT) AND i <= UINT_TO_INT(UPPER_LIMIT) THEN
                        IF (System.Math.SHR(data.request[Offset+7+(I - System.TO_INT(start_adr))/8], J) AND 1) <> (System.Math.SHR(pCoils[I/8-System.TO_INT(LOWER_LIMIT)/8]^, I MOD 8) AND 1) THEN
                            pCoils[I/8-UINT_TO_INT(LOWER_LIMIT)/8]^ := pCoils[I/8-UINT_TO_INT(LOWER_LIMIT)/8]^ XOR System.Math.SHL(BYTE#1, I MOD 8);
                        END_IF;
                        data.Changed_Coil_Status[i - UINT_TO_INT(LOWER_LIMIT)]^ := TRUE;
                    END_IF;
                    J:=(J+1) MOD 8;
                END_FOR;

                ByteArrayCopy(data.request, data.answer, System.TO_DINT(Offset), 5, 0);
                crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, 6));
                SplitWord(crc_packet, l, h);
                data.answer[6+ System.To_UInt(Offset)] := l;
                data.answer[7+ System.To_UInt(Offset)] := h;
                MS_SerialWrite(data, 8);
            END_IF;

        WRITE_MULTIPLE_REGISTER:
            start_adr := System.TO_DINT(MakeWord(data.request[3+Offset], data.request[2+Offset]));
            ndata := System.TO_DINT(MakeWord(data.request[5+Offset], data.request[4+Offset]));
{IF NOT DEF(NO_TCP_SUPPORT)}
            IF data.TcpIpSettings <> 0 THEN
                nvalue := DINT_TO_UINT(packetCount-13);
            ELSE
{ENDIF}
                nvalue := DINT_TO_UINT(packetCount-9);
{IF NOT DEF(NO_TCP_SUPPORT)}
            END_IF;
{ENDIF}
            IF ndata = 0 OR ndata > MAX_SEND_REGISTERS OR System.TO_DINT(data.request[6+Offset]) <> ndata * 2 OR BYTE_TO_UINT(data.request[6+Offset]) <> nvalue THEN
                SendException(data, ILLEGAL_DATA_VALUE);
    {IF DEF(EXCEP_ON_INVALID_ADDRESS)}
            ELSIF start_adr < System.TO_DINT(LOWER_LIMIT) OR start_adr > System.TO_DINT(UPPER_LIMIT) OR (start_adr + ndata - 1) > System.TO_DINT(UPPER_LIMIT) THEN
                SendException(data, ILLEGAL_DATA_ADDRESS);
    {ENDIF}
            ELSE
                dst_from := 7 + System.TO_UINT(Offset);

                IF start_adr < System.TO_DINT(LOWER_LIMIT) THEN
                    dst_from := LOWER_LIMIT - System.TO_UINT(start_adr);
                    ndata := ndata - System.TO_DINT(dst_from);
                    start_adr := System.TO_DINT(LOWER_LIMIT);
                    dst_from := dst_from*2 + 7;
                END_IF;

                IF start_adr + ndata - 1 > System.TO_DINT(UPPER_LIMIT) THEN
                    ndata := System.TO_DINT(UPPER_LIMIT) - start_adr + 1;
                END_IF;

                Utils.ByteArrayCopy.ByteToWord.ByteArrayCopy(data.request, pRegisters, UINT_TO_DINT(dst_from),  ndata + System.TO_DINT(dst_from) + System.TO_DINT(Offset) - 1, start_adr - System.TO_DINT(LOWER_LIMIT));
                FOR I := System.TO_INT(start_adr) TO System.TO_INT(start_adr + ndata - 1) DO
                    data.Changed_Holding_Register[I - UINT_TO_INT(LOWER_LIMIT)]^ := TRUE;
                END_FOR;
                ByteArrayCopy(data.request, data.answer, System.TO_DINT(Offset) , 5, 0);
                crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, 6));
                SplitWord(crc_packet, l, h);
                data.answer[6+ System.To_UInt(Offset)] := l;
                data.answer[7+ System.To_UInt(Offset)] := h;
                MS_SerialWrite(data, 8);
            END_IF;
        REPORT_SLAVE_ID:
            IF data.ReportSlaveID <> 0 THEN
                data.answer[0+offset] := data.request[0+offset];
                data.answer[1+offset] := data.request[1+Offset];
                data.answer[2+offset] := USINT_TO_BYTE(data.ReportSlaveID^.DataLen + 2);
                data.answer[3+offset] := data.ReportSlaveID^.ServerID;
                data.answer[4+offset] := data.ReportSlaveID^.RunIndicatorStatus;
                IF data.ReportSlaveID^.DataLen > 0 THEN
                    ByteArrayCopy(data.ReportSlaveID^.Data, data.answer, System.TO_DINT(Offset), USINT_TO_DINT(data.ReportSlaveID^.DataLen - 1), 5);
                END_IF;
                crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, USINT_TO_UDINT(data.ReportSlaveID^.DataLen) + 5));
                SplitWord(crc_packet, l, h);
                data.answer[data.ReportSlaveID^.DataLen + 5 + System.To_UsInt(Offset)] := l;
                data.answer[data.ReportSlaveID^.DataLen + 6 + System.To_UsInt(Offset)] := h;

                MS_SerialWrite(data, USINT_TO_UDINT(data.ReportSlaveID^.DataLen) + 7);
            END_IF;

            READ_FILE_RECORD:
                start_adr := System.TO_DINT(MakeWord(data.request[7], data.request[6]))*2; //record number
                ndata := System.TO_DINT(MakeWord(data.request[9], data.request[8]))*2;	   //record length
                value := MakeWord(data.request[5], data.request[4]); //file number
                byte_count := System.TO_UINT(data.request[2]);

                IF data.request[3] = 6 AND value > 0 AND byte_count = 7 THEN

                    payload := 0;   //used as a flag
                    
                    IF value >= ALARM_LOG_FILE_NUMBER AND value < APP_UPDATE_FILE_NUMBER THEN
                        (* Alarm log management*)
                        start_adr:=start_adr+(System.TO_DINT(value)-ALARM_LOG_FILE_NUMBER)*MAX_BYTE_PER_FILE;
						IF System.Alarm.GetAlarmLog(data.answer, 5, System.TO_UDINT(start_adr), System.TO_UDINT(ndata), ALARM_LOG_FILE_NUMBER) <> 0 THEN
							SendException(data, ILLEGAL_DATA_ADDRESS);
						ELSE
                            payload := 1;
                        END_IF;
                    ELSIF value = ALARM_INFO_FILE_NUMBER THEN
                        (* Alarm info management *)
						start_adr:=start_adr+(System.TO_DINT(value)-ALARM_INFO_FILE_NUMBER)*MAX_BYTE_PER_FILE;
						IF System.Alarm.GetAlarmInfo(data.answer, 5, System.TO_UDINT(start_adr), System.TO_UDINT(ndata), ALARM_INFO_FILE_NUMBER) <> 0 THEN
							SendException(data, ILLEGAL_DATA_ADDRESS);
						ELSE
                            payload := 1;
                        END_IF;
                    ELSIF value >= LOG_FILE_NUMBER THEN
                        (* LOG management *)
						start_adr:=start_adr+(System.TO_DINT(value)-LOG_FILE_NUMBER)*MAX_BYTE_PER_FILE;
						IF System.GetDataLog(data.answer, 5, System.TO_UDINT(start_adr), System.TO_UDINT(ndata)) <> 0 THEN
							SendException(data, ILLEGAL_DATA_ADDRESS);
						ELSE
                            payload := 1;
                        END_IF;
                    ELSE
                        (* Commissioning files management *)
    					start_adr:=start_adr+(System.TO_DINT(value)-STC_FILE_NUMBER)*MAX_BYTE_PER_FILE;
    					nvalue:=System.TO_UINT(HasCommissioningInfo(start_adr));
                        IF nvalue <> System.TO_UINT(CommissioningBlockType#SubBlockUnused)
                        THEN
                            GetCommissioningInfo(data.answer, 5, start_adr, ndata, System.TO_USINT(nvalue));
                            payload := 1;
                        ELSE
                            SendException(data, ILLEGAL_DATA_ADDRESS);
                        END_IF;
                    END_IF;

                    IF payload = 1 THEN
                        (* prepare answer *)
    					data.answer[0] := data.request[0];
                        data.answer[1] := data.request[1];
                        data.answer[2] := System.TO_BYTE(ndata+2);
                        data.answer[3]:= System.TO_BYTE(ndata+1);
                        data.answer[4]:=6;
                        crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, DINT_TO_UDINT(ndata)+5));
                        SplitWord(crc_packet, l, h);
                        data.answer[ndata + 5] := l;
                        data.answer[ndata + 6] := h;
                        MS_SerialWrite(data, DINT_TO_UDINT(ndata)+7);
                    END_IF;
                    
                ELSE
                    SendException(data, ILLEGAL_DATA_VALUE); // IF data.request[3] = 6 AND value > 0
                END_IF;
            
            REPORT_DATETIME:
                ndata := 32;
                data.answer[0] := data.request[0+Offset];
                data.answer[1] := data.request[1+offset];
                data.answer[2] := System.TO_BYTE(ndata);
                
				s:=system.timer.GET_TIME_ISO8601();
				FOR I := 0 TO System.TO_INT(System.text.LEN(s)-1) DO
					data.answer[3+I]:=System.TO_BYTE(s[I]);
				END_FOR;

                crc_packet := UDINT_TO_WORD(System.Serial.CalcAlgorithm(Algorithm#CRC, data.answer, 0, DINT_TO_UDINT(ndata)+3));
                SplitWord(crc_packet, l, h);
                data.answer[ndata + 3] := l;
                data.answer[ndata + 4] := h;
                MS_SerialWrite(data, DINT_TO_UDINT(ndata)+5);
        END_CASE;
    END_FUNCTION
    
    FUNCTION prepareHeader

    VAR_IN_OUT
    		question: ARRAY [*] OF BYTE;
    		answer: ARRAY [*] OF BYTE;
    END_VAR
    VAR_INPUT
    	len:UINT;
    END_VAR
    answer[0]:=question[0];
    answer[1]:=question[1];
    answer[2]:=0;
    answer[3]:=0;
    System.Util.SplitWord(UINT_TO_WORD(len),answer[5],answer[4]);
    END_FUNCTION
    
    FUNCTION MS_SerialWrite
        VAR_IN_OUT
            (** The byte array that contains the data to write to the port. *)
            data : ModbusSlaveData;
        END_VAR
        VAR_INPUT
            (** The number of bytes to write. *)
            count : UDINT;
        END_VAR
        VAR
            error : DINT;
        END_VAR
        IF data.SerialSettings <> 0 THEN
            error := System.Serial.SerialWrite(data.SerialSettings^.Channel, data.answer, count);
{IF NOT DEF(NO_TCP_SUPPORT)}
        ELSE
            prepareHeader(data.request, data.answer, System.To_Uint(count)-2);
            //data.answer[0] :=  SYSTEM.TO_BYTE(SYSTEM.TO_INT(data.answer[0]) + 1);
			System.Net.TcpIp.SessionWrite(data.session,data.clientID,data.answer,0,count+4);
{ENDIF}
        END_IF;
{IF DEF(DEBUG_PROTO)}
        IF error < 0 THEN
            System.WriteLog(System.LogLevel#Error_Level, System.Text.FORMAT('Slave Device %d: ', data.Ident) + System.Text.FORMAT('Serial Error %d writing data', error));
        END_IF;
{ENDIF}
    END_FUNCTION
	
	(**
	 * Returns if commissioning infos are available. If true, it returns the block index (as CommissioningBlockType).
	 *)
	FUNCTION HasCommissioningInfo:CommissioningBlockType
		VAR_IN_OUT
            (** Modbus offset *)
            offset : DINT;
		END_VAR
        VAR
			p:REF_TO BYTE;
			size,totSize,OldTotSize:UDINT;
			i:INT;
		END_VAR
		HasCommissioningInfo := CommissioningBlockType#SubBlockUnused;
		FOR i:=System.TO_INT(CommissioningBlockType#SubBlockParam) TO System.TO_INT(CommissioningBlockType#SubBlockTxtCfg) DO
			IF i=System.TO_INT(CommissioningBlockType#SubBlockNfcGeometry) THEN
				CONTINUE;
			END_IF;
			IF System.GetCommissioningInfo(p, size, System.TO_UINT(i))=FALSE THEN
				CONTINUE;
			ELSE
				IF (size MOD 2) = 1 THEN 
					size:=size+1;
				END_IF;
                OldTotSize := totSize;
				totSize:=totSize+size;
				IF  totSize > System.TO_UDINT(offset) THEN
					HasCommissioningInfo := System.TO_USINT(i);
                    offset := offset-System.TO_DINT(OldTotSize);
					RETURN;
				END_IF;
			END_IF;
		END_FOR;
	END_FUNCTION
	
	(**
	 * Load Commissionig info
	 *)
	FUNCTION GetCommissioningInfo:BOOL
		VAR_IN_OUT
			(**data to fill with commissioning info*)
			data : ARRAY[*] OF BYTE;
		END_VAR
		VAR_INPUT
			(**offset of data array*)
			dataoffset: INT;
			(**start of commissioning info*)
			offset: DINT;
			(**byte to copy*)
			quantity : DINT;
			(**Commissing sub block*)
			SubBlockIndex : CommissioningBlockType;
		END_VAR
		VAR
			size:UDINT;
            exceed : DINT;
			p:REF_TO BYTE;
        END_VAR
        
        IF System.GetCommissioningInfo(p, size, System.TO_UINT(SubBlockIndex))=FALSE THEN
			GetCommissioningInfo := FALSE;
			RETURN;
		END_IF;
        
        GetCommissioningInfo := TRUE;
        
        IF System.TO_DINT(size) < quantity THEN
            exceed := quantity - System.TO_DINT(size);
            quantity := System.TO_DINT(size);
        END_IF;
		
        System.util.memcpy(System.ADR(data[dataoffset]), p+System.TO_UDINT(offset), System.TO_UDINT(quantity));
        
        WHILE exceed>0 DO
            offset := offset + quantity;
            quantity := exceed;
            SubBlockIndex := SubBlockIndex + 1;
            
            IF System.GetCommissioningInfo(p, size, System.TO_UINT(SubBlockIndex)) THEN
                IF System.TO_DINT(size) < quantity THEN
                    exceed := quantity - System.TO_DINT(size);
                    quantity := System.TO_DINT(size);
                END_IF;
                System.util.memcpy(System.ADR(data[dataoffset]), p+System.TO_UDINT(offset), System.TO_UDINT(quantity));
            ELSE
                RETURN;
            END_IF;
        END_WHILE;
		
	END_FUNCTION

    NAMESPACE Utils.ByteArrayCopy
        NAMESPACE ByteToWord
            (**
             Copies a BYTE array to a WORD array,
             from an index to an index of the source,
             starting from a given index.
             *)
            FUNCTION ByteArrayCopy: DINT
                VAR_IN_OUT
                    (** Source array. *)
                    src: ARRAY [*] OF BYTE;
                    (** Destination array. *)
                    dst: REF_TO WORD;
                END_VAR
                VAR_INPUT
                    (** Index from start to copy the source array. *)
                    src_from: DINT;
                    (** Index up to copy the source array. *)
                    src_to: DINT;
                    (** Index from where to start to write the destination array. *)
                    dst_from: DINT;
                END_VAR
                VAR
                    i, s, d: DINT;
                END_VAR
                s := src_from;
                d := dst_from;
                ByteArrayCopy := src_to - src_from + 1;
                FOR I:=1 TO ByteArrayCopy DO
                    dst[d]^ := UINT_TO_WORD(WORD_TO_UINT(System.Math.SHL(BYTE_TO_WORD(src[s]),8)) + BYTE_TO_UINT(src[s+1]));
                    s := s + 2;
                    d := d + 1;
                END_FOR;
            END_FUNCTION
        END_NAMESPACE

        NAMESPACE WordToByte
            (**
             Copies a WORD array to a BYTE array,
             from an index to an index of the source,
             starting from a given index.
             *)
            FUNCTION ByteArrayCopy: DINT
                VAR_IN_OUT
                    (** Source array. *)
                    src: REF_TO WORD;
                    (** Destination array. *)
                    dst: ARRAY [*] OF BYTE;
                END_VAR
                VAR_INPUT
                    (** Index from start to copy the source array. *)
                    src_from: DINT;
                    (** Index up to copy the source array. *)
                    src_to: DINT;
                    (** Index from where to start to write the destination array. *)
                    dst_from: DINT;
                END_VAR
                VAR
                    i, s, d: DINT;
                END_VAR
                s := src_from;
                d := dst_from;
                ByteArrayCopy := src_to - src_from + 1;
                FOR i:=1 TO ByteArrayCopy DO
                    dst[d+1] := WORD_TO_BYTE(src[s]^);
                    dst[d  ] := WORD_TO_BYTE(System.Math.SHR(src[s]^, 8));
                    s := s + 1;
                    d := d + 2;
                END_FOR;
            END_FUNCTION
        END_NAMESPACE
    END_NAMESPACE
END_NAMESPACE