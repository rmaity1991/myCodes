USING System;
USING System.Math;
USING System.UI;
USING System.Timer;
USING System.Text;
USING System.Globalization;


	{DEFINE DOMAIN_NONE				 	 -1}
	{DEFINE DOMAIN_STRING			  	  0}
	{DEFINE DOMAIN_IMAGE				  1}
	{DEFINE DOMAIN_BOOL 				  2}
	{DEFINE DOMAIN_INT  				  3}
	{DEFINE DOMAIN_UINT  				  4}
	{DEFINE DOMAIN_REAL  				  5}
	{DEFINE DOMAIN_LREAL  				  6}
	{DEFINE DOMAIN_SINT  				  7}
	{DEFINE DOMAIN_USINT  				  8}
	{DEFINE DOMAIN_DINT  				  9}
	{DEFINE DOMAIN_UDINT  				  10}
	{DEFINE DOMAIN_DATE  				  11}
	{DEFINE DOMAIN_TOD  				  12}
	{DEFINE DOMAIN_BYTE  				  13}
	{DEFINE DOMAIN_TIME  				  14}
	{DEFINE DOMAIN_DT  				      15}
	{DEFINE DOMAIN_SHAPE  				  126}
	{DEFINE DOMAIN_WIDGET  				  127}

	{DEFINE PRESENTATION_SCROLLABLETEXT      2}
	{DEFINE PRESENTATION_WIDGET              1}
	{DEFINE PRESENTATION_NONE                0}
	{DEFINE PRESENTATION_TEXT               -1}
	{DEFINE PRESENTATION_VARIABLE           -2}
	{DEFINE PRESENTATION_IMAGE              -3}
	{DEFINE PRESENTATION_BAR                -4}
	{DEFINE PRESENTATION_IAR                -5}
	{DEFINE PRESENTATION_SIMPLESTRING       -6}
	{DEFINE PRESENTATION_COMPACTFIELD       -7}
	{DEFINE PRESENTATION_CONSTANT           -8}
	{DEFINE PRESENTATION_SHAPE              -9}
	{DEFINE PRESENTATION_TEXTAREA          -10}
	{DEFINE PRESENTATION_VARIABLEWITHUOM   -11}
	{DEFINE PRESENTATION_TIMEVARIABLE      -12}
 
/*OPTIMIZATION*/
 
{DEFINE USED_DOMAIN_STRING                                   0}
{DEFINE USED_DOMAIN_IMAGE                                    0}
{DEFINE USED_DOMAIN_BOOL                                     0}
{DEFINE USED_DOMAIN_INT                                      0}
{DEFINE USED_DOMAIN_UINT                                     0}
{DEFINE USED_DOMAIN_REAL                                     0}
{DEFINE USED_DOMAIN_LREAL                                    0}
{DEFINE USED_DOMAIN_SINT                                     0}
{DEFINE USED_DOMAIN_USINT                                    0}
{DEFINE USED_DOMAIN_DINT                                     0}
{DEFINE USED_DOMAIN_UDINT                                    0}
{DEFINE USED_DOMAIN_DATE                                     0}
{DEFINE USED_DOMAIN_TOD                                      0}
{DEFINE USED_DOMAIN_BYTE                                     0}
{DEFINE USED_DOMAIN_TIME                                     0}
{DEFINE USED_DOMAIN_DT                                       0}
{DEFINE USED_DOMAIN_SHAPE                                    0}
{DEFINE USED_DOMAIN_WIDGET                                   0}
{DEFINE USED_DOMAIN_NONE                                     0} 
{DEFINE USED_PRESENTATION_NONE                               0}
{DEFINE USED_PRESENTATION_WIDGET                             0}
{DEFINE USED_PRESENTATION_SCROLLABLETEXT                     0}
{DEFINE USED_PRESENTATION_TIMEVARIABLE                       0}
{DEFINE USED_PRESENTATION_VARIABLEWITHUOM                    0}
{DEFINE USED_PRESENTATION_TEXTAREA                           0}
{DEFINE USED_PRESENTATION_SHAPE                              0}
{DEFINE USED_PRESENTATION_CONSTANT                           0}
{DEFINE USED_PRESENTATION_COMPACTFIELD                       0}
{DEFINE USED_PRESENTATION_SIMPLESTRING                       0}
{DEFINE USED_PRESENTATION_IAR                                0}
{DEFINE USED_PRESENTATION_BAR                                0}
{DEFINE USED_PRESENTATION_IMAGE                              0}
{DEFINE USED_PRESENTATION_VARIABLE                           0}
{DEFINE USED_PRESENTATION_TEXT                               0}
/*END OPTIMIZATION*/

NAMESPACE SevenSegments
{DEFINE UI_INCREMENT 1}

TYPE VARCONTENT : UNION
	BOOL:BOOL;
	INT : INT;
	UDINT: UDINT;
	DINT:DINT;
	UINT: UINT;
	REAL: REAL;
	DATE: DATE;
	STRPOINTER: POINTER TO STRING;
	DATETIME: DATE_AND_TIME;
	LREAL: LREAL;
	SINT: SINT;
	USINT: USINT;
	BYTE: BYTE;
	TOD : TIME_OF_DAY;
	DT : DATE_AND_TIME;
	TIME : TIME;
END_UNION;
END_TYPE

FUNCTION INTERNAL Init : BOOL
	IF gui.init = FALSE THEN
		IF UserInit() THEN
			LoadFieldsData(gui.currentMask);
			HandleStartingField();
			gui.init := TRUE;
		ELSE
			Init := FALSE;
			RETURN;
		END_IF;
	END_IF;
	Init := TRUE;
END_FUNCTION


(** Standard action on KEY_DOWN for a field, e.g. decreasing a INT variable value*)
FUNCTION ActionFieldKeyDown : BOOL
VAR_IN_OUT CONSTANT
	keyCounter:UINT;
