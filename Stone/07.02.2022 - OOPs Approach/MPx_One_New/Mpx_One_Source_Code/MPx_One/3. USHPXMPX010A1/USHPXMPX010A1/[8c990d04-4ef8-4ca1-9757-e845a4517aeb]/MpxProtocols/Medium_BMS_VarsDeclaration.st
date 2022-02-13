{INCLUDE '../LibVer.g.st'}

USING System;
USING System.Globalization;

FUNCTION Get_SPV_Variables
    
    VAR_INPUT
        (** Read value from protocol to write local variable *)
        access : Libs.SPV_Gateway_HPX.BmsAccess;
    END_VAR
    
    VAR_IN_OUT CONSTANT
        UoM_hasChanged : BOOL;
    END_VAR
    
    VAR
        dummy : Libs.SPV_Gateway_HPX.BmsValue;
        AlarmActive_bkp : BOOL;
    END_VAR

{REGION Input status}      
    //Pressure probe alarm management to supervisor during defrost [d12]
        // save value
    IF (Ain_Cfg.Fct.EvapP.Ch > 0 AND TO_DINT(Ain_Cfg.Fct.EvapP.Ch) <= UPPER_BOUND(Alarms.Al.Al_PrbBroken, 1)) THEN
        AlarmActive_bkp := Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.EvapP.Ch].Info.Active; // at the end of this region reset original value
        IF (DfrStatus > DFR_IDLE AND DfrStatus < DFR_POST_DRIPPING) THEN
            Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.EvapP.Ch].Info.Active := Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.EvapP.Ch].Info.Active AND NOT(DfrPrbAlm = 0 OR DfrPrbAlm =1);
        END_IF;
    END_IF;    
    
    SpVTable.Input_Status[000].AssignMbInfo(access, Alarms.Al.Al_Reg.Info.Active);
    SpVTable.Input_Status[001].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[1].Info.Active);
    SpVTable.Input_Status[002].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[2].Info.Active);
    SpVTable.Input_Status[003].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[3].Info.Active);
    SpVTable.Input_Status[004].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[4].Info.Active);
    SpVTable.Input_Status[005].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[5].Info.Active);
    SpVTable.Input_Status[006].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[6].Info.Active);
    SpVTable.Input_Status[007].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[7].Info.Active);
    SpVTable.Input_Status[008].AssignMbInfo(access, Alarms.Al.Al_PrbBroken[8].Info.Active);
    SpVTable.Input_Status[009].AssignMbInfo(access, Alarms.Al.Al_SerialInputs[1].Info.Active);
    SpVTable.Input_Status[010].AssignMbInfo(access, Alarms.Al.Al_SerialInputs[2].Info.Active);
    SpVTable.Input_Status[011].AssignMbInfo(access, Alarms.Al.Al_SerialInputs[3].Info.Active);
    SpVTable.Input_Status[012].AssignMbInfo(access, Alarms.Al.Al_SerialInputs[4].Info.Active);
    SpVTable.Input_Status[013].AssignMbInfo(access, Alarms.Al.Al_LowTemp.Info.Active);
    SpVTable.Input_Status[014].AssignMbInfo(access, Alarms.Al.Al_HiTemp.Info.Active);
    SpVTable.Input_Status[015].AssignMbInfo(access, Alarms.Al.Al_LowTemp2.Info.Active);
    SpVTable.Input_Status[016].AssignMbInfo(access, Alarms.Al.Al_HiTemp2.Info.Active);
    SpVTable.Input_Status[017].AssignMbInfo(access, Alarms.Al.AlExtDin.Info.Active);
    SpVTable.Input_Status[018].AssignMbInfo(access, Alarms.Al.AlDelayExtDin.Info.Active);
    SpVTable.Input_Status[019].AssignMbInfo(access, Alarms.Al.Al_Door.Info.Active);
    SpVTable.Input_Status[020].AssignMbInfo(access, Alarms.Al.Al_RTC.Info.Active);
    SpVTable.Input_Status[021].AssignMbInfo(access, Alarms.Al.Al_LSH.Info.Active);
    SpVTable.Input_Status[022].AssignMbInfo(access, Alarms.Al.Al_LSA.Info.Active);
    SpVTable.Input_Status[023].AssignMbInfo(access, Alarms.Al.Al_MOP.Info.Active);
    SpVTable.Input_Status[024].AssignMbInfo(access, Alarms.Al.Al_LOP.Info.Active);
    SpVTable.Input_Status[025].AssignMbInfo(access, Alarms.Al.Al_bLO.Info.Active);
    SpVTable.Input_Status[026].AssignMbInfo(access, Alarms.Al.Al_Edc.Info.Active);
    SpVTable.Input_Status[027].AssignMbInfo(access, Alarms.Al.Al_HA.Info.Active);
    SpVTable.Input_Status[028].AssignMbInfo(access, Alarms.Al.Al_HF.Info.Active);
    SpVTable.Input_Status[029].AssignMbInfo(access, Alarms.Al.Al_MA.Info.Active);
    SpVTable.Input_Status[030].AssignMbInfo(access, Alarms.Al.Al_u[1].Info.Active);
    SpVTable.Input_Status[031].AssignMbInfo(access, Alarms.Al.Al_u[2].Info.Active);
    SpVTable.Input_Status[032].AssignMbInfo(access, Alarms.Al.Al_u[3].Info.Active);
    SpVTable.Input_Status[033].AssignMbInfo(access, Alarms.Al.Al_u[4].Info.Active);
    SpVTable.Input_Status[034].AssignMbInfo(access, Alarms.Al.Al_u[5].Info.Active);
    SpVTable.Input_Status[035].AssignMbInfo(access, Alarms.Al.Al_u[6].Info.Active);
    SpVTable.Input_Status[036].AssignMbInfo(access, Alarms.Al.Al_u[7].Info.Active);
    SpVTable.Input_Status[037].AssignMbInfo(access, Alarms.Al.Al_u[8].Info.Active);
    SpVTable.Input_Status[038].AssignMbInfo(access, Alarms.Al.Al_u[9].Info.Active);
    SpVTable.Input_Status[039].AssignMbInfo(access, Alarms.Al.Al_n[1].Info.Active);
    SpVTable.Input_Status[040].AssignMbInfo(access, Alarms.Al.Al_n[2].Info.Active);
    SpVTable.Input_Status[041].AssignMbInfo(access, Alarms.Al.Al_n[3].Info.Active);
    SpVTable.Input_Status[042].AssignMbInfo(access, Alarms.Al.Al_n[4].Info.Active);
    SpVTable.Input_Status[043].AssignMbInfo(access, Alarms.Al.Al_n[5].Info.Active);
    SpVTable.Input_Status[044].AssignMbInfo(access, Alarms.Al.Al_n[6].Info.Active);
    SpVTable.Input_Status[045].AssignMbInfo(access, Alarms.Al.Al_n[7].Info.Active);
    SpVTable.Input_Status[046].AssignMbInfo(access, Alarms.Al.Al_n[8].Info.Active);
    SpVTable.Input_Status[047].AssignMbInfo(access, Alarms.Al.Al_n[9].Info.Active);
    SpVTable.Input_Status[048].AssignMbInfo(access, Alarms.Al.Al_GPE.Info.Active);
    SpVTable.Input_Status[049].AssignMbInfo(access, Alarms.Al.Warn_Door.Info.Active);
    SpVTable.Input_Status[050].AssignMbInfo(access, Alarms.Al.Status_Standby.Info.Active);
    SpVTable.Input_Status[051].AssignMbInfo(access, Alarms.Al.Status_Clean.Info.Active);
    SpVTable.Input_Status[052].AssignMbInfo(access, DigitalInputs.Fct.Alarm);
    SpVTable.Input_Status[053].AssignMbInfo(access, DigitalInputs.Fct.DelayedAl);
    SpVTable.Input_Status[054].AssignMbInfo(access, DigitalInputs.Fct.EnDfr);
    SpVTable.Input_Status[055].AssignMbInfo(access, DigitalInputs.Fct.CallDfr);
    SpVTable.Input_Status[056].AssignMbInfo(access, DigitalInputs.Fct.DoorOff);
    SpVTable.Input_Status[057].AssignMbInfo(access, DigitalInputs.Fct.RemoteOff);
    SpVTable.Input_Status[058].AssignMbInfo(access, DigitalInputs.Fct.Curtain);
    SpVTable.Input_Status[059].AssignMbInfo(access, DigitalInputs.Fct.ContCycle);
    SpVTable.Input_Status[060].AssignMbInfo(access, DigitalInputs.Fct.Auxiliary);
    SpVTable.Input_Status[061].AssignMbInfo(access, DigitalInputs.Fct.Timed);
    SpVTable.Input_Status[062].AssignMbInfo(access, DigitalInputs.Fct.Standby);
    SpVTable.Input_Status[063].AssignMbInfo(access, DigitalInputs.Fct.Clean);
    SpVTable.Input_Status[064].AssignMbInfo(access, DigitalInputs.Fct.Config);
    SpVTable.Input_Status[065].AssignMbInfo(access, DigitalInputs.Fct.DoorOn);
    SpVTable.Input_Status[066].AssignMbInfo(access, DigitalOutputs.Fct.Solenoid);   //Before changing address search myInputStatus[66]
    SpVTable.Input_Status[067].AssignMbInfo(access, OrAlrm);                        //Before changing address search myInputStatus[67]
    SpVTable.Input_Status[068].AssignMbInfo(access, DigitalOutputs.Fct.Auxiliary);
    SpVTable.Input_Status[069].AssignMbInfo(access, DigitalOutputs.Fct.MasterAuxiliary);
    SpVTable.Input_Status[070].AssignMbInfo(access, DigitalOutputs.Fct.Light);
    SpVTable.Input_Status[071].AssignMbInfo(access, DigitalOutputs.Fct.MasterLight);
    SpVTable.Input_Status[072].AssignMbInfo(access, DigitalOutputs.Fct.Defrost);
    SpVTable.Input_Status[073].AssignMbInfo(access, DigitalOutputs.Fct.Defrost2);
    SpVTable.Input_Status[074].AssignMbInfo(access, DigitalOutputs.Fct.Fans);
    SpVTable.Input_Status[075].AssignMbInfo(access, DigitalOutputs.Fct.SuctVlv);
    SpVTable.Input_Status[076].AssignMbInfo(access, DigitalOutputs.Fct.EqualizVlv);
    SpVTable.Input_Status[077].AssignMbInfo(access, DigitalOutputs.Fct.LiquidVlv);
    SpVTable.Input_Status[078].AssignMbInfo(access, DigitalOutputs.Fct.Timed);
    SpVTable.Input_Status[079].AssignMbInfo(access, DigitalOutputs.Fct.DrainHeat);
    SpVTable.Input_Status[080].AssignMbInfo(access, Alarms.Al.DfrTout1.Info.Active);
    SpVTable.Input_Status[081].AssignMbInfo(access, Alarms.Al.DfrTout2.Info.Active);
    SpVTable.Input_Status[082].AssignMbInfo(access, DigitalInputs.Fct.DefrostMirror);
    SpVTable.Input_Status[083].AssignMbInfo(access, DigitalOutputs.Fct.Alarm);
    SpVTable.Input_Status[084].AssignMbInfo(access, DigitalOutputs.Fct.GenericStage1);
    SpVTable.Input_Status[085].AssignMbInfo(access, DigitalOutputs.Fct.RailHeaters);
    SpVTable.Input_Status[086].AssignMbInfo(access, SlavesTempReq);  //Temperature request from at least one slave
    SpVTable.Input_Status[087].AssignMbInfo(access, TempRegStatus);  //Before changing address search myInputStatus[87]
    SpVTable.Input_Status[088].AssignMbInfo(access, DayStatus);
    SpVTable.Input_Status[089].AssignMbInfo(access, SmLineStatus);
    SpVTable.Input_Status[090].AssignMbInfo(access, Alarms.Al.AL_DA1_EVDmini.Info.Active);
    SpVTable.Input_Status[091].AssignMbInfo(access, Alarms.Al.AL_DA2_EVDmini.Info.Active);
    SpVTable.Input_Status[092].AssignMbInfo(access, Alarms.Al.AL_DEE_EVDmini.Info.Active);
    SpVTable.Input_Status[093].AssignMbInfo(access, Alarms.Al.AL_DE5_EVDmini.Info.Active);
    SpVTable.Input_Status[094].AssignMbInfo(access, Alarms.Al.Al_GHI_1.Info.Active);
    SpVTable.Input_Status[095].AssignMbInfo(access, Alarms.Al.Al_GLO_1.Info.Active);
    SpVTable.Input_Status[096].AssignMbInfo(access, dummy.bool);  //UGH
    SpVTable.Input_Status[097].AssignMbInfo(access, dummy.bool);  //UGL
    SpVTable.Input_Status[098].AssignMbInfo(access, dummy.bool);  //FOk
    
        // reset value
    IF (Ain_Cfg.Fct.EvapP.Ch > 0 AND TO_DINT(Ain_Cfg.Fct.EvapP.Ch) <= UPPER_BOUND(Alarms.Al.Al_PrbBroken, 1)) THEN    
        Alarms.Al.Al_PrbBroken[Ain_Cfg.Fct.EvapP.Ch].Info.Active := AlarmActive_bkp; // reset original value
    END_IF;
{ENDREGION}
    
