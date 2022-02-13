{IF NOT DEF(NO_PLAN_SUPPORT)}

USING System;
USING System.Net.Plan;
USING System.Text;
USING System.UI;  

{DEFINE TERM_CONF_TIMEOUT   30 * 1000}

TYPE Terminal:
	STRUCT
		Address : UINT;
		Shared : BOOL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK TerminalsConfigFB
	VAR_INPUT
		keyPressed, keyCounter : UINT;
	END_VAR
	VAR_OUTPUT
		managed : BOOL;
	END_VAR
	VAR
		active, save, confirm: BOOL;
		activeTime : UDINT;
		str, temp : STRING;
		page, i, curTerm, curProp: INT;
		terminals : ARRAY [0..PLAN_MAX_TERMINALS - 1] OF Terminal;
	END_VAR

	// If state is not active, setup the initial state
	IF active = FALSE THEN
		active := TRUE;
		activeTime := GetSystemTime();
		save := FALSE;
		confirm := FALSE;
		page := 0;
		curTerm := 0;
		curProp := 0;
		ClearGraphics();
		
		// Retrieve the actual terminals configuration
		FOR i := 0 TO TO_INT(PLAN_MAX_TERMINALS) - 1 DO
			GetTerminalConfig(i, terminals[i].Address, terminals[i].Shared);
		END_FOR;
		
	END_IF;

	managed := TRUE;
	ClearTexts();
	HideCursor();
	
	// Refresh time every key
	IF keyPressed <> NO_KEY THEN
		activeTime := GetSystemTime();
	END_IF;
		
	IF keyPressed = KEY_ESC OR GetSystemTime() - activeTime > TERM_CONF_TIMEOUT THEN
		active := FALSE;
		page := 2;
	ELSE
		// Manage key per state
		CASE page OF
		0:
			CASE keyPressed OF
				KEY_ENTER:
					page := page + 1;
			END_CASE;
		1:
			CASE keyPressed OF
				KEY_UP:
					IF save THEN 
						confirm := NOT confirm;
					ELSIF curProp = 1 THEN
						terminals[curTerm].Shared := NOT terminals[curTerm].Shared;
					ELSE
						IF terminals[curTerm].Address >= TO_UINT(PLAN_MAX_ADDRESS) THEN
							terminals[curTerm].Address := 0;
						ELSE
							terminals[curTerm].Address := terminals[curTerm].Address + 1;
						END_IF;
					END_IF;
					
				KEY_DOWN:
					IF save THEN 
						confirm := NOT confirm;
					ELSIF curProp = 1 THEN
						terminals[curTerm].Shared := NOT terminals[curTerm].Shared;
					ELSE
						IF terminals[curTerm].Address = 0 THEN
							terminals[curTerm].Address := TO_UINT(PLAN_MAX_ADDRESS);
						ELSE
							terminals[curTerm].Address := terminals[curTerm].Address - 1;
						END_IF;
					END_IF;
					
				KEY_ENTER:
					IF save THEN
						IF confirm THEN		
							page := page + 1;
						ELSE
							save := FALSE;
						END_IF;
					ELSE 
						IF curProp = 1 THEN
							curProp := 0;
							curTerm := curTerm + 1;
						ELSIF terminals[curTerm].Address = 0 THEN
							curTerm := curTerm + 1;
						ELSE
							curProp := 1;
						END_IF;
						
						IF curTerm >= TO_INT(PLAN_MAX_TERMINALS) THEN
							curTerm := 0;
							save := TRUE;
						END_IF;
					END_IF;
			END_CASE;
		END_CASE;
	END_IF;
	
	// Draw the specified state
	CASE page OF
	0:
		str := ' Terminals Config. ';
		DrawString(str, 1, 1);
		str := '> ENTER to continue';
		DrawString(str, 3, 1);
		str := '> ESC   to discard';
		DrawString(str, 4, 1);
	1:
		str := ' Term | Addr | Share ';
		DrawString(str, 1, 0);
		
		// Draw terminals configuration
		FOR i := 0 TO TO_INT(PLAN_MAX_TERMINALS) - 1 DO
			
			str := '  --  |  --  |  ---  ';
			
			temp := FORMAT('%2d', i + 1);
			str := REPLACE(str, temp, 2, 2);
			
			IF terminals[i].Address <> 0 THEN
				temp := FORMAT('%2d', terminals[i].Address);
				str := REPLACE(str, temp, 2, 9);
				
				IF terminals[i].Shared = 1 THEN
					str := REPLACE(str, 'yes', 3, 16);
				ELSE
					str := REPLACE(str, ' no', 3, 16);
				END_IF;
			END_IF;
			
			DrawString(str, 2 + i, 0);
		END_FOR;
		
		str := FORMAT('PCO: %2d', GetPlanAddress());
		DrawString(str, 6, 1);
	
		IF confirm THEN
			str := CONCAT('Save?', 'yes');
		ELSE
			str := CONCAT('Save?', ' no');
		END_IF;
		DrawString(str, 6, 11);
		
		// Set the cursor position
		IF save THEN
			SetCursor(6, 18);
		ELSE
			SetCursor(2 + curTerm, 10 + curProp * 8);
		END_IF;
		
	2:
		// Send the new terminals configuration
		IF active THEN
			// Restore the not active state
			active := FALSE;
			
			// Set the modified configuration
			FOR i := 0 TO TO_INT(PLAN_MAX_TERMINALS) - 1 DO
				SetTerminalConfig(i, terminals[i].Address, terminals[i].Shared);
			END_FOR;
			
		END_IF;
		
		// End the configuration procedure in any case!
		EndTerminalsConfig();

		// Require the menage of request by previous normal state
		managed := FALSE;
	END_CASE;
	
END_FUNCTION_BLOCK

{ENDIF}