END_VAR
VAR
	dataIndex : INT := 0;
{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
    candidate : VARCONTENT;
{ENDIF}
END_VAR
    dataIndex := TO_INT(gui.currentField - guiInfo.masksInfo[gui.currentMask]);

	// if the field is selectable and is of type variable
	IF	gui.currentField > 0 AND
		fieldsSelectables(TO_INT(gui.currentField)) THEN

		gui.stringIndex := 0;
{IF USED_PRESENTATION_SIMPLESTRING}
        IF (guiInfo.fieldsInfo[gui.currentField].presentation = PRESENTATION_SIMPLESTRING) THEN //editable string
		    DecreaseChar(gui.currentData[dataIndex]^.STRPOINTER);
        ELSE
{ENDIF}
			IF guiInfo.fieldsInfo[gui.currentField].domain > DOMAIN_IMAGE THEN //other variable
				{IF DEF(MULTI_ZONE_UI)}
				IF GetUoM(gui.currentField) > 0 THEN
						CASE guiInfo.fieldsInfo[gui.currentField].domain OF
{IF USED_DOMAIN_LREAL OR USED_DOMAIN_REAL}
							DOMAIN_LREAL:
							DOMAIN_REAL:
								IF (UseTmpVarContent(gui.currentField)) THEN
									HandleRealUoMInput(keyCounter, FALSE);
								ELSE
									HandleRealUoMInput(gui.currentData[dataIndex], gui.currentField, keyCounter, FALSE);
								END_IF;
{ENDIF}
							ELSE
								IF (UseTmpVarContent(gui.currentField)) THEN
									HandleUoMInput(keyCounter, FALSE);
								ELSE
									HandleUoMInput(gui.currentData[dataIndex], keyCounter, FALSE);
								END_IF;
						END_CASE;
				ELSE
				{ENDIF}
					IF (UseTmpVarContent(gui.currentField)) THEN

							CASE guiInfo.fieldsInfo[gui.currentField].domain OF
	{IF USED_DOMAIN_BOOL}
								DOMAIN_BOOL:
									gui.tmpVarContent.BOOL := NOT gui.tmpVarContent.bool;
	{ENDIF}
	{IF USED_DOMAIN_DT}
								DOMAIN_DT,
	{ENDIF}
	{IF USED_DOMAIN_UINT}
								DOMAIN_UINT,
	{ENDIF}
	{IF USED_DOMAIN_SINT}
								DOMAIN_SINT,
	{ENDIF}
	{IF USED_DOMAIN_USINT}
								DOMAIN_USINT,
	{ENDIF}
	{IF USED_DOMAIN_DINT}
								DOMAIN_DINT,
	{ENDIF}
	{IF USED_DOMAIN_UDINT}
								DOMAIN_UDINT,
	{ENDIF}
	{IF USED_DOMAIN_TOD}
								DOMAIN_TOD,
	{ENDIF}
	{IF USED_DOMAIN_TIME}
								DOMAIN_TIME,
	{ENDIF}
	{IF USED_DOMAIN_DATE}
								DOMAIN_DATE,
	{ENDIF}
								DOMAIN_INT:
									DecrementVariable(REF(gui.tmpVarContent),
										gui.currentField, guiInfo.fieldsInfo[gui.currentField].domain,
										keyCounter);
	{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
								DOMAIN_REAL,
								DOMAIN_LREAL:
									candidate.DINT := gui.tmpVarContent.DINT - 1;
									gui.tmpVarContent.DINT := TO_DINT(CheckMin(gui.currentField,
										guiInfo.fieldsInfo[gui.currentField].domain,
										candidate).REAL * TO_REAL(GetRatio(gui.currentField)));
	{ENDIF}
							END_CASE;
					ELSE
						DecrementVariable(gui.currentData[dataIndex], gui.currentField,
							guiInfo.fieldsInfo[gui.currentField].domain, keyCounter);
					END_IF;
				{IF DEF(MULTI_ZONE_UI)}
				END_IF;
				{ENDIF}
			END_IF;
{IF USED_PRESENTATION_SIMPLESTRING}
        END_IF;
{ENDIF}
	END_IF;
	ActionFieldKeyDown := TRUE;
END_FUNCTION
(** Standard action on KEY_UP for a field, e.g. increasing a INT variable value*)
FUNCTION ActionFieldKeyUp : BOOL
VAR_IN_OUT CONSTANT
	keyCounter:UINT;
END_VAR
VAR
	dataIndex : INT := 0;
{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
    candidate : VARCONTENT;
{ENDIF}
END_VAR

    dataIndex := TO_INT(gui.currentField - guiInfo.masksInfo[gui.currentMask]);

	// if the field is selectable and is of type variable
	IF	gui.currentField > 0 AND
		fieldsSelectables(TO_INT(gui.currentField)) THEN

		gui.stringIndex := 0;
		
{IF USED_PRESENTATION_SIMPLESTRING}
        IF(guiInfo.fieldsInfo[gui.currentField].presentation = PRESENTATION_SIMPLESTRING) THEN //editable string
            IncreaseChar(gui.currentData[dataIndex]^.STRPOINTER);
        ELSE
{ENDIF}
			IF	guiInfo.fieldsInfo[gui.currentField].domain > 1 THEN //other variable
				{IF DEF(MULTI_ZONE_UI)}
				IF GetUoM(gui.currentField) > 0 THEN
					CASE guiInfo.fieldsInfo[gui.currentField].domain OF
	{IF USED_DOMAIN_LREAL OR USED_DOMAIN_REAL}
						DOMAIN_LREAL:
						DOMAIN_REAL:
							IF (UseTmpVarContent(gui.currentField)) THEN
								HandleRealUoMInput(keyCounter, TRUE);
							ELSE
								HandleRealUoMInput(gui.currentData[dataIndex], gui.currentField, keyCounter, TRUE);
							END_IF;
	{ENDIF}
						ELSE
							IF (UseTmpVarContent(gui.currentField)) THEN
								HandleUoMInput(keyCounter, TRUE);
							ELSE
								HandleUoMInput(gui.currentData[dataIndex], keyCounter, TRUE);
							END_IF;
					END_CASE;
				ELSE
				{ENDIF}
        			IF (UseTmpVarContent(gui.currentField)) THEN
                		CASE guiInfo.fieldsInfo[gui.currentField].domain OF
	{IF USED_DOMAIN_BOOL}
                			DOMAIN_BOOL: // bool
                				gui.tmpVarContent.BOOL := NOT gui.tmpVarContent.bool;
	{ENDIF}
	{IF USED_DOMAIN_DT}
                			DOMAIN_DT,
	{ENDIF}
	{IF USED_DOMAIN_UINT}
							DOMAIN_UINT,
	{ENDIF}
	{IF USED_DOMAIN_SINT}
							DOMAIN_SINT,
	{ENDIF}
	{IF USED_DOMAIN_USINT}
							DOMAIN_USINT,
	{ENDIF}
	{IF USED_DOMAIN_DINT}
							DOMAIN_DINT,
	{ENDIF}
	{IF USED_DOMAIN_UDINT}
							DOMAIN_UDINT,
	{ENDIF}
	{IF USED_DOMAIN_TOD}
							DOMAIN_TOD,
	{ENDIF}
	{IF USED_DOMAIN_TIME}
							DOMAIN_TIME,
	{ENDIF}
	{IF USED_DOMAIN_DATE}
							DOMAIN_DATE,
	{ENDIF}
							DOMAIN_INT:
                				IncrementVariable(REF(gui.tmpVarContent), gui.currentField,
									guiInfo.fieldsInfo[gui.currentField].domain, keyCounter);

	{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
                			DOMAIN_REAL,
							DOMAIN_LREAL:
                				candidate.DINT := gui.tmpVarContent.DINT + 1;
                				gui.tmpVarContent.DINT := TO_DINT(CheckMax(gui.currentField,
										guiInfo.fieldsInfo[gui.currentField].domain,
										candidate).REAL * TO_REAL(GetRatio(gui.currentField)));
	{ENDIF}
							END_CASE;
    				ELSE
    					IncrementVariable(gui.currentData[dataIndex],
    							gui.currentField,
    							guiInfo.fieldsInfo[gui.currentField].domain, keyCounter);
    				END_IF;
				{IF DEF(MULTI_ZONE_UI)}
				END_IF;
				{ENDIF}
			END_IF;
{IF USED_PRESENTATION_SIMPLESTRING}
        END_IF;
{ENDIF}
    END_IF;
	ActionFieldKeyUp := TRUE;
END_FUNCTION

FUNCTION INTERNAL IncrementVariable
	VAR_INPUT
		p : REF_TO VARCONTENT;
		i : UINT;
		domain : USINT;
	END_VAR
    VAR_IN_OUT CONSTANT
        keyCounter : UINT;
    END_VAR
	VAR
{IF USED_DOMAIN_INT OR USED_DOMAIN_UINT OR USED_DOMAIN_REAL OR USED_DOMAIN_LREAL OR USED_DOMAIN_SINT OR USED_DOMAIN_USINT OR USED_DOMAIN_DINT OR USED_DOMAIN_UDINT}
		candidate : VARCONTENT;
{ENDIF}
		
{IF USED_DOMAIN_LREAL OR USED_DOMAIN_REAL}
		ratio : INT;
{ENDIF}
{IF USED_DOMAIN_DT OR USED_DOMAIN_TIME OR USED_DOMAIN_TOD OR USED_DOMAIN_DATE}
		dateTime : DateTime;
		count : INT;
{ENDIF}
	END_VAR
	IF domain = DOMAIN_BOOL  THEN
		SetBool(TO_INT(i), NOT GetBool(TO_INT(i)));
	ELSE
		CASE domain OF
{IF USED_DOMAIN_INT}
			DOMAIN_INT: 
				candidate.INT := p^.INT + TO_INT(UI_INCREMENT);
				p^.INT := CheckMax(i, domain, candidate).INT;
{ENDIF}
{IF USED_DOMAIN_UINT}
			DOMAIN_UINT:
				candidate.UINT := p^.UINT + UI_INCREMENT;
				p^.UINT := CheckMax(i, domain, candidate).UINT;
{ENDIF}
{IF USED_DOMAIN_REAL}
			DOMAIN_REAL:  
				ratio := GetRatio(i);
				candidate.DINT := TO_DINT(p^.REAL * TO_REAL(ratio)) + TO_DINT(UI_INCREMENT);
				candidate := CheckMax(i, domain, candidate); //returns the REAL value
				p^.REAL := candidate.REAL;
{ENDIF}
{IF USED_DOMAIN_LREAL}
			DOMAIN_LREAL:	
				ratio := GetRatio(i);
				candidate.DINT := TO_DINT(p^.LREAL * TO_LREAL(ratio)) + TO_DINT(UI_INCREMENT);
				candidate := CheckMax(i, domain, candidate);
				p^.LREAL := TO_LREAL(candidate.REAL);
{ENDIF}
{IF USED_DOMAIN_SINT}
			DOMAIN_SINT:  
				candidate.SINT := p^.SINT + TO_SINT(UI_INCREMENT);
				p^.SINT := CheckMax(i, domain, candidate).SINT;
{ENDIF}
{IF USED_DOMAIN_USINT}
			DOMAIN_USINT:  
				candidate.USINT := p^.USINT + TO_USINT(UI_INCREMENT);
				p^.USINT := CheckMax(i, domain, candidate).USINT;
{ENDIF}
{IF USED_DOMAIN_DINT}
			DOMAIN_DINT:  
				candidate.DINT := p^.DINT + TO_DINT(UI_INCREMENT);
				p^.DINT := CheckMax(i, domain, candidate).DINT;
{ENDIF}
{IF USED_DOMAIN_UDINT}
			DOMAIN_UDINT: 
				candidate.UDINT := p^.UDINT + TO_UDINT(UI_INCREMENT);
				p^.UDINT := CheckMax(i, domain, candidate).UDINT;
{ENDIF}
{IF USED_DOMAIN_DATE}
			DOMAIN_DATE:
			    SPLIT_DATE(p^.DATE, dateTime);
				FOR count := 1 TO TO_INT(UI_INCREMENT) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#DAY,TRUE);
                END_FOR;
			    p^.DATE := CONCAT_DATE(dateTime.Year, dateTime.Month, dateTime.Day);
{ENDIF}
{IF USED_DOMAIN_TOD}
			DOMAIN_TOD: 
				SPLIT_TOD(p^.TOD, dateTime);
                FOR count := 1 TO TO_INT(UI_INCREMENT) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#MINUTE,TRUE);
                END_FOR;
                p^.TOD := CONCAT_TOD(dateTime.Hour, dateTime.Minute, dateTime.Second, dateTime.Millisecond);
{ENDIF}
{IF USED_DOMAIN_TIME}
            DOMAIN_TIME: 
				SPLIT_TIME(p^.TIME, dateTime);
                FOR count := 1 TO TO_INT(UI_INCREMENT) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#MINUTE,TRUE);
                END_FOR;
                p^.Time := CONCAT_TIME(dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second, dateTime.Millisecond);
{ENDIF}
{IF USED_DOMAIN_DT}
            DOMAIN_DT: 
				SPLIT_DT(p^.DT, dateTime);
                FOR count := 1 TO TO_INT(UI_INCREMENT) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#MINUTE,TRUE);
                END_FOR;
                p^.DT := CONCAT_DT(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second, dateTime.Millisecond);
{ENDIF}
		END_CASE;
	END_IF;
END_FUNCTION

FUNCTION INTERNAL DecrementVariable
	VAR_INPUT
		p : REF_TO VARCONTENT;
		i : UINT;
		domain : USINT;
	END_VAR
    VAR_IN_OUT CONSTANT
        keyCounter : UINT;
    END_VAR
	VAR
{IF USED_DOMAIN_INT OR USED_DOMAIN_UINT OR USED_DOMAIN_REAL OR USED_DOMAIN_LREAL OR USED_DOMAIN_SINT OR USED_DOMAIN_USINT OR USED_DOMAIN_DINT OR USED_DOMAIN_UDINT}
		candidate : VARCONTENT;
{ENDIF}
{IF USED_DOMAIN_LREAL OR USED_DOMAIN_REAL}
		ratio : INT;
{ENDIF}
{IF USED_DOMAIN_DT OR USED_DOMAIN_TIME OR USED_DOMAIN_TOD OR USED_DOMAIN_DATE}
		dateTime : DateTime;
		count : INT;
{ENDIF}
	END_VAR
	IF domain = DOMAIN_BOOL  THEN
		SetBool(TO_INT(i), NOT GetBool(TO_INT(i)));
	ELSE
		CASE domain OF
{IF USED_DOMAIN_INT}
			DOMAIN_INT:  
				candidate.INT := p^.INT - TO_INT(UI_INCREMENT);
				p^.INT := CheckMin(i, domain, candidate).INT;
{ENDIF}
{IF USED_DOMAIN_UINT}
			DOMAIN_UINT:  
				candidate.UINT := p^.UINT - UI_INCREMENT;
				p^.UINT := CheckMin(i, domain, candidate).UINT;
{ENDIF}
{IF USED_DOMAIN_REAL}
			DOMAIN_REAL:  
				ratio := GetRatio(i);
				candidate.DINT := TO_DINT(p^.REAL * TO_REAL(ratio)) - TO_DINT(UI_INCREMENT);
				candidate := CheckMin(i, domain, candidate); //returns the REAL value
				p^.REAL := candidate.REAL;
{ENDIF}
{IF USED_DOMAIN_LREAL}
			DOMAIN_LREAL:	
				ratio := GetRatio(i);
				candidate.DINT := TO_DINT(p^.LREAL * TO_LREAL(ratio)) - TO_DINT(UI_INCREMENT);
				candidate := CheckMin(i, domain, candidate);
				p^.LREAL := TO_LREAL(candidate.REAL);
{ENDIF}
{IF USED_DOMAIN_SINT}
			DOMAIN_SINT:  
				candidate.SINT := p^.SINT - TO_SINT(UI_INCREMENT);
				p^.SINT := CheckMin(i, domain, candidate).SINT;
{ENDIF}
{IF USED_DOMAIN_USINT}
			DOMAIN_USINT:  
				candidate.USINT := p^.USINT - TO_USINT(UI_INCREMENT);
				p^.USINT := CheckMin(i, domain, candidate).USINT;
{ENDIF}
{IF USED_DOMAIN_DINT}
			DOMAIN_DINT:  
				candidate.DINT := p^.DINT - TO_DINT(UI_INCREMENT);
				p^.DINT := CheckMin(i, domain, candidate).DINT;
{ENDIF}
{IF USED_DOMAIN_UDINT}
			DOMAIN_UDINT: 
				candidate.UDINT := p^.UDINT - TO_UDINT(UI_INCREMENT);
				p^.UDINT := CheckMin(i, domain, candidate).UDINT;
{ENDIF}
{IF USED_DOMAIN_DATE}
			DOMAIN_DATE: 
				SPLIT_DATE(p^.DATE, dateTime);
				FOR count := 1 TO TO_INT(keyCounter) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#DAY,FALSE);
                END_FOR;
			    p^.DATE := CONCAT_DATE(dateTime.Year, dateTime.Month, dateTime.Day);
{ENDIF}
{IF USED_DOMAIN_TOD}
			DOMAIN_TOD: 
				SPLIT_TOD(p^.TOD, dateTime);
                FOR count := 1 TO TO_INT(UI_INCREMENT) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#MINUTE,FALSE);
                END_FOR;
                p^.TOD := CONCAT_TOD(dateTime.Hour, dateTime.Minute, dateTime.Second, dateTime.Millisecond);
{ENDIF}
{IF USED_DOMAIN_TIME}
            DOMAIN_TIME: 
				SPLIT_TIME(p^.TIME, dateTime);
                FOR count := 1 TO TO_INT(UI_INCREMENT) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#MINUTE,FALSE);
                END_FOR;
                p^.Time := CONCAT_TIME(dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second, dateTime.Millisecond);
{ENDIF}
{IF USED_DOMAIN_DT}
            DOMAIN_DT: 
				SPLIT_DT(p^.DT, dateTime);
                FOR count := 1 TO TO_INT(UI_INCREMENT) DO
                    INCREASE_DECREASE_DATETIME(dateTime, DATETIME_FIELD#MINUTE,FALSE);
                END_FOR;
                p^.DT := CONCAT_DT(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second, dateTime.Millisecond);
{ENDIF}
		END_CASE;
	END_IF;
END_FUNCTION

FUNCTION INTERNAL DrawStringVariable
	VAR_IN_OUT CONSTANT
		p_str : REF_TO STRING;
		row : INT;
		column : INT;
		i : INT;
	END_VAR
	VAR
		length : USINT;
	END_VAR

	length := TO_USINT(LEN(p_str^));
	IF(gui.currentField = TO_UINT(i) AND //selectable AND selected
	   gui.stringIndex > length AND length > 0) THEN
		gui.stringIndex := length - 1; //handles runtime string changes with different lengths
		SetCursor(TO_INT(guiInfo.fieldsInfo[gui.currentField].row),
                  TO_INT(guiInfo.fieldsInfo[gui.currentField].column +
                  TO_UINT(gui.stringIndex)));
	END_IF;
	DrawString(p_str^, row, column);
END_FUNCTION

FUNCTION DrawScrollableText
	VAR_INPUT
		str_ptr : REF_TO STRING;
        size : USINT;
		row, col : INT;
		selected : BOOL;
	END_VAR
	VAR
        str : STRING;
		length : USINT;
	END_VAR
    str := str_ptr^;
	length := TO_USINT(LEN(str));
	IF selected AND length > size + 1 THEN //a space is added after the actual string
		IF (gui.stringIndex + size) <= length THEN
			DrawString(MID(str,size,gui.stringIndex), row, col);
		ELSE //expects a blank space to be added as last string char
			DrawString(CONCAT(MID(str, length - gui.stringIndex, gui.stringIndex),
							  MID(str, ((gui.stringIndex + size) - length), 0)),
					   row, col);
		END_IF;
		gui.stringIndex := (gui.stringIndex + 1) MOD length;
	ELSE
		DrawString(MID(str,size,0), row, col);
	END_IF;
END_FUNCTION

FUNCTION DrawVariable 
	VAR_INPUT 
		vc : VARCONTENT;
		fieldID : INT; //-1 when unknown or not used (e.g. inside a widget class) 
		row, col : INT;
        presentation : SINT;//0 = none presentation. if don't want use presentation,you can give a value 0        
		domain : USINT;
		isSelected : BOOL;
		shift : BOOL;
	END_VAR	
	VAR
		s : STRING;
	END_VAR
	s := GetVarString(vc, fieldID, domain, isSelected);	

    //adjust column: the original col decide the cursor position, the adjusted col decide the first char position
	IF (shift) THEN
		col := MAX(col - TO_INT(LEN(s)) + 1,0);
	END_IF;

    //set cursor for compact field
    IF presentation = -7 THEN
        IF isSelected  THEN
            SetCursor(row, col -1 + TO_INT(LEN(s)));//set cursor on last char
        ELSE
            HideCursor();
        END_IF;
    END_IF;
	DrawString(s, row, col);
END_FUNCTION


FUNCTION INTERNAL GetVarString : STRING
	VAR_INPUT 
		vc : VARCONTENT;
		fieldID : INT; //-1 when unknown or not used (e.g. inside a widget class) 
		domain : USINT;
		isSelected : BOOL;
	END_VAR	
	VAR
		s : STRING;
	END_VAR	
	IF isSelected AND UseTmpVarContent(TO_UINT(fieldID)) THEN
		// draw tmp value
		CASE domain OF
{IF USED_DOMAIN_BOOL}
			DOMAIN_BOOL: // bool
				s :=  TO_STRING(gui.tmpVarContent.BOOL);
{ENDIF}
{IF USED_DOMAIN_INT}
			DOMAIN_INT: // int
				s :=  TO_STRING(gui.tmpVarContent.INT);
{ENDIF}
{IF USED_DOMAIN_UINT}
			DOMAIN_UINT: //uint
				s :=  TO_STRING(gui.tmpVarContent.UINT);
{ENDIF}
{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
			DOMAIN_REAL,
			DOMAIN_LREAL:
				s :=  RealString(gui.currentField,gui.tmpVarContent.DINT);
{ENDIF}
{IF USED_DOMAIN_SINT}
			DOMAIN_SINT: //SINT
				s :=  TO_STRING(gui.tmpVarContent.SINT);	
{ENDIF}
{IF USED_DOMAIN_USINT}	
			DOMAIN_USINT : //USINT
				s :=  TO_STRING(gui.tmpVarContent.USINT);	
{ENDIF}
{IF USED_DOMAIN_DINT}	
			DOMAIN_DINT : //DINT
				s :=  TO_STRING(gui.tmpVarContent.DINT);
{ENDIF}
{IF USED_DOMAIN_UDINT}		
			DOMAIN_UDINT : //UDINT
				s :=  TO_STRING(gui.tmpVarContent.UDINT);
{ENDIF}
{IF USED_DOMAIN_BYTE}
			DOMAIN_BYTE: 
			s :=  TO_STRING(gui.tmpVarContent.BYTE);
{ENDIF}
		END_CASE;
	ELSE
		// else draw variable
		CASE domain OF
{IF USED_DOMAIN_BOOL}
			DOMAIN_BOOL: // bool
				s :=  TO_STRING(GetBool(fieldID));
{ENDIF}
{IF USED_DOMAIN_INT}
			DOMAIN_INT: // int
				s :=  TO_STRING(vc.INT);
{ENDIF}
{IF USED_DOMAIN_UINT}
			DOMAIN_UINT: //uint
				s :=  TO_STRING(vc.UINT);
{ENDIF}
{IF USED_DOMAIN_REAL}
			DOMAIN_REAL://real
				s :=  RealString(TO_UINT(fieldID),
						TO_DINT(vc.REAL * TO_REAL(GetRatio(TO_UINT(fieldID)))));	
{ENDIF}
{IF USED_DOMAIN_LREAL}	
			DOMAIN_LREAL: //lreal
				s :=  RealString(TO_UINT(fieldID),
					TO_DINT(vc.LREAL * TO_LREAL(GetRatio(TO_UINT(fieldID)))));
{ENDIF}
{IF USED_DOMAIN_SINT}
			DOMAIN_SINT: //SINT
				s :=  TO_STRING(vc.SINT);
{ENDIF}
{IF USED_DOMAIN_USINT}
			DOMAIN_USINT : //USINT
				s :=  TO_STRING(vc.USINT);
{ENDIF}
{IF USED_DOMAIN_DINT}
			DOMAIN_DINT : //DINT
				s :=  TO_STRING(vc.DINT);
{ENDIF}
{IF USED_DOMAIN_UDINT}
			DOMAIN_UDINT : //UDINT
				s :=  TO_STRING(vc.UDINT);
{ENDIF}
{IF USED_DOMAIN_BYTE}
			DOMAIN_BYTE: s :=  TO_STRING(vc.BYTE);
{ENDIF}
		END_CASE;
	END_IF;	
	IF(s = 'TRUE') THEN
		s := '1';
	ELSIF (s = 'FALSE') THEN
		s := '0';
	END_IF;
	GetVarString := s;
END_FUNCTION

FUNCTION IncrementVariable
	VAR_INPUT
		domain : USINT;
	END_VAR
    VAR_IN_OUT CONSTANT
        keyCounter : UINT;
    END_VAR
	VAR
{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
		candidate : VARCONTENT;
{ENDIF}
	END_VAR
	CASE domain OF
{IF USED_DOMAIN_BOOL}
		DOMAIN_BOOL: // bool
			gui.tmpVarContent.BOOL := NOT gui.tmpVarContent.bool;
{ENDIF}
{IF USED_DOMAIN_DT}
		DOMAIN_DT,
{ENDIF}
{IF USED_DOMAIN_UINT}
		DOMAIN_UINT,
{ENDIF}
{IF USED_DOMAIN_SINT}
		DOMAIN_SINT,
{ENDIF}
{IF USED_DOMAIN_USINT}
		DOMAIN_USINT,
{ENDIF}
{IF USED_DOMAIN_DINT}
		DOMAIN_DINT,
{ENDIF}
{IF USED_DOMAIN_UDINT}
		DOMAIN_UDINT,
{ENDIF}
{IF USED_DOMAIN_TOD}
		DOMAIN_TOD,
{ENDIF}
{IF USED_DOMAIN_TIME}
		DOMAIN_TIME,
{ENDIF}
		DOMAIN_INT:
			IncrementVariable(REF(gui.tmpVarContent), gui.currentField, domain, keyCounter);
{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
		DOMAIN_REAL,
		DOMAIN_LREAL:
			candidate.DINT := gui.tmpVarContent.DINT + 1;
			gui.tmpVarContent.DINT := GetDintFromRealTmpValue(CheckMaxReal(GetRealTmpValue(candidate.DINT, gui.currentField), gui.currentField), gui.currentField);
{ENDIF}
	END_CASE;
END_FUNCTION

FUNCTION DecrementVariable
	VAR_INPUT
		domain : USINT;
	END_VAR
    VAR_IN_OUT CONSTANT
        keyCounter : UINT;
    END_VAR
	VAR
{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
		candidate : VARCONTENT;
{ENDIF}
	END_VAR
	CASE domain OF
{IF USED_DOMAIN_BOOL}
		DOMAIN_BOOL: // bool
			gui.tmpVarContent.BOOL := NOT gui.tmpVarContent.bool;
{ENDIF}
{IF USED_DOMAIN_INT}
		DOMAIN_DT,
{ENDIF}
{IF USED_DOMAIN_UINT}
		DOMAIN_UINT,
{ENDIF}
{IF USED_DOMAIN_SINT}
		DOMAIN_SINT,
{ENDIF}
{IF USED_DOMAIN_USINT}
		DOMAIN_USINT,
{ENDIF}
{IF USED_DOMAIN_DINT}
		DOMAIN_DINT,
{ENDIF}
{IF USED_DOMAIN_UDINT}
		DOMAIN_UDINT,
{ENDIF}
{IF USED_DOMAIN_TOD}
		DOMAIN_TOD,
{ENDIF}
{IF USED_DOMAIN_TIME}
		DOMAIN_TIME,
{ENDIF}
		DOMAIN_INT:
			DecrementVariable(REF(gui.tmpVarContent), gui.currentField, domain, keyCounter);
{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
		DOMAIN_REAL,
		DOMAIN_LREAL:
			candidate.DINT := gui.tmpVarContent.DINT - 1;
			gui.tmpVarContent.DINT := GetDintFromRealTmpValue(CheckMinReal(GetRealTmpValue(candidate.DINT, gui.currentField), gui.currentField), gui.currentField);
{ENDIF}
	END_CASE;
END_FUNCTION


TYPE DATETIME_FIELD : 
(
    SECOND,
    MINUTE,
    HOUR,
    DAY,
    MONTH,
    YEAR
);
END_TYPE

FUNCTION INTERNAL INCREASE_DECREASE_DATETIME
    VAR_IN_OUT
        dateTime : DateTime;
    END_VAR
    VAR_INPUT
        field : DATETIME_FIELD;
		increase:BOOL;
    END_VAR
	VAR
		delta:TIME:=TIME#0s;
		DateAndTime:DATE_AND_TIME;
	END_VAR

	DateAndTime:=CONCAT_DT(DateTime);

    CASE field OF
        DATETIME_FIELD#SECOND: 
			delta:=TIME#1s;
		DATETIME_FIELD#MINUTE:
			delta:=TIME#1m;
		DATETIME_FIELD#HOUR:
			delta:=TIME#1h;
		DATETIME_FIELD#DAY:
			delta:=TIME#1d;
		DATETIME_FIELD#MONTH:
			delta:=TIME#31d;	//may change current day
		DATETIME_FIELD#YEAR:
			delta:=TIME#365d;	//may change current day/month
    END_CASE;
	IF increase THEN
		DateAndTime:=DateAndTime+delta;
	ELSE
		DateAndTime:=DateAndTime-delta;
	END_IF;

	SPLIT_DT(dateAndTime,DateTime);

END_FUNCTION 

FUNCTION INTERNAL GetLastMaskInLoop :UINT
    VAR_INPUT
        loopIndex : UINT;
    END_VAR

    IF loopIndex = LOOP_COUNT -1 THEN
        GetLastMaskInLoop := MASK_COUNT -1;     //last loop
    ELSE
        GetLastMaskInLoop := guiInfo.loopsInfo[loopIndex +1] - 1;
    END_IF;
END_FUNCTION

FUNCTION INTERNAL GetLastFieldInMask : UINT
    VAR_INPUT
        maskIndex : UINT;
	END_VAR
    VAR
		i : INT;
		index : INT := 0;
	END_VAR
    IF (guiInfo.masksInfo[maskIndex] <> 0)THEN //empty mask
        IF maskIndex = MASK_COUNT -1 THEN
            index := FIELD_COUNT -1;    //last mask
        ELSE
            index := TO_INT(guiInfo.masksInfo[maskIndex +1] - 1); //normal case
    		IF(index < 0) THEN //the next mask is empty
                FOR i := TO_INT(maskIndex + 1) TO TO_INT(MASK_COUNT)-1 DO
                    index := TO_INT(guiInfo.masksInfo[i] - 1);
                    IF(index >=0) THEN
                        EXIT;
                    END_IF;
                END_FOR;
            END_IF;
    		IF(index < 0) THEN //we are on the last mask with some fields
    			index := FIELD_COUNT -1;
    		END_IF;
        END_IF;
    END_IF;
    GetLastFieldInMask := to_UINT(index);
END_FUNCTION

(** Proceeds the UI navigation to the first mask of the next loop*)
FUNCTION GoToNextLoop
VAR
	i : INT;
END_VAR

    FOR i := TO_INT(gui.currentLoop + 1) TO TO_INT(LOOP_COUNT - 1) DO
	    IF GoToLoop(TO_UINT(i)) THEN
            EXIT;
        END_IF;
    END_FOR;

END_FUNCTION

(** Proceeds the UI navigation to the first mask of the previous loop*)
FUNCTION GoToPreviousLoop
VAR
	i : INT;
END_VAR

    FOR i := TO_INT(gui.currentLoop -1) TO 0 BY -1 DO
	    IF GoToLoop(TO_UINT(i)) THEN
            EXIT;
        END_IF;
    END_FOR;

END_FUNCTION

(** Proceeds the UI navigation to the first mask of the specified loop*)
    (**
        @example
        GoToLoop(LoopList#MyLoop);
    *)
FUNCTION GoToLoop
	VAR_INPUT
		(** Target loop, its type is an autogenerated enum, which values are the loops' names*)
		targetLoop : LoopList;
	END_VAR
    gui.blink := FALSE;
GoToLoop(TO_UINT(targetLoop));
END_FUNCTION

FUNCTION INTERNAL GoToLoop : BOOL
	VAR_INPUT
		targetLoop : UINT;
	END_VAR

    IF(EvaluateLoopEnable(TO_INT(targetLoop))) THEN
        gui.currentLoop := targetLoop;
        GoToLoop := TRUE;
    ELSE
        GoToLoop := FALSE;
    END_IF;
	GoToFirstMask();
END_FUNCTION

FUNCTION INTERNAL PushRecentMask
	VAR_INPUT
		recentMask : UINT;
	END_VAR
	// increase recent mask index (and restart from 0 if necessary)
	gui.lastRecentMask := gui.lastRecentMask +1;
	IF gui.lastRecentMask > MAX_RECENT_MASKS-1 THEN
		gui.lastRecentMask := 0;
	END_IF;
	// save recent mask
	gui.recentMasks[gui.lastRecentMask] := recentMask;
END_FUNCTION

(** Proceeds the UI navigation to the last visited mask*)
FUNCTION PopLastMask
	IF gui.lastRecentMask < MAX_RECENT_MASKS THEN
		GoToMask(gui.recentMasks[gui.lastRecentMask]);
		// void lastRecentMask
		gui.recentMasks[gui.lastRecentMask] := 16#FFFF;
		// decrease lastRecentMask
		IF gui.lastRecentMask > 0 THEN
			gui.lastRecentMask := gui.lastRecentMask -1;
		END_IF;
	END_IF;
END_FUNCTION

(** Proceeds the UI navigation to the next mask in the current loop. If the current mask is
    the last in the loop, it will restart from the first enabled mask of the current loop*)
FUNCTION GoToNextMask
	VAR
		nextMask : UINT;
	END_VAR
	nextMask := gui.currentMask+1;
	IF nextMask > GetLastMaskInLoop(gui.currentLoop) THEN
		nextMask := guiInfo.loopsInfo[gui.currentLoop];
	END_IF;
	GoToMask(nextMask ,TRUE);
END_FUNCTION

(** Proceeds the UI navigation to the previous mask in the current loop. If the current mask is
    the first in the loop, it will remain on that one*)
FUNCTION GoToPreviousMask
	VAR
		previousMask : UINT;
	END_VAR
	previousMask := gui.currentMask-1;
	IF gui.currentMask=0 OR previousMask < guiInfo.loopsInfo[gui.currentLoop] THEN
		previousMask := GetLastMaskInLoop(gui.currentLoop);
	END_IF;
	GoToMask(previousMask ,FALSE);
END_FUNCTION

(** Proceeds the UI navigation to the first mask in the current loop*)
FUNCTION GoToFirstMask
	GoToMask(guiInfo.loopsInfo[gui.currentLoop], TRUE);
END_FUNCTION

(** Proceeds the UI navigation to the last mask in the current loop*)
FUNCTION GoToLastMask
	GoToMask(GetLastMaskInLoop(gui.currentLoop), TRUE);
END_FUNCTION

(** Proceeds the UI navigation to the specified mask*)
    (**
        @example
        GoToMask(MaskList#MyMask);
    *)
	
FUNCTION GoToMask
	VAR_INPUT
		(** Target mask, its type is an autogenerated enum, which values are the masks' names*)
		targetMask : MaskList;
	END_VAR
    gui.blink := FALSE;
	GoToMask(TO_UINT(targetMask), TRUE, TRUE);
END_FUNCTION

FUNCTION INTERNAL GoToMask
	VAR_INPUT
		targetMask : UINT;
	END_VAR
	GoToMask(targetMask, TRUE, TRUE);
END_FUNCTION

FUNCTION INTERNAL GoToMask
	VAR_INPUT
		targetMask : UINT;
		increment : BOOL;
	END_VAR
	GoToMask(targetMask, increment, TRUE);
END_FUNCTION

FUNCTION INTERNAL GoToMask
	VAR_INPUT
		targetMask : UINT;
		increment : BOOL;
		saveRecent : BOOL;
	END_VAR
	VAR
		i : INT := 0;
		choosenOne : INT :=-1;
		choosenLoop : INT :=-1;
		lastMaskIndex : INT;
	END_VAR

	//jump on a mask of the same loop
	IF 	targetMask >= guiInfo.loopsInfo[gui.currentLoop] AND
		targetMask <= GetLastMaskInLoop(gui.currentLoop)AND
		EvaluateLoopEnable(TO_INT(gui.currentLoop)) THEN
			choosenLoop := TO_INT(gui.currentLoop);
	ELSE
		FOR i := 0 TO TO_INT(LOOP_COUNT)-1 DO
			IF targetMask >= guiInfo.loopsInfo[i] AND
				targetMask <= GetLastMaskInLoop(TO_UINT(i)) AND
				EvaluateLoopEnable(i) THEN
				choosenLoop := i;
				EXIT;
			//ELSE non ho trovato loop lascio -1
			END_IF;
		END_FOR;
	END_IF;
	IF (choosenLoop <> -1) THEN
		lastMaskIndex := TO_INT(GetLastMaskInLoop(TO_UINT(choosenLoop)));
		IF(increment = TRUE) THEN
				FOR i := TO_INT(targetMask) TO lastMaskIndex DO
					IF EvaluateMaskEnable(i) THEN
						choosenOne := i;
						EXIT;
					END_IF;
				END_FOR;
			IF(choosenOne = -1) THEN
				FOR i := TO_INT(guiInfo.loopsInfo[choosenLoop]) TO TO_INT(targetMask) DO
					IF EvaluateMaskEnable(i) THEN
						choosenOne := i;
						EXIT;
					END_IF;
				END_FOR;
			END_IF;
		ELSE //go Up reverse order
			FOR i := TO_INT(targetMask) TO TO_INT(guiInfo.loopsInfo[choosenLoop]) BY -1 DO
				IF EvaluateMaskEnable(i) THEN
					choosenOne := i;
					EXIT;
				END_IF;
			END_FOR;
			IF(choosenOne = -1) THEN
				FOR i := lastMaskIndex TO TO_INT(targetMask) BY -1 DO
					IF EvaluateMaskEnable(i) THEN
						choosenOne := i;
						EXIT;
					END_IF;
				END_FOR;
			END_IF;
		END_IF;
		IF(choosenOne <>-1 AND choosenOne <> TO_INT(gui.currentMask)) THEN
			// save recent mask
			IF saveRecent = TRUE THEN
				PushRecentMask(gui.currentMask);
			END_IF;

			gui.currentLoop := TO_UINT(choosenLoop);
			// reset cursor and current field
			gui.currentField := StartingField(choosenOne);
			gui.currentMask := TO_UINT(choosenOne);
			LoadFieldsData(gui.currentMask);
			HandleStartingField();

            IF gui.currentField = 0 THEN
		        HandleDummyField();
	        ELSE
			    SetCursor(TO_INT(guiInfo.fieldsInfo[gui.currentField].row), TO_INT(guiInfo.fieldsInfo[gui.currentField].column));
            END_IF;

			// change current mask
		END_IF;
	ELSE
		//no changes occur, there aren't any valid masks
	END_IF;
END_FUNCTION


FUNCTION INTERNAL HandleStartingField
VAR 
	i : INT;
END_VAR
	//tmpVarContent handling for starting field =/= 0
	IF(gui.currentField > 0) THEN
		i := TO_INT(gui.currentField - guiInfo.masksInfo[gui.currentMask]);
		IF(gui.currentData[i] <> 0) THEN //check pointer
			IF(guiInfo.fieldsInfo[gui.currentField].domain = DOMAIN_REAL) THEN
				gui.tmpVarContent.DINT := TO_DINT(gui.currentData[i]^.REAL * TO_REAL(GetRatio(gui.currentField)));
			ELSIF (guiInfo.fieldsInfo[gui.currentField].domain = DOMAIN_LREAL) THEN
				gui.tmpVarContent.DINT := TO_DINT(gui.currentData[i]^.LREAL * TO_LREAL(GetRatio(gui.currentField)));
			ELSIF (guiInfo.fieldsInfo[gui.currentField].domain = DOMAIN_BOOL) THEN
				gui.tmpVarContent.BOOL := GetBool(TO_INT(gui.currentField));
			ELSE
				gui.tmpVarContent := gui.currentData[i]^;
			END_IF;
		END_IF;
	END_IF;
END_FUNCTION

FUNCTION INTERNAL SetDecimalValue
	VAR_INPUT
		var_p : POINTER TO VARCONTENT;
		intValue : DINT;
		ratio : INT;
		domain : USINT;
	END_VAR
	CASE domain OF
		DOMAIN_REAL: var_p^.REAL := TO_REAL(intValue) / TO_REAL(ratio);
		DOMAIN_LREAL: var_p^.LREAL := TO_LREAL(intValue) / TO_LREAL(ratio);
	END_CASE;
END_FUNCTION
FUNCTION INTERNAL RealString : STRING
	VAR_INPUT
		fieldIndex : UINT;
		noPoint : DINT;
	END_VAR
	VAR
		intString : STRING[22];
		decString : STRING[4];
		formatString : STRING[5];
		intPart : DINT;
		decPart : INT;
		ratio : INT;
		numberOfDigits : STRING[1]; //after the point
	END_VAR
	ratio := GetRatio(fieldIndex);
	intPart := noPoint / TO_DINT(ratio);
	IF (noPoint <> 0) THEN decPart := TO_INT(noPoint MOD TO_DINT(ratio));
	ELSE decPart := 0;
	END_IF;
	IF(intPart < 0 OR decPart < 0) THEN
		intPart := ABS(intPart);
		decPart := ABS(decPart);
		intString := intString + '-';
	END_IF;
    CASE ratio OF
		10 : numberOfDigits := '1';
		100 : numberOfDigits := '2';
		1000 : numberOfDigits := '3';
		10000 : numberOfDigits := '4';
		ELSE numberOfDigits := '0';
	END_CASE;
	IF numberOfDigits = '0' THEN
		RealString := TO_STRING(intPart);
	ELSE
		formatString := '%0' + numberOfDigits +'ld';
		decString := FORMAT(formatString, decPart); //always put zeroes after the point to pad
		IF (NOT ZeroSuppression(fieldIndex)) THEN
			formatString := '%0' + TO_STRING(IntPartLength(fieldIndex)) + 'd';
			intString := intString + FORMAT(formatString, intPart);
		ELSE intString := intString + TO_STRING(intPart);
		END_IF;
		RealString := intString + '.' + decString;
	END_IF;
END_FUNCTION
FUNCTION INTERNAL NextStringChar
    VAR
    	length : USINT;
        dataIndex : UINT;
    END_VAR

    dataIndex := gui.currentField - guiInfo.masksInfo[gui.currentMask];
    length := TO_USINT(LEN(gui.currentData[dataIndex]^.STRPOINTER^));

	IF length > 0 THEN
		gui.stringIndex := gui.stringIndex + 1;
		IF(gui.stringIndex >= length) THEN
			GoToNextField();
		ELSE
			SetCursor(TO_INT(guiInfo.fieldsInfo[gui.currentField].row), TO_INT(guiInfo.fieldsInfo[gui.currentField].column + TO_UINT(gui.stringIndex)));
		END_IF;
	END_IF;
END_FUNCTION
FUNCTION INTERNAL IncreaseChar
    VAR_IN_OUT
    	s_ptr : REF_TO STRING;
    END_VAR
    VAR
		length : USINT;
        nextChar : USINT;
    END_VAR

	length := TO_USINT(LEN(s_ptr^));
	IF gui.stringIndex < length THEN
		nextChar := TO_USINT(s_ptr^[gui.stringIndex]) + 1;
		IF (nextChar > LAST_VALID_CHAR) THEN
			nextChar := FIRST_VALID_CHAR;
		END_IF;
		s_ptr^[gui.stringIndex] := TO_CHAR(nextChar);
	END_IF;
END_FUNCTION
FUNCTION INTERNAL DecreaseChar
    VAR_IN_OUT
    	s_ptr : REF_TO STRING;
    END_VAR
    VAR
		length : USINT;
        nextChar : USINT;
    END_VAR

	length := TO_USINT(LEN(s_ptr^));
	IF gui.stringIndex < length THEN
		nextChar := TO_USINT(s_ptr^[gui.stringIndex]) - 1;
		IF (nextChar < FIRST_VALID_CHAR) THEN
			nextChar := LAST_VALID_CHAR;
		END_IF;
		s_ptr^[gui.stringIndex] := TO_CHAR(nextChar);
	END_IF;
END_FUNCTION


(** Sets the UI to the next available language, restarting from the first when the last one is reached*)
FUNCTION SetNextLanguage
	SetLanguageID((GetLanguageID() + 1) MOD Assets.Language.LanguagesCount);
END_FUNCTION

FUNCTION GetDintFromRealTmpValue : DINT
VAR_INPUT
    value : REAL;
	fieldIndex : UINT;
END_VAR
GetDintFromRealTmpValue := TO_DINT(value * TO_REAL(GetRatio(fieldIndex)));
END_FUNCTION

FUNCTION INTERNAL GetRealTmpValue : REAL
VAR_INPUT
	value : DINT;
    fIndex : UINT;
END_VAR
GetRealTmpValue := TO_REAL(TO_REAL(value) / TO_REAL(GetRatio(fIndex)));
END_FUNCTION

FUNCTION INTERNAL GetLongRealTmpValue : LREAL
VAR_INPUT
	value : DINT;
    fIndex : UINT;
END_VAR
GetLongRealTmpValue := TO_LREAL(TO_LREAL(value) / TO_LREAL(GetRatio(fIndex)));
END_FUNCTION

{IF DEF(MULTI_ZONE_UI)}
FUNCTION INTERNAL ConvertValueToUoM : VARCONTENT
VAR_INPUT
    vc : VARCONTENT;
    domain : USINT;
	uom : UOM;
END_VAR
VAR
	result : REAL;
END_VAR
    CONVERT_ZONE_UOM(GetRealFromVarContent(vc, domain), gui.currentZone, result, uom);
    SetRealIntoVarContent(vc, domain, result);
    tempUoMVar := CheckMax(gui.currentField, domain, vc);
    IF tempUoMVar.REAL > vc.REAL THEN
        vc.real := tempUoMVar.real;
    END_IF;
    tempUoMVar := CheckMin(gui.currentField, domain, vc);
    IF tempUoMVar.REAL < vc.REAL THEN
        vc.real := tempUoMVar.real;
    END_IF;
    ConvertValueToUoM := vc;
END_FUNCTION

FUNCTION GetRealFromVarContent : REAL
VAR_INPUT
	vc : VARCONTENT;
END_VAR
VAR_IN_OUT CONSTANT
    domain : USINT;
END_VAR
    CASE domain OF
{IF USED_DOMAIN_INT}
		DOMAIN_INT: 
			GetRealFromVarContent := TO_REAL(vc.INT);
{ENDIF}
{IF USED_DOMAIN_UINT}
		DOMAIN_UINT:
			GetRealFromVarContent := TO_REAL(vc.UINT);
{ENDIF}
{IF USED_DOMAIN_REAL}
		DOMAIN_REAL:
			GetRealFromVarContent := vc.REAL;
{ENDIF}
{IF USED_DOMAIN_LREAL}
		DOMAIN_LREAL:
			GetRealFromVarContent := TO_REAL(vc.LREAL);
{ENDIF}
{IF USED_DOMAIN_SINT}
        DOMAIN_SINT:
			GetRealFromVarContent := TO_REAL(vc.SINT);
{ENDIF}
{IF USED_DOMAIN_USINT}
		DOMAIN_USINT:
			GetRealFromVarContent := TO_REAL(vc.USINT);
{ENDIF}
{IF USED_DOMAIN_DINT}
		DOMAIN_DINT:
			GetRealFromVarContent := TO_REAL(vc.DINT);
{ENDIF}
{IF USED_DOMAIN_UDINT}
		DOMAIN_UDINT:
			GetRealFromVarContent := TO_REAL(vc.UDINT);
{ENDIF}
    END_CASE;
END_FUNCTION
FUNCTION SetRealIntoVarContent
VAR_IN_OUT
	vc : VARCONTENT;
END_VAR
VAR_IN_OUT CONSTANT
    domain : USINT;
    value : REAL;
END_VAR
    CASE domain OF
{IF USED_DOMAIN_INT}
		DOMAIN_INT:
			vc.INT:= TO_INT(value);
{ENDIF}
{IF USED_DOMAIN_UINT}
		DOMAIN_UINT:
			vc.UINT:= TO_UINT(value);
{ENDIF}
{IF USED_DOMAIN_REAL}
		DOMAIN_REAL:
			vc.REAL := value;
{ENDIF}
{IF USED_DOMAIN_LREAL}
		DOMAIN_LREAL:
			vc.LREAL:= TO_LREAL(value);
{ENDIF}
{IF USED_DOMAIN_SINT}
        DOMAIN_SINT:
			vc.SINT:= TO_SINT(value);
{ENDIF}
{IF USED_DOMAIN_USINT}
		DOMAIN_USINT:
			vc.USINT:= TO_USINT(value);
{ENDIF}
{IF USED_DOMAIN_DINT}
		DOMAIN_DINT:
			vc.DINT:= TO_DINT(value);
{ENDIF}
{IF USED_DOMAIN_UDINT}
		DOMAIN_UDINT:
			vc.UDINT:= TO_UDINT(value);
{ENDIF}
    END_CASE;
END_FUNCTION

FUNCTION ConvertFieldToZone : VARCONTENT
VAR_INPUT
    vc : VARCONTENT;
	domain : USINT;
    uom : UOM;
END_VAR
VAR
	result : REAL;
END_VAR
    CONVERT_UOM_ZONE(GetRealFromVarContent(vc, domain), uom, result, gui.currentZone);
    SetRealIntoVarContent(vc, domain, result);
    ConvertFieldToZone := vc;
END_FUNCTION
{ENDIF}

FUNCTION INTERNAL DrawUoMField
VAR_IN_OUT CONSTANT
	dataIndex : INT;
    i : INT;
    row : INT;
    column : INT;
END_VAR
VAR
	tmp : VARCONTENT;
    uom : UOM;
	s : STRING;
END_VAR
    uom := GetUoM(TO_UINT(i));
    IF TO_UINT(i) = gui.currentField AND UseTmpVarContent(TO_UINT(i)) THEN
        tmp := gui.tmpVarContent; //conversion already made in the tmpVarContent
        IF guiInfo.fieldsInfo[i].domain = DOMAIN_REAL OR guiInfo.fieldsInfo[i].domain = DOMAIN_LREAL THEN
            tmp.REAL := GetRealTmpValue(gui.tmpVarContent.DINT, TO_UINT(i));
        END_IF;
    ELSE
        tmp := gui.currentData[dataIndex]^;
		{IF DEF(MULTI_ZONE_UI)}
        tmp := ConvertFieldToZone(tmp, guiInfo.fieldsInfo[i].domain, uom);
		{ENDIF}
    END_IF;
	s := GetVarString(tmp, i, guiInfo.fieldsInfo[i].domain, TO_UINT(i) = gui.currentField);
	DrawString(s, row, MAX(column - TO_INT(LEN(s)) + 1,0));
END_FUNCTION

FUNCTION SetUIZone
VAR_INPUT
	zone : ZONE;
END_VAR
    gui.currentZone := zone;
END_FUNCTION

FUNCTION GetUIZone : ZONE
    GetUIZone := gui.currentZone;
END_FUNCTION

FUNCTION HandleDummyField
IF guiInfo.fieldsInfo[gui.currentField].row = 0 AND 
   guiInfo.fieldsInfo[gui.currentField].column = 0 AND
   ShowDummy(gui.currentMask) = FALSE THEN
	HideCursor();
ELSE
	SetCursor(TO_INT(guiInfo.fieldsInfo[gui.currentField].row), 
		TO_INT(guiInfo.fieldsInfo[gui.currentField].column));
END_IF;
END_FUNCTION

FUNCTION GetCurrentMask : UINT
     GetCurrentMask:= gui.currentMask;
END_FUNCTION


FUNCTION WriteInVarContent
VAR_IN_OUT CONSTANT
    value : VARCONTENT;
END_VAR
VAR_INPUT
    destination : REF_TO VARCONTENT;
END_VAR 
VAR_IN_OUT CONSTANT 
    domain : USINT;
END_VAR
    
    CASE domain OF
{IF USED_DOMAIN_INT}
		DOMAIN_INT: 
			destination^.INT := value.INT;
{ENDIF}
{IF USED_DOMAIN_UINT}
        DOMAIN_UINT: 
			destination^.UINT := value.UINT;
{ENDIF}
{IF USED_DOMAIN_REAL}
		DOMAIN_REAL: 
			destination^.REAL := value.REAL;
{ENDIF}
{IF USED_DOMAIN_LREAL}
        DOMAIN_LREAL: 	
			destination^.LREAL := value.LREAL;
{ENDIF}
{IF USED_DOMAIN_SINT}
        DOMAIN_SINT: 
			destination^.SINT := value.SINT;
{ENDIF}
{IF USED_DOMAIN_USINT}
        DOMAIN_USINT: 
			destination^.USINT := value.USINT;
{ENDIF}
{IF USED_DOMAIN_DINT}
        DOMAIN_DINT: 
			destination^.DINT := value.DINT;
{ENDIF}
{IF USED_DOMAIN_UDINT}
        DOMAIN_UDINT: 
			destination^.UDINT := value.UDINT;
{ENDIF}
{IF USED_DOMAIN_DATE}
		DOMAIN_DATE: 
			destination^.DATE := value.DATE;
{ENDIF}
{IF USED_DOMAIN_TOD}
		DOMAIN_TOD: 
			destination^.TOD := value.TOD;
{ENDIF}
{IF USED_DOMAIN_TIME}
		DOMAIN_TIME: 
			destination^.TIME := value.TIME;
{ENDIF}
{IF USED_DOMAIN_DT}
		DOMAIN_DT: 
			destination^.DT := value.DT; 
{ENDIF}
	END_CASE;

END_FUNCTION

FUNCTION SetVariableValue
	VAR_INPUT
		p : POINTER TO VARCONTENT;
		fieldID : INT;
		domain : USINT;
	END_VAR
    {IF DEF(MULTI_ZONE_UI)}
    VAR
        result : VARCONTENT;
    END_VAR 
    IF GetUoM(gui.currentField) > 0 THEN //UoM handling
        CASE domain OF
{IF USED_DOMAIN_REAL}
            DOMAIN_REAL:
                tempUoMVar.REAL := GetRealTmpValue(gui.tmpVarContent.DINT, TO_UINT(fieldID));
                result := ConvertValueToUoM(tempUoMVar, domain, GetUoM(TO_UINT(fieldID)));
{ENDIF}
{IF USED_DOMAIN_LREAL}
            DOMAIN_LREAL:
                tempUoMVar.LREAL := GetLongRealTmpValue(gui.tmpVarContent.DINT, TO_UINT(fieldID));
                result := ConvertValueToUoM(tempUoMVar, domain, GetUoM(TO_UINT(fieldID)));
{ENDIF}
            ELSE
                result := ConvertValueToUoM(gui.tmpVarContent, domain, GetUoM(TO_UINT(fieldID)));  
        END_CASE;
        WriteInVarContent(result, p,domain);
    ELSE
    {ENDIF}
        CASE domain OF

{IF USED_DOMAIN_REAL OR USED_DOMAIN_LREAL}
            DOMAIN_REAL,
            DOMAIN_LREAL:
                SetDecimalValue(p, gui.tmpVarContent.DINT, GetRatio(TO_UINT(fieldID)), domain);
{ENDIF}
{IF USED_DOMAIN_BOOL}
            DOMAIN_BOOL:
                SetBool(fieldID, gui.tmpVarContent.BOOL);
{ENDIF}
            ELSE
                WriteInVarContent(gui.tmpVarContent, p, domain);
        END_CASE;
    {IF DEF(MULTI_ZONE_UI)}
    END_IF;  
    {ENDIF}
END_FUNCTION

{IF DEF(MULTI_ZONE_UI)}
FUNCTION HandleRealUoMInput
VAR_IN_OUT CONSTANT
    keyCounter : UINT;
END_VAR
VAR_INPUT
    increasing : BOOL;
END_VAR

    IF increasing THEN
        gui.tmpVarContent.DINT := gui.tmpVarContent.DINT + TO_DINT(UI_INCREMENT);
    ELSE
        gui.tmpVarContent.DINT := gui.tmpVarContent.DINT - TO_DINT(UI_INCREMENT);
    END_IF;

    CONVERT_ZONE_UOM(GetRealTmpValue(gui.tmpVarContent.DINT, gui.currentField), gui.currentZone, tempUoMVar.REAL, GetUoM(gui.currentField));
    
    IF increasing THEN //adjust within bounds
        tempUoMVar.REAL := CheckMaxReal(tempUoMVar.REAL, gui.currentField); 
    ELSE
        tempUoMVar.REAL := CheckMinReal(tempUoMVar.REAL, gui.currentField);
    END_IF;

    tempUoMVar := ConvertFieldToZone(tempUoMVar, DOMAIN_REAL, GetUoM(gui.currentField)); //real value in the UI zone UoM
    gui.tmpVarContent.DINT := GetDintFromRealTmpValue(tempUoMVar.REAL, gui.currentField); //get DINT correspondent     
END_FUNCTION

FUNCTION HandleRealUoMInput
VAR_IN_OUT CONSTANT
    p : REF_TO VARCONTENT;
    i : UINT;
    keyCounter : UINT;
END_VAR
VAR_INPUT
    increasing : BOOL;
END_VAR
VAR
	support : REAL;
END_VAR
   support := p^.REAL;
   
   IF increasing THEN
        support := support + (TO_REAL(UI_INCREMENT)/TO_REAL(GetRatio(i)));
        p^.REAL := CheckMaxReal(support, gui.currentField);
    ELSE
        support := support - (TO_REAL(UI_INCREMENT)/TO_REAL(GetRatio(i)));
        p^.REAL := CheckMinReal(support, gui.currentField);
    END_IF;

END_FUNCTION

FUNCTION HandleUoMInput
VAR_IN_OUT CONSTANT
    keyCounter : UINT;
END_VAR
VAR_INPUT
    increasing : BOOL;
END_VAR
VAR
    support : VARCONTENT;
    legit : VARCONTENT;
    uom :UOM;	
END_VAR
    uom := GetUoM(gui.currentField);
	
    IF increasing THEN
        CASE guiInfo.fieldsInfo[gui.currentField].domain OF
{IF USED_DOMAIN_INT}
    		DOMAIN_INT: 
				support.INT := gui.tmpVarContent.INT + TO_INT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UINT}
            DOMAIN_UINT: 
				support.UINT := gui.tmpVarContent.UINT + TO_UINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_SINT}
            DOMAIN_SINT: 
				support.SINT := gui.tmpVarContent.SINT + TO_SINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_USINT}
            DOMAIN_USINT: 
				support.USINT := gui.tmpVarContent.USINT + TO_USINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_DINT}
            DOMAIN_DINT: 
				support.DINT := gui.tmpVarContent.DINT + TO_DINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UDINT}
            DOMAIN_UDINT: 
				support.UDINT := gui.tmpVarContent.UDINT + TO_UDINT(UI_INCREMENT);
{ENDIF}
    	END_CASE;
    ELSE
        CASE guiInfo.fieldsInfo[gui.currentField].domain OF
{IF USED_DOMAIN_INT}
			DOMAIN_INT: 
				support.INT := gui.tmpVarContent.INT - TO_INT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UINT}
            DOMAIN_UINT: 
				support.UINT := gui.tmpVarContent.UINT - TO_UINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_SINT}
            DOMAIN_SINT: 
				support.SINT := gui.tmpVarContent.SINT - TO_SINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_USINT}
			DOMAIN_USINT: 
				support.USINT := gui.tmpVarContent.USINT - TO_USINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_DINT}
            DOMAIN_DINT: 
				support.DINT := gui.tmpVarContent.DINT - TO_DINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UDINT}
            DOMAIN_UDINT: 
				support.UDINT := gui.tmpVarContent.UDINT - TO_UDINT(UI_INCREMENT);
{ENDIF}
    	END_CASE;
    END_IF;

    tempUoMVar := ConvertValueToUoM(support, guiInfo.fieldsInfo[gui.currentField].domain, uom);
    legit := tempUoMVar;   
	
   tempUoMVar := CheckMax(gui.currentField, guiInfo.fieldsInfo[gui.currentField].domain, tempUoMVar);
   IF tempUoMVar = legit THEN
	tempUoMVar := CheckMin(gui.currentField, guiInfo.fieldsInfo[gui.currentField].domain, tempUoMVar);
   END_IF;            
    IF tempUoMVar = legit THEN
        gui.tmpVarContent := support;
    ELSE
        gui.tmpVarContent := ConvertFieldToZone(tempUoMVar, guiInfo.fieldsInfo[gui.currentField].domain, uom);  
    END_IF;
END_FUNCTION

FUNCTION HandleUoMInput
VAR_IN_OUT CONSTANT
    p : REF_TO VARCONTENT;
    keyCounter : UINT;
END_VAR
VAR_INPUT
    increasing : BOOL;
END_VAR
VAR
    support : VARCONTENT;
END_VAR

    IF increasing THEN
        CASE guiInfo.fieldsInfo[gui.currentField].domain OF
{IF USED_DOMAIN_INT}
    		DOMAIN_INT: 
				support.INT := p^.INT + TO_INT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UINT}
            DOMAIN_UINT: 
				support.UINT := p^.UINT + TO_UINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_SINT}
            DOMAIN_SINT: 
				support.SINT := p^.SINT + TO_SINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_USINT}
            DOMAIN_USINT: 
				support.USINT := p^.USINT + TO_USINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_DINT}
            DOMAIN_DINT: 
				support.DINT := p^.DINT + TO_DINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UDINT}
            DOMAIN_UDINT: 
				support.UDINT := p^.UDINT + TO_UDINT(UI_INCREMENT);
{ENDIF}
    	END_CASE;
    ELSE
        CASE guiInfo.fieldsInfo[gui.currentField].domain OF
{IF USED_DOMAIN_INT}
    		DOMAIN_INT: 
				support.INT := p^.INT - TO_INT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UINT}
            DOMAIN_UINT: 
				support.UINT := p^.UINT - TO_UINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_SINT}
            DOMAIN_SINT: 
				support.SINT := p^.SINT - TO_SINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_USINT}
            DOMAIN_USINT: 
				support.USINT := p^.USINT - TO_USINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_DINT}
            DOMAIN_DINT: 
				support.DINT := p^.DINT - TO_DINT(UI_INCREMENT);
{ENDIF}
{IF USED_DOMAIN_UDINT}
            DOMAIN_UDINT: 
				support.UDINT := p^.UDINT - TO_UDINT(UI_INCREMENT);
{ENDIF}
    	END_CASE;
    END_IF;

   tempUoMVar := CheckMax(gui.currentField, guiInfo.fieldsInfo[gui.currentField].domain, support);
   IF tempUoMVar = support THEN
	tempUoMVar := CheckMin(gui.currentField, guiInfo.fieldsInfo[gui.currentField].domain, support);
   END_IF;
   WriteInVarContent(tempUoMVar, p, guiInfo.fieldsInfo[gui.currentField].domain);
END_FUNCTION
{ENDIF}

END_NAMESPACE