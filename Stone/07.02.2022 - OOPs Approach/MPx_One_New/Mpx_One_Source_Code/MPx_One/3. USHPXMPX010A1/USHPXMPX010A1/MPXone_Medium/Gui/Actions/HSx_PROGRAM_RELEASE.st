USING System;
USING System.UI;
USING HEOneRow;

FUNCTION HSx_PROGRAM_RELEASE
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    CASE GetCurrentMask() OF
        TO_UINT(MaskList#HS0) : IdxVis_AlrmHyst := 1;
        TO_UINT(MaskList#HS1) : IdxVis_AlrmHyst := 2;
        TO_UINT(MaskList#HS2) : IdxVis_AlrmHyst := 3;
        TO_UINT(MaskList#HS3) : IdxVis_AlrmHyst := 4;
        TO_UINT(MaskList#HS4) : IdxVis_AlrmHyst := 5;
        TO_UINT(MaskList#HS5) : IdxVis_AlrmHyst := 6;
        TO_UINT(MaskList#HS6) : IdxVis_AlrmHyst := 7;
        TO_UINT(MaskList#HS7) : IdxVis_AlrmHyst := 8;
        TO_UINT(MaskList#HS8) : IdxVis_AlrmHyst := 9;
        TO_UINT(MaskList#HS9) : IdxVis_AlrmHyst := 10;
    END_CASE;
    
   GoToMask(MaskList#ShowAlrmHyst);

END_FUNCTION
