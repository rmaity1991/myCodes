{IF NOT DEF(NO_SYSTEM_MENU)}

USING Carel.Views;
USING System;
USING System.Math;
{IF NOT DEF(NO_TCP_SUPPORT)}
USING System.Net.TcpIp;
{ENDIF}
{IF NOT DEF(NO_PLAN_SUPPORT)}
USING System.Net.Plan;
{ENDIF}
USING System.Serial;
USING System.Text;
USING System.Timer; 
USING System.UI;
USING System.Util;

{REGION Defines}

//Menu UI
{DEFINE MNU_SYSTEM_MENU 				'SYSTEM MENU'}
                                		
//Submenu SYSTEM MENU           		
{DEFINE MNU_INFO        				'INFO'}
{DEFINE MNU_SETTINGS    				'SETTINGS'}
{DEFINE MNU_APPLICATION 				'APPLICATION'}
{DEFINE MNU_UPGRADE     				'UPGRADE'}
{DEFINE MNU_TOOLS       				'TOOLS'}
                                		
//Submenu INFO                  		
{DEFINE MNU_FIRMWARE 					'FIRMWARE VER'}
{DEFINE MNU_MEMORY   					'MEMORY'}
{DEFINE MNU_TCPIP    					'TCP-IP'}
{DEFINE MNU_PLAN     					'PLAN NETWORK'}
{DEFINE MNU_BMS2     					'BMS2'}
{DEFINE MNU_PROJ     					'PROJECT'}
{DEFINE MNU_SNAPSHOT     				'SNAPSHOT'}
                           		
//Labels TCPIP                  		
{DEFINE LBL_IP_ADDR  					'IP'}
{DEFINE LBL_MAC_ADDR 					'MAC ADDRESS'}
                                		
//Labels BMS2                   		
{DEFINE LBL_BMS2_BAUDRATE     			'BAUDRATE:'}
{DEFINE LBL_BMS2_BITS         			'BITS:'}
{DEFINE LBL_BMS2_PARITY       			'PARITY:'}
{DEFINE LBL_BMS2_STOPBITS     			'STOP BITS:'}
{DEFINE LBL_BMS2_PARITY_NONE  			'NONE'}
{DEFINE LBL_BMS2_PARITY_ODD   			'ODD'}
{DEFINE LBL_BMS2_PARITY_EVEN  			'EVEN'}
{DEFINE LBL_BMS2_MODBUSNODE   			'MODBUS NODE:'}
{DEFINE LBL_BMS2_IDE_ONLY     			'IDE ONLY'}
{DEFINE LBL_BMS2_IDE_SHARED   			'IDE SHARED'}
{DEFINE LBL_BMS2_IDE_DISABLED 			'IDE DISABLED'}
                                		
//Labels PROJ                   		
{DEFINE LBL_PROJ_VER    				'Version: '}
{DEFINE LBL_PROJ_AUTHOR 				'Author: '}
{DEFINE LBL_PROJ_VENDOR 				'Vendor: '}
{DEFINE LBL_PROJ_BUILD  				'Build: '}

{DEFINE LBL_SNAPSHOT                    'Snapshot Info'}
{DEFINE LBL_SNAPSHOT_NOT_PRESENT  		'Snapshot not Present'}
{DEFINE LBL_SNAPSHOT_VER  				'Version :'}
{DEFINE LBL_SNAPSHOT_DATE  				'Creation Date :'}
										
{DEFINE EDT_COM_GENERIC_MSG1 			'Press Enter to Execute'}
{DEFINE EDT_COM_GENERIC_MSG2 			'or ESC to Cancel'}
{DEFINE EDT_PLAN_ADDRESS_TEXT 			'PLAN ADDRESS'}
                                		
{DEFINE EDT_MODBUS_NODE_TEXT  			'MODBUS NODE'}
{DEFINE EDT_MODBUS_NODE_INFO1 			'Modbus ID for IDE'}
{DEFINE EDT_MODBUS_NODE_INFO2 			'connection'}
                                		
{DEFINE EDT_DATE_TIME_TEXT 				'DATE & TIME'}
{DEFINE LBL_DATE_TIME_CUR  				'Current:'}
{DEFINE LBL_DATE_TIME_NEW  				'New:'}
                                		
{DEFINE EDT_COM_IDE_ONLY_TEXT  			'FORCE IDE ONLY'}
{DEFINE EDT_COM_IDE_ONLY_INFO1 			'Force serial BMS2 COM'}
{DEFINE EDT_COM_IDE_ONLY_INFO2 			'in Debug IDE ONLY mode'}
                                		
{DEFINE LBL_UP_TIME      				'UP TIME'}
{DEFINE LBL_CURRENT_TIME 				'CURRENT TIME:'}
{DEFINE LBL_START_TIME   				'START TIME:'}
{DEFINE LBL_WORKING_TIME 				'WORKING TIME:'}

{DEFINE EDT_COM_CLEAR_SETTINGS_TEXT   	'CLEAR SETTINGS'}
{DEFINE EDT_COM_CLEAR_SETTINGS_INFO1 	'Reset device and user'}
{DEFINE EDT_COM_CLEAR_SETTINGS_INFO2 	'settings to defaults'}

{DEFINE LBL_LOGS                        'LOGS'}

{DEFINE LBL_WIPE_RETAIN                 'WIPE RETAIN DATA'}
{DEFINE LBL_PRESS_ENTER_TO_WIPE         'Press enter to wipe'}
{DEFINE LBL_RETAIN_DATA                 'Retain Data'}
{DEFINE LBL_WIPED_DATA                  'Wipe complete!'}

{DEFINE EDT_BULTIN   				    'BULT-IN'}
{DEFINE LBL_EDT_BULTIN_1 				'Backlight: '}
{DEFINE LBL_EDT_BULTIN_2 				'Timeout enabled: '}
{DEFINE LBL_EDT_BULTIN_3 				'Timeout seconds: '}
{DEFINE LBL_EDT_BULTIN_4 				'Key buzzer: '}
                                		
{DEFINE EDT_IP_SETTINGS					'TCP-IP'}

//Column indexes for IP SETTINGS grid positioning
{DEFINE IPCOL1 							8}
{DEFINE IPCOL2 							12}
{DEFINE IPCOL3 							16}
{DEFINE IPCOL4 							20}

//Row indexes for IP SETTINGS grid positioning
{DEFINE IPROW_DHCP    					1}
{DEFINE IPROW_IP      					2}
{DEFINE IPROW_SUBMASK 					3}
{DEFINE IPROW_GETAWAY 					4}
{DEFINE IPROW_DNS1    					5}
{DEFINE IPROW_DNS2    					6}
{DEFINE IPROW_SAVE    					7}

{DEFINE YES_LBL       					'YES'}
{DEFINE NO_LBL        					'NO'}
{DEFINE SAVE_LBL      					'SAVE?'}
{DEFINE SAVED_LBL     					'SAVED'}
{DEFINE NOT_SAVED_LBL 					'NOT SAVED'}

{DEFINE EDT_MODBUS_NODE_MIN   		    1}
{DEFINE EDT_MODBUS_NODE_MAX             247}
{DEFINE EDT_MODBUS_NODE_DEF   		    127}
{DEFINE SYSTEM_MENU_TIMEOUT 		    30 * 1000} // 30 sec

