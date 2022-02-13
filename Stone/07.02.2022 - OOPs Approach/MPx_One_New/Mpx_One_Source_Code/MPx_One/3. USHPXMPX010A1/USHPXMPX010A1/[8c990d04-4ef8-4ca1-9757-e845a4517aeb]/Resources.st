USING System;

(* 0 highest priority, 10 lowest *)
CONFIGURATION __CONFIGURATION__
	RESOURCE __RESOURCE__ ON RUNTIMETARGET

        TASK MainTask(INTERVAL := T#500ms, PRIORITY := 3);//, AUTOSTART := 0);
        PROGRAM GeneralMngInstance      WITH MainTask : LibraryNamespaceAndVersion.GeneralMng; //Clock (RTC + SPV), NFC (READ), Generations of function enable flags that depends on configuration
        PROGRAM UnitStatusMngInstance   WITH MainTask : LibraryNamespaceAndVersion.UnitStatusMng; //Unit status managemnt and Unit ON/OFF
        PROGRAM InputsMngInstance       WITH MainTask : LibraryNamespaceAndVersion.InputsMng;  //AIN + DIN + VirtualProbes + Input data conversion
        PROGRAM AlarmsMngInstance       WITH MainTask : LibraryNamespaceAndVersion.AlarmsMng;  //Alarms: delay + check condition
        //PROGRAM OnOffUnitMngInstance    WITH MainTask : OnOffUnitMng;   //Scheduler/Time band + OnOff Unit
        PROGRAM UnitStartUpMngInstance  WITH MainTask : LibraryNamespaceAndVersion.UnitStartUpMng; //Sequence of events preceding and following machine start-up
        PROGRAM MainRegMngInstance      WITH MainTask : LibraryNamespaceAndVersion.MainRegMng; //Temperature regulation
        PROGRAM DfrMngInstance          WITH MainTask : LibraryNamespaceAndVersion.DfrMng; //Defrost Management
        PROGRAM FanRegulationInstance   WITH MainTask : LibraryNamespaceAndVersion.FanRegMng;  //Evaporator fan management
        //PROGRAM CompressorMngInstance      WITH MainTask : CompresorMng; //Compressor timings, startup, shutdown
        PROGRAM ExvMngInstance          WITH MainTask : LibraryNamespaceAndVersion.ExvMng; //Evd managemnt: built-in and FB
        PROGRAM HeatersMngInstance      WITH MainTask : LibraryNamespaceAndVersion.HeatersMng; //Fan management: 0-10V or serial line
        PROGRAM OutputsMngInstance      WITH MainTask : LibraryNamespaceAndVersion.OutputsMng; //Digital outputs, Analogue outputs, test mode
        //PROGRAM AlarmsHistoryMng        WITH MainTask : AlarmsHistoryMng;   //Management of data logging
        
	END_RESOURCE
END_CONFIGURATION