{REGION Coils}    
    SpVTable.Coil_Status[000].AssignMbInfo(access, Din_Cfg.Arr[1].Logic);
    SpVTable.Coil_Status[001].AssignMbInfo(access, Din_Cfg.Arr[2].Logic);
    SpVTable.Coil_Status[002].AssignMbInfo(access, Din_Cfg.Arr[3].Logic);
    SpVTable.Coil_Status[003].AssignMbInfo(access, Din_Cfg.Arr[4].Logic);
    SpVTable.Coil_Status[004].AssignMbInfo(access, Din_Cfg.Arr[5].Logic);
    SpVTable.Coil_Status[005].AssignMbInfo(access, Din_Cfg.Arr[6].Logic);
    SpVTable.Coil_Status[006].AssignMbInfo(access, Din_Cfg.Arr[7].Logic);
    SpVTable.Coil_Status[007].AssignMbInfo(access, Din_Cfg.Arr[8].Logic);
    SpVTable.Coil_Status[008].AssignMbInfo(access, Din_Cfg.Arr[9].Logic);
    SpVTable.Coil_Status[009].AssignMbInfo(access, Din_Cfg.Arr[10].Logic);
    SpVTable.Coil_Status[010].AssignMbInfo(access, Din_Cfg.Arr[11].Logic);
    SpVTable.Coil_Status[011].AssignMbInfo(access, Din_Cfg.Arr[12].Logic);
    SpVTable.Coil_Status[012].AssignMbInfo(access, Din_Cfg.Arr[13].Logic);
    SpVTable.Coil_Status[013].AssignMbInfo(access, Din_Cfg.Arr[14].Logic);
    SpVTable.Coil_Status[014].AssignMbInfo(access, Din_Cfg.Arr[15].Logic);
    SpVTable.Coil_Status[015].AssignMbInfo(access, ZoneHMI);
    SpVTable.Coil_Status[016].AssignMbInfo(access, DisDecPointMainVar);
    SpVTable.Coil_Status[017].AssignMbInfo(access, RemoteHMIAlrms);
    SpVTable.Coil_Status[018].AssignMbInfo(access, SupervOnOff);
    SpVTable.Coil_Status[019].AssignMbInfo(access, NightPrbReg);
    SpVTable.Coil_Status[020].AssignMbInfo(access, DfrMasterEndSync);
    SpVTable.Coil_Status[021].AssignMbInfo(access, DisNetworkDfr);
    SpVTable.Coil_Status[022].AssignMbInfo(access, StartupDef);
    //SpVTable.Coil_Status[023].AssignMbInfo(access, Ain_Types.Group1); removed from version 1.6.9 Ain_Types.Group1 
    SpVTable.Coil_Status[023].AssignMbInfo(access, dummy.bool);
    SpVTable.Coil_Status[024].AssignMbInfo(access, DfrSafetyTime);
    SpVTable.Coil_Status[025].AssignMbInfo(access, DfrEndAlTimeout);
    SpVTable.Coil_Status[026].AssignMbInfo(access, DfrPriorityCont);
    SpVTable.Coil_Status[027].AssignMbInfo(access, AbsAlarmThr);
    SpVTable.Coil_Status[028].AssignMbInfo(access, AbsAlarm2Thr);
    SpVTable.Coil_Status[029].AssignMbInfo(access, NetworkDfr);         //Before changing address search myCoilStatus[29]
    SpVTable.Coil_Status[030].AssignMbInfo(access, RegFanConfig);
    SpVTable.Coil_Status[031].AssignMbInfo(access, DfrFanCfg);
    SpVTable.Coil_Status[032].AssignMbInfo(access, ExvEnCloseLsa);
    SpVTable.Coil_Status[033].AssignMbInfo(access, EnBloAlarm);
    SpVTable.Coil_Status[034].AssignMbInfo(access, ExvEnCloseMOP); //PM5
    SpVTable.Coil_Status[035].AssignMbInfo(access, EnManExv);
    SpVTable.Coil_Status[036].AssignMbInfo(access, EnSmoothLine);
    SpVTable.Coil_Status[037].AssignMbInfo(access, isMaster);
    SpVTable.Coil_Status[038].AssignMbInfo(access, BMS_Prot);
    SpVTable.Coil_Status[039].AssignMbInfo(access, EnNfc);                          //H5
    SpVTable.Coil_Status[040].AssignMbInfo(access, EnBuzzer);                       //H8 
    SpVTable.Coil_Status[041].AssignMbInfo(access, DayNightOutput);
    SpVTable.Coil_Status[042].AssignMbInfo(access, ManContinuous);                  //only status for slave
    SpVTable.Coil_Status[043].AssignMbInfo(access, Dout_Cfg.Fct.Solenoid.Logic);  
    SpVTable.Coil_Status[044].AssignMbInfo(access, Dout_Cfg.Fct.Alarm.Logic);
    SpVTable.Coil_Status[045].AssignMbInfo(access, Dout_Cfg.Fct.Auxiliary.Logic);
    SpVTable.Coil_Status[046].AssignMbInfo(access, Dout_Cfg.Fct.MasterAuxiliary.Logic);
    SpVTable.Coil_Status[047].AssignMbInfo(access, Dout_Cfg.Fct.Light.Logic);
    SpVTable.Coil_Status[048].AssignMbInfo(access, Dout_Cfg.Fct.MasterLight.Logic);
    SpVTable.Coil_Status[049].AssignMbInfo(access, Dout_Cfg.Fct.Defrost.Logic);
    SpVTable.Coil_Status[050].AssignMbInfo(access, Dout_Cfg.Fct.Defrost2.Logic);
    SpVTable.Coil_Status[051].AssignMbInfo(access, Dout_Cfg.Fct.Fans.Logic);
    SpVTable.Coil_Status[052].AssignMbInfo(access, Dout_Cfg.Fct.SuctVlv.Logic);
    SpVTable.Coil_Status[053].AssignMbInfo(access, Dout_Cfg.Fct.EqualizVlv.Logic);   
    SpVTable.Coil_Status[054].AssignMbInfo(access, Dout_Cfg.Fct.LiquidVlv.Logic);  
    SpVTable.Coil_Status[055].AssignMbInfo(access, Dout_Cfg.Fct.Timed.Logic); 
    SpVTable.Coil_Status[056].AssignMbInfo(access, Dout_Cfg.Fct.DrainHeat.Logic);
    SpVTable.Coil_Status[057].AssignMbInfo(access, DoubleThermostatConf);
    SpVTable.Coil_Status[058].AssignMbInfo(access, MstVlvConfig);
    SpVTable.Coil_Status[059].AssignMbInfo(access, ManDfr);                            //Before changing address search myInputStatus[059]
    SpVTable.Coil_Status[060].AssignMbInfo(access, DfrSkipEn);
    SpVTable.Coil_Status[061].AssignMbInfo(access, LightsOn);                           //Before changing address search myInputStatus[061]
    SpVTable.Coil_Status[062].AssignMbInfo(access, PowDfrConf[1]);
    SpVTable.Coil_Status[063].AssignMbInfo(access, PowDfrConf[2]);
    SpVTable.Coil_Status[064].AssignMbInfo(access, PowDfrConf[3]);
    SpVTable.Coil_Status[065].AssignMbInfo(access, PowDfrConf[4]);
    SpVTable.Coil_Status[066].AssignMbInfo(access, PowDfrConf[5]);
    SpVTable.Coil_Status[067].AssignMbInfo(access, PowDfrConf[6]);
    SpVTable.Coil_Status[068].AssignMbInfo(access, PowDfrConf[7]);
    SpVTable.Coil_Status[069].AssignMbInfo(access, PowDfrConf[8]);
    SpVTable.Coil_Status[070].AssignMbInfo(access, DfrPDFanCfg);                        // Fpd                                       
    SpVTable.Coil_Status[071].AssignMbInfo(access, DfrHotGasSafety);                    // only protocol no to model or commissioning
    SpVTable.Coil_Status[072].AssignMbInfo(access, SlaveAlarmCheck);                    // Ar
    SpVTable.Coil_Status[073].AssignMbInfo(access, Dout_Cfg.Fct.RailHeaters.Logic);     // rOQ
    SpVTable.Coil_Status[074].AssignMbInfo(access, Dout_Cfg.Fct.GenericStage1.Logic);   // rOS
    SpVTable.Coil_Status[075].AssignMbInfo(access, ManClean);                           // ManClean
    
    SpVTable.Coil_Status[076].AssignMbInfo(access, VirtualDI);                          //Before changing address search myInputStatus[76]
    SpVTable.Coil_Status[077].AssignMbInfo(access, MstRegStatus);                       //Before changing address search myCoilStatus[077] // only protocol no to model or commissioning
    SpVTable.Coil_Status[078].AssignMbInfo(access, EnKeyboard);                         // H6
    SpVTable.Coil_Status[079].AssignMbInfo(access, NetworkAux);                         // only protocol no to model or commissioning
    SpVTable.Coil_Status[080].AssignMbInfo(access, GenFctStages_Cfg[1].Rev);            // GFS_T
    SpVTable.Coil_Status[081].AssignMbInfo(access, GenFctModul_Cfg[1].Rev);             // GFM_T
    SpVTable.Coil_Status[082].AssignMbInfo(access, GenFctAlarm_Cfg[1].AlType);          // GFA_AlType
    SpVTable.Coil_Status[083].AssignMbInfo(access, Dout_Cfg.Fct.HotGas.Logic);          // rOAA
    SpVTable.Coil_Status[084].AssignMbInfo(access, AlrmRes);                            // res
    SpVTable.Coil_Status[085].AssignMbInfo(access, TempCtrl_DirRev);                    // rC
    SpVTable.Coil_Status[086].AssignMbInfo(access, Din_Cfg.Fct.GenFctAlrm.Logic);       // rIs
    SpVTable.Coil_Status[087].AssignMbInfo(access, En_SupervOnOff);                     // ONS
    SpVTable.Coil_Status[088].AssignMbInfo(access, ManContCycle_bySuperv);              // no Applica
    SpVTable.Coil_Status[089].AssignMbInfo(access, NetworkLight);                       //Before changing address search myCoilStatus[089]; Light setting from network // only protocol no to model or commissioning    
    
    SpVTable.Coil_Status[090].AssignMbInfo(access, dummy.bool);                         //GFA_We
    SpVTable.Coil_Status[091].AssignMbInfo(access, dummy.bool);                         //rOk
    
    SpVTable.Coil_Status[092].AssignMbInfo(access, ManLogic_Dout[1]);
    SpVTable.Coil_Status[093].AssignMbInfo(access, ManLogic_Dout[2]);
    SpVTable.Coil_Status[094].AssignMbInfo(access, ManLogic_Dout[3]);
    SpVTable.Coil_Status[095].AssignMbInfo(access, ManLogic_Dout[4]);
    SpVTable.Coil_Status[096].AssignMbInfo(access, ManVal_Dout[1]);
    SpVTable.Coil_Status[097].AssignMbInfo(access, ManVal_Dout[2]);
    SpVTable.Coil_Status[098].AssignMbInfo(access, ManVal_Dout[3]);
    SpVTable.Coil_Status[099].AssignMbInfo(access, ManVal_Dout[4]);
    
    
{ENDREGION}
    
