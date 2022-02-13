USING System;
USING System.UI;

NAMESPACE HEOneRow

FUNCTION MenuPROGRAM_RELEASE
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR
    
    IF keyCounter < 30 AND NOT blockHmi THEN
        
        IF BasicVisualiz AND GetCurrentMask() = GetLastMaskInLoop(gui.currentLoop) THEN
            GoToMask(MaskList#mMain);
            BasicVisualiz := FALSE;
            LedOnArrow := FALSE;
            PrbVisualiz := FALSE;
            RETURN;
        END_IF;
        
        CASE currMenuLevel OF
            0: // At function selection
            
            IF isProdBasicVersion AND currMenu = 6 THEN
                currMenu := 7;
            END_IF;
            
            CASE currMenu OF
                1: GoToLoop(LoopList#VIS_Loop);
                2: GoToLoop(LoopList#CTL_Param);
                3: GoToLoop(LoopList#dEF_Param);
                4: GoToLoop(LoopList#ALM_menu);
                5: GoToLoop(LoopList#FAN_Param);
                {IF DEF(MPXONE_MEDIUM)}
                6: GoToLoop(LoopList#EVD_Param);
                {ENDIF}
                7: GoToLoop(LoopList#CNF_Param);
                8: GoToLoop(LoopList#rtC_Param);
            ELSE
                GoToLoop(LoopList#Menu);
            END_CASE;
            
            currMenuLevel := 1;
            
            1: // editing the value
            GoToNextField();
            
            // Or exiting
            IF GetCurrentMask() = GetLastMaskInLoop(gui.currentLoop) THEN
                CASE currMenu OF
                    1: GoToMask(MaskList#VIS);
                    2: GoToMask(MaskList#CTL);
                    3: GoToMask(MaskList#DEF);
                    4: GoToMask(MaskList#ALM);
                    5: GoToMask(MaskList#FAN);
                    6: GoToMask(MaskList#EVD);
                    7: GoToMask(MaskList#CNF);
                    8: GoToMask(MaskList#RtC);
                ELSE
                    GoToLoop(LoopList#Menu);
                END_CASE;
                
                currMenuLevel := 0;
                currMenu_SecondLev := 0;
            END_IF;
            
            2: // editing the value
            GoToNextField();
            
            // Or exiting
            IF GetCurrentMask() = GetLastMaskInLoop(gui.currentLoop) THEN
                CASE currMenu_SecondLev OF
                    0: GoToMask(MaskList#ALM_Param);
                    1: GoToMask(MaskList#ALM_Hyst);
                ELSE
                    GoToMask(MaskList#ALM);
                END_CASE;
                currMenu := 4;
                currMenuLevel := 1;
            END_IF;
            
        END_CASE;
        
        
    END_IF;
    
    blockHmi := FALSE;

END_FUNCTION
    
END_NAMESPACE