(* Virtual keys to represent enter and exit of views *)
{DEFINE KEY_SHOW 					    16#100}
{DEFINE KEY_CLOSE                       16#101}

{ENDREGION}

FUNCTION_BLOCK SystemMenuFB
	VAR_INPUT
		keyPressed, keyCounter : UINT;
		startTime : DATE_AND_TIME;
	END_VAR
	VAR_OUTPUT
		managed : BOOL;
	END_VAR
	VAR
		active : BOOL;
		activeTime: UDINT;
		i, view, count, selected, userFont : INT;
		entries : ARRAY[0..7] OF STRING[TEXT_LINE_LENGTH];
		
		builtInSettingsView : BuiltInSettingsView;
		crashInfoView : CrashInfoView;
		dateSettingsView : DateSettingsView;
		modbusClearSettingsView : ModbusClearSettingsView;
		modbusModeSettingsView : ModbusModeSettingsView;
		modbusNodeSettingsView : ModbusNodeSettingsView;
{IF NOT DEF(NO_PLAN_SUPPORT)}
		planInfoView : PlanInfoView;
		planSettingsView : PlanSettingsView;
{ENDIF}
		projectInfoView : ProjectInfoView;
		snapshotInfoView : SnapshotInfoView;
		serialInfoView : SerialInfoView;
		systemInfoView : SystemInfoView;
		systemUptimeView : systemUptimeView;
{IF NOT DEF(NO_TCP_SUPPORT)}
		tcpIpSettingsView : TcpIpSettingsView;
{ENDIF}
		logListView : LogListView;
        wipeRetainView : WipeRetainView;
	END_VAR
	
	IF active = FALSE THEN
		active := TRUE;
		userFont := GetCurrentFont();
		SetFontEmbedded(0);
		keyPressed := KEY_SHOW;
		view := 1;
		count := 0;
		selected := 0;
		HideCursor();
	END_IF;
	
	// Refresh active time every key
	IF keyPressed <> NO_KEY THEN
		activeTime := GetSystemTime();
	END_IF;
	
	IF GetSystemTime() - activeTime > SYSTEM_MENU_TIMEOUT THEN
		keyPressed := KEY_CLOSE;
		HideCursor();
	END_IF;
	
	REPEAT
		managed := TRUE;
	
		(* Restore System menu font size *)
		FOR i := 0 TO 7 DO
			SetFontSize(i, 1);
		END_FOR;
		
		ClearTexts();
		ClearGraphics();
		
		IF count > 0 THEN
			CASE keyPressed OF
			KEY_UP:
				selected := selected - 1;
				IF selected < 0 THEN
					selected := count - 1;
				END_IF;
			KEY_DOWN:
				selected := selected + 1;
				IF selected >= count THEN
					selected := 0;
				END_IF;
			KEY_ENTER:
				keyPressed := KEY_SHOW;
				view := view * 10 + selected;
				count := 0;
				selected := 0;
			END_CASE;
		END_IF;
		
		CASE view OF
		0:
			// Exit from system menu
			keyPressed := KEY_CLOSE;
			
		1:
			IF keyPressed = KEY_SHOW THEN
				count := 5;
				entries[0] := MNU_INFO;
				entries[1] := MNU_SETTINGS;
				entries[2] := MNU_APPLICATION;
				entries[3] := MNU_UPGRADE;
				entries[4] := MNU_TOOLS;
			END_IF;
			DrawStringAligned(MNU_SYSTEM_MENU, 0, TextAlignment#Center);
			
		//  ---   INFORMATION   ---
		10:
			IF keyPressed = KEY_SHOW THEN
				count := 7;
				entries[0] := MNU_FIRMWARE;
				entries[1] := MNU_MEMORY;
				entries[2] := MNU_TCPIP;
				entries[3] := MNU_PLAN;
				entries[4] := MNU_BMS2;
				entries[5] := MNU_PROJ;
				entries[6] := MNU_SNAPSHOT;
			END_IF;
			DrawStringAligned(MNU_INFO, 0, TextAlignment#Center);
		
		100:
			DrawStringAligned(MNU_FIRMWARE, 0, TextAlignment#Center);
			systemInfoView(keyPressed := keyPressed);
			
		101:
			DrawStringAligned(MNU_MEMORY, 0, TextAlignment#Center);
			
		102:
			DrawStringAligned(MNU_TCPIP, 0, TextAlignment#Center);
{IF NOT DEF(NO_TCP_SUPPORT)}
			DrawString(LBL_IP_ADDR, 1,0);
			DrawString(GetIpAddressAsString(),2,0);
			DrawString(LBL_MAC_ADDR,3,0);
			DrawString(GetHWAddressAsString(),4,0);
{ENDIF}			
		103:
			DrawStringAligned(MNU_PLAN, 0, TextAlignment#Center);
{IF NOT DEF(NO_PLAN_SUPPORT)}
			planInfoView(keyPressed := keyPressed);
{ENDIF}

		104:
			DrawStringAligned(MNU_BMS2, 0, TextAlignment#Center);
			serialInfoView(keyPressed := keyPressed);
			
		105:
			projectInfoView(keyPressed := keyPressed);
		106:
			snapshotInfoView(keyPressed := keyPressed);
			
		//  ---    SETTINGS     ---
		11:
			IF keyPressed = KEY_SHOW THEN
				count := 5;
				entries[0] := EDT_PLAN_ADDRESS_TEXT;
				entries[1] := EDT_MODBUS_NODE_TEXT;
				entries[2] := EDT_DATE_TIME_TEXT;
				entries[3] := EDT_BULTIN;
				entries[4] := EDT_IP_SETTINGS;
			END_IF;
			HideCursor();
			DrawStringAligned(MNU_SETTINGS, 0, TextAlignment#Center);
			
		//  ---    SETTINGS/PLAN ADDRESS     ---
		110:
			DrawStringAligned(EDT_PLAN_ADDRESS_TEXT, 0, TextAlignment#Center);
{IF NOT DEF(NO_PLAN_SUPPORT)}
			planSettingsView(keyPressed := keyPressed);
{ENDIF}
			
		//  ---    SETTINGS/MODBUS ID ---
		111:
			DrawStringAligned(EDT_MODBUS_NODE_TEXT, 0, TextAlignment#Center);
			modbusNodeSettingsView(keyPressed := keyPressed);
			
		//  ---    SETTINGS/DATE & TIME ---
		112:
			DrawStringAligned(EDT_DATE_TIME_TEXT, 0, TextAlignment#Center);
			dateSettingsView(keyPressed := keyPressed);
			
		//  ---    SETTINGS/BUILTIN ---		
		113:
			DrawStringAligned(EDT_BULTIN, 0, TextAlignment#Center);
			builtinSettingsView(keyPressed := keyPressed);
			
		//  ---    SETTINGS/TCP-IP ---
		114:
			DrawStringAligned(EDT_IP_SETTINGS, 0, TextAlignment#Center);
{IF NOT DEF(NO_TCP_SUPPORT)}
			tcpIpSettingsView(keyPressed := keyPressed, keyCounter:=keyCounter);
{ENDIF}
		
		//  ---   APPLICATION   ---
		12:
			DrawStringAligned(MNU_APPLICATION, 0, TextAlignment#Center);
			crashInfoView(keyPressed := keyPressed);
		
		//  ---     UPGRADE     ---
		13:
			DrawStringAligned(MNU_UPGRADE, 0, TextAlignment#Center);
		
		//  ---      TOOLS      ---
		14:
			IF keyPressed = KEY_SHOW THEN
				count := 5;
				entries[0] := EDT_COM_IDE_ONLY_TEXT;
				entries[1] := LBL_UP_TIME;
				entries[2] := EDT_COM_CLEAR_SETTINGS_TEXT;
				entries[3] := LBL_LOGS;
                entries[4] := LBL_WIPE_RETAIN;
			END_IF;
			DrawStringAligned(MNU_TOOLS, 0, TextAlignment#Center);
			
		//  ---    TOOLS/COM IDE ONLY     ---
		140:
			DrawStringAligned(EDT_COM_IDE_ONLY_TEXT, 0, TextAlignment#Center);
			modbusModeSettingsView(keyPressed := keyPressed);
					
		141:
			DrawStringAligned(LBL_UP_TIME, 0, TextAlignment#Center);
			systemUptimeView(keyPressed := keyPressed, startTime := startTime);
			
		142:
			DrawStringAligned(EDT_COM_CLEAR_SETTINGS_TEXT, 0, TextAlignment#Center);
			modbusClearSettingsView(keyPressed := keyPressed);
		143:
			DrawStringAligned(LBL_LOGS, 0, TextAlignment#Center);
			logListView(keyPressed := keyPressed);
        144:
            DrawStringAligned(LBL_WIPE_RETAIN, 0, TextAlignment#Center);
            wipeRetainView(keyPressed := keyPressed);
		END_CASE;
		
		IF count > 0 THEN
			DrawMenuList(entries, count, selected, 2);
		END_IF;
		
		IF keyPressed = KEY_ESC THEN
			managed := FALSE;
			keyPressed := KEY_SHOW;
			selected := view MOD 10;
			view := view / 10;
			count := 0;
		END_IF;
		
	UNTIL NOT managed END_REPEAT;

	IF keyPressed = KEY_CLOSE THEN
		//Restore user font
		SetFontEmbedded(userFont);
		ClearTexts();
		ClearGraphics();
		managed := FALSE;
		active := FALSE;
	END_IF;

END_FUNCTION_BLOCK

NAMESPACE Carel.Views

{REGION Views}
FUNCTION_BLOCK BuiltInSettingsView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR
		backlight, prevBacklight : USINT;
		timeout, prevTimeout : UINT;
        buzzer, prevBuzzer : BOOL;
		curPos : USINT;
	END_VAR
	
	CASE keyPressed OF
	KEY_SHOW:
		timeout := GetBuiltInBacklightTimeout();
		backlight := GetBuiltInBacklight();
        buzzer := GetBuiltInKeyBuzzer();
		prevTimeout := timeout;
		prevBacklight := backlight;
        prevBuzzer := buzzer;
		SetCursor(2, 17);
		curPos := 0;
	
	KEY_UP:
		CASE curPos OF
		0: 
			IF backlight <> 100 THEN
				backlight := backlight + 5;
			END_IF;
		1:
			IF timeout = 0 THEN
				timeout := 1;
			ELSE
				timeout := 0;
			END_IF;
		2:
			IF timeout <> 60 THEN
				timeout := timeout + 1;
			END_IF;
        3:
            buzzer := NOT buzzer;
		END_CASE;
		
	KEY_DOWN:
		CASE curPos OF
		0: 
			IF backlight <> 0 THEN
				backlight := backlight - 5;
			END_IF;
		1:
            IF timeout = 0 THEN
				timeout := 1;
			ELSE
				timeout := 0;
			END_IF;
		2:
			IF timeout <> 1 THEN
				timeout := timeout - 1;
			END_IF;
        3: 
            buzzer := NOT buzzer;
		END_CASE;
		
	KEY_ENTER:
		CASE curPos OF
		0:
			curPos := 1;
			SetCursor(3, 17);
		1:
			IF timeout <> 0 THEN
                curPos := 2;
				SetCursor(4, 17);
            ELSE
                curPos := 3;
				SetCursor(5, 17);
			END_IF;
		2:
			curPos := 3;
			SetCursor(5, 17);
        3:
            curPos := 0;
			SetCursor(2, 17);
		END_CASE;
		
	KEY_ESC,
	KEY_CLOSE:
		SetBuiltInBacklight(prevBacklight);
		SetBuiltInBacklightTimeout(prevTimeout);
        SetBuiltInKeyBuzzer(prevBuzzer);
		RETURN;
		
	KEY_PRG:
		prevBacklight := backlight;
		prevTimeout := timeout;
        prevBuzzer := buzzer;
		SaveBuiltInSettings();
	END_CASE;
	
	DrawString(LBL_EDT_BULTIN_1, 2, 0);
    DrawString(TO_STRING(backlight) + '%', 2, 17);
    DrawString(LBL_EDT_BULTIN_2, 3, 0);
    
    IF timeout <> 0 THEN
		DrawString(YES_LBL, 3, 17);
        DrawString(LBL_EDT_BULTIN_3, 4, 0);
		DrawString(TO_STRING(timeout), 4, 17);
	ELSE
		DrawString(NO_LBL, 3, 17);
	END_IF;
    
    DrawString(LBL_EDT_BULTIN_4, 5, 0);
    DrawString(TO_STRING(buzzer), 5, 17);
    
	DrawStringAligned('Press PROGRAM to save.', 7, TextAlignment#Center);
	
	SetBuiltInBacklight(backlight);
	SetBuiltInBacklightTimeout(timeout);
    SetBuiltInKeyBuzzer(buzzer);
	
END_FUNCTION_BLOCK

FUNCTION_BLOCK CrashInfoView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR_TEMP
		lastError : VMLastError;
	END_VAR
	
	CASE keyPressed OF
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	IF GetLastError(LastError) = 1 THEN
		DrawString('Last crash info', 1, 0);
		DrawString('Err code: 0x' + FORMAT('%X', LastError.errorCode), 2, 0);
		DrawString('POU ID:     ' + FORMAT('%d', LastError.pouID), 3, 0);
		DrawString('OFFSET:     ' + FORMAT('%d', LastError.PouOffset), 4, 0);
		DrawString('TIME:       ', 5, 0);
		DrawString(TO_STRING(LastError.time), 6, 0);
	ELSE
		DrawString('No recent crash', 1, 0);
	END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK DateSettingsView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR
		YYYY, MM, DD, hh, minute, ss, milliseconds : UINT;
		dateTime, tmpDT : DATE_AND_TIME;
		cursor : ARRAY [0..1] OF INT := [5, 4]; // [Row, Column] - [y, x]
		getInstantTime : BOOL := TRUE;
		signFlag : BOOL;
		yesNoLBL : STRING[4] := NO_LBL;
		err : UINT;
		errStr : STRING[TEXT_LINE_LENGTH];
	END_VAR
	
	CASE keyPressed OF
	KEY_UP,
	KEY_DOWN:
		CASE keyPressed OF
		KEY_UP:
			signFlag := TRUE;
		KEY_DOWN:
			signFlag := FALSE;
		END_CASE;
		CASE cursor[0] OF			// Cursor positions := [[5, (4, 7, 10, 13, 16, 19)], [7, 7]]
		5:						// Change selected date and time value
			CASE cursor[1] OF
			4:
				SetYear(YYYY, signFlag);
			7:
				SetMonth(YYYY, MM, signFlag);
			10:
				SetDay(YYYY, MM, DD, signFlag);
			13:
				SetHour(YYYY, MM,DD, hh, signFlag);
			16:
				SetMin(YYYY, MM,DD, hh,minute, signFlag);
			19:
				SetSec(YYYY, MM, DD, hh, minute, ss, signFlag);
			END_CASE;
		
		7:						// Change YES/NO Save options
			CASE keyPressed OF
			KEY_UP, KEY_DOWN:
				IF yesNoLBL = YES_LBL THEN
					yesNoLBL := NO_LBL;
				ELSE
					yesNoLBL := YES_LBL;
				END_IF;
			END_CASE;
		END_CASE;
		
	KEY_ENTER:						// Save changes
		IF cursor[0] = 7 AND yesNoLBL = YES_LBL THEN
			dateTime := CONCAT_DT(YYYY, MM, DD, hh, minute, ss, milliseconds);
			err := SetTime(dateTime);
			yesNoLBL := NO_LBL;
			IF err = 0 THEN
				errStr := '';
			ELSE
				errStr := CONCAT('E:', TO_STRING(err));
			END_IF;
			cursor[0] := 5;
			cursor[1] := 4;
			getInstantTime := TRUE;
		ELSE	// Switch cursor position
			SwitchSetHourCursor(cursor);
		END_IF;
		
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
		
	END_CASE;
	
	DrawStringAligned(LBL_DATE_TIME_CUR, 1, TextAlignment#Center);
	GetTime(dateTime);
	DrawStringAligned(TO_STRING(dateTime), 2, TextAlignment#Center);
	IF getInstantTime THEN
		SPLIT_DT(dateTime, YYYY, MM, DD, hh, minute, ss, milliseconds);
		getInstantTime := FALSE;
	END_IF;
	DrawStringAligned(LBL_DATE_TIME_NEW, 3, TextAlignment#Center);
	DrawStringAligned('YYYY/MM/DD hh:mm:ss', 4, TextAlignment#Center);
	SetCursor(cursor[0], cursor[1]);
	tmpDT := CONCAT_DT(YYYY, MM, DD, hh, minute, ss, milliseconds);
	DrawStringAligned(TO_STRING(tmpDT), 5, TextAlignment#Center);
	DrawString('Save?', 7, 0);
	DrawString(yesNoLBL, 7, 7);
	DrawStringAligned(errStr, 7, TextAlignment#Right);
END_FUNCTION_BLOCK

FUNCTION_BLOCK ModbusClearSettingsView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR

	CASE keyPressed OF
	KEY_ENTER:
		ClearSettings();
		keyPressed := KEY_ESC;
		RETURN;
		
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	DrawStringAligned(EDT_COM_GENERIC_MSG1, 2, TextAlignment#Center);
	DrawStringAligned(EDT_COM_GENERIC_MSG2, 3, TextAlignment#Center);
	
	DrawStringAligned(EDT_COM_CLEAR_SETTINGS_INFO1, 6, TextAlignment#Center);
	DrawStringAligned(EDT_COM_CLEAR_SETTINGS_INFO2, 7, TextAlignment#Center);
END_FUNCTION_BLOCK

FUNCTION_BLOCK ModbusModeSettingsView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR

	CASE keyPressed OF
	KEY_ENTER:
        {IF DEF (PCO_MINI)}
		SetModbusDebugOnly(Serial_Channel#FBUS1);
        {ELSE}
        SetModbusDebugOnly(Serial_Channel#BMS2);
        {ENDIF}
		keyPressed := KEY_ESC;
		RETURN;
		
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	DrawStringAligned(EDT_COM_GENERIC_MSG1, 2, TextAlignment#Center);
	DrawStringAligned(EDT_COM_GENERIC_MSG2, 3, TextAlignment#Center);
	
	DrawStringAligned(EDT_COM_IDE_ONLY_INFO1, 6, TextAlignment#Center);
	DrawStringAligned(EDT_COM_IDE_ONLY_INFO2, 7, TextAlignment#Center);
END_FUNCTION_BLOCK

FUNCTION_BLOCK ModbusNodeSettingsView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR
		node : USINT;
	END_VAR
	VAR_TEMP
		str : STRING[TEXT_LINE_LENGTH];
	END_VAR
	
	CASE keyPressed OF
	KEY_UP:
		IF node + 1 <= EDT_MODBUS_NODE_MAX THEN
			node := node + 1;
		END_IF;
		
	KEY_DOWN:
		IF node - 1 >= EDT_MODBUS_NODE_MIN THEN
			node := node - 1;
		END_IF;
		
	KEY_SHOW:
        {IF DEF (PCO_MINI)}
		node := GetModbusDebugID(Serial_Channel#FBUS1);
        {ELSE}
        node := GetModbusDebugID(Serial_Channel#BMS2);
        {ENDIF}
		
	KEY_ENTER:
        {IF DEF (PCO_MINI)}
		SetModbusDebugID(TO_USINT(node),Serial_Channel#FBUS1); 
        {ELSE}
        SetModbusDebugID(TO_USINT(node),Serial_Channel#BMS2);
        {ENDIF}
        keyPressed := KEY_ESC;
		RETURN;
		
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	//Show current value
	str := '>>>  ' + TO_STRING(node) + '  <<<';
	DrawStringAligned(str, 2, TextAlignment#Center);	
	
	str := 'Range:' +
		TO_STRING(EDT_MODBUS_NODE_MIN) + '-' +
		TO_STRING(EDT_MODBUS_NODE_MAX) + ' Def.:' +
		TO_STRING(EDT_MODBUS_NODE_DEF);
	
	DrawStringAligned(str, 4, TextAlignment#Center);
	DrawStringAligned(EDT_MODBUS_NODE_INFO1, 6, TextAlignment#Center);
	DrawStringAligned(EDT_MODBUS_NODE_INFO2, 7, TextAlignment#Center);
	
END_FUNCTION_BLOCK

FUNCTION_BLOCK SerialInfoView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR_TEMP
		serSettings: SerialSettings;
	END_VAR
	
	CASE keyPressed OF
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	serSettings := SerialGetSettings();
	DrawString(LBL_BMS2_BAUDRATE,2,0); 
	DrawString(TO_STRING(serSettings.Speed),2 ,13);
	DrawString(LBL_BMS2_BITS,3,0);
	DrawString(TO_STRING(serSettings.Bits),3 ,13);
	DrawString(LBL_BMS2_PARITY,4,0);
	CASE serSettings.Parity OF
	0:
		DrawString(LBL_BMS2_PARITY_NONE,4 ,13);
	1:
		DrawString(LBL_BMS2_PARITY_ODD,4 ,13);
	2:
		DrawString(LBL_BMS2_PARITY_EVEN,4 ,13);
	END_CASE;
	DrawString(LBL_BMS2_STOPBITS,5,0);
	DrawString(TO_STRING(serSettings.Stops),5 ,13);
	DrawString(LBL_BMS2_MODBUSNODE,6,0);
    {IF DEF (PCO_MINI)}
	DrawString(TO_STRING(GetModbusDebugID(Serial_Channel#FBUS1)),6 ,13);
    {ELSE}
    DrawString(TO_STRING(GetModbusDebugID(Serial_Channel#BMS2)),6 ,13);
    {ENDIF}
    {IF DEF (PCO_MINI)}
	CASE GetModbusDebugMode(Serial_Channel#FBUS1) OF
    {ELSE}
    CASE GetModbusDebugMode(Serial_Channel#BMS1) OF
    {ENDIF}
	0:
		DrawStringAligned(LBL_BMS2_IDE_ONLY,7, TextAlignment#Center);
	1:
		DrawStringAligned(LBL_BMS2_IDE_SHARED,7, TextAlignment#Center);
	2:
		DrawStringAligned(LBL_BMS2_IDE_DISABLED,7, TextAlignment#Center);
	END_CASE;
END_FUNCTION_BLOCK

FUNCTION_BLOCK ProjectInfoView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR_TEMP
		projectInfo : ProjectInfo;
		str : STRING[TEXT_LINE_LENGTH];
	END_VAR
	
	CASE keyPressed OF
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	GetProjectInfo(projectInfo);
	
	DrawStringAligned(projectInfo.AppName, 0, TextAlignment#Center);
	DrawString(LBL_PROJ_AUTHOR + projectInfo.Author, 2, 0); 
	DrawString(LBL_PROJ_VENDOR + projectInfo.Vendor, 3, 0); 
	
	str := LBL_PROJ_VER + 
		FORMAT('%d.', projectInfo.VersionMajor) +
		FORMAT('%d.', projectInfo.VersionMinor) +
		FORMAT('%d ', projectInfo.VersionBuild);
    
	IF TO_BYTE(projectInfo.VersionType) > 0 THEN
		str := str + FORMAT('%c', projectInfo.VersionType);
	END_IF;
		
	DrawString(str, 4, 0); 
	
	str := LBL_PROJ_BUILD +
		TO_STRING(TO_INT(projectInfo.BuildDay)) +'/' +
		FORMAT('%02d', TO_INT(projectInfo.BuildMonth)) + '/' +
		TO_STRING(TO_INT(projectInfo.BuildYear));
		
	DrawString(str, 5, 0);
	
	str := TO_STRING(TO_INT(projectInfo.BuildHour)) + ':' +
		FORMAT('%02d', TO_INT(projectInfo.BuildMinute)) + ':' +
		FORMAT('%02d', TO_INT(projectInfo.BuildSecond));
		
	DrawString(str, 6, TO_INT(LEN(LBL_PROJ_BUILD)));
END_FUNCTION_BLOCK

FUNCTION_BLOCK SnapshotInfoView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR_TEMP
		snapshotInfo : SnapshotInfo;
	END_VAR
	
	CASE keyPressed OF
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	GetSnapshotInfo(0, snapshotInfo);
	
	DrawStringAligned(LBL_SNAPSHOT, 0, TextAlignment#Center);
	IF snapshotInfo.Present > 0 THEN
		DrawString(LBL_SNAPSHOT_VER + TO_STRING(snapshotInfo.Version), 2, 0); 
		DrawString(LBL_SNAPSHOT_DATE, 3, 0); 
		DrawString(TO_STRING(snapshotInfo.CreationDate), 4, 0); 
	ELSE
		DrawStringAligned(LBL_SNAPSHOT_NOT_PRESENT, 3, TextAlignment#Center);
	END_IF;	

END_FUNCTION_BLOCK

{IF NOT DEF(NO_PLAN_SUPPORT)}
FUNCTION_BLOCK PlanInfoView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR_TEMP
		i, j, index : INT;
		netConfig, termConfig : UDINT;
	END_VAR
	
	CASE keyPressed OF
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	netConfig := GetNetConfiguration();
	termConfig := GetNetTerminalConfiguration();

	FOR i := 0 TO 3 DO
		DrawString(TO_STRING((8 * i + 1)), i + 2, 5 - (TO_INT(SHR(TO_WORD(8*i), 4) AND 1)));
		FOR j := 0 TO 7 DO
			index := 8 * i + j;
			IF DWORD#1 = (SHR(TO_DWORD(termConfig), index) AND DWORD#1) THEN
				DrawString('$91', i + 2, j + 7);
			ELSIF DWORD#1 = (SHR(TO_DWORD(netConfig), index) AND DWORD#1) THEN
				DrawString('$92', i + 2, j + 7);
			ELSE
				DrawString('$93', i + 2, j + 7);
			END_IF;
		END_FOR;
		DrawString(TO_STRING((8 * i + 8)), i + 2, 16);
	END_FOR;
	DrawStringAligned('Net Conf.: ' + TO_STRING(TO_DWORD(netConfig)), 6, TextAlignment#Center);
	DrawStringAligned('NetTConf.: ' + TO_STRING(TO_DWORD(termConfig)), 7, TextAlignment#Center);
END_FUNCTION_BLOCK

FUNCTION_BLOCK PlanSettingsView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR
		selectedPLanAddressValue, tmpAddress : UINT;
		canChangePLanAddress : BOOL;
	END_VAR
	
	CASE keyPressed OF
	KEY_SHOW:
		selectedPLanAddressValue := FindNextAddressFrom(GetPlanAddress());
		canChangePLanAddress := FALSE;
		
	KEY_UP:
		selectedPLanAddressValue := FindNextAddressFrom(selectedPLanAddressValue);
		canChangePLanAddress := TRUE;
		
	KEY_DOWN:
		tmpAddress := selectedPLanAddressValue - 2;
		WHILE FindNextAddressFrom(tmpAddress) = selectedPLanAddressValue  DO
			tmpAddress := tmpAddress - 1;
			IF NOT (tmpAddress >= 1 AND tmpAddress <= 32) THEN
				tmpAddress := 32;
			END_IF;
		END_WHILE;
		selectedPLanAddressValue := FindNextAddressFrom(tmpAddress);
		canChangePLanAddress := TRUE;
		
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	IF canChangePLanAddress AND (keyPressed = KEY_ENTER) THEN
{IF NOT def(NO_SEV_SUPPORT)}
		IF SetPlanAddress(TO_UINT(selectedPLanAddressValue)) THEN
			System.UI.SEV.SetNumber(TO_UINT(selectedPLanAddressValue));
		END_IF;
{ENDIF}
			canChangePLanAddress := FALSE;
	END_IF;
	
	DrawStringAligned('Current Address: ' + TO_STRING(GetPlanAddress()), 2, TextAlignment#Center);
	DrawStringAligned('New Address: ' + TO_STRING(selectedPLanAddressValue), 4, TextAlignment#Center);
	DrawString('Press ENTER to save.', 6, 0);;
END_FUNCTION_BLOCK
{ENDIF}

FUNCTION_BLOCK SystemInfoView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR_TEMP
		systemInfo : SystemInfo;
	END_VAR
	
	CASE keyPressed OF
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	GetSystemInfo(systemInfo);
		
	DrawString('BOOT VER ', 1, 0);
	DrawString(TO_STRING(systemInfo.BootloaderVersion), 1, 10);
	
	DrawString('FW VER ', 2, 0);
	DrawString(TO_STRING(systemInfo.FirmwareVersion), 2, 10);
	
	DrawString('VM OS VER', 3, 0);
	DrawString(TO_STRING(systemInfo.VMVersion), 3, 10);
	DrawString(TO_STRING(systemInfo.OSVersion), 3, 14);
	
	DrawString('BUILD ' + systemInfo.BuildTime,4,0);
END_FUNCTION_BLOCK

FUNCTION_BLOCK SystemUptimeView
	VAR_IN_OUT
		keyPressed : UINT;
		startTime : DATE_AND_TIME;
	END_VAR
	VAR_TEMP
		dateTime : DATE_AND_TIME;
		str : STRING[TEXT_LINE_LENGTH];
	END_VAR
	
	CASE keyPressed OF
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
	END_CASE;
	
	GetTime(dateTime);
	str := DifferenceBetweenDTFormatted(dateTime, startTime);
	DrawStringAligned(LBL_CURRENT_TIME, 2, TextAlignment#Center);
	DrawStringAligned(TO_STRING(dateTime), 3, TextAlignment#Center);
	DrawStringAligned(LBL_START_TIME, 4, TextAlignment#Center);
	DrawStringAligned(TO_STRING(startTime), 5, TextAlignment#Center);
	DrawStringAligned(LBL_WORKING_TIME, 6, TextAlignment#Center);
	DrawStringAligned(str, 7, TextAlignment#Center);
END_FUNCTION_BLOCK

{IF NOT DEF(NO_TCP_SUPPORT)}
FUNCTION_BLOCK TcpIpSettingsView
	VAR_IN_OUT
		keyPressed : UINT;
		keyCounter : UINT;
	END_VAR
	VAR
		IPSettings : IPSettings;
		IP1, IP2, IP3, IP4,
		SM1, SM2, SM3, SM4,
		GW1, GW2, GW3, GW4,
		DNS11, DNS12, DNS13, DNS14, 
		DNS21, DNS22, DNS23, DNS24 : BYTE;
		
		nIP1, nIP2, nIP3, nIP4,
		nSM1, nSM2, nSM3, nSM4,
		nGW1, nGW2, nGW3, nGW4,
		nDNS11, nDNS12, nDNS13, nDNS14, 
		nDNS21, nDNS22, nDNS23, nDNS24 : USINT;
		
		curR, curC : INT;
		DHCP : STRING[TEXT_LINE_LENGTH] := YES_LBL;
		yn : STRING[TEXT_LINE_LENGTH] := NO_LBL;
		needRestart : BOOL;
		restart : STRING[TEXT_LINE_LENGTH];
	END_VAR
	
	VAR_TEMP
	keyCounterUS:USINT;
	END_VAR
	
	keyCounterUS:=TO_USINT(keyCounter);
	
	IF keyPressed = KEY_SHOW THEN
		SetCursor(IPROW_DHCP, 6);
		curR := IPROW_DHCP;
		curC := 6;
		GetIPSetting(IPSettings);
		Int2Ip(IPSettings.SubnetMask, SM1, SM2, SM3, SM4);
		Int2Ip(IPSettings.Getaway, GW1, GW2, GW3, GW4);
		Int2Ip(IPSettings.DNS1, DNS11, DNS12, DNS13, DNS14);
		Int2Ip(IPSettings.DNS2, DNS21, DNS22, DNS23, DNS24);
		nSM1 := TO_USINT(SM1); nSM2 := TO_USINT(SM2); nSM3 := TO_USINT(SM3); nSM4 := TO_USINT(SM4);
		nGW1 := TO_USINT(GW1); nGW2 := TO_USINT(GW2); nGW3 := TO_USINT(GW3); nGW4 := TO_USINT(GW4);
		nDNS11 := TO_USINT(DNS11); nDNS12 := TO_USINT(DNS12); nDNS13 := TO_USINT(DNS13); nDNS14 := TO_USINT(DNS14);
		nDNS21 := TO_USINT(DNS21); nDNS22 := TO_USINT(DNS22); nDNS23 := TO_USINT(DNS23); nDNS24 := TO_USINT(DNS24);
		IF IPSettings.DHCP > 0 THEN
			DHCP := YES_LBL;
		ELSE
			DHCP := NO_LBL;
		END_IF;
		yn := NO_LBL;
		restart := '';
	END_IF;
	
	IF DHCP = YES_LBL THEN 
		Int2Ip(IPSettings.IPAddress, IP1, IP2, IP3, IP4);
		nIP1 := TO_USINT(IP1); nIP2 := TO_USINT(IP2); nIP3 := TO_USINT(IP3); nIP4 := TO_USINT(IP4);
	END_IF;
	
	CASE keyPressed OF
	KEY_UP:
		CASE curR OF
		IPROW_DHCP:
			IF DHCP = YES_LBL THEN
				DHCP := NO_LBL;
				IPSettings.DHCP := 0;
			ELSE
				DHCP := YES_LBL;
				IPSettings.DHCP := 1;
			END_IF;
		IPROW_IP:
			CASE curC OF
			IPCOL1: nIP1 := nIP1 + keyCounterUS;
			IPCOL2: nIP2 := nIP2 + keyCounterUS;
			IPCOL3: nIP3 := nIP3 + keyCounterUS;
			IPCOL4: nIP4 := nIP4 + keyCounterUS;
			END_CASE;
		IPROW_SUBMASK:
			CASE curC OF
			IPCOL1: nSM1 := nSM1 +  keyCounterUS;
			IPCOL2: nSM2 := nSM2 +  keyCounterUS;
			IPCOL3: nSM3 := nSM3 +  keyCounterUS;
			IPCOL4:  nSM4 := nSM4 + keyCounterUS;
			END_CASE;
		IPROW_GETAWAY:
			CASE curC OF
			IPCOL1: nGW1 := nGW1 + keyCounterUS;
			IPCOL2: nGW2 := nGW2 + keyCounterUS;
			IPCOL3: nGW3 := nGW3 + keyCounterUS;
			IPCOL4: nGW4 := nGW4 + keyCounterUS;
			END_CASE;
		IPROW_DNS1:
			CASE curC OF
			IPCOL1: nDNS11 := nDNS11 + keyCounterUS;
			IPCOL2: nDNS12 := nDNS12 + keyCounterUS;
			IPCOL3: nDNS13 := nDNS13 + keyCounterUS;
			IPCOL4: nDNS14 := nDNS14 + keyCounterUS;
			END_CASE;
		IPROW_DNS2:
			CASE curC OF
			IPCOL1: nDNS21 := nDNS21 + keyCounterUS;
			IPCOL2: nDNS22 := nDNS22 + keyCounterUS;
			IPCOL3: nDNS23 := nDNS23 + keyCounterUS;
			IPCOL4: nDNS24 := nDNS24 + keyCounterUS;
			END_CASE;
		IPROW_SAVE:
			IF yn = YES_LBL THEN
				yn := NO_LBL;
			ELSE
				yn := YES_LBL;
			END_IF;
		END_CASE;
		
	KEY_DOWN:
		CASE curR OF
		IPROW_DHCP:
			IF DHCP = YES_LBL THEN
				DHCP := NO_LBL;
				IPSettings.DHCP := 0;
			ELSE
				DHCP := YES_LBL;
				IPSettings.DHCP := 1;
			END_IF;
		IPROW_IP:
			CASE curC OF
			IPCOL1: nIP1 := nIP1 - keyCounterUS;
			IPCOL2: nIP2 := nIP2 - keyCounterUS;
			IPCOL3: nIP3 := nIP3 - keyCounterUS;
			IPCOL4: nIP4 := nIP4 - keyCounterUS;
			END_CASE;
		IPROW_SUBMASK:
			CASE curC OF
			IPCOL1: nSM1 := nSM1 - keyCounterUS;
			IPCOL2: nSM2 := nSM2 - keyCounterUS;
			IPCOL3: nSM3 := nSM3 - keyCounterUS;
			IPCOL4: nSM4 := nSM4 - keyCounterUS;
			END_CASE;
		IPROW_GETAWAY:
			CASE curC OF
			IPCOL1: nGW1 := nGW1 - keyCounterUS;
			IPCOL2: nGW2 := nGW2 - keyCounterUS;
			IPCOL3: nGW3 := nGW3 - keyCounterUS;
			IPCOL4: nGW4 := nGW4 - keyCounterUS;
			END_CASE;
		IPROW_DNS1:
			CASE curC OF
			IPCOL1: nDNS11 := nDNS11 - keyCounterUS;
			IPCOL2: nDNS12 := nDNS12 - keyCounterUS;
			IPCOL3: nDNS13 := nDNS13 - keyCounterUS;
			IPCOL4: nDNS14 := nDNS14 - keyCounterUS;
			END_CASE;
		IPROW_DNS2:
			CASE curC OF
			IPCOL1: nDNS21 := nDNS21 - keyCounterUS;
			IPCOL2: nDNS22 := nDNS22 - keyCounterUS;
			IPCOL3: nDNS23 := nDNS23 - keyCounterUS;
			IPCOL4: nDNS24 := nDNS24 - keyCounterUS;
			END_CASE;
		IPROW_SAVE:
			IF yn = YES_LBL THEN
				yn := NO_LBL;
			ELSE
				yn := YES_LBL;
			END_IF;
		END_CASE;
		
	KEY_ENTER:
		CASE curR OF
		IPROW_DHCP:
			IF DHCP = NO_LBL THEN
				SetCursor(IPROW_IP, IPCOL1);
				curR := IPROW_IP;
				curC := IPCOL1;
			ELSE
				SetCursor(IPROW_SAVE, 6);
				curR := IPROW_SAVE;
				curC := 6;
			END_IF;
		IPROW_IP:
			CASE curC OF
			IPCOL1:
				SetCursor(IPROW_IP, IPCOL2);
				curR := IPROW_IP;
				curC := IPCOL2;
			IPCOL2:
				SetCursor(IPROW_IP, IPCOL3);
				curR := IPROW_IP;
				curC := IPCOL3;
			IPCOL3:
				SetCursor(IPROW_IP, IPCOL4);
				curR := IPROW_IP;
				curC := IPCOL4;
			IPCOL4: 
				SetCursor(IPROW_SUBMASK, IPCOL1);
				curR := IPROW_SUBMASK;
				curC := IPCOL1;
			END_CASE;
		IPROW_SUBMASK:
			CASE curC OF
			IPCOL1:
				SetCursor(IPROW_SUBMASK, IPCOL2);
				curR := IPROW_SUBMASK;
				curC := IPCOL2;
			IPCOL2:
				SetCursor(IPROW_SUBMASK, IPCOL3);
				curR := IPROW_SUBMASK;
				curC := IPCOL3;
			IPCOL3:
				SetCursor(IPROW_SUBMASK, IPCOL4);
				curR := IPROW_SUBMASK;
				curC := IPCOL4;
			IPCOL4: 
				SetCursor(IPROW_GETAWAY, IPCOL1);
				curR := IPROW_GETAWAY;
				curC := IPCOL1;
			END_CASE;
		IPROW_GETAWAY:
			CASE curC OF
			IPCOL1:
				SetCursor(IPROW_GETAWAY, IPCOL2);
				curR := IPROW_GETAWAY;
				curC := IPCOL2;
			IPCOL2:
				SetCursor(IPROW_GETAWAY, IPCOL3);
				curR := IPROW_GETAWAY;
				curC := IPCOL3;
			IPCOL3:
				SetCursor(IPROW_GETAWAY, IPCOL4);
				curR := IPROW_GETAWAY;
				curC := IPCOL4;
			IPCOL4: 
				SetCursor(IPROW_DNS1, IPCOL1);
				curR := IPROW_DNS1;
				curC := IPCOL1;
			END_CASE;
		IPROW_DNS1:
			CASE curC OF
			IPCOL1:
				SetCursor(IPROW_DNS1, IPCOL2);
				curR := IPROW_DNS1;
				curC := IPCOL2;
			IPCOL2:
				SetCursor(IPROW_DNS1, IPCOL3);
				curR := IPROW_DNS1;
				curC := IPCOL3;
			IPCOL3:
				SetCursor(IPROW_DNS1, IPCOL4);
				curR := IPROW_DNS1;
				curC := IPCOL4;
			IPCOL4: 
				SetCursor(IPROW_DNS2, IPCOL1);
				curR := IPROW_DNS2;
				curC := IPCOL1;
			END_CASE;
		IPROW_DNS2:
			CASE curC OF
			IPCOL1:
				SetCursor(IPROW_DNS2, IPCOL2);
				curR := IPROW_DNS2;
				curC := IPCOL2;
			IPCOL2:
				SetCursor(IPROW_DNS2, IPCOL3);
				curR := IPROW_DNS2;
				curC := IPCOL3;
			IPCOL3:
				SetCursor(IPROW_DNS2, IPCOL4);
				curR := IPROW_DNS2;
				curC := IPCOL4;
			IPCOL4: 
				SetCursor(IPROW_SAVE, 6);
				curR := IPROW_SAVE;
				curC := 6;
			END_CASE;
		IPROW_SAVE: 
			IF yn = YES_LBL THEN
				SetIPSetting(IPSettings, needRestart);
				IF needRestart THEN
					restart := 'RESTART!';
				END_IF;
			END_IF;
			SetCursor(IPROW_DHCP, 6);
			curR := IPROW_DHCP;
			curC := 6;
		END_CASE;
		
	KEY_ESC,
	KEY_CLOSE:
		RETURN;
		
	END_CASE;
	
	IF keyPressed = KEY_UP OR keyPressed = KEY_DOWN THEN
		IP1 := TO_BYTE(nIP1); IP2 := TO_BYTE(nIP2); IP3 := TO_BYTE(nIP3); IP4 := TO_BYTE(nIP4);
		SM1 := TO_BYTE(nSM1); SM2 := TO_BYTE(nSM2); SM3 := TO_BYTE(nSM3); SM4 := TO_BYTE(nSM4);
		GW1 := TO_BYTE(nGW1); GW2 := TO_BYTE(nGW2); GW3 := TO_BYTE(nGW3); GW4 := TO_BYTE(nGW4);
		DNS11 := TO_BYTE(nDNS11); DNS12 := TO_BYTE(nDNS12); DNS13 := TO_BYTE(nDNS13); DNS14 := TO_BYTE(nDNS14);
		DNS21 := TO_BYTE(nDNS21); DNS22 := TO_BYTE(nDNS22); DNS23 := TO_BYTE(nDNS23); DNS24 := TO_BYTE(nDNS24);
		IPSettings.IPAddress := Ip2Int(IP1, IP2, IP3, IP4);
		IPSettings.SubnetMask := Ip2Int(SM1, SM2, SM3, SM4);
		IPSettings.Getaway := Ip2Int(GW1, GW2, GW3, GW4);
		IPSettings.DNS1 := Ip2Int(DNS11, DNS12, DNS13, DNS14);
		IPSettings.DNS2 := Ip2Int(DNS21, DNS22, DNS23, DNS24);
	END_IF;
	
	DrawString(CONCAT('DHCP: ', DHCP), IPROW_DHCP, 0);
	
	//IF DHCP = NO_LBL THEN
		DrawString('IP:   ' + Ip2String(IPSettings.IPAddress), IPROW_IP, 0);
		DrawString('SM:   ' + Ip2String(IPSettings.SubnetMask), IPROW_SUBMASK, 0);
		DrawString('GW:   ' + Ip2String(IPSettings.Getaway), IPROW_GETAWAY, 0);
		DrawString('DNS1: ' + Ip2String(IPSettings.DNS1), IPROW_DNS1, 0);
		DrawString('DNS2: ' + Ip2String(IPSettings.DNS2), IPROW_DNS2, 0);
	//END_IF;
	
	DrawString(CONCAT('Save? ', yn) , IPROW_SAVE, 0);
	DrawStringAligned(restart, IPROW_SAVE, TextAlignment#Right);
END_FUNCTION_BLOCK
{ENDIF}

{DEFINE MAX_VIEW_ENTRIES 7}
{DEFINE CURRENT_VIEW_LIST_OFFSET 1}
{DEFINE LIST_OFFSET 1}
FUNCTION_BLOCK LogListView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR
		selected : INT;
		isLogMaximized : BOOL;
	END_VAR
	VAR_TEMP
		i : INT := 1;
		err : INT;
		offsetLine, count : INT;
		message : STRING;
		pager : STRING[7];
	END_VAR
	CASE keyPressed OF
		KEY_SHOW:
			selected := 1;
			isLogMaximized := FALSE;
		KEY_ESC,
		KEY_CLOSE:
			RETURN;
	END_CASE;
	IF IsLogInitialized(err) THEN
		count := GetLogRecordsNumber();
		IF count = 0 THEN
			DrawStringAligned('No logs are present.', 3, TextAlignment#Center);
			RETURN;
		END_IF;
		CASE keyPressed OF
			KEY_UP:
				selected := selected - 1;
				IF selected < 1 THEN
					selected := count;
				END_IF;
			KEY_DOWN:
				selected := selected + 1;
				IF selected > count THEN
					selected := 1;
				END_IF;
			KEY_ENTER:
				isLogMaximized := NOT isLogMaximized;
		END_CASE;
		IF selected > MAX_VIEW_ENTRIES THEN
			offsetLine := selected - (MAX_VIEW_ENTRIES - 1);
		ELSE
			offsetLine := 1;
		END_IF;
		
		IF isLogMaximized THEN
			message := GetLogMessage(selected);
			DrawStringAligned(GetLogLevelAsString(selected) + ' - ' + TO_STRING(GetLogTS(selected)), 0, TextAlignment#Center);
			DrawRect(0, 0, TO_INT(GRAPHICS_WIDTH), 8, TRUE);
			DrawRect(3, 12, TO_INT(GRAPHICS_WIDTH) - 6, TO_INT(GRAPHICS_HEIGHT) - 24, FALSE);
			FOR i := 2 TO 5 DO
				DrawString(message, i, 1, (i-2)*20, 20);
				IF (TO_DINT(i) - 2) * 20 > LEN(message) THEN
					EXIT;
				END_IF;
			END_FOR;
			pager := TO_STRING(selected) + '/' + TO_STRING(count);
			DrawStringAligned(pager, 7, TextAlignment#Right);
			DrawOval(TO_INT(GRAPHICS_WIDTH) - TO_INT(LEN(pager)*6) - 8, TO_INT(GRAPHICS_HEIGHT) - 9, 18, 18, TRUE);
			DrawRect(TO_INT(GRAPHICS_WIDTH) - TO_INT(LEN(pager)*8 - 9), TO_INT(GRAPHICS_HEIGHT) - 9, TO_INT(GRAPHICS_WIDTH) - 9, 9, TRUE);
			RETURN;
		END_IF;

		FOR i := offsetLine  TO count DO
			IF i = selected THEN
				DrawRect(0, (i + LIST_OFFSET - offsetLine) * 8, TO_INT(GRAPHICS_WIDTH)-6, 8, TRUE);
			END_IF;
			IF i - offsetLine < MAX_VIEW_ENTRIES THEN
				DrawString(GetLogRecord(i), (i + LIST_OFFSET - offsetLine), 0);
			END_IF;
			
		END_FOR;
		
		DrawLine(130, 0, 130, 63);
		DrawRect(TO_INT(GRAPHICS_WIDTH) - 3, (TO_INT(GRAPHICS_HEIGHT)/(count))*(selected-1), 3, TO_INT(GRAPHICS_HEIGHT)/(count), TRUE);
		
	ELSE
		DrawStringAligned('ERROR!!!', 2, TextAlignment#Center);
		IF err = -1 THEN
			DrawStringAligned('Log is not initialized!', 3, TextAlignment#Center);
		ELSE
			DrawStringAligned('Error ' + TO_STRING(err) + ' during', 3, TextAlignment#Center);
			DrawStringAligned('log initialization!!', 4, TextAlignment#Center);
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK WipeRetainView
	VAR_IN_OUT
		keyPressed : UINT;
	END_VAR
	VAR
        wipeDone : BOOL;
    END_VAR
	CASE keyPressed OF
    KEY_ENTER:
        System.RetainRestoreDefault();
        wipeDone := TRUE;
	KEY_ESC,
	KEY_CLOSE:
        wipeDone := FALSE;
		RETURN;
	END_CASE;
    
	DrawStringAligned(LBL_PRESS_ENTER_TO_WIPE, 2, TextAlignment#Center);
	DrawStringAligned(LBL_RETAIN_DATA, 3, TextAlignment#Center);
    
    IF wipeDone THEN
        DrawStringAligned(LBL_WIPED_DATA, 5, TextAlignment#Center);
    END_IF;
END_FUNCTION_BLOCK
{ENDREGION}

END_NAMESPACE

{REGION Utility Functions}
FUNCTION DrawMenuList
	VAR_IN_OUT
		entries : ARRAY[*] OF STRING;
	END_VAR
	VAR_INPUT
		count, selected, offset: INT;
	END_VAR
	VAR
		maxViewedEntries : INT := 5;
		i, offsetLine : INT;
		str : STRING[TEXT_LINE_LENGTH];
	END_VAR
	
	IF selected > maxViewedEntries - 1 THEN
		offsetLine := selected - (maxViewedEntries - 1);
	ELSE
		offsetLine := 0;
	END_IF;
	FOR i := offsetLine  TO count - 1 DO
		IF i = selected THEN
			str := '>';
			DrawString(str, i + offset - offsetLine , 0);
			DrawRect(0, (i + offset - offsetLine) * 8, TO_INT(GRAPHICS_WIDTH)-4, 8, TRUE);
		END_IF;
		IF i - offsetLine < maxViewedEntries THEN
			DrawString(entries[i], (i + offset - offsetLine), 2);
		END_IF;
		
	END_FOR;
	DrawLine(130, 0, 130, 63);
	DrawRect(TO_INT(GRAPHICS_WIDTH) - 3, (TO_INT(GRAPHICS_HEIGHT)/count)*selected, 3, TO_INT(GRAPHICS_HEIGHT)/count, TRUE);
END_FUNCTION

FUNCTION SwitchSetHourCursor
	VAR_IN_OUT
		cursor : ARRAY [0..1] OF INT;
	END_VAR
	CASE cursor[0] OF
	5:
		CASE cursor[1] OF
		4:
			cursor[0]:=5;
			cursor[1]:=7;
		7:
			cursor[0]:=5;
			cursor[1]:=10;
		10:
			cursor[0]:=5;
			cursor[1]:=13;
		13:
			cursor[0]:=5;
			cursor[1]:=16;
		16:
			cursor[0]:=5;
			cursor[1]:=19;
		19:
			cursor[0]:=7;
			cursor[1]:=7;
		END_CASE;
	7:
		cursor[0]:=5;
		cursor[1]:=4;
	END_CASE;
END_FUNCTION
{ENDREGION}

{REGION DateTime Functions}
FUNCTION SetYear
	VAR_IN_OUT
		YYYY : UINT;
	END_VAR
	VAR_INPUT
		sign : BOOL;
	END_VAR
	IF sign THEN
		YYYY := YYYY + 1;
	ELSE
		YYYY := YYYY - 1;
	END_IF;
END_FUNCTION

FUNCTION SetMonth
	VAR_IN_OUT
		YYYY:UINT;
		MM : UINT;
	END_VAR
	VAR_INPUT
		sign : BOOL;
	END_VAR
	IF sign THEN
		IF MM = 12 THEN
			MM := 1;
			setYear(YYYY, TRUE);
		ELSE
			MM := MM + 1;
		END_IF;
	ELSE
		IF MM = 1 THEN
			MM := 12;
			setYear(YYYY, FALSE);
		ELSE
			MM := MM - 1;
		END_IF;
	END_IF;
END_FUNCTION

FUNCTION SetDay
	VAR_IN_OUT
		YYYY,MM,DD : UINT;
	END_VAR
	VAR_INPUT
		sign : BOOL;
	END_VAR
	IF sign THEN
		CASE MM OF
		1, 3, 5, 7, 8, 10, 12:		// MM with 31 DD
			IF DD = 31 THEN
				DD := 1;
				setMonth(YYYY,MM, TRUE);
			ELSE
				DD := DD + 1;
			END_IF;
		4, 6, 9, 11:				// MM with 30 DD
			IF DD = 30 THEN
				DD := 1;
				setMonth(YYYY, MM, TRUE);
			ELSE
				DD := DD + 1;
			END_IF;
		2:							// Feb - 28 or 29 DD??
			IF ((YYYY MOD 4 = 0) AND (YYYY MOD 100 <> 0)) OR (YYYY MOD 400 = 0) THEN
				IF DD = 29 THEN
					DD := 1;
					setMonth(YYYY, MM, TRUE);
				ELSE
					DD := DD + 1;
				END_IF;
			ELSE
				IF DD = 28 THEN
					DD := 1;
					setMonth(YYYY, MM, TRUE);
				ELSE
					DD := DD + 1;
				END_IF;
			END_IF;
		END_CASE;
	ELSE
		CASE MM OF
		1, 3, 5, 7, 8, 10, 12:		// MM with 31 DD
			IF DD = 1 THEN
				DD := 31;
				setMonth(YYYY, MM, FALSE);
			ELSE
				DD := DD - 1;
			END_IF;
		4, 6, 9, 11:				// MM with 30 DD
			IF DD = 1 THEN
				DD := 30;
				setMonth(YYYY,MM, FALSE);
			ELSE
				DD := DD - 1;
			END_IF;
		2:							// Feb - 28 or 29 DD??
			IF ((YYYY MOD 4 = 0) AND (YYYY MOD 100 <> 0)) OR (YYYY MOD 400 = 0) THEN
				IF DD = 1 THEN
					DD := 29;
					setMonth(YYYY,MM, FALSE);
				ELSE
					DD := DD - 1;
				END_IF;
			ELSE
				IF DD = 1 THEN
					DD := 28;
					setMonth(YYYY,MM, FALSE);
				ELSE
					DD := DD - 1;
				END_IF;
			END_IF;
		END_CASE;
	END_IF;
END_FUNCTION

FUNCTION SetHour
	VAR_IN_OUT
		YYYY, MM, DD, hh : UINT;
	END_VAR
	VAR_INPUT
		sign : BOOL;
	END_VAR
	IF sign THEN
		IF hh = 23 THEN
			hh := 0;
			setDay(YYYY,MM, DD, TRUE);
		ELSE
			hh := hh + 1;
		END_IF;
	ELSE
		IF hh = 0 THEN
			hh := 23;
			setDay(YYYY,MM,DD, FALSE);
		ELSE
			hh := hh - 1;
		END_IF;
	END_IF;
END_FUNCTION

FUNCTION SetMin
	VAR_IN_OUT
		YYYY, MM, DD, hh, min : UINT;
	END_VAR
	VAR_INPUT
		sign : BOOL;
	END_VAR
	IF sign THEN
		IF min = 59 THEN
			min := 0;
			setHour(YYYY,MM,DD,hh, TRUE);
		ELSE
			min := min + 1;
		END_IF;
	ELSE
		IF min = 0 THEN
			min := 59;
			setHour(YYYY,MM,DD,hh, FALSE);
		ELSE
			min := min - 1;
		END_IF;
	END_IF;
END_FUNCTION

FUNCTION SetSec
	VAR_IN_OUT
		YYYY, MM, DD, hh, minute, ss : UINT;
	END_VAR
	VAR_INPUT
		sign : BOOL;
	END_VAR
	IF sign THEN
		IF ss = 59 THEN
			ss := 0;
			setMin(YYYY,MM,DD,hh,minute, TRUE);
		ELSE
			ss := ss + 1;
		END_IF;
	ELSE
		IF ss = 0 THEN
			ss := 59;
			setMin(YYYY,MM,DD,hh,minute, FALSE);
		ELSE
			ss := ss - 1;
		END_IF;
	END_IF;
END_FUNCTION
{ENDREGION}

{ENDIF}