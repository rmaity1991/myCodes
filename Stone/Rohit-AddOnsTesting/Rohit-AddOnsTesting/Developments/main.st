USING System.UI;


VAR_GLOBAL
    averageTesting: DFR_MOV_AVER;
    averageTesting1 : DFR_MOV_AVER_V1;
    randomValues : Randomizer;

END_VAR

PROGRAM main
	Display.Init();
	Display.Read();

	(* Insert strategy here *)

	Display.Write();
	
	(* Refresh UI *)
	SendVirtualKey(NO_KEY, 1);
    
{REGION}
    
    randomValues(Start := 10, Stop := 30);
    averageTesting.manual_sample_array[0] := 32.0;
    averageTesting.manual_sample_array[1] := 43.0;
    averageTesting.manual_sample_array[2] := 45.0;
    averageTesting.manual_sample_array[3] := 38.0;
    averageTesting.manual_sample_array[4] := 39.0;
        
    averageTesting(in_sample := randomValues.Out);
    
    averageTesting1(in_sample := randomValues.Out);

    
    
    
{ENDREGION}
    
    
END_PROGRAM