{REGION INPUT REGISTER}
    SpVTable.Input_Register[000].AssignMbInfo(access, VirtualProbe, UOM_OF(VirtualProbe), UoM_hasChanged);
    SpVTable.Input_Register[001].AssignMbInfo(access, AnalogInputs.Fct.AirOff, UOM_OF(AnalogInputs.Fct.AirOff), UoM_hasChanged);
    SpVTable.Input_Register[002].AssignMbInfo(access, AnalogInputs.Fct.Defrost, UOM_OF(AnalogInputs.Fct.Defrost), UoM_hasChanged);
    SpVTable.Input_Register[003].AssignMbInfo(access, AnalogInputs.Fct.AirOn, UOM_OF(AnalogInputs.Fct.AirOn), UoM_hasChanged);
    SpVTable.Input_Register[004].AssignMbInfo(access, AnalogInputs.Fct.SuctT, UOM_OF(AnalogInputs.Fct.SuctT), UoM_hasChanged);
    SpVTable.Input_Register[005].AssignMbInfo(access, EvapSatTemp, UOM_OF(EvapSatTemp), UoM_hasChanged);
    SpVTable.Input_Register[006].AssignMbInfo(access, AnalogInputs.Fct.Defrost2, UOM_OF(AnalogInputs.Fct.Defrost2), UoM_hasChanged);
    SpVTable.Input_Register[007].AssignMbInfo(access, AnalogInputs.Fct.Auxiliary, UOM_OF(AnalogInputs.Fct.Auxiliary), UoM_hasChanged);
    SpVTable.Input_Register[008].AssignMbInfo(access, AnalogInputs.Fct.Auxiliary2, UOM_OF(AnalogInputs.Fct.Auxiliary2), UoM_hasChanged);
    SpVTable.Input_Register[009].AssignMbInfo(access, AnalogInputs.Fct.AmbientT, UOM_OF(AnalogInputs.Fct.AmbientT), UoM_hasChanged);
    SpVTable.Input_Register[010].AssignMbInfo(access, AnalogInputs.Fct.AmbientH, UOM_OF(AnalogInputs.Fct.AmbientH), UoM_hasChanged);
    SpVTable.Input_Register[011].AssignMbInfo(access, AnalogOutputs.Fct.Rails);
    SpVTable.Input_Register[012].AssignMbInfo(access, AnalogInputs.Fct.DewPoint, UOM_OF(AnalogInputs.Fct.DewPoint), UoM_hasChanged);
    SpVTable.Input_Register[013].AssignMbInfo(access, AnalogInputs.Fct.EvapP, UOM_OF(AnalogInputs.Fct.EvapP), UoM_hasChanged);
    SpVTable.Input_Register[014].AssignMbInfo(access, ActualSH, UOM_OF(ActualSH), UoM_hasChanged);
    SpVTable.Input_Register[015].AssignMbInfo(access, ExvVlvPosition);
    SpVTable.Input_Register[016].AssignMbInfo(access, BMS_SHSet, UOM_OF(BMS_SHSet), UoM_hasChanged);
    SpVTable.Input_Register[017].AssignMbInfo(access, DfrStatus); // Before to change this address search Slaves[i].myInputRegisters[017]
    SpVTable.Input_Register[018].AssignMbInfo(access, ActualTempSetpoint, UOM_OF(ActualTempSetpoint), UoM_hasChanged);
    SpVTable.Input_Register[019].AssignMbInfo(access, ActualTemp2Setpoint, UOM_OF(ActualTemp2Setpoint), UoM_hasChanged);
    SpVTable.Input_Register[020].AssignMbInfo(access, HACCP_CountHA);
    SpVTable.Input_Register[021].AssignMbInfo(access, HACCP_CountHF);
    SpVTable.Input_Register[022].AssignMbInfo(access, swVersion);
    SpVTable.Input_Register[023].AssignMbInfo(access, ActualShSetp);
    SpVTable.Input_Register[024].AssignMbInfo(access, AnalogInputs.Fct.GlassT, UOM_OF(AnalogInputs.Fct.GlassT), UoM_hasChanged);
    SpVTable.Input_Register[025].AssignMbInfo(access, SPV_CurrDay);
    SpVTable.Input_Register[026].AssignMbInfo(access, SPV_CurrMonth);
    SpVTable.Input_Register[027].AssignMbInfo(access, SPV_Curryear);
    SpVTable.Input_Register[028].AssignMbInfo(access, SPV_CurrHour);
    SpVTable.Input_Register[029].AssignMbInfo(access, SPV_CurrMin);
    SpVTable.Input_Register[030].AssignMbInfo(access, SPV_CurrDoW);
    SpVTable.Input_Register[031].AssignMbInfo(access, UniqueID_SPV[7]);//MSB
    SpVTable.Input_Register[032].AssignMbInfo(access, UniqueID_SPV[6]);
    SpVTable.Input_Register[033].AssignMbInfo(access, UniqueID_SPV[5]);
    SpVTable.Input_Register[034].AssignMbInfo(access, UniqueID_SPV[4]);
    SpVTable.Input_Register[035].AssignMbInfo(access, UniqueID_SPV[3]);
    SpVTable.Input_Register[036].AssignMbInfo(access, UniqueID_SPV[2]);
    SpVTable.Input_Register[037].AssignMbInfo(access, UniqueID_SPV[1]);
    SpVTable.Input_Register[038].AssignMbInfo(access, UniqueID_SPV[0]);//LSB
    SpVTable.Input_Register[039].AssignMbInfo(access, RestartsCounter);
    SpVTable.Input_Register[040].AssignMbInfo(access, UnitStatus);
                    // -- Variable for IoT Analisys ---
    SpVTable.Input_Register[041].AssignMbInfo(access, dummy.uint);
    SpVTable.Input_Register[042].AssignMbInfo(access, dummy.uint);
    SpVTable.Input_Register[043].AssignMbInfo(access, dummy.uint);
    SpVTable.Input_Register[044].AssignMbInfo(access, dummy.real);
    SpVTable.Input_Register[045].AssignMbInfo(access, dummy.real); 
    SpVTable.Input_Register[046].AssignMbInfo(access, dummy.int);
    SpVTable.Input_Register[047].AssignMbInfo(access, dummy.int);
    SpVTable.Input_Register[048].AssignMbInfo(access, dummy.int);
    SpVTable.Input_Register[049].AssignMbInfo(access, dummy.int);
    SpVTable.Input_Register[050].AssignMbInfo(access, dummy.int);
    SpVTable.Input_Register[051].AssignMbInfo(access, dummy.int);
    SpVTable.Input_Register[052].AssignMbInfo(access, dummy.int);

    
{ENDREGION}
    
