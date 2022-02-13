USING System.Globalization;
USING System;

FUNCTION Get_HPX_SPV_Variables
    
    VAR_INPUT
        (** Read value from protocol to write local variable *)
        access : Libs.SPV_Gateway_HPX.BmsAccess;
    END_VAR
    
    VAR_IN_OUT CONSTANT
        UoM_hasChanged : BOOL;
    END_VAR
    
    VAR
        dummy : Libs.SPV_Gateway_HPX.BmsValue;
    END_VAR

{REGION Coil status}
    SpVTable.Input_Status[099].AssignMbInfo(access, V_CSM_bs.system.alarmflag);               // System Alarm Flag
    SpVTable.Input_Status[100].AssignMbInfo(access, V_CSM_bs.comp.alarmflag);                 // Compressor Alarm Flag
    SpVTable.Input_Status[101].AssignMbInfo(access, V_CSM_bs.cond.alarmflag);                 // Condensor Alarm Flag
    SpVTable.Input_Status[102].AssignMbInfo(access, V_CSM_bs.metering.alarmflag);             // Metering System Alarm Flag
    SpVTable.Input_Status[103].AssignMbInfo(access, V_CSM_bs.evap.alarmflag);                 // Evaporator Alarm Flag
    SpVTable.Input_Status[104].AssignMbInfo(access, V_CSM_bs.comm.alarmflag);                 // Communication System Alarm Flag
    SpVTable.Input_Status[105].AssignMbInfo(access, V_CSM_bs.device.alarmflag);               // Device Alarm Flag
    SpVTable.Input_Status[106].AssignMbInfo(access, dummy.bool);
    SpVTable.Input_Status[107].AssignMbInfo(access, dummy.bool);
    SpVTable.Input_Status[108].AssignMbInfo(access, dummy.bool);
    SpVTable.Input_Status[109].AssignMbInfo(access, dummy.bool);
    SpVTable.Input_Status[110].AssignMbInfo(access, dummy.bool);
    SpVTable.Input_Status[111].AssignMbInfo(access, dummy.bool);
    SpVTable.Input_Status[112].AssignMbInfo(access, dummy.bool);
    SpVTable.Input_Status[113].AssignMbInfo(access, dummy.bool);
    
{ENDREGION}
    
{REGION Coils}
    SpVTable.Coil_Status[100].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[101].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[102].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[103].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[104].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[105].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[106].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[107].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[108].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[109].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[110].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[111].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[112].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[113].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[114].AssignMbInfo(access, dummy.bool);
    
{ENDREGION}
  
{REGION INPUT REGISTER}
    SpVTable.Input_Register[053].AssignMbInfo(access, V_CSM_bs.System.alarm.i);                 // System Alarm
    SpVTable.Input_Register[054].AssignMbInfo(access, V_CSM_bs.Device.alarm.i);                 // Device Alarm
    SpVTable.Input_Register[055].AssignMbInfo(access, V_CSM_bs.evap.alarm.i);                   // Evaporator Alarm
    SpVTable.Input_Register[056].AssignMbInfo(access, V_CSM_bs.comp.alarm.i);                   // Compressor Alarm
    SpVTable.Input_Register[057].AssignMbInfo(access, V_CSM_bs.cond.alarm.i);                   // Condensor Alarm
    SpVTable.Input_Register[058].AssignMbInfo(access, V_CSM_bs.Metering.alarm.i);               // Metering System Alarm
    SpVTable.Input_Register[059].AssignMbInfo(access, V_CSM_bs.Comm.alarm.i);                   // Communication System Alarm
    SpVTable.Input_Register[060].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[061].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[062].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[063].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[064].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[065].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[066].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[067].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[068].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[069].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[070].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[071].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[072].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[073].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[074].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[075].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[076].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[077].AssignMbInfo(access, dummy.real);
  
{ENDREGION}
    
{REGION HOLDING REGISTER}
    SpVTable.Holding_Register[344].AssignMbInfo(access, V_CSM_CaseSystemInfo1);                // CIN Case System Info 1 
    SpVTable.Holding_Register[345].AssignMbInfo(access, V_CSM_CaseSystemInfo2);                // CIN Case System Info 2
    SpVTable.Holding_Register[346].AssignMbInfo(access, V_CSM_CaseSystemInfo3);                // CIN Case System Info 3
    SpVTable.Holding_Register[347].AssignMbInfo(access, V_CSM_CaseSystemInfo4);                // CIN CAse System Info 4
    SpVTable.Holding_Register[348].AssignMbInfo(access, V_CSM_CaseSystemInfo5);                // CIN Case System Info 5
    SpVTable.Holding_Register[349].AssignMbInfo(access, V_CSM_CaseSystemInfo6);                // CIN Case System Info 6
    SpVTable.Holding_Register[350].AssignMbInfo(access, V_CSM_FeatureInfo1);                   // CIN Case Feature Info 1
    SpVTable.Holding_Register[351].AssignMbInfo(access, V_CSM_FeatureInfo2);                   // CIN Case Feature Info 2
    SpVTable.Holding_Register[352].AssignMbInfo(access, V_CSM_FeatureInfo3);                   // CIN Case Feature Info 3
    SpVTable.Holding_Register[353].AssignMbInfo(access, V_CSM_FeatureInfo4);                   // CIN Case Feature Info 4
    SpVTable.Holding_Register[354].AssignMbInfo(access, V_CSM_SerialNumber1);                  // CIN Case Serial Number 1
    SpVTable.Holding_Register[355].AssignMbInfo(access, V_CSM_SerialNumber2);                  // CIN Case Serial Number 2
    SpVTable.Holding_Register[356].AssignMbInfo(access, dummy.int);
    SpVTable.Holding_Register[357].AssignMbInfo(access, dummy.int);
    SpVTable.Holding_Register[358].AssignMbInfo(access, dummy.int);
    SpVTable.Holding_Register[359].AssignMbInfo(access, dummy.int);
    SpVTable.Holding_Register[360].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[361].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[362].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[363].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[364].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[365].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[366].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[367].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[368].AssignMbInfo(access, dummy.real);
       
{ENDREGION}
    
END_FUNCTION
