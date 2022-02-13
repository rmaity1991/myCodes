USING System;
USING System.UI;
USING HEOneRow;

FUNCTION WIZ_ENDPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    // Configure the probes
    Ain_Types.Group1 := tmpWiz.Fct._P1.usint;
    Ain_Types.Group2 := tmpWiz.Fct._P2.usint;
    Ain_Types.Group3 := tmpWiz.Fct._P3.usint;
    
    Ain_Cfg.Fct.SuctT.Ch := TO_SINT(tmpWiz.Fct._FD.usint);
    Ain_Cfg.Fct.EvapP.Ch := TO_SINT(tmpWiz.Fct._FE.usint);
    
    // Probe limits
    EvapMax := tmpWiz.Fct._UE.real;
    EvapMin := tmpWiz.Fct._LE.real;
    
    // Valve configuration
    ValveCnf := tmpWiz.Fct.P1.usint;
    RfrgTyp := TO_UINT(tmpWiz.Fct.PH.usint);
    
    // Configure protocols
    BMS_Addr := tmpWiz.Fct.H0.usint;
    BMS_Prot := tmpWiz.Fct.H3.bool;
    isMaster := tmpWiz.Fct.In.bool;
    SlavesNum := tmpWiz.Fct.Sn.usint;
    
    
    // Wizard flags to complete the procedure
    WizDone := TRUE;
    WizProgress := FALSE;
    blockHmi := TRUE;
    StartupReset := FALSE;
    
    // Force backup
    //RetainForceBackup();
    GoToLoop(LoopList#Main);
    //SoftwareReset(ResetMode#Warm);
    
    LedOnArrow := FALSE;

END_FUNCTION
