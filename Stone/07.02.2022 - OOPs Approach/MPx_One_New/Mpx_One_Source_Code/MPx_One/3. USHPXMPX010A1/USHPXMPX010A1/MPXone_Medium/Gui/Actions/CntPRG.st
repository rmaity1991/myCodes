USING System;
USING System.UI;
USING HEOneRow;


FUNCTION CntPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    //DispMngInst.StartSync(DownloadDir#ACUtoHMI);
    NewDispPrompt := FALSE;
    GoToLoop(LoopList#Main);

END_FUNCTION
