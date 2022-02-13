USING System;
USING System.UI;
USING HEOneRow;

FUNCTION MenuPRG
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    
    IF keyCounter >30 AND NOT blockHmi THEN 
        blockHmi := TRUE;
        
        IF currMenuLevel = 0 THEN 
            GoToMask(MaskList#mMain);
            
        ELSE
            CASE currMenu OF
                1: GoToMask(MaskList#VIS);
                2: GoToMask(MaskList#CTL);
                3: GoToMask(MaskList#DEF);
                4: GoToMask(MaskList#ALM);
                5: GoToMask(MaskList#FAN);
                6: GoToMask(MaskList#EVD);
                7: GoToMask(MaskList#CNF);
            ELSE
                GoToLoop(LoopList#Menu);
            END_CASE;
            
            currMenuLevel := 0;
        END_IF;
    END_IF;

END_FUNCTION
