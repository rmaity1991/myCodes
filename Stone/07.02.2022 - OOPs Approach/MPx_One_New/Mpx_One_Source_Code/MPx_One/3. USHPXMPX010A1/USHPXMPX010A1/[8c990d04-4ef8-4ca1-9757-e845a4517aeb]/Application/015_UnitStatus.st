USING System.Math;

{DEFINE IDE_VER_1 1}
{DEFINE IDE_VER_2 3}
{DEFINE IDE_VER_3 3871}
{DEFINE IDE_VER_4 17150}

NAMESPACE LibraryNamespaceAndVersion

PROGRAM UnitStatusMng
        //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;
    
{REGION Unit On Off}
    {IF __EDITOR_VER_1__ >= IDE_VER_1 AND __EDITOR_VER_2__ >= IDE_VER_2 AND __EDITOR_VER_3__ >= IDE_VER_3 AND __EDITOR_VER_4__ >= IDE_VER_4}
    UnitOn :=   NOT OrSeriousAlrm 
                AND SEL(En_SupervOnOff, TRUE, SupervOnOff)
                AND SEL(Din_Cfg.Fct.RemoteOff.Ch <> 0,TRUE, NOT DigitalInputs.Fct.RemoteOff)
                AND SEL(En_KeyboardOnOff, TRUE, KeyboardOnOff);
    {ELSE}    
    UnitOn :=   NOT OrSeriousAlrm 
                AND SEL(En_SupervOnOff, SupervOnOff, TRUE)
                AND SEL(Din_Cfg.Fct.RemoteOff.Ch <> 0, NOT DigitalInputs.Fct.RemoteOff, TRUE)
                AND SEL(En_KeyboardOnOff, KeyboardOnOff, TRUE);
    {ENDIF}
{ENDREGION}
    
{REGION Unit Status}
    IF DfrStatus = DFR_DFR THEN
        UnitStatus := UNIT_STATUS#DEFROST;
    ELSIF ManContinuous THEN
        UnitStatus := UNIT_STATUS#CONTINUOS_CYCLE;
    ELSIF DutySettings THEN
        UnitStatus := UNIT_STATUS#DUTY_SETTINGS;
    ELSIF DigitalInputs.Fct.DoorOff OR DigitalInputs.Fct.DoorOn THEN
        UnitStatus := UNIT_STATUS#DOOR_OPEN;
    ELSIF ManClean THEN
        UnitStatus := UNIT_STATUS#CLEAN;
    ELSIF Alarms.Al.Status_Standby.Info.Active THEN
        UnitStatus := UNIT_STATUS#STANDBY;
    ELSIF En_KeyboardOnOff AND NOT KeyboardOnOff THEN
        UnitStatus := UNIT_STATUS#OFF_BY_KEYBOARD;
    ELSIF Din_Cfg.Fct.RemoteOff.Ch <> 0 AND DigitalInputs.Fct.RemoteOff THEN
        UnitStatus := UNIT_STATUS#OFF_BY_DIGITAL_INPUT;
    ELSIF En_SupervOnOff AND NOT SupervOnOff THEN
        UnitStatus := UNIT_STATUS#OFF_BY_SUPERVISOR;
    ELSIF OrSeriousAlrm THEN
        UnitStatus := UNIT_STATUS#OFF_BY_ALARM;
    ELSE 
        UnitStatus := UNIT_STATUS#UNIT_ON;
    END_IF;
{ENDREGION}
    
{REGION UNIT STATUS WORKING MODE}
    CASE UnitStatus OF
        UNIT_STATUS#OFF_BY_ALARM,
        UNIT_STATUS#OFF_BY_DIGITAL_INPUT, 
        UNIT_STATUS#OFF_BY_KEYBOARD, 
        UNIT_STATUS#OFF_BY_SUPERVISOR,
        UNIT_STATUS#OFF_BY_TIME_BAND:
            {IF __EDITOR_VER_1__ >= IDE_VER_1 AND __EDITOR_VER_2__ >= IDE_VER_2 AND __EDITOR_VER_3__ >= IDE_VER_3 AND __EDITOR_VER_4__ >= IDE_VER_4}
            UnitStatus_WorkingMode := SEL(OrAlrm, UNIT_STATUS_GEN_FCT#UNIT_OFF, UNIT_STATUS_GEN_FCT#UNIT_ALARM);
            {ELSE}
            UnitStatus_WorkingMode := SEL(OrAlrm, UNIT_STATUS_GEN_FCT#UNIT_ALARM, UNIT_STATUS_GEN_FCT#UNIT_OFF);
            {ENDIF}
        UNIT_STATUS#UNIT_ON:
            {IF __EDITOR_VER_1__ >= IDE_VER_1 AND __EDITOR_VER_2__ >= IDE_VER_2 AND __EDITOR_VER_3__ >= IDE_VER_3 AND __EDITOR_VER_4__ >= IDE_VER_4}
            UnitStatus_WorkingMode := SEL(TempRegStatus, UNIT_STATUS_GEN_FCT#UNIT_ON, UNIT_STATUS_GEN_FCT#REGULATION_ON);
            {ELSE}
            IF OrAlrm THEN
                UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#UNIT_ALARM;
            ELSIF TempRegStatus THEN
                UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#REGULATION_ON;
            ELSE
                UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#UNIT_ON;
            END_IF;
            {ENDIF}
        UNIT_STATUS#DEFROST:
            UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#DEFROST;
        UNIT_STATUS#CLEAN:
            UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#CASE_CLEANING;
        UNIT_STATUS#CONTINUOS_CYCLE:
            UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#CONT_CYCLE;
        UNIT_STATUS#DUTY_SETTINGS:
            UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#DUTY_SETTINGS;
        UNIT_STATUS#STANDBY:
            UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#STANDBY;
        UNIT_STATUS#DOOR_OPEN:
            UnitStatus_WorkingMode := UNIT_STATUS_GEN_FCT#DOOR_OPEN;
        ELSE
            {IF __EDITOR_VER_1__ >= IDE_VER_1 AND __EDITOR_VER_2__ >= IDE_VER_2 AND __EDITOR_VER_3__ >= IDE_VER_3 AND __EDITOR_VER_4__ >= IDE_VER_4}
            UnitStatus_WorkingMode := SEL(OrAlrm, UNIT_STATUS_GEN_FCT#UNKNOWN, UNIT_STATUS_GEN_FCT#UNIT_ALARM);
            {ELSE}
            UnitStatus_WorkingMode := SEL(OrAlrm, UNIT_STATUS_GEN_FCT#UNIT_ALARM, UNIT_STATUS_GEN_FCT#UNKNOWN);
            {ENDIF}
    END_CASE;
{ENDREGION}
    
END_PROGRAM
    
END_NAMESPACE