{REGION HOLDIONG REGISTER}
    SpVTable.Holding_Register[000].AssignMbInfo(access, Ain_Types.Group2);
    SpVTable.Holding_Register[001].AssignMbInfo(access, Ain_Types.Group3);
    SpVTable.Holding_Register[002].AssignMbInfo(access, Ain_Types.Group4);      //Fix Probe Type =1 (default). Param not used 
    SpVTable.Holding_Register[003].AssignMbInfo(access, Ain_Cfg.Fct.AirOff.Ch); 
    SpVTable.Holding_Register[004].AssignMbInfo(access, Ain_Cfg.Fct.Defrost.ch);
    SpVTable.Holding_Register[005].AssignMbInfo(access, Ain_Cfg.Fct.AirOn.Ch);
    SpVTable.Holding_Register[006].AssignMbInfo(access, Ain_Cfg.Fct.SuctT.ch);
    SpVTable.Holding_Register[007].AssignMbInfo(access, Ain_Cfg.Fct.EvapP.ch);
    SpVTable.Holding_Register[008].AssignMbInfo(access, Ain_Cfg.Fct.Defrost2.ch);
    SpVTable.Holding_Register[009].AssignMbInfo(access, Ain_Cfg.Fct.Auxiliary.ch);
    SpVTable.Holding_Register[010].AssignMbInfo(access, Ain_Cfg.Fct.Auxiliary2.ch);
    SpVTable.Holding_Register[011].AssignMbInfo(access, Ain_Cfg.Fct.AmbientT.ch);
    SpVTable.Holding_Register[012].AssignMbInfo(access, Ain_Cfg.Fct.AmbientH.ch);
    SpVTable.Holding_Register[013].AssignMbInfo(access, Ain_Cfg.Fct.GlassT.ch);
    SpVTable.Holding_Register[014].AssignMbInfo(access, Ain_Cfg.Fct.DewPoint.ch);
    SpVTable.Holding_Register[015].AssignMbInfo(access, Ain_Offset.Fct.AirOff, UOM_OF(Ain_Offset.Fct.AirOff), UoM_hasChanged);
    SpVTable.Holding_Register[016].AssignMbInfo(access, Ain_Offset.Fct.Defrost, UOM_OF(Ain_Offset.Fct.Defrost), UoM_hasChanged);
    SpVTable.Holding_Register[017].AssignMbInfo(access, Ain_Offset.Fct.AirOn, UOM_OF(Ain_Offset.Fct.AirOn), UoM_hasChanged);
    SpVTable.Holding_Register[018].AssignMbInfo(access, Ain_Offset.Fct.SuctT, UOM_OF(Ain_Offset.Fct.SuctT), UoM_hasChanged);
    SpVTable.Holding_Register[019].AssignMbInfo(access, Ain_Offset.Fct.EvapP, UOM_OF(Ain_Offset.Fct.EvapP), UoM_hasChanged);
    SpVTable.Holding_Register[020].AssignMbInfo(access, Ain_Offset.Fct.Defrost2, UOM_OF(Ain_Offset.Fct.Defrost2), UoM_hasChanged);
    SpVTable.Holding_Register[021].AssignMbInfo(access, Ain_Offset.Fct.Auxiliary, UOM_OF(Ain_Offset.Fct.Auxiliary), UoM_hasChanged);
    SpVTable.Holding_Register[022].AssignMbInfo(access, Ain_Offset.Fct.Auxiliary2, UOM_OF(Ain_Offset.Fct.Auxiliary2), UoM_hasChanged);
    SpVTable.Holding_Register[023].AssignMbInfo(access, Ain_Offset.Fct.AmbientT, UOM_OF(Ain_Offset.Fct.AmbientT), UoM_hasChanged);
    SpVTable.Holding_Register[024].AssignMbInfo(access, Ain_Offset.Fct.AmbientH, UOM_OF(Ain_Offset.Fct.AmbientH), UoM_hasChanged);
    SpVTable.Holding_Register[025].AssignMbInfo(access, Ain_Offset.Fct.DewPoint, UOM_OF(Ain_Offset.Fct.DewPoint), UoM_hasChanged);
    SpVTable.Holding_Register[026].AssignMbInfo(access, EvapOffset, UOM_OF(EvapOffset), UoM_hasChanged);
    SpVTable.Holding_Register[027].AssignMbInfo(access, EvapMin, UOM_OF(EvapMin), UoM_hasChanged);
    SpVTable.Holding_Register[028].AssignMbInfo(access, EvapMax, UOM_OF(EvapMax), UoM_hasChanged);
    SpVTable.Holding_Register[029].AssignMbInfo(access, AmbHMin, UOM_OF(AmbHMin), UoM_hasChanged);
    SpVTable.Holding_Register[030].AssignMbInfo(access, AmbHMax, UOM_OF(AmbHMax), UoM_hasChanged);
    SpVTable.Holding_Register[031].AssignMbInfo(access, Din_Cfg.Arr[1].Ch);
    SpVTable.Holding_Register[032].AssignMbInfo(access, Din_Cfg.Arr[2].Ch);
    SpVTable.Holding_Register[033].AssignMbInfo(access, Din_Cfg.Arr[3].Ch);
    SpVTable.Holding_Register[034].AssignMbInfo(access, Din_Cfg.Arr[4].Ch);
    SpVTable.Holding_Register[035].AssignMbInfo(access, Din_Cfg.fct.DoorOff.Ch);
    SpVTable.Holding_Register[036].AssignMbInfo(access, Din_Cfg.Arr[6].Ch);
    SpVTable.Holding_Register[037].AssignMbInfo(access, Din_Cfg.Arr[7].Ch);
    SpVTable.Holding_Register[038].AssignMbInfo(access, Din_Cfg.Arr[8].Ch);
    SpVTable.Holding_Register[039].AssignMbInfo(access, Din_Cfg.Arr[9].Ch);
    SpVTable.Holding_Register[040].AssignMbInfo(access, Din_Cfg.Arr[10].Ch);
    SpVTable.Holding_Register[041].AssignMbInfo(access, Din_Cfg.Arr[11].Ch);
    SpVTable.Holding_Register[042].AssignMbInfo(access, Din_Cfg.Arr[12].Ch);
    SpVTable.Holding_Register[043].AssignMbInfo(access, Din_Cfg.Arr[13].Ch);
    SpVTable.Holding_Register[044].AssignMbInfo(access, Din_Cfg.fct.DoorOn.Ch);
    SpVTable.Holding_Register[045].AssignMbInfo(access, Din_Cfg.Arr[15].Ch);
    SpVTable.Holding_Register[046].AssignMbInfo(access, Dout_Cfg.Arr[1].Ch); 
    SpVTable.Holding_Register[047].AssignMbInfo(access, Dout_Cfg.Arr[2].Ch);
    SpVTable.Holding_Register[048].AssignMbInfo(access, Dout_Cfg.Arr[3].Ch);
    SpVTable.Holding_Register[049].AssignMbInfo(access, Dout_Cfg.Arr[4].Ch);
    SpVTable.Holding_Register[050].AssignMbInfo(access, Dout_Cfg.Fct.Light.Ch);
    SpVTable.Holding_Register[051].AssignMbInfo(access, Dout_Cfg.Arr[6].Ch);
    SpVTable.Holding_Register[052].AssignMbInfo(access, Dout_Cfg.Arr[7].Ch);
    SpVTable.Holding_Register[053].AssignMbInfo(access, Dout_Cfg.Arr[8].Ch);
    SpVTable.Holding_Register[054].AssignMbInfo(access, Dout_Cfg.Arr[9].Ch);
    SpVTable.Holding_Register[055].AssignMbInfo(access, Dout_Cfg.Arr[10].Ch);
    SpVTable.Holding_Register[056].AssignMbInfo(access, Dout_Cfg.Arr[11].Ch);
    SpVTable.Holding_Register[057].AssignMbInfo(access, Dout_Cfg.Arr[12].Ch);
    SpVTable.Holding_Register[058].AssignMbInfo(access, Dout_Cfg.Arr[13].Ch);
    SpVTable.Holding_Register[059].AssignMbInfo(access, Dout_Cfg.Arr[14].Ch);
    SpVTable.Holding_Register[060].AssignMbInfo(access, AOut_Cfg.Arr[1].Ch);
    SpVTable.Holding_Register[061].AssignMbInfo(access, AOut_Cfg.Arr[2].Ch);
    SpVTable.Holding_Register[062].AssignMbInfo(access, AOut_Cfg.Arr[3].Ch);
    SpVTable.Holding_Register[063].AssignMbInfo(access, AinStability);
    SpVTable.Holding_Register[064].AssignMbInfo(access, VirtualComposition);
    SpVTable.Holding_Register[065].AssignMbInfo(access, HmiMainSel);
    SpVTable.Holding_Register[066].AssignMbInfo(access, HmiRemSel);
    SpVTable.Holding_Register[067].AssignMbInfo(access, TempSetP, UOM_OF(TempSetP), UoM_hasChanged);
    SpVTable.Holding_Register[068].AssignMbInfo(access, TempSetP2, UOM_OF(TempSetP2), UoM_hasChanged);
    SpVTable.Holding_Register[069].AssignMbInfo(access, TempDiff, UOM_OF(TempDiff), UoM_hasChanged);
    SpVTable.Holding_Register[070].AssignMbInfo(access, TempDiff2, UOM_OF(TempDiff2), UoM_hasChanged);
    SpVTable.Holding_Register[071].AssignMbInfo(access, DoubleThermSafety);
    SpVTable.Holding_Register[072].AssignMbInfo(access, MinTempSet, UOM_OF(MinTempSet), UoM_hasChanged);
    SpVTable.Holding_Register[073].AssignMbInfo(access, MaxTempSet, UOM_OF(MaxTempSet), UoM_hasChanged);
    SpVTable.Holding_Register[074].AssignMbInfo(access, SetpNightOffset, UOM_OF(SetpNightOffset), UoM_hasChanged);
    SpVTable.Holding_Register[075].AssignMbInfo(access, PrbErrorOffset, UOM_OF(PrbErrorOffset), UoM_hasChanged);
    SpVTable.Holding_Register[076].AssignMbInfo(access, VlvCloseDelay);
    SpVTable.Holding_Register[077].AssignMbInfo(access, VlvMinRefrigCnt);
    SpVTable.Holding_Register[078].AssignMbInfo(access, CleanTout);
    SpVTable.Holding_Register[079].AssignMbInfo(access, StbyTout);
    SpVTable.Holding_Register[080].AssignMbInfo(access, DfrType);
    SpVTable.Holding_Register[081].AssignMbInfo(access, DfrInterval);
    SpVTable.Holding_Register[082].AssignMbInfo(access, DfrEndTemp, UOM_OF(DfrEndTemp), UoM_hasChanged);
    SpVTable.Holding_Register[083].AssignMbInfo(access, DfrEnd2Temp, UOM_OF(DfrEnd2Temp), UoM_hasChanged);
    SpVTable.Holding_Register[084].AssignMbInfo(access, DfrMaxDuration);
    SpVTable.Holding_Register[085].AssignMbInfo(access, DfrMaxDuration2);
    SpVTable.Holding_Register[086].AssignMbInfo(access, DfrPowOnDelay);
    SpVTable.Holding_Register[087].AssignMbInfo(access, HMIMainDef);
    SpVTable.Holding_Register[088].AssignMbInfo(access, DripTime);
    SpVTable.Holding_Register[089].AssignMbInfo(access, DfrHiBypass);
    SpVTable.Holding_Register[090].AssignMbInfo(access, DfrTimeRun);
    SpVTable.Holding_Register[091].AssignMbInfo(access, DfrTempRun);
    SpVTable.Holding_Register[092].AssignMbInfo(access, DfrPrbAlm);
    SpVTable.Holding_Register[093].AssignMbInfo(access, DfrOffTimeSeq);
    SpVTable.Holding_Register[094].AssignMbInfo(access, DfrOnTimeSeq);
    SpVTable.Holding_Register[095].AssignMbInfo(access, DfrPowTemp);
    SpVTable.Holding_Register[096].AssignMbInfo(access, DfrPowTime);
    SpVTable.Holding_Register[097].AssignMbInfo(access, DfrSkipDuration);
    SpVTable.Holding_Register[098].AssignMbInfo(access, DailyDfrNum);
    SpVTable.Holding_Register[099].AssignMbInfo(access, DailyDfrNum2);
    SpVTable.Holding_Register[100].AssignMbInfo(access, DfrPmpDwnDuration);
    SpVTable.Holding_Register[101].AssignMbInfo(access, GlassEstimComp);
    SpVTable.Holding_Register[102].AssignMbInfo(access, DfrVlvPos);
    SpVTable.Holding_Register[103].AssignMbInfo(access, VlvPressPrbTyp);
    SpVTable.Holding_Register[104].AssignMbInfo(access, CompFanDelay);
    SpVTable.Holding_Register[105].AssignMbInfo(access, MinOnOnSameT);
    SpVTable.Holding_Register[106].AssignMbInfo(access, MinOffT);
    SpVTable.Holding_Register[107].AssignMbInfo(access, MinOnT);
    SpVTable.Holding_Register[108].AssignMbInfo(access, DutySetOnTime);
    SpVTable.Holding_Register[109].AssignMbInfo(access, ContCycleTout);
    SpVTable.Holding_Register[110].AssignMbInfo(access, ContCycleLowBypass);
    SpVTable.Holding_Register[111].AssignMbInfo(access, AlarmPrbConf);
    SpVTable.Holding_Register[112].AssignMbInfo(access, Alarm2PrbConf);
    SpVTable.Holding_Register[113].AssignMbInfo(access, AlarmResetDiff);
    SpVTable.Holding_Register[114].AssignMbInfo(access, LowAlarmThr, UOM_OF(LowAlarmThr), UoM_hasChanged);
    SpVTable.Holding_Register[115].AssignMbInfo(access, HiAlarmThr, UOM_OF(HiAlarmThr), UoM_hasChanged);
    SpVTable.Holding_Register[116].AssignMbInfo(access, LowAlarm2Thr, UOM_OF(LowAlarm2Thr), UoM_hasChanged);
    SpVTable.Holding_Register[117].AssignMbInfo(access, HiAlarm2Thr, UOM_OF(HiAlarm2Thr), UoM_hasChanged);
    SpVTable.Holding_Register[118].AssignMbInfo(access, AlarmDelay);
    SpVTable.Holding_Register[119].AssignMbInfo(access, Alarm2Delay);
    SpVTable.Holding_Register[120].AssignMbInfo(access, VirtualDiOut);
    SpVTable.Holding_Register[121].AssignMbInfo(access, CmpAlConfig);    // A10             
    SpVTable.Holding_Register[122].AssignMbInfo(access, AlDinDelay);
    SpVTable.Holding_Register[123].AssignMbInfo(access, AlBypassDoor);
    SpVTable.Holding_Register[124].AssignMbInfo(access, FanMngConfig);
    SpVTable.Holding_Register[125].AssignMbInfo(access, FansSet, UOM_OF(FansSet), UoM_hasChanged);
    SpVTable.Holding_Register[126].AssignMbInfo(access, PostDripTime);
    SpVTable.Holding_Register[127].AssignMbInfo(access, FansDiff, UOM_OF(FansDiff), UoM_hasChanged);
    SpVTable.Holding_Register[128].AssignMbInfo(access, FansCutOff, UOM_OF(FansCutOff), UoM_hasChanged);
    SpVTable.Holding_Register[129].AssignMbInfo(access, FansMaxOut, UOM_OF(FansMaxOut), UoM_hasChanged);
    SpVTable.Holding_Register[130].AssignMbInfo(access, FansMinOut, UOM_OF(FansMinOut), UoM_hasChanged);
    SpVTable.Holding_Register[131].AssignMbInfo(access, FansRegCnf[1]);
    SpVTable.Holding_Register[132].AssignMbInfo(access, FansRegCnf[2]);
    SpVTable.Holding_Register[133].AssignMbInfo(access, ValveCnf);
    SpVTable.Holding_Register[134].AssignMbInfo(access, SHSetp, UOM_OF(SHSetp), UoM_hasChanged);
    SpVTable.Holding_Register[135].AssignMbInfo(access, ExvKp);
    SpVTable.Holding_Register[136].AssignMbInfo(access, ExvTi);
    SpVTable.Holding_Register[137].AssignMbInfo(access, ExvTd);
    SpVTable.Holding_Register[138].AssignMbInfo(access, LowSH_Thrsh, UOM_OF(LowSH_Thrsh), UoM_hasChanged);
    SpVTable.Holding_Register[139].AssignMbInfo(access, LowSH_Ti);
    SpVTable.Holding_Register[140].AssignMbInfo(access, LowSH_AlrmDelay);
    SpVTable.Holding_Register[141].AssignMbInfo(access, LowSuctThrsh, UOM_OF(LowSuctThrsh), UoM_hasChanged);
    SpVTable.Holding_Register[142].AssignMbInfo(access, LowSuctAlrmDelay);
    SpVTable.Holding_Register[143].AssignMbInfo(access, ExvSatTempBackup, UOM_OF(ExvSatTempBackup), UoM_hasChanged);
    SpVTable.Holding_Register[144].AssignMbInfo(access, RfrgTyp);
    SpVTable.Holding_Register[145].AssignMbInfo(access, Ain_Offset.Fct.GlassT, UOM_OF(Ain_Offset.Fct.GlassT), UoM_hasChanged);
    SpVTable.Holding_Register[146].AssignMbInfo(access, MOP_Thrsh, UOM_OF(MOP_Thrsh), UoM_hasChanged);
    SpVTable.Holding_Register[147].AssignMbInfo(access, MOP_Ti);
    SpVTable.Holding_Register[148].AssignMbInfo(access, MOP_AlrmDelay);
    SpVTable.Holding_Register[149].AssignMbInfo(access, MOP_StartDelay);
    SpVTable.Holding_Register[150].AssignMbInfo(access, MOP_SuctTempThrsh, UOM_OF(MOP_SuctTempThrsh), UoM_hasChanged);
    SpVTable.Holding_Register[151].AssignMbInfo(access, LOP_Thrsh, UOM_OF(LOP_Thrsh), UoM_hasChanged);
    SpVTable.Holding_Register[152].AssignMbInfo(access, LOP_Ti);
    SpVTable.Holding_Register[153].AssignMbInfo(access, LOP_AlrmDelay);
    SpVTable.Holding_Register[154].AssignMbInfo(access, StartEEVOpenRatio);
    SpVTable.Holding_Register[155].AssignMbInfo(access, PosManExv);
    SpVTable.Holding_Register[156].AssignMbInfo(access, SmLineTempOffset, UOM_OF(SmLineTempOffset), UoM_hasChanged);
    SpVTable.Holding_Register[157].AssignMbInfo(access, SmLineSHOffset, UOM_OF(SmLineSHOffset), UoM_hasChanged);
    SpVTable.Holding_Register[158].AssignMbInfo(access, SmLineTd);
    SpVTable.Holding_Register[159].AssignMbInfo(access, SmLineTi);
    SpVTable.Holding_Register[160].AssignMbInfo(access, SmLineKp);
    SpVTable.Holding_Register[161].AssignMbInfo(access, SlavesNum);
    SpVTable.Holding_Register[162].AssignMbInfo(access, BMS_Addr);
    SpVTable.Holding_Register[163].AssignMbInfo(access, BMS_Conf);
    SpVTable.Holding_Register[164].AssignMbInfo(access, BMS_Baud);
    SpVTable.Holding_Register[165].AssignMbInfo(access, FB_Baud);
    SpVTable.Holding_Register[166].AssignMbInfo(access, FansPeekTime); // FB conf
    SpVTable.Holding_Register[167].AssignMbInfo(access, dummy.sint); // FB conf
    SpVTable.Holding_Register[168].AssignMbInfo(access, ManHeaterPerc);
    SpVTable.Holding_Register[169].AssignMbInfo(access, ManHeaterPeriod);
    SpVTable.Holding_Register[170].AssignMbInfo(access, HeaterOffs, UOM_OF(HeaterOffs), UoM_hasChanged);
    SpVTable.Holding_Register[171].AssignMbInfo(access, HeatersDiff, UOM_OF(HeatersDiff), UoM_hasChanged);
    SpVTable.Holding_Register[172].AssignMbInfo(access, TimerDelay);
    SpVTable.Holding_Register[173].AssignMbInfo(access, FansSpeedupTime); 
    SpVTable.Holding_Register[174].AssignMbInfo(access, LightOnDoorDelay);
    SpVTable.Holding_Register[175].AssignMbInfo(access, CoolingCapacity); //POM
    SpVTable.Holding_Register[176].AssignMbInfo(access, GlassTEstimateA, UOM_OF(GlassTEstimateA), UoM_hasChanged);
    SpVTable.Holding_Register[177].AssignMbInfo(access, GlassTEstimateB);
    SpVTable.Holding_Register[178].AssignMbInfo(access, Dout_Cfg.Arr[15].Ch);
    SpVTable.Holding_Register[179].AssignMbInfo(access, dummy.usint);
    SpVTable.Holding_Register[180].AssignMbInfo(access, HACCP_AlrmDelay);
    SpVTable.Holding_Register[181].AssignMbInfo(access, ExvDelayDfr);
    SpVTable.Holding_Register[182].AssignMbInfo(access, DfrStart[1].Day);
    SpVTable.Holding_Register[183].AssignMbInfo(access, DfrStart[1].Hour);
    SpVTable.Holding_Register[184].AssignMbInfo(access, DfrStart[1].Minute);
    SpVTable.Holding_Register[185].AssignMbInfo(access, DfrStart[2].Day);
    SpVTable.Holding_Register[186].AssignMbInfo(access, DfrStart[2].Hour);
    SpVTable.Holding_Register[187].AssignMbInfo(access, DfrStart[2].Minute);
    SpVTable.Holding_Register[188].AssignMbInfo(access, DfrStart[3].Day);
    SpVTable.Holding_Register[189].AssignMbInfo(access, DfrStart[3].Hour);
    SpVTable.Holding_Register[190].AssignMbInfo(access, DfrStart[3].Minute);
    SpVTable.Holding_Register[191].AssignMbInfo(access, DfrStart[4].Day);
    SpVTable.Holding_Register[192].AssignMbInfo(access, DfrStart[4].Hour);
    SpVTable.Holding_Register[193].AssignMbInfo(access, DfrStart[4].Minute);
    SpVTable.Holding_Register[194].AssignMbInfo(access, DfrStart[5].Day);
    SpVTable.Holding_Register[195].AssignMbInfo(access, DfrStart[5].Hour);
    SpVTable.Holding_Register[196].AssignMbInfo(access, DfrStart[5].Minute);
    SpVTable.Holding_Register[197].AssignMbInfo(access, DfrStart[6].Day);
    SpVTable.Holding_Register[198].AssignMbInfo(access, DfrStart[6].Hour);
    SpVTable.Holding_Register[199].AssignMbInfo(access, DfrStart[6].Minute);
    SpVTable.Holding_Register[200].AssignMbInfo(access, DfrStart[7].Day);
    SpVTable.Holding_Register[201].AssignMbInfo(access, DfrStart[7].Hour);
    SpVTable.Holding_Register[202].AssignMbInfo(access, DfrStart[7].Minute);
    SpVTable.Holding_Register[203].AssignMbInfo(access, DfrStart[8].Day);
    SpVTable.Holding_Register[204].AssignMbInfo(access, DfrStart[8].Hour);
    SpVTable.Holding_Register[205].AssignMbInfo(access, DfrStart[8].Minute);
    SpVTable.Holding_Register[206].AssignMbInfo(access, SPV_Day);
    SpVTable.Holding_Register[207].AssignMbInfo(access, SPV_Month);
    SpVTable.Holding_Register[208].AssignMbInfo(access, SPV_Year);
    SpVTable.Holding_Register[209].AssignMbInfo(access, SPV_Hour);
    SpVTable.Holding_Register[210].AssignMbInfo(access, SPV_Min);
    SpVTable.Holding_Register[211].AssignMbInfo(access, SPV_DoW);
    SpVTable.Holding_Register[212].AssignMbInfo(access, DfrMstStatus);          // Before to change this address search Slaves[i].myHoldingRegisters[212]
    SpVTable.Holding_Register[213].AssignMbInfo(access, MstEvapSatTemp, UOM_OF(MstEvapSatTemp), UoM_hasChanged);   // Before to change this address search Slaves[i].myInputRegisters[213]
    SpVTable.Holding_Register[214].AssignMbInfo(access, MstEvapP, UOM_OF(MstEvapP), UoM_hasChanged);               // Before to change this address search Slaves[i].myInputRegisters[214]
    SpVTable.Holding_Register[215].AssignMbInfo(access, MstAmbientH, UOM_OF(MstAmbientH), UoM_hasChanged);         // Before to change this address search Slaves[i].myInputRegisters[215]
    SpVTable.Holding_Register[216].AssignMbInfo(access, MstAmbientT, UOM_OF(MstAmbientT), UoM_hasChanged);         // Before to change this address search Slaves[i].myInputRegisters[216]
    SpVTable.Holding_Register[217].AssignMbInfo(access, MstDewPoint, UOM_OF(MstDewPoint), UoM_hasChanged);         // Before to change this address search Slaves[i].myInputRegisters[217]
    SpVTable.Holding_Register[218].AssignMbInfo(access, EVD_Digin1Cfg); //FREE
    SpVTable.Holding_Register[219].AssignMbInfo(access, CustomGasCoeff.GasId);
    SpVTable.Holding_Register[220].AssignMbInfo(access, CustomGasCoeff.GasCoeff[0]);
    SpVTable.Holding_Register[221].AssignMbInfo(access, CustomGasCoeff.GasCoeff[1]);
    SpVTable.Holding_Register[222].AssignMbInfo(access, CustomGasCoeff.GasCoeff[2]);
    SpVTable.Holding_Register[223].AssignMbInfo(access, CustomGasCoeff.GasCoeff[3]);
    SpVTable.Holding_Register[224].AssignMbInfo(access, CustomGasCoeff.GasCoeff[4]);
    SpVTable.Holding_Register[225].AssignMbInfo(access, CustomGasCoeff.GasCoeff[5]);
    SpVTable.Holding_Register[226].AssignMbInfo(access, CustomGasCoeff.GasCoeff[6]);
    SpVTable.Holding_Register[227].AssignMbInfo(access, CustomGasCoeff.GasCoeff[7]);
    SpVTable.Holding_Register[228].AssignMbInfo(access, CustomGasCoeff.GasCoeff[8]);
    SpVTable.Holding_Register[229].AssignMbInfo(access, CustomGasCoeff.GasCoeff[9]);
    SpVTable.Holding_Register[230].AssignMbInfo(access, CustomGasCoeff.GasCoeff[10]);
    SpVTable.Holding_Register[231].AssignMbInfo(access, CustomGasCoeff.GasCoeff[11]);
    SpVTable.Holding_Register[232].AssignMbInfo(access, CustomGasCoeff.CRC);
    SpVTable.Holding_Register[233].AssignMbInfo(access, TimeBandStart[1].Day);
    SpVTable.Holding_Register[234].AssignMbInfo(access, TimeBandStart[1].Hour);
    SpVTable.Holding_Register[235].AssignMbInfo(access, TimeBandStart[1].Minute);
    SpVTable.Holding_Register[236].AssignMbInfo(access, TimeBandEnd[1].Day);
    SpVTable.Holding_Register[237].AssignMbInfo(access, TimeBandEnd[1].Hour);
    SpVTable.Holding_Register[238].AssignMbInfo(access, TimeBandEnd[1].Minute);
    SpVTable.Holding_Register[239].AssignMbInfo(access, MstRegTemp);                // Before to change this address search Slaves[i].myHoldingRegisters[239]
    SpVTable.Holding_Register[240].AssignMbInfo(access, SerialInputs[1].r);
    SpVTable.Holding_Register[241].AssignMbInfo(access, SerialInputs[2].r);
    SpVTable.Holding_Register[242].AssignMbInfo(access, SerialInputs[3].r);
    SpVTable.Holding_Register[243].AssignMbInfo(access, SerialInputs[4].r);
    SpVTable.Holding_Register[244].AssignMbInfo(access, TimeBandStart[2].Day);
    SpVTable.Holding_Register[245].AssignMbInfo(access, TimeBandStart[2].Hour);
    SpVTable.Holding_Register[246].AssignMbInfo(access, TimeBandStart[2].Minute);
    SpVTable.Holding_Register[247].AssignMbInfo(access, TimeBandEnd[2].Day);         //(CAR ADDR 206 )
                        // ---------------------------------------------------------- END OF CAREL ADDRESS
    SpVTable.Holding_Register[248].AssignMbInfo(access, TimeBandEnd[2].Hour);
    SpVTable.Holding_Register[249].AssignMbInfo(access, TimeBandEnd[2].Minute);
    SpVTable.Holding_Register[250].AssignMbInfo(access, TimeBandStart[3].Day);
    SpVTable.Holding_Register[251].AssignMbInfo(access, TimeBandStart[3].Hour);
    SpVTable.Holding_Register[252].AssignMbInfo(access, TimeBandStart[3].Minute);
    SpVTable.Holding_Register[253].AssignMbInfo(access, TimeBandEnd[3].Day);
    SpVTable.Holding_Register[254].AssignMbInfo(access, TimeBandEnd[3].Hour);
    SpVTable.Holding_Register[255].AssignMbInfo(access, TimeBandEnd[3].Minute);
    SpVTable.Holding_Register[256].AssignMbInfo(access, TimeBandStart[4].Day);
    SpVTable.Holding_Register[257].AssignMbInfo(access, TimeBandStart[4].Hour);
    SpVTable.Holding_Register[258].AssignMbInfo(access, TimeBandStart[4].Minute);
    SpVTable.Holding_Register[259].AssignMbInfo(access, TimeBandEnd[4].Day);
    SpVTable.Holding_Register[260].AssignMbInfo(access, TimeBandEnd[4].Hour);
    SpVTable.Holding_Register[261].AssignMbInfo(access, TimeBandEnd[4].Minute);
    SpVTable.Holding_Register[262].AssignMbInfo(access, TimeBandStart[5].Day);
    SpVTable.Holding_Register[263].AssignMbInfo(access, TimeBandStart[5].Hour);
    SpVTable.Holding_Register[264].AssignMbInfo(access, TimeBandStart[5].Minute);
    SpVTable.Holding_Register[265].AssignMbInfo(access, TimeBandEnd[5].Day);
    SpVTable.Holding_Register[266].AssignMbInfo(access, TimeBandEnd[5].Hour);
    SpVTable.Holding_Register[267].AssignMbInfo(access, TimeBandEnd[5].Minute);
    SpVTable.Holding_Register[268].AssignMbInfo(access, TimeBandStart[6].Day);
    SpVTable.Holding_Register[269].AssignMbInfo(access, TimeBandStart[6].Hour);
    SpVTable.Holding_Register[270].AssignMbInfo(access, TimeBandStart[6].Minute);
    SpVTable.Holding_Register[271].AssignMbInfo(access, TimeBandEnd[6].Day);
    SpVTable.Holding_Register[272].AssignMbInfo(access, TimeBandEnd[6].Hour);
    SpVTable.Holding_Register[273].AssignMbInfo(access, TimeBandEnd[6].Minute);
    SpVTable.Holding_Register[274].AssignMbInfo(access, TimeBandStart[7].Day);
    SpVTable.Holding_Register[275].AssignMbInfo(access, TimeBandStart[7].Hour);
    SpVTable.Holding_Register[276].AssignMbInfo(access, TimeBandStart[7].Minute);
    SpVTable.Holding_Register[277].AssignMbInfo(access, TimeBandEnd[7].Day);
    SpVTable.Holding_Register[278].AssignMbInfo(access, TimeBandEnd[7].Hour);
    SpVTable.Holding_Register[279].AssignMbInfo(access, TimeBandEnd[7].Minute);
    SpVTable.Holding_Register[280].AssignMbInfo(access, TimeBandStart[8].Day);
    SpVTable.Holding_Register[281].AssignMbInfo(access, TimeBandStart[8].Hour);
    SpVTable.Holding_Register[282].AssignMbInfo(access, TimeBandStart[8].Minute);
    SpVTable.Holding_Register[283].AssignMbInfo(access, TimeBandEnd[8].Day);
    SpVTable.Holding_Register[284].AssignMbInfo(access, TimeBandEnd[8].Hour);
    SpVTable.Holding_Register[285].AssignMbInfo(access, TimeBandEnd[8].Minute);
    SpVTable.Holding_Register[286].AssignMbInfo(access, SmLineSH_AvgT);
    SpVTable.Holding_Register[287].AssignMbInfo(access, SmLine_SH_thrsh);
    SpVTable.Holding_Register[288].AssignMbInfo(access, GenFctStages_Cfg[1].SetP);
    SpVTable.Holding_Register[289].AssignMbInfo(access, GenFctStages_Cfg[1].Diff);
    SpVTable.Holding_Register[290].AssignMbInfo(access, GenFctStages_Cfg[1].RegVar_1);
    SpVTable.Holding_Register[291].AssignMbInfo(access, GenFctStages_Cfg[1].RegVar_2);
    SpVTable.Holding_Register[292].AssignMbInfo(access, GenFctStages_EnableOn[1]);
    SpVTable.Holding_Register[293].AssignMbInfo(access, GenFctModul_Cfg[1].SetP);
    SpVTable.Holding_Register[294].AssignMbInfo(access, GenFctModul_Cfg[1].Diff);
    SpVTable.Holding_Register[295].AssignMbInfo(access, GenFctModul_Cfg[1].CutOffDiff);
    SpVTable.Holding_Register[296].AssignMbInfo(access, GenFctModul_Cfg[1].HystDiff);
    SpVTable.Holding_Register[297].AssignMbInfo(access, GenFctModul_Cfg[1].MaxOut);
    SpVTable.Holding_Register[298].AssignMbInfo(access, GenFctModul_Cfg[1].MinOut);
    SpVTable.Holding_Register[299].AssignMbInfo(access, GenFctModul_Cfg[1].PID_Cfg.kp);   
    SpVTable.Holding_Register[300].AssignMbInfo(access, GenFctModul_Cfg[1].PID_Cfg.Ti);
    SpVTable.Holding_Register[301].AssignMbInfo(access, GenFctModul_Cfg[1].PID_Cfg.Td);
    SpVTable.Holding_Register[302].AssignMbInfo(access, GenFctModul_Cfg[1].RegVar_1);
    SpVTable.Holding_Register[303].AssignMbInfo(access, GenFctModul_Cfg[1].RegVar_2);
    SpVTable.Holding_Register[304].AssignMbInfo(access, GenFctModul_EnableOn[1]);
    SpVTable.Holding_Register[305].AssignMbInfo(access, GenFctAlarm_Cfg[1].Delay);
    SpVTable.Holding_Register[306].AssignMbInfo(access, GenFctAlarm_Cfg[1].HighThr);
    SpVTable.Holding_Register[307].AssignMbInfo(access, GenFctAlarm_Cfg[1].LowThr);
    SpVTable.Holding_Register[308].AssignMbInfo(access, GenFctAlarm_Cfg[1].Diff);
    SpVTable.Holding_Register[309].AssignMbInfo(access, GenFctAlarm_Cfg[1].RegVar_1); 
    SpVTable.Holding_Register[310].AssignMbInfo(access, GenFctAlarm_Cfg[1].RegVar_2);
    SpVTable.Holding_Register[311].AssignMbInfo(access, GenFctAlarm_EnableOn[1]);
    SpVTable.Holding_Register[312].AssignMbInfo(access, Din_Cfg.Arr[16].Ch); 
    SpVTable.Holding_Register[313].AssignMbInfo(access, DfrStartByDeltaT);
    SpVTable.Holding_Register[314].AssignMbInfo(access, DfrStartByDeltaThrsh);
    SpVTable.Holding_Register[315].AssignMbInfo(access, DfrStartByDeltaPrb1);
    SpVTable.Holding_Register[316].AssignMbInfo(access, DfrStartByDeltaPrb2);    
    SpVTable.Holding_Register[317].AssignMbInfo(access, Ain_Types.Group1);
    SpVTable.Holding_Register[318].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[319].AssignMbInfo(access, dummy.real);
    SpVTable.Holding_Register[320].AssignMbInfo(access, Ain_Types.Group5);      //Only advanced - keep for advanced Model compatibility
    SpVTable.Holding_Register[321].AssignMbInfo(access, dummy.uint);    //GFA_AA
    SpVTable.Holding_Register[322].AssignMbInfo(access, dummy.uint);    //GFA_n
    SpVTable.Holding_Register[323].AssignMbInfo(access, dummy.uint);    //GFA_P
    SpVTable.Holding_Register[324].AssignMbInfo(access, dummy.int);     //GFA_r
    SpVTable.Holding_Register[325].AssignMbInfo(access, dummy.int);     //GFA_WA
    SpVTable.Holding_Register[326].AssignMbInfo(access, dummy.real);    //GFA_WD
    SpVTable.Holding_Register[327].AssignMbInfo(access, dummy.int);     //GFA_WDe
    SpVTable.Holding_Register[328].AssignMbInfo(access, dummy.real);    //GFA_WHth
    SpVTable.Holding_Register[329].AssignMbInfo(access, dummy.real);    //GFA_WLth
    SpVTable.Holding_Register[330].AssignMbInfo(access, LowAlarmThrAbs, UOM_OF(LowAlarmThrAbs), UoM_hasChanged);      //ALA
    SpVTable.Holding_Register[331].AssignMbInfo(access, HiAlarmThrAbs, UOM_OF(HiAlarmThrAbs), UoM_hasChanged);        //AHA
    SpVTable.Holding_Register[332].AssignMbInfo(access, LowAlarm2ThrAbs, UOM_OF(LowAlarm2ThrAbs), UoM_hasChanged);    //ALA2
    SpVTable.Holding_Register[333].AssignMbInfo(access, HiAlarm2ThrAbs, UOM_OF(HiAlarm2ThrAbs), UoM_hasChanged);      //AHA2 
    SpVTable.Holding_Register[334].AssignMbInfo(access, dummy.usint);   //c11
    SpVTable.Holding_Register[335].AssignMbInfo(access, dummy.usint);   //c12
    SpVTable.Holding_Register[336].AssignMbInfo(access, dummy.sint);    //DOk

    SpVTable.Holding_Register[337].AssignMbInfo(access, pwd_EOL_Test[1]);
    SpVTable.Holding_Register[338].AssignMbInfo(access, pwd_EOL_Test[2]);
    SpVTable.Holding_Register[339].AssignMbInfo(access, pwd_EOL_Test[3]);
    SpVTable.Holding_Register[340].AssignMbInfo(access, EOL_Test_Time);
    SpVTable.Holding_Register[341].AssignMbInfo(access, ManType_Aout);
    SpVTable.Holding_Register[342].AssignMbInfo(access, ManVal_Aout[1]);
    SpVTable.Holding_Register[343].AssignMbInfo(access, ManVal_Aout[2]);

    
{ENDREGION}
    
END_FUNCTION
