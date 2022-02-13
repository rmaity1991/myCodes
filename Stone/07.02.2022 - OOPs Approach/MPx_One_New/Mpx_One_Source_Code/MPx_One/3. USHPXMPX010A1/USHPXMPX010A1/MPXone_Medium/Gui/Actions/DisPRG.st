USING System;
USING System.UI;
USING HEOneRow;


FUNCTION DisPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR

    //DispMngInst.StartSync(DownloadDir#HMItoACU);
    NewDispPrompt := FALSE;
    GoToLoop(LoopList#Main);

END_FUNCTION
