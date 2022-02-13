VAR_GLOBAL PERSISTENT
    {LOCATION En_GlobalSwitch_Override}
	(**EnableGlobal switch for output override : 0 = Carel mode; 1 = HPX mode*)
	En_GlobalSwitch_Override : BOOL := FALSE;    
	{LOCATION AbsAlarm2Thr}
	(**Alarm thresholds (AL2, AH2) relative to the set point St2 or absolute: 0 = relative; 1 = absolute*)
	AbsAlarm2Thr : BOOL := FALSE;
	{LOCATION AbsAlarmThr}
	(**Alarm thresholds (AL, AH) relative to the set point St or absolute: 0 = relative; 1 = absolute*)
	AbsAlarmThr : BOOL := FALSE;
	{LOCATION Ain_Cfg}
	Ain_Cfg : AinCfgUnion;
	{LOCATION Ain_Offset}
	(**Value offset for probe reading*)
	Ain_Offset : AinOffsetUnion;
	{LOCATION Ain_Types}
	(**Probe type configuration for phisical channel 1 - 3*)
	{METADATA LIBRARY Libs.LibMpx}
	Ain_Types : AinType;
	{LOCATION AinStability}
	(**Analogue probe measurement stability*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 15}
	AinStability : USINT := 9;
	{LOCATION Alarm2Delay}
	(**Delay time for high and low temperature alarms (AH2, AL2)*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 240}
	Alarm2Delay : USINT := 30;
	{LOCATION Alarm2PrbConf}
	(**Assign probe for high (AH2) and low (AL2) temperature alarms*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 14}
	Alarm2PrbConf : USINT := 1;
	{LOCATION AlarmDelay}
	(**Delay time for high and low temperature alarms (AH, AL)*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	AlarmDelay : USINT := 120;
	{LOCATION AlarmPrbConf}
	(**Assign probe for high (AH) and low (AL) temperature alarms*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 14}
	AlarmPrbConf : USINT := 1;
	{LOCATION AlarmResetDiff}
	(**High and low temperature alarm reset differential*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0.1}
	{METADATA MAX_VAL 20}
	AlarmResetDiff : REAL := 2;
	{LOCATION AlBypassDoor}
	(**High temperature alarm bypass time for door open*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 240}
	AlBypassDoor : USINT := 30;
	{LOCATION AlDinDelay}
	(**Delay time for delayed external alarm*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	AlDinDelay : USINT := 0;
	{LOCATION AmbHMax}
	(**Maximum value for ambient humidity active robe*)
	{ATTRIBUTE UOM PERCENT_rH}
	{METADATA MIN_VAL AmbHMin}
	{METADATA MAX_VAL 100}
	AmbHMax : REAL := 100;
	{LOCATION AmbHMin}
	(**Minimum value for ambient humidity active robe*)
	{ATTRIBUTE UOM PERCENT_rH}
	{METADATA MIN_VAL 10.0}
	{METADATA MAX_VAL AmbHMax}
	AmbHMin : REAL := 10;
	{LOCATION AOut_Cfg}
	AOut_Cfg : AOutCfgUnion;
	{LOCATION BakSerialInputs}
	(**EEPROM value saved for serial probe*)
	BakSerialInputs : ARRAY[1..4] OF System.IO.uChannel;
	{LOCATION BMS_Addr}
	(**BMS address*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 247}
	BMS_Addr : USINT := 199;
	{LOCATION BMS_Baud}
	(**BMS baudrate*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 8}
	BMS_Baud : USINT := 4;
	{LOCATION BMS_Conf}
	(**BMS configuration (Stopbit and parity)*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 5}
	BMS_Conf : USINT := 1;
	{LOCATION BMS_Prot}
	(**BMS serial protocol is Carel (FALSE) or Modbus (TRUE)*)
	BMS_Prot : BOOL := TRUE;
	{LOCATION CleanTout}
	(**Maximum time for Clean status*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	CleanTout : UINT := 0;
	{LOCATION CmpAlConfig}
	(**Configure solenoid/compressor control during external alarm (immediate or delayed) with fixed 15 min OFF time*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	CmpAlConfig : USINT := 0;
	{LOCATION CompFanDelay}
	(**Delay enable compressor and evaporator fans on power-up*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	CompFanDelay : USINT := 0;
	{LOCATION ContCycleLowBypass}
	(**Low temperature alarm bypass time after continuous cycle*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	ContCycleLowBypass : USINT := 60;
	{LOCATION ContCycleTout}
	(**Running time in continuous cycle*)
	{ATTRIBUTE UOM HOUR}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 15}
	ContCycleTout : USINT := 0;
	{LOCATION CoolingCapacity}
	(**Unit cooling capacity indication*)
	{ATTRIBUTE UOM WATT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 32000}
	CoolingCapacity : UINT := 4000;
	{LOCATION CustomGasCoeff}
	(**Custom gas coefficents*)
	{METADATA LIBRARY Libs.CustomGas}
	CustomGasCoeff : Libs.CustomGas.RetCustGas;
	{LOCATION DailyDfrNum}
	(**Number of daily defrost from time band 1*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 14}
	DailyDfrNum : USINT := 0;
	{LOCATION DailyDfrNum2}
	(**Number of daily defrost from time band 2*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 14}
	DailyDfrNum2 : USINT := 0;
	{LOCATION DayNightOutput}
	(**Output switched with time bands 0 = Light; 1 = AUX*)
	DayNightOutput : BOOL := FALSE;
	{LOCATION DfrEnd2Temp}
	(**End defrost temperature read by Sd2*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	DfrEnd2Temp : REAL := 8;
	{LOCATION DfrEndAlTimeout}
	(**End defrost signal by timeout: 0 = disabled, 1 = enabled*)
	DfrEndAlTimeout : BOOL := FALSE;
	{LOCATION DfrEndTemp}
	(**End defrost temperature read by Sd*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	DfrEndTemp : REAL := 8;
	{LOCATION DfrFanCfg}
	(**Evaporators fan during defrost*)
	DfrFanCfg : BOOL := TRUE;
	{LOCATION DfrHiBypass}
	(**Bypass high temperature alarm time after defrost*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 240}
	DfrHiBypass : USINT := 30;
	{LOCATION DfrHotGasSafety}
	(**Safety procedure for hot gas defrost on offline Secondary*)
	DfrHotGasSafety : BOOL := FALSE;
	{LOCATION DfrInterval}
	(**Maximum interval between consecutive defrost*)
	{ATTRIBUTE UOM HOUR}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	DfrInterval : USINT := 8;
	{LOCATION DfrMasterEndSync}
	(**End defrost synchronized by Main*)
	DfrMasterEndSync : BOOL := TRUE;
	{LOCATION DfrMaxDuration}
	(**Maximum defrost duration*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 240}
	DfrMaxDuration : USINT := 45;
	{LOCATION DfrMaxDuration2}
	(**Maximum defrost duration on auxiliary evaporator*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 240}
	DfrMaxDuration2 : USINT := 45;
	{LOCATION DfrOffTimeSeq}
	(**Compressor off time in "Sequential stop" defrost mode*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 45}
	DfrOffTimeSeq : USINT := 0;
	{LOCATION DfrOnTimeSeq}
	(**Compressor operating time in "Sequential stop" defrost mode*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	DfrOnTimeSeq : USINT := 120;
	{LOCATION DfrPDFanCfg}
	(**Evaporators fans during post-dripping*)
	DfrPDFanCfg : BOOL := TRUE;
	{LOCATION DfrPmpDwnDuration}
	(**Pump down phase duration: 0 = Pum down disabled*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	DfrPmpDwnDuration : UINT := 0;
	{LOCATION DfrPowOnDelay}
	(**Defrost delay on power-up or (for Secondary) after control from Main*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	DfrPowOnDelay : USINT := 0;
	{LOCATION DfrPowTemp}
	(**Additional end defrost temperature delta in "Power defrost" mode*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL -20}
	{METADATA MAX_VAL 20}
	DfrPowTemp : REAL := 0;
	{LOCATION DfrPowTime}
	(**Additional maximum defrost time delta in "Power defrost" mode*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 60}
	DfrPowTime : USINT := 0;
	{LOCATION DfrPrbAlm}
	(**Pressure probe alarm management during defrost*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 3}
	DfrPrbAlm : USINT := 0;
	{LOCATION DfrPriorityCont}
	(**Defrost priority over continuous cycle 0 = no, 1= yes*)
	DfrPriorityCont : BOOL;
	{LOCATION DfrSafetyTime}
	(**Defrost priority over compressor protection times*)
	DfrSafetyTime : BOOL := TRUE;
	{LOCATION DfrSkipDuration}
	(**Nominal "Skip defrost" duration*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	DfrSkipDuration : USINT := 75;
	{LOCATION DfrSkipEn}
	(**Skip defrost: 0 = disabled; 1 = enabled;*)
	DfrSkipEn : BOOL := FALSE;
	{LOCATION DfrStart}
	(**Defrost scheduler time start*)
	DfrStart : ARRAY[1..8] OF TimeBand;
	{LOCATION DfrStartByDeltaPrb1}
	(**Defrost start by delta first probe
	 *0 : Not configured
	 *1 : Air off (Sm) 
	 *2 : Defrost (Sd) 
	 *3 : Air on (Sr) 
	 *4 : Auxiliary defrost (Sd2) 
	 *5 : Auxiliary 1 (Saux1) 
	 *6 : Auxiliary 2 (Saux2) 
	 *7 : Ambient temp (SA) 
	 *8 : Ambient humidity (SU) 
	 *9: Glass temperature (Svt) 
	 *10 : Dewpoint (SdP) 
	 *11 : Virtual probe (Sv) *)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 11}
	DfrStartByDeltaPrb1 : USINT := 11;
	{LOCATION DfrStartByDeltaPrb2}
	(**Defrost start by delta second probe
	 *0 : Not configured
	 *1 : Air off (Sm) 
	 *2 : Defrost (Sd) 
	 *3 : Air on (Sr) 
	 *4 : Auxiliary defrost (Sd2) 
	 *5 : Auxiliary 1 (Saux1) 
	 *6 : Auxiliary 2 (Saux2) 
	 *7 : Ambient temp (SA) 
	 *8 : Ambient humidity (SU) 
	 *9: Glass temperature (Svt) 
	 *10 : Dewpoint (SdP) 
	 *11 : Virtual probe (Sv) *)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 11}
	DfrStartByDeltaPrb2 : USINT := 11;
	{LOCATION DfrStartByDeltaT}
	(**Delay time before starts a defrost procedure when delta between DfrStartByDeltaPrb1 and 2 is above DfrStartDeltaThrsh*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 15}
	{METADATA MAX_VAL 240}
	DfrStartByDeltaT : UINT := 60;
	{LOCATION DfrStartByDeltaThrsh}
	(**Starts a defrost procedure when delta between DfrStartByDeltaPrb1 and 2 is above this threshold for DfrStartDeltaT seconds (0=disabled).*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -99.9}
	{METADATA MAX_VAL 99.9}
	DfrStartByDeltaThrsh : REAL := 50;
	{LOCATION DfrTempRun}
	(**Defrost temperature threshold in "Running time" mode*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	DfrTempRun : REAL := -30;
	{LOCATION DfrTimeRun}
	(**Defrost time in “Running time" mode: 0 = function disabled*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	DfrTimeRun : USINT := 0;
	{LOCATION DfrType}
	(**Type of defrost*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 4}
	DfrType : USINT := 0;
	{LOCATION DfrVlvPos}
	(**Valve position during defrost. (0 = valve positioned as defi ned for the type
	 *of defrost selected, 1 = valve forced closed, 2 - 100 = opening percentage)*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	DfrVlvPos : USINT := 0;
	{LOCATION Din_Cfg}
	Din_Cfg : DinCfgUnion;
	{LOCATION DisDecPointMainVar}
	(**Display decimal point. 0 = Enabled, 1 = Disabled*)
	DisDecPointMainVar : BOOL := FALSE;
	{LOCATION DisNetworkDfr}
	(**Disable send network defrost control (for Main); 0: disabled; 1:enabled | Ignore network defrost control (for Secondary); 0: disabled; 1:enabled*)
	DisNetworkDfr : BOOL := FALSE;
	{LOCATION DoubleThermostatConf}
	(**Temperature regulation mode with double thermostat (0 = AND logic, 1 = OR logic)*)
	DoubleThermostatConf : BOOL := FALSE;
	{LOCATION DoubleThermSafety}
	(**Double thermostat safety timeout*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	DoubleThermSafety : USINT := 0;
	{LOCATION Dout_Cfg}
	Dout_Cfg : DOutCfgUnion;
	{LOCATION DripTime}
	(**Dripping time after defrost (fans off)*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 15}
	DripTime : USINT := 2;
	{LOCATION DutySetOnTime}
	(**ON time for duty setting operation (Toff = 15 minutes fixed) : 0 = compressor/valve always OFF, 100 = compressor/valve always ON*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	DutySetOnTime : USINT := 0;
	{LOCATION En_KeyboardOnOff}
	(**Enable On/Off unit by keyboard*)
	En_KeyboardOnOff : BOOL := TRUE;
	{LOCATION En_SupervOnOff}
	(**Enable On/Off unit by supervisor*)
	En_SupervOnOff : BOOL := FALSE;
	{LOCATION EnBloAlarm}
	(**Enable valve alarm at end travel ("blo")*)
	EnBloAlarm : BOOL := TRUE;
	{LOCATION EnBuzzer}
	(**Terminal buzzer (if present) 0 = enabled; 1= disabled*)
	EnBuzzer : BOOL := TRUE;
	{LOCATION EnKeyboard}
	(**Enable 7-seg UI keyboard*)
	EnKeyboard : BOOL := TRUE;
	{LOCATION EnNfc}
	(**Enable NFC memory*)
	EnNfc : BOOL := TRUE;
	{LOCATION EnSmoothLine}
	(**Enable the smooth line function*)
	EnSmoothLine : BOOL;
	{LOCATION EvapMax}
	(**Evaporation pressure probe maximum value*)
	{ATTRIBUTE UOM BAR}
	{METADATA MIN_VAL EvapMin}
	{METADATA MAX_VAL 200}
	EvapMax : REAL := 9.3;
	{LOCATION EvapMin}
	(**Evaporation pressure probe minimum value*)
	{ATTRIBUTE UOM BAR}
	{METADATA MIN_VAL -1}
	{METADATA MAX_VAL EvapMax}
	EvapMin : REAL := -1;
	{LOCATION EvapOffset}
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL -20}
	{METADATA MAX_VAL 20}
	EvapOffset : REAL;
	{LOCATION EVD_Digin1Cfg}
	(**EVD ice/mini digital input 1 configuration: 1 = start/stop control; 2 = control backup*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 2}
	EVD_Digin1Cfg : UINT := 2;
	{LOCATION EvdAddr}
	(**Evd Mini/ICE serial address*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 247}
	EvdAddr : USINT := 99;
	{LOCATION ExvDelayDfr}
	(**Initial valve position maintenance time after defrost*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 30}
	ExvDelayDfr : UINT := 10;
	{LOCATION ExvEnCloseLsa}
	(**Enable close solenoid valve for low superheat (LowSH) and/or low suction temperature (LSA)*)
	ExvEnCloseLsa : BOOL := FALSE;
	{LOCATION ExvEnCloseMOP}
	(**MOP: enable close solenoid valve*)
	ExvEnCloseMOP : BOOL := FALSE;
	{LOCATION ExvKp}
	(**Proportional gain for superheat regulation*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	ExvKp : REAL := 15;
	{LOCATION ExvSatTempBackup}
	(**Support saturated temperature for pressure probe error*)
	{ATTRIBUTE UOM CELSIUS}
	ExvSatTempBackup : REAL := -15;
	{LOCATION ExvTd}
	(**Derivative time for superheat regulation*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	ExvTd : USINT := 5;
	{LOCATION ExvTi}
	(**Integral time for superheat regulation*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 900}
	ExvTi : UINT := 150;
	{LOCATION FanMngConfig}
	(**Evaporator fan management: 0=always on, 1=Sa-Sb, 2=Sa, 3=On with door closed (DIP configured)*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 3}
	FanMngConfig : USINT := 0;
	{LOCATION FansCutOff}
	(**Fan activation differential (including variable speed)*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL FansSet}
	{METADATA MAX_VAL 50}
	FansCutOff : REAL := 50;
	{LOCATION FansDiff}
	(**Fan activation differential (including variable speed)*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0.1}
	{METADATA MAX_VAL 20}
	FansDiff : REAL := 2;
	{LOCATION FansMaxOut}
	(**Maximum evaporator fan speed*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL FansMinOut}
	{METADATA MAX_VAL 100}
	FansMaxOut : REAL := 100;
	{LOCATION FansMinOut}
	(**Minimum evaporator fan speed*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL FansMaxOut}
	FansMinOut : REAL := 0;
	{LOCATION FansPeekTime}
	(**Evaporator fan peak time (0 = function disabled)*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	FansPeekTime : USINT := 0;
	{LOCATION FansRegCnf}
	(**Fans regulation probes config*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 13}
	FansRegCnf : ARRAY[1..2] OF USINT := [2,13];
	{LOCATION FansSet}
	(**Evaporator fan activation threshold (only if F0 =1 or 2)*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	FansSet : REAL := -5;
	{LOCATION FansSpeedupTime}
	(**Evaporator fan forcing time at maximum speed (0 = function disabled)*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	FansSpeedupTime : USINT := 0;
	{LOCATION FB_Baud}
	(**FieldBus Baudrate*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 8}
	FB_Baud : USINT := 4;
	{LOCATION GenFctAlarm_Cfg}
	(**Generic alarms funtion configuration value*)
	{METADATA LIBRARY Libs.GenericFunctionMng}
	GenFctAlarm_Cfg : ARRAY[1..1] OF Libs.GenericFunctionMng.ALARM_GF;
	{LOCATION GenFctAlarm_EnableOn}
	{METADATA LIBRARY Libs.GenericFunctionMng}
	GenFctAlarm_EnableOn : ARRAY[1..1] OF USINT;
	{LOCATION GenFctModul_Cfg}
	(**Generic modulating funtion configuration value*)
	{METADATA LIBRARY Libs.GenericFunctionMng}
	GenFctModul_Cfg : ARRAY[1..1] OF Libs.GenericFunctionMng.MODULATION_GF;
	{LOCATION GenFctModul_EnableOn}
	{METADATA LIBRARY Libs.GenericFunctionMng}
	GenFctModul_EnableOn : ARRAY[1..1] OF USINT;
	{LOCATION GenFctStages_Cfg}
	(**Generic funtion configuration value*)
	{METADATA LIBRARY Libs.GenericFunctionMng}
	GenFctStages_Cfg : ARRAY[1..1] OF Libs.GenericFunctionMng.STAGE_GF;
	{LOCATION GenFctStages_EnableOn}
	{METADATA LIBRARY Libs.GenericFunctionMng}
	GenFctStages_EnableOn : ARRAY[1..1] OF USINT;
	{LOCATION GlassEstimComp}
	(**Virtual probe composition for glass temperature
	 *probe estimate*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	GlassEstimComp : USINT := 20;
	{LOCATION GlassTEstimateA}
	(**Coefficient A for glass temperature probe estimate*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL -20}
	{METADATA MAX_VAL 20}
	GlassTEstimateA : REAL := 2;
	{LOCATION GlassTEstimateB}
	(**Coefficient B for glass temperature probe estimate*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	GlassTEstimateB : USINT := 22;
	{LOCATION HACCP_AlrmDelay}
	(**HACCP Alarm delay, 0 = Monitoring disabled*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	HACCP_AlrmDelay : USINT := 0;
	{LOCATION HACCP_LogBuffer}
	(**HACCP logs buffer*)
	HACCP_LogBuffer : ARRAY[0..9] OF REAL;
	{LOCATION HACCP_LogIndex}
	(**HACCP logs buffer index*)
	HACCP_LogIndex : USINT := 0;
	{LOCATION HeaterOffs}
	(**Offset for anti-sweat heater modulation*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL -20}
	{METADATA MAX_VAL 20}
	HeaterOffs : REAL := 2;
	{LOCATION HeatersDiff}
	(**Differential for anti-sweat heater modulation*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 20}
	HeatersDiff : REAL := 0;
	{LOCATION HiAlarm2Thr}
	(**High temperature alarm 2 threshold*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 50}
	HiAlarm2Thr : REAL := 0;
	{LOCATION HiAlarmThr}
	(**High temperature alarm threshold*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 50}
	HiAlarmThr : REAL := 10;
	{LOCATION HighTempBypDoor}
	(**High temperature alarm bypass time for door open*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 240}
	HighTempBypDoor : USINT := 30;
	{LOCATION HMIMainDef}
	(**Display on terminals during defrost*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 2}
	HMIMainDef : USINT := 1;
	{LOCATION HmiMainSel}
	(**Dispaly visualization selection*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 16}
	HmiMainSel : USINT := 9;
	{LOCATION HmiRemSel}
	(**Display on remote display*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 14}
	HmiRemSel : USINT;
	{LOCATION isManufacturer}
	(**Dummy variable for profiling needs*)
	isManufacturer : BOOL;
	{LOCATION isMaster}
	(**Type of unit 0 = Secondary;1 = Main*)
	isMaster : BOOL := FALSE;
	{LOCATION isService}
	(**Dummy variable for profiling needs*)
	isService : BOOL;
	{LOCATION isUser}
	(**Dummy variable for profiling needs*)
	isUser : BOOL;
	{LOCATION KeyboardOnOff}
	(**On/Off unit by keyboard*)
	KeyboardOnOff : BOOL := TRUE;
	{LOCATION LightOnDoorDelay}
	(**Time light stays on after closing the door*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	LightOnDoorDelay : USINT := 0;
	{LOCATION LogAlarms}
	(**Alarms history*)
	LogAlarms : ARRAY[1..10] OF System.Alarm.AlarmLog;
	{LOCATION LogAlrmIdx}
	(**Current index for alarm hystory management*)
	LogAlrmIdx : UINT;
	{LOCATION LogHACCP_HA}
	(**Log array for HACCP HA alarms type*)
	LogHACCP_HA : ARRAY[1..6] OF System.Alarm.AlarmLog;
	{LOCATION LogHACCP_HA_Index}
	(**Log index for HACCP HA alarms type*)
	LogHACCP_HA_Index : UINT := 0;
	{LOCATION LogHACCP_HF}
	(**Log array for HACCP HF alarms type*)
	LogHACCP_HF : ARRAY[1..6] OF System.Alarm.AlarmLog;
	{LOCATION LogHACCP_HF_Index}
	(**Log index for HACCP HF alarms type*)
	LogHACCP_HF_Index : UINT := 0;
	{LOCATION LOP_AlrmDelay}
	(**LOP: alarm delay - 0 = function disabled*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	LOP_AlrmDelay : USINT := 0;
	{LOCATION LOP_Thrsh}
	(**LOP: minimum saturated evaporation temperature threshold*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	LOP_Thrsh : REAL := -50;
	{LOCATION LOP_Ti}
	(**LOP: integration time*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 800}
	LOP_Ti : REAL := 0;
	{LOCATION LowAlarm2Thr}
	(**Low temperature alarm 2 threshold*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 50}
	LowAlarm2Thr : REAL := 0;
	{LOCATION LowAlarmThr}
	(**Low temperature alarm threshold*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 50}
	LowAlarmThr : REAL := 4;
	{LOCATION LowSH_AlrmDelay}
	(**LowSH: alarm delay - 0 = alarm disabled*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	LowSH_AlrmDelay : UINT := 600;
	{LOCATION LowSH_Thrsh}
	(**LowSH: low superheat threshold*)
	{ATTRIBUTE UOM KELVIN}
	{METADATA MIN_VAL -10.0}
	{METADATA MAX_VAL SHSetp}
	LowSH_Thrsh : REAL := 5;
	{LOCATION LowSH_Ti}
	(**LowSH: integration time - 0 = function disabled*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0.0}
	{METADATA MAX_VAL 240.0}
	LowSH_Ti : REAL := 15;
	{LOCATION LowSuctAlrmDelay}
	(**LSA: alarm delay - 0 = alarm disabled*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	LowSuctAlrmDelay : UINT := 600;
	{LOCATION LowSuctThrsh}
	(**LSA: low suction temperature threshold*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50.0}
	{METADATA MAX_VAL 50.0}
	LowSuctThrsh : REAL := -50;
	{LOCATION ManHeaterPerc}
	(**Manual anti-sweater heater activation percentage (of period rHt)*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	ManHeaterPerc : USINT := 70;
	{LOCATION ManHeaterPeriod}
	(**Manual anti-sweater heater activation period*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 180}
	ManHeaterPeriod : USINT := 5;
	{LOCATION MasterVlvCnf}
	(**Main solenoid valve configuration: 0 = local valve;1 = network valve (connected to Main)*)
	MasterVlvCnf : BOOL := FALSE;
	{LOCATION MaxTempSet}
	(**Maximum temperature setpoint*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL MinTempSet}
	{METADATA MAX_VAL 200}
	MaxTempSet : REAL := 50;
	{LOCATION MinOffT}
	(**Minimum OFF time*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 15}
	MinOffT : UINT := 0;
	{LOCATION MinOnOnSameT}
	(**Minimum time between successive starts*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 15}
	MinOnOnSameT : UINT := 0;
	{LOCATION MinOnT}
	(**Minimum ON time*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 15}
	MinOnT : UINT := 0;
	{LOCATION MinTempSet}
	(**Minimum temperature setpoint*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL MaxTempSet}
	MinTempSet : REAL := -50;
	{LOCATION MOP_AlrmDelay}
	(**MOP: alarm delay - 0 = function disabled*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	MOP_AlrmDelay : UINT := 600;
	{LOCATION MOP_StartDelay}
	(**MOP: delay activation of function when starting control*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	MOP_StartDelay : USINT := 2;
	{LOCATION MOP_SuctTempThrsh}
	(**MOP: maximum suction temperature threshold used to stop MOP due to possible compressor overheating with reduced refrigerant flow*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	MOP_SuctTempThrsh : REAL := 30;
	{LOCATION MOP_Thrsh}
	(**MOP: maximum saturated evaporation temperature threshold*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	MOP_Thrsh : REAL := 50;
	{LOCATION MOP_Ti}
	(**MOP: integration time*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 800.0}
	MOP_Ti : REAL := 20;
	{LOCATION MstAlarmOnSlv}
	(**Signal alarms from Secondary to Main: 0 = not enabled; 1 = enabled*)
	MstAlarmOnSlv : BOOL := TRUE;
	{LOCATION MstVlvConfig}
	(**Main solenoid valve configuration: 0 = local valve;1 = network valve (connected to Main)*)
	MstVlvConfig : BOOL := FALSE;
	{LOCATION MyLastOffDate_Saved}
	(**Last off date saved from blackout*)
	MyLastOffDate_Saved : DATE_AND_TIME;
	{LOCATION NfcWriteInfo}
	(**Nfc memory information*)
	NfcWriteInfo : System.NFC.nfcWriteInfo;
	{LOCATION NightPrbReg}
	(**Probe for night-time control: 0 = virtual probe Sv; 1 = intake probe Sr*)
	NightPrbReg : BOOL := FALSE;
	{LOCATION PostDripTime}
	(**Post dripping time after dripping (fans off with control active)*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 15}
	PostDripTime : USINT := 2;
	{LOCATION PowDfrConf}
	(**Configuration of power defrost for each timeband*)
	PowDfrConf : ARRAY[1..8] OF BOOL;
	{LOCATION PrbErrorOffset}
	(**Control offset with probe error*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0.0}
	{METADATA MAX_VAL 20.0}
	PrbErrorOffset : REAL := 0;
	{LOCATION Pwd_Manuf}
	(**Manufacturer password*)
	Pwd_Manuf : STRING[8] := '44';
	{LOCATION Pwd_Service}
	(**Service password*)
	Pwd_Service : STRING[8] := '22';
	{LOCATION Pwd_User}
	(**User password*)
	Pwd_User : STRING[8];
	{LOCATION PwdDisplay}
	(**Display password*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	PwdDisplay : UINT := 33;
	{LOCATION RegFanConfig}
	(**Fans runs only when solenoid valve is open or compressor is on*)
	RegFanConfig : BOOL := TRUE;
	{LOCATION RemoteHMIAlrms}
	(**Display signals / alarms on remote display*)
	RemoteHMIAlrms : BOOL := FALSE;
	{LOCATION RfrgTyp}
	(**Type of refrigerant*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 41}
	RfrgTyp : UINT := 3;
	{LOCATION SetpNightOffset}
	(**Automatic night-time set point variation*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	SetpNightOffset : REAL := 0;
	{LOCATION SH_PID_Type}
	(**Type of PID used on smoothline, 0 = PID Incremental 1 = PID advanced*)
	SH_PID_Type : BOOL := FALSE;
	{LOCATION SHSetp}
	(**Superheat setpoint*)
	{ATTRIBUTE UOM KELVIN}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 25}
	SHSetp : REAL := 10;
	{LOCATION SimulateMode}
	(**Simulation of probes mode is active*)
	SimulateMode : BOOL := FALSE;
	{LOCATION SlaveAlarmCheck}
	(**Communication of alarms from Secondary to Main*)
	SlaveAlarmCheck : BOOL := TRUE;
	{LOCATION SlavesNum}
	(**Number of configured Secondary devices*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 9}
	SlavesNum : USINT := 0;
	{LOCATION SmLine_SH_thrsh}
	(**Smooth Lines - Superheat threshold *)
	{METADATA MIN_VAL 0.0}
	{METADATA MAX_VAL 5.0}
	SmLine_SH_thrsh : REAL := 0;
	{LOCATION SmLineKp}
	(**Kp for Smooth Line PID*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	SmLineKp : REAL := 5;
	{LOCATION SmLineSH_AvgT}
	(**Smooth Lines - Superheat set averaging time *)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 60}
	SmLineSH_AvgT : USINT;
	{LOCATION SmLineSHOffset}
	(**Superheat maximum offset applied when the regulation power needs to be decreased*)
	{ATTRIBUTE UOM KELVIN}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 50}
	SmLineSHOffset : REAL := 15;
	{LOCATION SmLineTd}
	(**Derivative time for smooth line setpoint*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	SmLineTd : UINT := 0;
	{LOCATION SmLineTempOffset}
	(**Regulation temperature maximum offset to switch off the regulation*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 10}
	SmLineTempOffset : REAL := 2;
	{LOCATION SmLineTi}
	(**Integral time for smooth line setpoint*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 800}
	SmLineTi : UINT := 150;
	{LOCATION StandbyEEVOpenPosition}
	(**Valve opening during standby*)
	{ATTRIBUTE UOM STEPS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 480}
	StandbyEEVOpenPosition : UINT := 0;
	{LOCATION StartEEVOpenRatio}
	(**Valve opening at startup*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	StartEEVOpenRatio : USINT := 30;
	{LOCATION StartupDef}
	(**Defrost on power-up: 0 = disabled ; 1 = enabled*)
	StartupDef : BOOL := FALSE;
	{LOCATION StbyTout}
	(**Timeout for stanby status, once elapsed it will restart the normal regulation*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 240}
	StbyTout : USINT := 0;
	{LOCATION SuctVlvRegDelay}
	(**Suction valve closure delay in normal regolation mode*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	SuctVlvRegDelay : UINT := 0;
	{LOCATION SupervOnOff}
	(**On/Off unit by supervisor*)
	SupervOnOff : BOOL := FALSE;
	{LOCATION swVersion}
	(**Current software version*)
	swVersion : UINT;
	{LOCATION Tau_value}
	Tau_value : REAL;
	{LOCATION TempCtrl_DirRev}
	(**Temperature regulation operating mode
	 *0: Direct
	 *1: Reverse*)
	TempCtrl_DirRev : BOOL := FALSE;
	{LOCATION TempDiff}
	(**Temperature regulation differential*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0.1}
	{METADATA MAX_VAL 99.9}
	TempDiff : REAL := 2;
	{LOCATION TempDiff2}
	(**Temperature regulation differential*)
	{ATTRIBUTE UOM DELTACELSIUS}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 99.9}
	TempDiff2 : REAL := 0;
	{LOCATION TempSetP}
	(**Temperature regulation setpoint*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL MinTempSet}
	{METADATA MAX_VAL MaxTempSet}
	TempSetP : REAL := 50;
	{LOCATION TempSetP2}
	(**Temperature regulation setpoint*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL MinTempSet}
	{METADATA MAX_VAL MaxTempSet}
	TempSetP2 : REAL := 50;
	{LOCATION TimeBandEnd}
	(**Time band end arrays*)
	TimeBandEnd : ARRAY[1..8] OF TimeBand;
	{LOCATION TimeBandStart}
	(**Time band start arrays*)
	TimeBandStart : ARRAY[1..8] OF TimeBand;
	{LOCATION TimerDelay}
	(**Timer duration for timed input*)
	{ATTRIBUTE UOM MINUTE}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	TimerDelay : UINT := 0;
	{LOCATION ValveCnf}
	(**Elettronic valve
	 *0 = not present
	 *1 = CAREL E2V valve on board
	 *2 = CAREL E2V valve (Suct Temp probe on MPXone)
	 *6 = CAREL E2V valve (Suct Temp on Evd driver)*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 6}
	ValveCnf : USINT := 0;
	{LOCATION VirtualComposition}
	(**Virtual probe composition 0% AirOff only, 100% AirOn Only*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	VirtualComposition : USINT;
	{LOCATION VirtualDiOut}
	(**Select digital input propagated from Main to Secondaries (only on Main)*)
	{METADATA MIN_VAL -1}
	{METADATA MAX_VAL 5}
	VirtualDiOut : SINT := 0;
	{LOCATION VlvCloseDelay}
	(**Suction valve closure delay in normal regolation mode*)
	{ATTRIBUTE UOM SECOND}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 999}
	VlvCloseDelay : UINT := 0;
	{LOCATION VlvMinOpen}
	(**Minimum opening % for refrigerant control*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	VlvMinOpen : USINT := 0;
	{LOCATION VlvMinRefrigCnt}
	(**Minimum valve opening % for refrigerant control*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	VlvMinRefrigCnt : USINT := 0;
	{LOCATION VlvPressPrbTyp}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 14}
	VlvPressPrbTyp : UINT := 3;
	{LOCATION WaitForUpdate}
	(**The controller has received a download request, any device that needs to be off before the update will be managed*)
	WaitForUpdate : BOOL := FALSE;
	{LOCATION WizDone}
	(**Wizard procedure completed with success*)
	WizDone : BOOL := FALSE;
	{LOCATION ZoneHMI}
	(**User interface unit of measure, FALSE = SI, TRUE = IMPERIAL*)
	ZoneHMI : BOOL := FALSE;
    {LOCATION HiAlarmThrAbs}
	(**Absolute high temperature alarm threshold*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	HiAlarmThrAbs : REAL := 50;
    (**Absolute high temperature 2 alarm threshold*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	HiAlarm2ThrAbs : REAL := 50;
    (**Absolute low temperature alarm threshold*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	LowAlarmThrAbs : REAL := 50;
    (**Absolute low temperature 2 alarm threshold*)
	{ATTRIBUTE UOM CELSIUS}
	{METADATA MIN_VAL -50}
	{METADATA MAX_VAL 50}
	LowAlarm2ThrAbs : REAL := 50;
	{LOCATION DEFAULT}
END_VAR
VAR_GLOBAL
    {LOCATION Ain_Err}
    (**Error on analog inputs*)
	Ain_Err : AinErrUnion;
    {LOCATION Din_Err}
    (**Error on digital inputs*)
	Din_Err : DinErrUnion;
    {LOCATION Dout_Err}
    (**Error on ddigital ouptputs*)
	Dout_Err : DoutErrUnion;
    {LOCATION Aout_Err}
    (**Error on analog outputs*)
	Aout_Err : AoutErrUnion;
	{LOCATION AckAlm}
	(**Acknowledge alarm*)
	AckAlm : BOOL;
	{LOCATION ActCarosel}
	(**Active carosel on main mask*)
	ActCarosel : BOOL;
	{LOCATION ActualSH}
	(**Actual superheat reading*)
	{ATTRIBUTE UOM KELVIN}
	ActualSH : REAL;
	{LOCATION ActualShSetp}
	(**Actual superheat setpoint with applied offsets*)
	{ATTRIBUTE UOM KELVIN}
	ActualShSetp : REAL;
	{LOCATION ActualTemp2Setpoint}
	(**Actual setpoint used for regulation of double thermostat*)
	{ATTRIBUTE UOM CELSIUS}
	ActualTemp2Setpoint : REAL;
	{LOCATION ActualTempSetpoint}
	(**Actual setpoint used for regulation*)
	{ATTRIBUTE UOM CELSIUS}
	ActualTempSetpoint : REAL;
	{LOCATION AirOffBroken}
	(**AirOff probe is broken or disconnected*)
	AirOffBroken : BOOL;
	{LOCATION AirOnBroken}
	(**AirOn probe is broken or disconnected*)
	AirOnBroken : BOOL;
	{LOCATION AlrmHyst_idx}
	AlrmHyst_idx : ALRMHYST_ENUM := 0;
	{LOCATION AlrmRes}
	(**Reset all active alarms*)
	AlrmRes : BOOL;
	{LOCATION AnalogInputs}
	AnalogInputs : AinUnion;
	{LOCATION AnalogOutputs}
	(**Analog output functions structure*)
	AnalogOutputs : AOUnion;
	{LOCATION AuxOn}
	(**Auxiliary output status*)
	AuxOn : BOOL;
	{LOCATION BasicVisualiz}
	BasicVisualiz : BOOL;
	{LOCATION BlackoutSR}
	(**Blackout notification during the startup time*)
	BlackoutSR : System.Math.SR;
	{LOCATION BlockHmi}
	(**Flag blocks HMI button*)
	BlockHmi : BOOL;
	{LOCATION BMS_SHSet}
	(**Actual superheat setpoint sent to BMS*)
	{ATTRIBUTE UOM KELVIN}
	BMS_SHSet : REAL;
	{LOCATION ChangedUoM}
	ChangedUoM : BOOL;
	{LOCATION CleanStatus}
	(**Clean status from digital input*)
	CleanStatus : BOOL := FALSE;
	{LOCATION CmdAux}
	(**Quick command to manually force the auxiliary output*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 2}
	CmdAux : USINT := 1;
	{LOCATION CmdComp}
	(**Quick command to force manually the compressor/valve*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 2}
	CmdComp : USINT := 1;
	{LOCATION CmdFans}
	(**Quick command to manually force the fans*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 2}
	CmdFans : USINT := 1;
	{LOCATION CntDwnSafT}
	CntDwnSafT : Libs.CntDwnSafT_v1_4_1.CntDwnSafT;
	{LOCATION CompAllAlrm}
	(**Blocking alarm status for solenoid / compressor*)
	CompAllAlrm : BOOL := FALSE;
	{LOCATION CompFanDelay_TON}
	CompFanDelay_TON : System.Timer.TON;
	{LOCATION CompOn}
	(**Solenoid / Compressor status*)
	CompOn : BOOL;
	{LOCATION CurrDateTime}
	(**Current date and time read from RTC*)
	CurrDateTime : DATE_AND_TIME;
	{LOCATION CurrentDoW}
	(**Current day of week of internal clock*)
	CurrentDoW : System.Timer.DayOfWeek;
	{LOCATION currMenu}
	(**Current menu opened by the use*)
	currMenu : USINT;
	{LOCATION currMenu_SecondLev}
	currMenu_SecondLev : USINT;
	{LOCATION currMenuLevel}
	(**Current menu level*)
	currMenuLevel : USINT;
	{LOCATION DateAndTimeChanged}
	(**Date and time changed*)
	DateAndTimeChanged : BOOL;
	{LOCATION DateTimeToSet}
	(**Date and time to write in RTC*)
	DateTimeToSet : DATE_AND_TIME;
	{LOCATION DayStatus}
	(**Current status is Day*)
	DayStatus : BOOL := TRUE;
	{LOCATION DfrBook}
	(**Defrost booked after disabling by digital input (Dic) an active defrost*)
	DfrBook : BOOL;
	{LOCATION DfrCnt}
	DfrCnt : UINT;
	{LOCATION DfrCompOff}
	(**Defrost logic force compressor / liquid solenoid valve off*)
	DfrCompOff : BOOL := FALSE;
	{LOCATION DfrHiBypassEnd}
	(**High temperature alarm bypass during defrost has expired*)
	DfrHiBypassEnd : BOOL;
	{LOCATION DfrHotGasSafetyActive}
	(**Safety procedure is active*)
	DfrHotGasSafetyActive : BOOL;
	{LOCATION DfrInProgress}
	(**Defrost in progress*)
	DfrInProgress : BOOL;
	{LOCATION DfrMstStatus}
	(**Main defrost status*)
	DfrMstStatus : USINT;
	{LOCATION DfrNatural}
	(**Natural defrost status*)
	DfrNatural : BOOL := FALSE;
	{LOCATION DfrOn}
	(**Defrost status*)
	DfrOn : BOOL;
	{LOCATION DfrOn2}
	(**Auxiliary evaporator defrosto status*)
	DfrOn2 : BOOL := FALSE;
	{LOCATION DfrPerformedCntLog}
	DfrPerformedCntLog : UINT;
	{LOCATION DfrPerformedCntLog_prev}
	DfrPerformedCntLog_prev : UINT;
	{LOCATION DfrStartedDT}
	DfrStartedDT : DATE_AND_TIME;
	{LOCATION DfrStatus}
	(**Current defrost status*)
	DfrStatus : USINT := 0;
	{LOCATION DigitalInputs}
	{METADATA LIBRARY Libs.LibMpx}
	DigitalInputs : DinUnion;
	{LOCATION DigitalOutputs}
	(**Digital outputs union*)
	{METADATA LIBRARY Libs.LibMpx}
	DigitalOutputs : DOUnion;
	{LOCATION DispMngInst}
	(**Instance of NFC manager class helper*)
	DispMngInst : DisplayManager;
	{LOCATION DoorOnStatus}
	(**Door status feedback with regulation active*)
	DoorOnStatus : BOOL := FALSE;
	{LOCATION DoorTrigger}
	(**Door status trigger on rising and falling *)
	{METADATA LIBRARY Libs.CAREL_BASIC_LIB}
	DoorTrigger : Libs.Logics_v0_1_4.RF_TRIG;
	{LOCATION DutySettings}
	(**Duty settings regulation is active*)
	DutySettings : BOOL;
	{LOCATION E_VlvOn}
	(**Equalizing solenoid valve status*)
	E_VlvOn : BOOL := FALSE;
	{LOCATION EnDirFunct}
	(**Enable direct function*)
	EnDirFunct : BOOL;
	{LOCATION EnManExv}
	(**Manual valve command*)
	EnManExv : BOOL := FALSE;
	{LOCATION EvapSatTemp}
	(**Evaporation *)
	{ATTRIBUTE UOM CELSIUS}
	EvapSatTemp : REAL;
	{LOCATION EvapTempNTC_Log}
	(**Evaporator saturated temperature only for data log purpose*)
	{ATTRIBUTE UOM CELSIUS}
	EvapTempNTC_Log : REAL;
	{LOCATION EVD_EvapP}
	(**Evaporation pressure read from EVD mini/ice*)
	{ATTRIBUTE UOM BAR}
	EVD_EvapP : REAL;
	{LOCATION ExvVlvPosition}
	(**Valve opening percentage*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	ExvVlvPosition : USINT;
	{LOCATION FansOn}
	(**Fans status*)
	FansOn : BOOL;
	{LOCATION FansReq}
	(**Fans request in percentage*)
	{ATTRIBUTE UOM PERCENT}
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	FansReq : REAL;
	{LOCATION firstCycle}
	(**Startup time before to start any regulation logic*)
	firstCycle : BOOL := TRUE;
	{LOCATION GenFctAlarm_Out}
	(**Generic alarms output values*)
	{METADATA LIBRARY Libs.GenericFunctionMng}
	GenFctAlarm_Out : ARRAY[1..1] OF Libs.GenericFunctionMng.ALARM_OUT_GF;
	{LOCATION GenFctAlarm_Serious}
	(**There are at least one general Function Alarm Serius*)
	GenFctAlarm_Serious : BOOL := FALSE;
	{LOCATION GenFctModul_Out}
	(**Generic modulating funtion output value*)
	GenFctModul_Out : ARRAY[1..1] OF REAL;
	{LOCATION GenFctStages_Out}
	(**Generic funtion output value*)
	GenFctStages_Out : ARRAY[1..1] OF BOOL;
	{LOCATION HACCP_CountHA}
	(**HACCP number of HA alarm type recorded*)
	HACCP_CountHA : USINT;
	{LOCATION HACCP_CountHF}
	(**HACCP number of HF alarm type recorded*)
	HACCP_CountHF : USINT;
	{LOCATION HeatersOut}
	(**Modulating output for heaters*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 100}
	HeatersOut : USINT;
	{LOCATION HeatersReq}
	(**Heaters for anti-sweater on glass request*)
	{ATTRIBUTE UOM PERCENT}
	HeatersReq : REAL;
	{LOCATION HwDesc}
	(**All information about current hardware running this application*)
	HwDesc : System.HardwareDescription;
	{LOCATION IdxVis_AlrmHyst}
	IdxVis_AlrmHyst : INT := 1;
	{LOCATION InsideLoopDirFunct}
	(**Inside loop direct function*)
	InsideLoopDirFunct : BOOL;
	{LOCATION IO_Mng}
	{METADATA LIBRARY Libs.IOMng_Basic}
	IO_Mng : Libs.IOMng_Basic.Class_IOMng_Basic;
	{LOCATION isAdvanced}
	(**Current application is for MPX ONE ADVANCED*)
	isAdvanced : BOOL;
	{LOCATION isBasic}
	(**Current application is for MPX ONE BASIC*)
	isBasic : BOOL;
	{LOCATION isCustomBasicRU}
	isCustomBasicRU : BOOL;
	{LOCATION isMedium}
	(**Current application is for MPX ONE MEDIUM*)
	isMedium : BOOL;
	{LOCATION isPanelVersion}
	isPanelVersion : BOOL;
	{LOCATION isProdBasicVersion}
	isProdBasicVersion : BOOL;
	{LOCATION L_VlvOn}
	(**Liquid solenoid valve status*)
	L_VlvOn : BOOL := FALSE;
	{LOCATION LEDAlmBlink}
	(**LED blink alarm*)
	LEDAlmBlink : BOOL;
	{LOCATION LEDAlmOn}
	(**LED on alarm*)
	LEDAlmOn : BOOL;
	{LOCATION LedAuxOn}
	(**Auxiliary function LED status*)
	LedAuxOn : BOOL;
	{LOCATION LedBlinkArrow}
	(**Led arrows blinking*)
	LedBlinkArrow : BOOL;
	{LOCATION LedClockOn}
	(**Clock LED status*)
	LedClockOn : BOOL;
	{LOCATION LEDCompBlink}
	LEDCompBlink : BOOL;
	{LOCATION LEDCompOn}
	LEDCompOn : BOOL;
	{LOCATION LedDfrFlash}
	(**Defrost LED flashing*)
	LedDfrFlash : BOOL;
	{LOCATION LedDfrOn}
	(**LED status for defrost icon*)
	LedDfrOn : BOOL;
	{LOCATION LedEcoOn}
	(**Eco function LED status*)
	LedEcoOn : BOOL;
	{LOCATION LedFanOn}
	(**LED status for fan icon*)
	LedFanOn : BOOL;
	{LOCATION LedHACCPOn}
	(**HACCP LED On*)
	LedHACCPOn : BOOL;
	{LOCATION LedLightsOn}
	(**LED status for light icon*)
	LedLightsOn : BOOL;
	{LOCATION LedOnArrow}
	(**Led arrows on*)
	LedOnArrow : BOOL;
	{LOCATION LedProgram}
	(**Led status of program button*)
	LedProgram : BOOL := TRUE;
	{LOCATION LedServiceOn}
	(**Service LED status*)
	LedServiceOn : BOOL;
	{LOCATION LightsOn}
	(**Current light status is ON*)
	LightsOn : BOOL := FALSE;
	{LOCATION lkLed}
	(**Left column of display leds status*)
	lkLed : ARRAY[0..4] OF BOOL;
	{LOCATION LogAlrmRes}
	(**Reset alarm log*)
	LogAlrmRes : BOOL;
	{LOCATION LogsEventsCounter}
	(**Event log: counter to generate the event to store variables value*)
	LogsEventsCounter : UINT;
	{LOCATION MachineStatus}
	MachineStatus : USINT := 2;
	{LOCATION ManClean}
	(**Clean command*)
	ManClean : BOOL := FALSE;
	{LOCATION ManContCycle_byDisplay}
	(**Contìnuos Cycle Started/Stopped by Display*)
	ManContCycle_byDisplay : BOOL := FALSE;
	{LOCATION ManContCycle_bySuperv}
	(**Contìnuos Cycle Started/Stopped by Supervisor*)
	ManContCycle_bySuperv : BOOL := FALSE;
	{LOCATION ManContinuous}
	(**Continuous cycle*)
	ManContinuous : BOOL := FALSE;
	{LOCATION ManDfr}
	(**Start/Stop manual defrost*)
	ManDfr : BOOL;
	{LOCATION MasterOnlineTON}
	(**Time counter for Main online detection*)
	MasterOnlineTON : System.Timer.TON;
	{LOCATION mpxRepeater}
	(**Repeater instance*)
	{METADATA LIBRARY Libs.AcuRepeater}
	mpxRepeater : Libs.AcuRepeater.Repeater;
	{LOCATION MskValue}
	MskValue : REAL;
	{LOCATION MstAmbientH}
	(**Ambient humidity from Main*)
	{ATTRIBUTE UOM PERCENT_rH}
	MstAmbientH : REAL;
	{LOCATION MstAmbientT}
	(**Ambient temperature from Main*)
	{ATTRIBUTE UOM CELSIUS}
	MstAmbientT : REAL;
	{LOCATION MstDewPoint}
	(**Dew point from Main*)
	{ATTRIBUTE UOM CELSIUS}
	MstDewPoint : REAL;
	{LOCATION MstEvapP}
	(**Evaporation pressure from Main*)
	{ATTRIBUTE UOM BAR}
	MstEvapP : REAL;
	{LOCATION MstEvapSatTemp}
	(**Evaporation saturated temperature from Main*)
	{ATTRIBUTE UOM CELSIUS}
	MstEvapSatTemp : REAL;
	{LOCATION MstRegStatus}
	(**Main regulation status*)
	MstRegStatus : BOOL;
	{LOCATION MstRegTemp}
	(**Main regulation temperature*)
	{ATTRIBUTE UOM CELSIUS}
	MstRegTemp : REAL;
	{LOCATION Navigation}
	(**HMI is active *)
	Navigation : BOOL;
	{LOCATION NetworkAux}
	(**Solenoid valve request from Secondaries*)
	NetworkAux : BOOL := FALSE;
	{LOCATION NetworkDfr}
	(**Perform a network defrost*)
	NetworkDfr : BOOL := FALSE;
	{LOCATION NetworkLight}
	(**Network light status from Main*)
	NetworkLight : BOOL := FALSE;
	{LOCATION NetworkVlv}
	(**Network solenoid valve*)
	NetworkVlv : BOOL := FALSE;
	{LOCATION NewDispPrompt}
	(**New display procedure in progress, waiting for user interaction*)
	NewDispPrompt : BOOL;
	{LOCATION OrAlrm}
	(**OR condition for all Alarms*)
	OrAlrm : BOOL;
	{LOCATION OrPrbAlrm}
	OrPrbAlrm : BOOL;
	{LOCATION OrSeriousAlrm}
	(**OR condition for serious alarms*)
	OrSeriousAlrm : BOOL;
	{LOCATION OrStatus}
	(**Or of the status variables*)
	OrStatus : BOOL;
	{LOCATION OrWarning}
	(**OR condition for all warnings*)
	OrWarning : BOOL;
	{LOCATION PassThroughTON}
	(**Safety timer for passthrough funcionality*)
	PassThroughTON : System.Timer.TON;
	{LOCATION Posix}
	(**Posix string to set Timezone*)
	Posix : STRING;
	{LOCATION PosManExv}
	(**Manual valve position to set*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 480}
	PosManExv : UINT := 0;
	{LOCATION PrbVisualiz}
	(**Sensors value visualizaztion*)
	PrbVisualiz : BOOL;
	{LOCATION Product_Info}
	Product_Info : System.ProductInfo;
	{LOCATION Pwd_OEM_Ok}
	(**User logger as OEM*)
	Pwd_OEM_Ok : BOOL;
	{LOCATION Pwd_SERVICE_Ok}
	(**User logger as SERVICE*)
	Pwd_SERVICE_Ok : BOOL;
	{LOCATION Pwd_USER_Ok}
	(**User logger as USER*)
	Pwd_USER_Ok : BOOL;
	{LOCATION RegProbe}
	(**Regulation probe with Day/Night offset*)
	{ATTRIBUTE UOM CELSIUS}
	RegProbe : REAL;
	{LOCATION repeaterConfig}
	repeaterConfig : Protocols.ProtocolDeviceInfo;
	{LOCATION ResCarelSets}
	(**Restore to Carel settings*)
	ResCarelSets : BOOL;
	{LOCATION rkLed}
	(**Right column of display leds status*)
	rkLed : ARRAY[0..3] OF BOOL;
	{LOCATION S_VlvOn}
	(**Suction solenoid valve status*)
	S_VlvOn : BOOL := FALSE;
	{LOCATION SerialInputs}
	(**Value containers for serial inputs*)
	SerialInputs : ARRAY[1..4] OF System.IO.uChannel;
	{LOCATION SlavesTempReq}
	(**Temperature request from at least one Secondary*)
	SlavesTempReq : BOOL;
	{LOCATION SlvUpdFW}
	(**Update of Secondaries firmware is in progress*)
	SlvUpdFW : BOOL;
	{LOCATION SmLineStatus}
	(**Smooth line status
	 *FALSE = Smooth line not active
	 *TRUE = Smooth line active*)
	SmLineStatus : BOOL;
	{LOCATION SPV_CurrDay}
	(**Day - Current value by internal RTC*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 31}
	SPV_CurrDay : USINT;
	{LOCATION SPV_CurrDoW}
	(**Day of week - Current value by internal RTC*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 7}
	SPV_CurrDoW : USINT;
	{LOCATION SPV_CurrHour}
	(**Hour - Current value by internal RTC*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 23}
	SPV_CurrHour : USINT;
	{LOCATION SPV_CurrMin}
	(**Minutes - Current value by internal RTC*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 59}
	SPV_CurrMin : USINT;
	{LOCATION SPV_CurrMonth}
	(**Month - Current value by internal RTC*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 12}
	SPV_CurrMonth : USINT;
	{LOCATION SPV_Curryear}
	(**Year - Current value by internal RTC*)
	{METADATA MIN_VAL 17}
	{METADATA MAX_VAL 99}
	SPV_Curryear : USINT;
	{LOCATION SPV_Day}
	(**Day - Clock settings by supervisor*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 31}
	SPV_Day : USINT := 1;
	{LOCATION SPV_DoW}
	(**Day of week - Clock settings by supervisor*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 7}
	SPV_DoW : USINT := 0;
	{LOCATION SPV_Hour}
	(**Hour - Clock settings by supervisor*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 23}
	SPV_Hour : USINT := 0;
	{LOCATION SPV_Min}
	(**Minutes - Clock settings by supervisor*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 59}
	SPV_Min : USINT := 0;
	{LOCATION SPV_Month}
	(**Month - Clock settings by supervisor*)
	{METADATA MIN_VAL 1}
	{METADATA MAX_VAL 12}
	SPV_Month : USINT := 1;
	{LOCATION SPV_Year}
	(**Year - Clock settings by supervisor*)
	{METADATA MIN_VAL 17}
	{METADATA MAX_VAL 99}
	SPV_Year : USINT := 17;
	{LOCATION StartupReset}
	(**User has started the reset procedure*)
	StartupReset : BOOL;
	{LOCATION StartupTimeTON}
	(**Time counter for startup standby*)
	StartupTimeTON : System.Timer.TON;
	{LOCATION TempAlarms}
	(**Temperature alarm management FB*)
	TempAlarms : ARRAY[1..2] OF LibraryNamespaceAndVersion.MpxAlarmMng;
	{LOCATION TempReg}
	(** Input functions *)
	{METADATA LIBRARY Libs.CAREL_BASIC_LIB}
	TempReg : Libs.Hysteresis_v0_1_7.HysterAdv;
	{LOCATION TempReg2}
	{METADATA LIBRARY Libs.CAREL_BASIC_LIB}
	TempReg2 : Libs.Hysteresis_v0_1_7.HysterAdv;
	{LOCATION TempRegStatus}
	(**Status from temperature regulation*)
	TempRegStatus : BOOL;
	{LOCATION TimedOn}
	(**Status of timed function*)
	TimedOn : BOOL;
	{LOCATION tmpPassword}
	(**Mask field for password input*)
	tmpPassword : USINT;
	{LOCATION ToggleSetTimeAPP}
	(**Set date and time on RTC memory*)
	ToggleSetTimeAPP : BOOL := FALSE;
	{LOCATION ToggleSetTimeSPV}
	(**Set date and time on RTC memory by SPV/UI*)
	ToggleSetTimeSPV : BOOL;
	{LOCATION TotActAlm}
	(**Total actual alarm active*)
	TotActAlm : UINT;
	{LOCATION TotActStatus}
	(**Actual status notification to show*)
	TotActStatus : UINT;
	{LOCATION TotActWarning}
	(**Total actual warning active*)
	TotActWarning : UINT;
	{LOCATION UniqueID_SPV}
	UniqueID_SPV : ARRAY[0..7] OF USINT;
	{LOCATION UnitOn}
	(**Unit ON status
	 *0/1 : OFF/ON*)
	UnitOn : BOOL;
	{LOCATION UnitStatus}
	(**Unit status
	 *0 : Unit On,
	 *1 : Off By Alarm,
	 *2 : Off By Supervisor,
	 *3 : Off By Time Band,
	 *4 : Off By Digital Input,
	 *5 : Off By Keyboard,
	 *6 : Standby,
	 *7 : Clean,
	 *8 : Door Open,
	 *9 : Duty Settings,
	 *10 : Continuos Cycle,
	 *11 : Defrost;*)
	{METADATA MIN_VAL 0}
	{METADATA MAX_VAL 11}
	UnitStatus : USINT;
	{LOCATION UnitStatus_WorkingMode}
	{METADATA LIBRARY Libs.GenericFunctionMng}
	UnitStatus_WorkingMode : UNIT_STATUS_GEN_FCT;
	{LOCATION VirtualDI}
	(**Virtual Digital Input value from BMS*)
	VirtualDI : BOOL := FALSE;
	{LOCATION VirtualProbe}
	(**Virtual probe value used for temperature regulation*)
	{ATTRIBUTE UOM CELSIUS}
	VirtualProbe : REAL;
	{LOCATION VlvPresent}
	(**Expansion valve is configured in parameter P1*)
	VlvPresent : BOOL := FALSE;
	{LOCATION WizProgress}
	(**Currently a wizard is in progress*)
	WizProgress : BOOL;
	{LOCATION WrongPsw}
	(**Wrong password flag*)
	WrongPsw : BOOL;
        {LOCATION En_AlarmOverwrite}
    (**Enable overwite of the alarm digital output at runtime*)
    En_AlarmOverwrite : BOOL;
    {LOCATION Custom_AlarmOutput}
    (**Value used to overwrite the alarm digital output at runtime*)
    Custom_AlarmOutput : BOOL;
    {LOCATION En_AuxOutputOverwrite}
    (**Enable overwite of the auxiliary digital output at runtime*)
    En_AuxOutputOverwrite : BOOL;
    {LOCATION Custom_AuxOutput}
    (**Value used to overwrite the auxiliary digital output at runtime*)
    Custom_AuxOutput : BOOL;
    {LOCATION En_MstAuxOutputOverwrite}
    (**Enable overwite of the master auxiliary digital output at runtime*)
    En_MstAuxOutputOverwrite : BOOL;
    {LOCATION Custom_MstAuxOutput}
    (**Value used to overwrite the master auxiliary digital output at runtime*)
    Custom_MstAuxOutput : BOOL;
    {LOCATION En_LightOverwrite}
    (**Enable overwite of the light digital output at runtime*)
    En_LightOverwrite : BOOL;
    {LOCATION Custom_LightOutput}
    (**Value used to overwrite the light digital output at runtime*)
    Custom_LightOutput : BOOL;
    {LOCATION En_MstLightOverwrite}
    (**Enable overwite of the master light digital output at runtime*)
    En_MstLightOverwrite : BOOL;
    {LOCATION Custom_MstLightOutput}
    (**Value used to overwrite the master light digital output at runtime*)
    Custom_MstLightOutput : BOOL;
    {LOCATION En_FanstOverwrite}
    (**Enable overwite of the fans digital output at runtime*)
    En_FansOverwrite : BOOL;
    {LOCATION Custom_FansOutput}
    (**Value used to overwrite the fans digital output at runtime*)
    Custom_FansOutput : BOOL;
    {LOCATION En_TimedOutOverwrite}
    (**Enable overwite of the timed digital output at runtime*)
    En_TimedOutOverwrite : BOOL;
    {LOCATION Custom_TimedOutput}
    (**Value used to overwrite the timed digital output at runtime*)
    Custom_TimedOutput : BOOL;
    {LOCATION En_DrainHeaterOverwrite}
    (**Enable overwite of the Drain heater digital output at runtime*)
    En_DrainHeaterOverwrite : BOOL;
    {LOCATION Custom_DrainHeaterOutput}
    (**Value used to overwrite the Drain heater digital output at runtime*)
    Custom_DrainHeaterOutput : BOOL;
    {LOCATION En_RailHeaterOverwrite}
    (**Enable overwite of the Rail heater digital output at runtime*)
    En_RailHeaterOverwrite : BOOL;
    {LOCATION Custom_DrainHeaterOutput}
    (**Value used to overwrite the Rail heater digital output at runtime*)
    Custom_RailHeaterOutput : BOOL;
    {LOCATION En_GenFctStageOverwrite}
    (**Enable overwite of the Generic function stage digital output at runtime*)
    En_GenFctStageOverwrite : BOOL;
    {LOCATION Custom_GenFctStageOutput}
    (**Value used to overwrite the Generic function stage digital output at runtime*)
    Custom_GenFctStageOutput : BOOL;
    {LOCATION En_GenFctModulOverwrite}
    (**Enable overwite of the Generic function modulating analog output at runtime*)
    En_GenFctModulOverwrite : BOOL;
    {LOCATION Custom_GenFctModulOutput}
    (**Value used to overwrite the Generic function modulating analog output at runtime*)
    Custom_GenFctModulOutput : REAL;
    {LOCATION En_FansModulOverwrite}
    (**Enable overwrite of the fans analog output at runtime**)
    En_FansModulOverwrite : BOOL;
    {LOCATION Custom_FansModulOutput}
    (**Value used to overwrite the fans analog output at runtime**)
    Custom_FansModulOutput : REAL;
    {LOCATION En_ValveModulOverwrite}
    (**Enable overwrite of the valve analog output at runtime**)
    En_ValveModulOverwrite : BOOL;
    {LOCATION Custom_ValveModulOutput}
    (**Value used to overwrite the valve analog output at runtime**)
    Custom_ValveModulOutput : REAL;
    {LOCATION En_HeatersModulOverwrite}
    (**Enable overwrite of the rail heater analog output at runtime**)
    En_HeatersModulOverwrite : BOOL;
    {LOCATION Custom_HeatersModulOutput}
    (**Value used to overwrite the rail heater analog output at runtime**)
    Custom_HeatersModulOutput : REAL;
    
	{LOCATION DEFAULT}
END_VAR
VAR_GLOBAL CONSTANT
	{LOCATION DFR_CALL}
	(**Current defrost status is calling*)
	DFR_CALL : USINT := 1;
	{LOCATION DFR_CHECK_END}
	(**Current defrost status si CHECK END (wait for Secondaries)*)
	DFR_CHECK_END : USINT := 3;
	{LOCATION DFR_DFR}
	(**Current defrost status is DEFROST*)
	DFR_DFR : USINT := 2;
	{LOCATION DFR_DRIPPING}
	(**Current defrost status is DRIPPING*)
	DFR_DRIPPING : USINT := 4;
	{LOCATION DFR_IDLE}
	(**Current defrost status is IDLE*)
	DFR_IDLE : USINT := 0;
	{LOCATION DFR_POST_DRIPPING}
	(**Current defrost status is POST-DRIPPING*)
	DFR_POST_DRIPPING : USINT := 5;
	{LOCATION HACCP_Period}
	(**Period between HACCP log save*)
	HACCP_Period : TIME := TIME#1h;
	{LOCATION HW_ALARMS_TYPE}
	(**Alarm type category for hardware faults*)
	HW_ALARMS_TYPE : UINT := 2;
	{LOCATION MANUAL}
	MPX_MACHINE_STATUS_TEST : USINT := 0;
	{LOCATION MAX_AIN}
	(**Maximum AIN on ACU Platform*)
	MAX_AIN : USINT := 8;
	{LOCATION MAX_AIN_ADVANCED}
	(**Maximum number of phisical AIN for Advanced hardware*)
	MAX_AIN_ADVANCED : USINT := 8;
	{LOCATION MAX_AIN_BASIC}
	(**Maximum number of phisical AIN for Basic hardware*)
	MAX_AIN_BASIC : USINT := 3;
	{LOCATION MAX_AIN_MEDIUM}
	(**Maximum number of phisical AIN for Medium hardware*)
	MAX_AIN_MEDIUM : USINT := 6;
	{LOCATION MAX_DIN}
	(**Maximum DIN on ACU platform*)
	MAX_DIN : USINT := 6;
	{LOCATION MAX_DIN_ADVANCED}
	(**Maximum number of DIN on Advanced board*)
	MAX_DIN_ADVANCED : USINT := 5;
	{LOCATION MAX_DIN_BASIC}
	(**Maximum number of DIN on Basic board*)
	MAX_DIN_BASIC : USINT := 2;
	{LOCATION MAX_DIN_MEDIUM}
	(**Maximum number of DIN on Medium board*)
	MAX_DIN_MEDIUM : USINT := 2;
	{LOCATION MENU_ITEMS}
	(**Maximum number of menu items*)
	MENU_ITEMS : USINT := 8;
	{LOCATION PRB_ALARMS_TYPE}
	(**Alarm category for probe alarms*)
	PRB_ALARMS_TYPE : UINT := 1;
	{LOCATION REG_ALARMS_TYPE}
	(**Regulation type of alarms*)
	REG_ALARMS_TYPE : UINT := 4;
	{LOCATION REG_STATUS_TYPE}
	(**Regulation status on display*)
	REG_STATUS_TYPE : UINT := 16;
	{LOCATION REG_WARNINGS_TYPE}
	(**Warnign category*)
	REG_WARNINGS_TYPE : UINT := 8;
	{LOCATION REGULATION}
	MPX_MACHINE_STATUS_REGULATION : USINT := 2;
	{LOCATION SER_AIN}
	(**Number of serial inputs from BMS*)
	SER_AIN : USINT := 4;
	{LOCATION STAND_BY}
	STAND_BY : USINT := 3;
	{LOCATION StartupTime}
	StartupTime : TIME := TIME#10s;
	{LOCATION DEFAULT}
END_VAR