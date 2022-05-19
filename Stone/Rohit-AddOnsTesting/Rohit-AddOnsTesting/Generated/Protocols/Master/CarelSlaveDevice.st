USING System;
USING System.Encoding;
USING System.Math;
USING System.Serial;
USING System.Util;
USING Protocols;
USING ProtocolsCommon;




VAR_GLOBAL CONSTANT
	USER_EVENT_DATA : UDINT := 123;
END_VAR

 TYPE DataChange :
	STRUCT
		
		DataA			: REF_TO WORD;
		DataI			: REF_TO WORD;
		DataD			: REF_TO BYTE;
	
		minDataA        : INT;
		minDataI        : INT;
		minDataD        : INT;
		
		CurrentPollA : REF_TO INT;
		CurrentPollI : REF_TO INT;
		CurrentPollD : REF_TO INT;
		
		uChange_DataA			: REF_TO BOOL;
		uChange_DataI			: REF_TO BOOL;
		uChange_DataD			: REF_TO BOOL;
		
		pChange_DataA			: REF_TO BOOL;
		pChange_DataI			: REF_TO BOOL;
		pChange_DataD			: REF_TO BOOL;
		mutex : Mutex;
	END_STRUCT;
END_TYPE



(**
 ### Carel Slave Device ###
 Describes a Carel Slave Device.
 
 *)
