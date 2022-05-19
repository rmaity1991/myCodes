USING ProtocolsCommon;
USING System;
USING System.Math;
USING System.Util;

NAMESPACE MasterProtocols.Tables
{REGION APIs}
FUNCTION ReadRegisters : BOOL
    VAR_IN_OUT CONSTANT
        table : ARRAY [*] OF LWORD;
    END_VAR
    VAR_INPUT
        baseAddress : UDINT;
        data : REF_TO WORD;
        protocolChanges : REF_TO BOOL;
        LOWER_LIMIT : UINT;
        zone : UDINT;
        typeMaster : USINT;
    END_VAR
    VAR
        mmData : System.Util.MMRegistersData;
    END_VAR

    mmData.table := REF(table);
    mmData.lowerBound := LOWER_BOUND(table, 1);
    mmData.upperBound := UPPER_BOUND(table, 1);
    mmData.data := data;
    mmData.protocolChanges := protocolChanges;
    mmData.zone := zone;
    mmData.changesLowerLimit := LOWER_LIMIT;
    mmData.baseAddress := baseAddress;
	
    IF typeMaster = 1 THEN
        mmdata.flags.isCarel := TRUE;
    ELSE
        mmdata.flags.isCarel := FALSE;
    END_IF;

    System.Util.MMReadRegisters(mmData);

    ReadRegisters := mmData.flags.changedData;

END_FUNCTION

FUNCTION WriteRegisters
    VAR_IN_OUT CONSTANT
        table : ARRAY [*] OF LWORD;
    END_VAR
    VAR_INPUT
        baseAddress : UDINT;
        data : REF_TO WORD;
        applicationChanges : REF_TO BOOL;
        protocolChanges : REF_TO BOOL;
        LOWER_LIMIT : UINT;
        zone : UDINT;
        skipWriteOnChange : BOOL;
        hysteresis : REF_TO UINT;
    END_VAR
    VAR
        mmData : System.Util.MMRegistersData;
    END_VAR

    mmData.table := REF(table);
    mmData.lowerBound := LOWER_BOUND(table, 1);
    mmData.upperBound := UPPER_BOUND(table, 1);
    mmData.data := data;
    mmData.applicationChanges := applicationChanges;
    mmData.protocolChanges := protocolChanges;
    mmData.zone := zone;
    mmData.changesLowerLimit := LOWER_LIMIT;
    mmData.baseAddress := baseAddress;
    mmData.flags.skipWriteOnChange := skipWriteOnChange;
	

    System.Util.MMWriteRegisters(mmData,hysteresis);

END_FUNCTION
{ENDREGION }

END_NAMESPACE