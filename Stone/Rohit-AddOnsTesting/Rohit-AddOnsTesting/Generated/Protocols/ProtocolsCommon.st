USING System;
USING System.Math;
USING System.Serial;

NAMESPACE ProtocolsCommon
    VAR_GLOBAL CONSTANT
        voidBuffer : ARRAY [0..270] OF BYTE;
    END_VAR

    TYPE ByteBits:
        UNION
            data : BYTE;
            bits : ARRAY [0..7] OF BOOL;
        END_UNION;
    END_TYPE

    TYPE RealUnion :
        UNION
            REAL : REAL;
            LREAL : LREAL;
            DWORD : DWORD;
            LWORD : LWORD;
        END_UNION;
    END_TYPE

    (**
     * Calculates the control block of packet with specified size.
     *)
    FUNCTION CalculatePacketControl : WORD
        VAR_IN_OUT
            (** The packet on which to calculate the control block. *)
            buffer : ARRAY [*] OF BYTE;
        END_VAR
        VAR_INPUT
            useCrc : BOOL;
            offset : INT;
            count : INT;
        END_VAR
		

        IF useCrc THEN
            CalculatePacketControl := UDINT_TO_WORD(CalcAlgorithm(Algorithm#CRC, buffer, TO_UDINT(offset), TO_UDINT(count)));
        ELSE
            CalculatePacketControl := UDINT_TO_WORD(CalcAlgorithm(Algorithm#CHK, buffer, TO_UDINT(offset), TO_UDINT(count)));
        END_IF;
    END_FUNCTION

    (**
     * Calculates the control block of packet into buffer
     * and serialize it after packet data.
     * Returns the total size of packet including control block size.
     *)
    FUNCTION GeneratePacketControl : UDINT
        VAR_IN_OUT
            (** The packet on which to generate the control block. *)
            buffer : ARRAY [*] OF BYTE;
        END_VAR
        VAR_INPUT
            useCRC : BOOL;
            offset, count : INT;
        END_VAR
        VAR
            ctrlsize, i : INT;
            ctrl: WORD;
            b : BYTE;
        END_VAR

        IF useCRC THEN
            ctrlsize := 4;
        ELSE
            ctrlsize := 2;
        END_IF;

        // Calculate control of packet data
        ctrl := CalculatePacketControl(buffer, useCRC, offset, count);

        // Serialize control block after packet data
        FOR i := 0 TO ctrlsize - 1 DO
            b := WORD_TO_BYTE(SHR(ctrl, (ctrlsize - i - 1) * 4)) AND 16#0F;
            b := CHAR_TO_BYTE(BYTE_TO_CHAR(b) + '0');
            buffer[offset + count + i] := b;
        END_FOR;

        GeneratePacketControl := TO_UDINT(count + ctrlsize);

    END_FUNCTION

    (**
     * Verifies the control block of packet into buffer.
     * Returns TRUE if the packet is valid; FALSE otherwise.
     *)
    FUNCTION VerifyPacketControl : BOOL
        VAR_IN_OUT
            (** The packet to verify. *)
            buffer : ARRAY [*] OF BYTE;
        END_VAR
        VAR_INPUT
            UseCRC : BOOL;
            offset, count : INT;
        END_VAR
        VAR
            ctrlsize, i : INT;
            ctrl: WORD;
            b : BYTE;
        END_VAR

        IF UseCRC THEN
            ctrlsize := 4;
        ELSE
            ctrlsize := 2;
        END_IF;

        IF count < ctrlsize THEN
            RETURN;
        END_IF;

        // Subtract control block length from packet length.
        count := count - ctrlsize;

        // Calculate control of packet data
        ctrl := CalculatePacketControl(buffer, UseCRC, offset, count);

        // Verify the control block per byte
        VerifypacketControl := TRUE;
        FOR i := 0 TO ctrlsize - 1 DO
            b := WORD_TO_BYTE(SHR(ctrl, (ctrlsize - i - 1) * 4)) AND 16#0F;
            b := CHAR_TO_BYTE(BYTE_TO_CHAR(b) + '0');
            IF buffer[count + i] <> b THEN
                VerifyPacketControl := FALSE;
                EXIT;
            END_IF;
        END_FOR;
    END_FUNCTION
    
    FUNCTION SetDeviceError
        VAR_IN_OUT
            Info : protocols.ProtocolDeviceInfo;
        END_VAR
        VAR_INPUT
            Error : DeviceError;
        END_VAR
        IF Info.DeviceError <> Error THEN
            Info.DeviceError := Error;
            Info.ErrorsCount := Info.ErrorsCount + 1;
        END_IF;
    END_FUNCTION
    
END_NAMESPACE