CLASS CarelSlaveDevice
	VAR PUBLIC
		ID : INT;
		Info : REF_TO ProtocolDeviceInfo; 
		EventMask : DWORD;
		(** Slave index into Master array. *)
		Index : UINT;
		(** Slave Ident. *)
		Ident : UINT;
		(** Slave CRC usage: FALSE = Checksum - TRUE = CRC. *)
		UseCRC			: BOOL;
		(** Check if it is possible to poll next device. *)
		CanPollNextDevice : BOOL;
	
		SerialChannel : Serial_Channel;
		
		
		
		PeripheralID	: BYTE;
		SWRelease		: BYTE;
		
		_Type              	: WORD;
		FwRelease         	: WORD;
		ProtocolCap       	: WORD;
		HwCode            	: WORD; 
		Template   	        : BYTE;
		ExportIfaceCode   	: BYTE;
		ApplicationRelease	: BYTE;
		ApplicationCode     : WORD;
		CustomerCode        : WORD;
		USMaxVar            : BYTE;
		BMaxVar             : BYTE;
		
		LastIndex : UINT;
		WaitingAck		: BOOL;
		POLL_STEP : UINT;
		Retry : UINT;
		IsFirstPollLoopAfterOnline : BOOL;
		Sizes : REF_TO CarelMaster.DataTypes.CAREL_Sizes;
		DATA : REF_TO DataChange;
		LastOfflineDetection : UDINT;
	END_VAR
	
    VAR
        EnqCount : INT :=0;
    END_VAR
	   
	
	

	
	(** Manage current Slave answer data packet. *)
	METHOD ManageAnswer
		VAR_IN_OUT
			(** Incoming Data Packet. *)
			data : ARRAY [*] OF BYTE;
		END_VAR
		VAR_INPUT
			(** Incoming Data Packet Length. *)
			dataLen : DINT;
		END_VAR
		VAR
			i, j : INT;
			acceptCRC : BOOL;
			pAddr, index, nVar, curVar, nBytes, offset : INT;
			pKind, tmpByte : BYTE;
            bitdigit : ByteBits;
		END_VAR
		
		IF dataLen = 1 THEN
			CASE data[0] OF
				ASCII_NAK:
					THIS.CanPollNextDevice := TRUE;
					THIS.NotifyProtocol(THIS.Info^.CommandDelay);
				ASCII_NULL:
					(* <NULL> received after <ENQ>, start with WRITE commands *)
					THIS.POLL_STEP := THIS.POLL_STEP + 1;
					(* Sign current device as an online device *)
					THIS.SetLineStatus(TRUE);
					THIS.NotifyProtocol(THIS.Info^.CommandDelay);
				ASCII_ACK:
					IF THIS.WaitingAck THEN
						(* Sign current device as an online device *)
						THIS.SetLineStatus(TRUE);
						IF THIS.POLL_STEP = 0 THEN
							(* Expected <ACK>, send <ENQ> *)
							THIS.SendENQ();
							(* Update TimeOut *)
							THIS.NotifyProtocol(THIS.Info^.TimeOut);
						ELSE
							(* <ACK> received after a WRITE command;
							   switch to the next command for the current slave device *)
							THIS.POLL_STEP := THIS.POLL_STEP + 1;
							THIS.NotifyProtocol(THIS.Info^.CommandDelay);
						END_IF;
					ELSE
						(* Unexpected <ACK>, poll next device *)
						THIS.CanPollNextDevice := TRUE;
						THIS.NotifyProtocol(THIS.Info^.CommandDelay);
					END_IF;
			END_CASE;
			(* Reset Retry counter *)
			THIS.Retry := 0;
			RETURN;
		END_IF;
		
		IF NOT VerifyPacketControl(data, THIS.UseCRC, 0, TO_INT(dataLen)) THEN
			(* Wrong CHK/CRC *)
			THIS.NotifyProtocol(0);
			RETURN;
		END_IF;
		
		(* Start decode answer *)
		(* buffer[0] = ASCII_STX *)
		
		(* Peripheral Address *)
		pAddr := TO_INT(data[1]) - 16#30;
		
		(* Check if the packet is for the current Slave device *)
		IF pAddr <> TO_INT(THIS.Ident) THEN
			THIS.NotifyProtocol(0);
			RETURN;
		END_IF;
		
		(* Packet Kind *)
		pKind := data[2];
		
		(* Check if the packet is a correct answer to the previous question *)
		CASE pKind OF
			
		END_CASE;
		
		(* It is a valid data packet, reset timeout and retry counter *)
		THIS.SetLineStatus(TRUE);
		THIS.NotifyProtocol(THIS.Info^.TimeOut);
		THIS.Retry := 0;
		
		
		index := TO_INT(data[3]) - 16#30;	//Variable Address, Start Address or Peripheral Identifier
		
		CASE pKind OF
			(* Single variables *)
			16#41://'A'
				IF index-THIS.DATA^.minDataA > THIS.Sizes^.MAX_A-THIS.Sizes^.MIN_A THEN
					SetDeviceError(THIS.info^, DeviceError#ReceivedDataOutOfRange);
				ELSE
					THIS.DATA^.DataA[index-THIS.DATA^.minDataA]^ := TO_WORD(STRING_TO_HEX(data, 4, 4));
					THIS.DATA^.pChange_DataA[index-THIS.DATA^.minDataA]^ := TRUE;
				END_IF;
			16#49://'I'
				IF index-THIS.DATA^.minDataI > THIS.Sizes^.MAX_I-THIS.Sizes^.MIN_I THEN
					SetDeviceError(THIS.info^, DeviceError#ReceivedDataOutOfRange);
				ELSE
					THIS.DATA^.DataI[index-THIS.DATA^.minDataI]^ := TO_WORD(STRING_TO_HEX(data, 4, 4));
					THIS.DATA^.pChange_DataI[index-THIS.DATA^.minDataI]^ := TRUE;
				END_IF;
			16#44://'D'
				IF index-THIS.DATA^.minDataD > THIS.Sizes^.MAX_D-THIS.Sizes^.MIN_D THEN
					SetDeviceError(THIS.info^, DeviceError#ReceivedDataOutOfRange);
				ELSE
					THIS.DATA^.DataD[index / 8 - THIS.DATA^.minDataD / 8]^ := THIS.DATA^.DataD[index /8 - THIS.DATA^.minDataD / 8]^ XOR  System.Math.SHL(SHR(tmpByte, j - 1) AND 1,index MOD 8);
					THIS.DATA^.pChange_DataD[index -THIS.DATA^.minDataD]^ := TRUE;
				END_IF;
			(* Packed variables *)
			16#53://'S'
				nVar := TO_INT(data[4]) - 16#30;
				FOR i := 5 TO 5 + 4*nVar - 1 BY 4 DO
					IF index < THIS.Sizes^.MIN_A OR index > THIS.Sizes^.MAX_A THEN
					SetDeviceError(THIS.info^, DeviceError#ReceivedDataOutOfRange);
					ELSE
						THIS.DATA^.DataA[index + ((i-5)/4) -THIS.DATA^.minDataA]^ := TO_WORD(STRING_TO_HEX(data, TO_UDINT(i), 4));
						THIS.DATA^.pChange_DataA[index + ((i - 5) / 4) -THIS.DATA^.minDataA]^ := TRUE;
					END_IF;
				END_FOR;
			16#55://'U'
				nVar := TO_INT(data[4]) - 16#30;
				FOR i := 5 TO 5 + 4*nVar - 1 BY 4 DO
					IF index < THIS.Sizes^.MIN_I OR index > THIS.Sizes^.MAX_I THEN
					SetDeviceError(THIS.info^, DeviceError#ReceivedDataOutOfRange);
					ELSE
						THIS.DATA^.DataI[index + ((i-5)/4)-THIS.DATA^.minDataI]^ := TO_WORD(STRING_TO_HEX(data, TO_UDINT(i), 4));
						THIS.DATA^.pChange_DataI[index + ((i - 5) / 4)-THIS.DATA^.minDataI]^ := TRUE;
					END_IF;
				END_FOR;
			16#42://'B'
				nVar := TO_INT(data[4]) - 16#30;
				curVar := 1;
				IF nVar MOD 8 = 0 THEN
					nBytes := (nVar / 8);
				ELSE
					nBytes := ((nVar / 8) + 1);
				END_IF;
				FOR i := 0 TO nBytes - 1 DO
					tmpByte := TO_BYTE(STRING_TO_HEX(data, 5 + 2 * TO_UDINT(i), 2));
					IF nVar - curVar < 8 THEN
						offset := nVar - curVar + 1;
					ELSE
						offset := 8;
					END_IF;
					FOR j := 1  TO offset DO
    					IF index < THIS.Sizes^.MIN_D OR index > THIS.Sizes^.MAX_D THEN
    						    SetDeviceError(THIS.info^, DeviceError#ReceivedDataOutOfRange);
    					ELSE
                            bitdigit.data := THIS.DATA^.DataD[(index + curVar-1) / 8 - THIS.DATA^.minDataD / 8]^;
                            IF (SHR(tmpByte, j - 1) AND 1) = 1 THEN
                                 bitdigit.bits[(index + curVar - 1) MOD 8] := TRUE;
                            ELSE
                                bitdigit.bits[(index + curVar - 1) MOD 8] := FALSE;
                            END_IF;
							THIS.DATA^.DataD[(index + curVar-1) / 8 - THIS.DATA^.minDataD / 8]^ := bitdigit.data;
                            THIS.DATA^.pChange_DataD[index -THIS.DATA^.minDataD + curVar -1]^ := TRUE;	
                        END_IF;
						curVar := curVar + 1;
						IF curVar > nVar THEN
							EXIT;
						END_IF;
					END_FOR;
				END_FOR;
			(* Identification data *)
			16#56://'V'
				THIS.PeripheralID := TO_BYTE(index);
				IF data[4] <> ASCII_ETX THEN
					THIS.SWRelease := TO_BYTE(TO_USINT(data[4]) - 16#30);
				END_IF;
				IF (THIS.PeripheralID >= 170 AND THIS.PeripheralID <= 189) OR
					THIS.SWRelease = 16#0A THEN
					THIS.SendQM1();
				ELSE
					THIS.SendF1();
					THIS.WaitingAck := TRUE;
				END_IF;
                EnqCount := 0;
				RETURN;
			16#78://'x'
				THIS._Type := 				TO_WORD(STRING_TO_HEX(data,  3, 4));
				THIS.FwRelease := 			TO_WORD(STRING_TO_HEX(data,  7, 4));
				THIS.ProtocolCap := 		TO_WORD(STRING_TO_HEX(data, 11, 4));
				THIS.HwCode := 				TO_WORD(STRING_TO_HEX(data, 15, 4));
				THIS.ExportIfaceCode := 	TO_BYTE(STRING_TO_HEX(data, 19, 2));
				THIS.ApplicationRelease := 	TO_BYTE(STRING_TO_HEX(data, 21, 2));
				THIS.ApplicationCode := 	TO_WORD(STRING_TO_HEX(data, 23, 4));
				THIS.CustomerCode := 		TO_WORD(STRING_TO_HEX(data, 27, 4));
				THIS.USMaxVar := 			TO_BYTE(STRING_TO_HEX(data, 31, 2));
				THIS.BMaxVar := 			TO_BYTE(STRING_TO_HEX(data, 33, 2));
				
				acceptCRC := (SHR(THIS.ProtocolCap, 1) AND 1) = 1;
				
				IF acceptCRC THEN
					THIS.SendF2();
					THIS.UseCRC := TRUE;	//To verify after <ACK>
				ELSE
					THIS.SendF1();
				END_IF;
				
				THIS.WaitingAck := TRUE;
                EnqCount := 0;
				RETURN;
            ELSE
                EnqCount := 0;
		END_CASE;
		
        IF EnqCount < 200 THEN
    		THIS.SendACK();
    		THIS.SendENQ();
            EnqCount := EnqCount + 1;
        ELSE
    		THIS.SendACK();
			(* <NULL> received after <ENQ>, start with WRITE commands *)
			THIS.POLL_STEP := THIS.POLL_STEP + 1;
			(* Sign current device as an online device *)
			THIS.SetLineStatus(TRUE);
            THIS.NotifyProtocol(THIS.Info^.CommandDelay); 
            EnqCount := 0;
        END_IF;

		THIS.WaitingAck := TRUE;
		
	END_METHOD
	
	(**
		Update current Line Status.
		Call Callback if status is changed.
	 *)
	METHOD SetLineStatus
		VAR_INPUT
			(** New Line Status. *)
			status : BOOL;
		END_VAR
		IF status <> THIS.info^.IsOnline THEN
			THIS.info^.IsOnline := status;
		END_IF;
	END_METHOD
	
{REGION Control Messages}
	(** Send Force Data Packet. *)
	METHOD SendF
		VAR
			request		: ARRAY [0..7] OF BYTE;
			packetSize	: UDINT;
		END_VAR
		
		request[0] := ASCII_STX;
		request[1] := TO_BYTE(THIS.Ident + 16#30);	//address + 30h
		request[2] := 16#46;	//'F'
		request[3] := ASCII_ETX;
		
		packetSize := GeneratePacketControl(request, THIS.UseCRC, 0, 4);
	
		SerialWrite(THIS.SerialChannel, request, 0, packetSize);
		
		THIS.WaitingAck := TRUE;
	END_METHOD
	
	(** Send Force 1 Data Packet. *)
	METHOD SendF1
		VAR
			request		: ARRAY [0..8] OF BYTE;
			packetSize	: UDINT;
		END_VAR
		
		request[0] := ASCII_STX;
		request[1] := TO_BYTE(THIS.Ident + 16#30);	//address + 30h
		request[2] := 16#46;	//'F'
		request[3] := 16#31;	//'1'
		request[4] := ASCII_ETX;
		
		packetSize := GeneratePacketControl(request, THIS.UseCRC, 0, 5);
		
		SerialWrite(THIS.SerialChannel, request, 0, packetSize);
		
		THIS.WaitingAck := TRUE;
	END_METHOD
	
	(** Send Force 2 Data Packet. *)
	METHOD SendF2
		VAR
			request		: ARRAY [0..8] OF BYTE;
			packetSize	: UDINT;
		END_VAR
		
		request[0] := ASCII_STX;
		request[1] := TO_BYTE(THIS.Ident + 16#30);	//address + 30h
		request[2] := 16#46;	//'F'
		request[3] := 16#32;	//'2'
		request[4] := ASCII_ETX;
		
		packetSize := GeneratePacketControl(request, THIS.UseCRC, 0, 5);
		
		SerialWrite(THIS.SerialChannel, request, 0, packetSize);
		
		THIS.WaitingAck := TRUE;
	END_METHOD
	
	(** Send Enquire Data Packet. *)
	METHOD SendENQ
		VAR
			request		: ARRAY [0..8] OF BYTE;
		END_VAR
		
		request[0] := ASCII_ENQ;
		request[1] := TO_BYTE(THIS.Ident + 16#30);
		
		SerialWrite(THIS.SerialChannel, request, 0, 2);
	END_METHOD
	
	(** Send Acknowledge Data Packet. *)
	METHOD SendACK
		VAR
			request		: ARRAY [0..0] OF BYTE;
		END_VAR
		
		request[0] := ASCII_ACK;
		
		SerialWrite(THIS.SerialChannel, request, 0, 1);
	END_METHOD
	
	(** Send ? Data Packet. *)
	METHOD SendQM
		VAR
			request		: ARRAY [0..5] OF BYTE;
			packetSize	: UDINT;
		END_VAR
		
		request[0] := ASCII_STX;
		request[1] := TO_BYTE(THIS.Ident + 16#30);
		request[2] := 16#3F; //'?'
		request[3] := ASCII_ETX;
		
		THIS.UseCRC := FALSE;	//Reset CRC flag

		packetSize := GeneratePacketControl(request, THIS.UseCRC, 0, 4);
		
		SerialWrite(THIS.SerialChannel, request, 0, packetSize);
	END_METHOD
	
	(** Send ?1 Data Packet. *)
	METHOD SendQM1
		VAR
			request		: ARRAY [0..8] OF BYTE;
			packetSize	: UDINT;
		END_VAR
		
		request[0] := ASCII_STX;
		request[1] := TO_BYTE(THIS.Ident + 16#30);
		request[2] := 16#3F; //'?'
		request[3] := 16#31; //'1'
		request[4] := ASCII_ETX;
		
		packetSize := GeneratePacketControl(request, THIS.UseCRC, 0, 5);
		
		SerialWrite(THIS.SerialChannel, request, 0, packetSize);
	END_METHOD
	
{ENDREGION}

{REGION Reset}

	(** Reset current status. *)
	METHOD Reset
		THIS.Retry := 0;
		THIS.POLL_STEP := 0;
		THIS.CanPollNextDevice := FALSE;
	END_METHOD
	
{ENDREGION}

{REGION Event management}
	METHOD NotifyProtocol
		VAR_INPUT
			t : UINT;
		END_VAR
		SignalDynamicEvent(USER_EVENT_DATA, TO_UDINT(t), THIS.EventMask, SignalDynamicEventMode#OVERRIDE_MODE);
	END_METHOD
{ENDREGION}

END_CLASS

FUNCTION WriteDigital
	VAR_INPUT
		address : INT;
		count : INT;
	END_VAR
	VAR_IN_OUT
		Slave : CarelSlaveDevice;
		answer : ARRAY [*] OF BYTE;
	END_VAR
	VAR
		tmpbt : Byte;
		size : UDINT;
	END_VAR
	VAR
		i : INT;
	END_VAR
	
	answer[0] := ASCII_STX;
	answer[1] := TO_BYTE(slave.Ident + 16#30);
	IF count > 8 THEN
		answer[2] := CHAR_TO_BYTE('B');
		answer[3] := TO_BYTE(address + 16#30);
		answer[4] := TO_BYTE(count + 16#30);
		
		FOR i := 0 TO count-1 DO 
			IF i MOD 8 = 0 THEN
				HEX_TO_STRING(answer, TO_UDINT(5+(i/8)), 2, to_dword(tmpbt));
				tmpbt := 0;
				END_IF;
			tmpbt := tmpbt OR shl(TO_BYTE(slave.Data^.dataD[address -slave.data^.minDataD - i]^), i - (i/8));
		END_FOR;
		
		answer[6+(count / 8)] := ASCII_ETX;
		size := GeneratePacketControl(answer, Slave.UseCRC, 0, 7+(count/8));
	ELSE
		answer[2] := CHAR_TO_BYTE('D');
		answer[3] := TO_BYTE(address + 16#30);
		answer[4] := TO_BYTE(TO_UDINT(System.Math.SHR(slave.Data^.dataD[(address-slave.data^.minDataD+1)/8]^,(address-slave.data^.minDataD +1) MOD 8) AND 1) + 16#30);
		answer[5] := ASCII_ETX;
		size := GeneratePacketControl(answer, slave.useCRC, 0, 6);
	END_IF;
	SerialWrite(slave.serialChannel, answer, 0, size);
END_FUNCTION


FUNCTION WriteInteger
	VAR_INPUT
		address : INT;
		count : INT;
	END_VAR
	VAR_IN_OUT
		Slave : CarelSlaveDevice;
		answer : ARRAY [*] OF BYTE;
	END_VAR

		VAR
			size : UDINT;
			i : INT;
		END_VAR
		
	 
		
		answer[0] := ASCII_STX;
		answer[1] := TO_BYTE(Slave.Ident + 16#30);
		IF count > 1 THEN
		answer[2] := CHAR_TO_BYTE('U');
		answer[3] := TO_BYTE(address + 16#30);
		answer[4] := TO_BYTE(count + 16#30);
		
		FOR i := 1 TO count DO 
			HEX_TO_STRING(answer, TO_UDINT(5+((i-1)*4)), 4, WORD_TO_DWORD(Slave.Data^.DataI[address-1-slave.data^.minDataI+i]^));

		END_FOR;
	   
	
		answer[5+(count*4)] := ASCII_ETX;
		
		size := GeneratePacketControl(answer, Slave.UseCRC, 0, 6+(count*4));
		ELSE
		answer[2] := CHAR_TO_BYTE('I');
		answer[3] := TO_BYTE(address + 16#30);
		HEX_TO_STRING(answer, 4, 4, WORD_TO_DWORD(Slave.Data^.DataI[address-slave.data^.minDataI]^));
		answer[8] := ASCII_ETX;
		size := GeneratePacketControl(answer, Slave.UseCRC, 0, 9);
		END_IF;
		
		SerialWrite(Slave.SerialChannel, answer, 0, size);
END_FUNCTION

FUNCTION WriteAnalog
	VAR_INPUT
		address : INT;
		count : INT;
	END_VAR
	VAR_IN_OUT
		Slave : CarelSlaveDevice;
		answer : ARRAY [*] OF BYTE;
	END_VAR
	VAR
		size : UDINT;
	END_VAR
	VAR
		i : INT;
	END_VAR

	
	answer[0] := ASCII_STX;
	answer[1] := TO_BYTE(Slave.Ident + 16#30);
	IF count > 1 THEN
		answer[2] := CHAR_TO_BYTE('U');
		answer[3] := TO_BYTE(address + 16#30);
		answer[4] := TO_BYTE(count + 16#30);
		
		FOR i := 1 TO count DO 
			HEX_TO_STRING(answer, TO_UDINT(5+((i-1)*4)), 4, WORD_TO_DWORD(Slave.Data^.DataA[address-1-slave.data^.minDataA+i]^));

		END_FOR;
	   
	
		answer[5+(count*4)] := ASCII_ETX;
		
		size := GeneratePacketControl(answer, Slave.UseCRC, 0, 6+(count*4));
		ELSE
			answer[2] := CHAR_TO_BYTE('A');
			answer[3] := TO_BYTE(address + 16#30);
			
			HEX_TO_STRING(answer, 4, 4, WORD_TO_DWORD(Slave.DATA^.DataA[address-slave.data^.minDataA]^));
			
			answer[8] := ASCII_ETX;
			
			size := GeneratePacketControl(answer, Slave.UseCRC, 0, 9);
		END_IF;
	SerialWrite(Slave.SerialChannel, answer, 0, size);
END_FUNCTION