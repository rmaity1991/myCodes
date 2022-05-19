USING ProtocolsCommon;
USING System;
USING System.Math;
USING System.Util;

NAMESPACE SlaveProtocol.Tables

{REGION APIs}
FUNCTION ReadRegisters
    VAR_IN_OUT CONSTANT
        table : ARRAY [*] OF LWORD;
    END_VAR
    VAR_INPUT
        data : REF_TO WORD;
        changed : REF_TO BOOL;
        LOWER_LIMIT : UINT;
        zone : UDINT;
		typeMaster : INT;
    END_VAR
    VAR
        msData : MSRegistersData;
    END_VAR

    msData.table := REF(table);
    msData.lowerBound := LOWER_BOUND(table, 1);
    msData.upperBound := UPPER_BOUND(table, 1);
    msData.data := data;
    msData.changes := changed;
    msData.zone := zone;
    msData.changesLowerLimit := LOWER_LIMIT;
	
    IF typeMaster = 1 THEN
        msData.flags.isCarel := TRUE;
    ELSE
        msData.flags.isCarel := FALSE;
    END_IF;

    System.Util.MSReadRegisters(msData);

END_FUNCTION

FUNCTION WriteRegisters :BOOL
    VAR_IN_OUT CONSTANT
        table : ARRAY [*] OF LWORD;
    END_VAR
    VAR_INPUT
        data : REF_TO WORD;
        changed : REF_TO BOOL;
        changedp : REF_TO BOOL;
        sent : REF_TO BOOL;
        LOWER_LIMIT : UINT;
        zone : UDINT;
        hysteresis : REF_TO UINT;
    END_VAR
    VAR
        msData : MSRegistersData;
    END_VAR

    msData.table := REF(table);
    msData.lowerBound := LOWER_BOUND(table, 1);
    msData.upperBound := UPPER_BOUND(table, 1);
    msData.data := data;
    msData.changes := changed;
    msData.changesp := changedp;
    msData.Sent := sent;
    msData.zone := zone;
    msData.changesLowerLimit := LOWER_LIMIT;

    WriteRegisters := System.Util.MSWriteRegisters(msData,hysteresis);

END_FUNCTION
{ENDREGION }
END_NAMESPACE