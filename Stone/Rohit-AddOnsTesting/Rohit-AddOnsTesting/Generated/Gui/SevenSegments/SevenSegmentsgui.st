USING System.Globalization;
USING System;
USING System.Math;
USING System.UI;
USING System.Timer;
USING System.Text;
NAMESPACE SevenSegments

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






VAR_GLOBAL CONSTANT
SPECIAL_MASK_FIELD : UINT := 0;
MAX_FIELD_PER_MASK : INT := 1;
MAX_REAL_VALUE : REAL := 9999.9;
MIN_REAL_VALUE : REAL := -9999.9;
MAX_L_REAL_VALUE : LREAL := 99999.9;
MIN_L_REAL_VALUE : LREAL := -99999.9;
FIELD_COUNT : INT := 1;
MASK_COUNT : UINT := 1;
LOOP_COUNT : UINT := 1;
MAX_RECENT_MASKS : UINT := 10;
FIRST_VALID_CHAR : USINT := 32;
LAST_VALID_CHAR : USINT := 126;
KEY_PRG : UINT := 16#05;
KEY_ALARM : UINT := 16#0C;
KEY_UP : UINT := 16#0E;
KEY_DOWN : UINT := 16#0F;
KEY_ALARM_RELEASE : UINT := 16#800C;
KEY_UP_RELEASE : UINT := 16#800E;
KEY_DOWN_RELEASE : UINT := 16#800F;
KEY_PROGRAM_RELEASE : UINT := 16#8005;
guiInfo : GUIInfoStruct := (fieldsInfo :=
[(column :=0, domain := 0, presentation := 0)],
masksInfo := [                   0    //MaskName: Mask0
],
loopsInfo := [0]);
KEY_UP_ALARM : UINT := 128;
KEY_PRG_ALARM : UINT := 87;
KEY_PRG_UP : UINT := 89;
KEY_PRG_DOWN : UINT := 90;
KEY_DOWN_ALARM : UINT := 132;
KEY_UP_DOWN : UINT := 135;
ACU_LED_1 : USINT := 1;
ACU_LED_2 : USINT := 2;
ACU_LED_3 : USINT := 3;
ACU_LED_4 : USINT := 4;
ACU_LED_5 : USINT := 5;
ACU_LED_6 : USINT := 6;
ACU_LED_7 : USINT := 7;
ACU_LED_8 : USINT := 8;
ACU_LED_9 : USINT := 9;
ACU_LED_10 : USINT := 10;
ACU_LED_11 : USINT := 11;
ACU_LED_12 : USINT := 12;
ACU_LED_13 : USINT := 13;
ACU_LED_14 : USINT := 14;
ACU_LED_17 : USINT := 17;
ACU_LED_19 : USINT := 19;
UP : USINT := 15;
DOWN : USINT := 16;
PRG : USINT := 18;
END_VAR

VAR_GLOBAL
{METADATA HIDDEN}
gui: GuiStruct;
{METADATA HIDDEN}
ArrayLed: ARRAY[1..18] OF USINT := [18(16#FF)];
{METADATA HIDDEN}
tempUoMVar : VARCONTENT;
END_VAR


FUNCTION INTERNAL UserInit : BOOL
VAR
	i:INT;
	start:INT;
END_VAR

start := -1;
FOR i := 0 TO TO_INT(LOOP_COUNT - 1) DO
	IF EvaluateLoopEnable(i) THEN
		start := i;
        EXIT;
    END_IF;
END_FOR;

IF start >= 0 THEN
	gui.currentLoop := TO_UINT(start);
ELSE
	UserInit := FALSE;
	RETURN;
END_IF;

start := -1;
FOR i := TO_INT(guiInfo.loopsInfo[gui.currentLoop]) TO TO_INT(GetLastMaskInLoop(gui.currentLoop)) DO
	IF EvaluateMaskEnable(i) THEN
		start := i;
		EXIT;
	END_IF;
END_FOR;

IF start >= 0 THEN
	gui.currentMask := TO_UINT(start);
ELSE
	UserInit := FALSE;
	RETURN;
END_IF;

gui.currentField := StartingField(TO_INT(gui.currentMask));
	SetLanguageID(Assets.Language._EN);
	gui.currentZone := 0;
UserInit:=TRUE;
END_FUNCTION



FUNCTION INTERNAL fieldsSelectables : BOOL

	VAR_INPUT
		i:INT;
	END_VAR

	/*Fields selectables CASE generating by generateFieldsSelectablesFunction*/
	fieldsSelectables := TRUE;



END_FUNCTION
FUNCTION INTERNAL BoolMultistate
	VAR_INPUT
		fIndex : UINT;
		maskIndex : UINT;
        dataIndex : INT;
    END_VAR

    VAR
        value: BOOL;
    END_VAR
                
    IF gui.currentField = fIndex AND UseTmpVarContent(fIndex) THEN
        value := gui.tmpVarContent.BOOL;	
    ELSE
        value := GetBool(TO_INT(fIndex));
    END_IF;
                
    IF value THEN
        
    ELSE
        
    END_IF;
END_FUNCTION
FUNCTION INTERNAL IntMultistate
	VAR_INPUT
		fIndex:UINT;
		maskIndex:UINT;
		dataIndex:INT;
	END_VAR
	VAR
		value:VARCONTENT;
	END_VAR

IF(gui.currentField = fIndex AND UseTmpVarContent(fIndex)) THEN
WriteInVarContent(gui.tmpVarContent, REF(value), guiInfo.fieldsInfo[fIndex].domain);
ELSE 
WriteInVarContent(gui.currentData[dataIndex]^, REF(value), guiInfo.fieldsInfo[fIndex].domain);
END_IF;


END_FUNCTION

FUNCTION INTERNAL ScrTxtLength : USINT

	VAR_INPUT
		i:INT;
	END_VAR


ScrTxtLength := 0;


END_FUNCTION

(**
*  Handle Mask level leds.
*)
FUNCTION INTERNAL HandleMaskLed
	VAR_INPUT
		maskIndex:UINT;
	END_VAR



	



END_FUNCTION


(**
*  Handle Loop level leds.
*)
FUNCTION INTERNAL HandleLoopLed
	VAR_INPUT
		maskIndex:UINT;
	END_VAR



	



END_FUNCTION


(**
*  Handle Global level leds.
*)
FUNCTION INTERNAL HandleGlobalLed
	VAR_INPUT
		maskIndex:UINT;
	END_VAR



	
	CASE maskIndex OF
		0 : 
			{LOCATION SevenSegments.stgui()}ManageLed(UP,SevenSegments.gui.blink,NOT SevenSegments.gui.blink);
ManageLed(DOWN,SevenSegments.gui.blink,NOT SevenSegments.gui.blink);
ArrayLED[PRG] := LedStatus#SWITCH_ON;


	END_CASE;



END_FUNCTION


(**
*  Handle leds, if mask level hasn't set, use loop level led, if loop level hasn't set, use global level
*)
FUNCTION INTERNAL HandleLed
	VAR_INPUT
		maskIndex:UINT;
	END_VAR
	VAR
		i:INT := 0;
	END_VAR

		HandleMaskLed(maskIndex);
		HandleLoopLed(maskIndex);
		HandleGlobalLed(maskIndex);

		FOR i := 1 TO 18 DO
		    IF ArrayLED[i] <> 255 THEN
		        SetLed(TO_USINT(i),ArrayLED[i]);
		    END_IF;
		END_FOR;


END_FUNCTION

FUNCTION INTERNAL DrawCurrentMask
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR


gui.CustomMask := TRUE;gui.CustomMask := FALSE;
ManageInput(keyPressed, keyCounter);
DrawMask(keyPressed,gui.currentMask);


END_FUNCTION

FUNCTION INTERNAL ShowDummy : BOOL

	VAR_INPUT
		maskIndex:UINT;
	END_VAR


ShowDummy := TRUE;


END_FUNCTION

FUNCTION INTERNAL UseTmpVarContent : BOOL

	VAR_INPUT
		fieldId:UINT;
	END_VAR


UseTmpVarContent := TRUE;


END_FUNCTION

FUNCTION INTERNAL CompactDesc : STRING

	VAR_INPUT
		fieldIndex:INT;
	END_VAR


CompactDesc := '';


END_FUNCTION

FUNCTION INTERNAL GetBool : BOOL

	VAR_INPUT
		fieldID:INT;
	END_VAR


GetBool := FALSE;


END_FUNCTION

FUNCTION INTERNAL SetBool
	VAR_INPUT
		fieldID:INT;
		value:BOOL;
	END_VAR


END_FUNCTION

FUNCTION INTERNAL GetText : STRING

	VAR_INPUT
		fIndex:INT;
	END_VAR


GetText := '';


END_FUNCTION

FUNCTION INTERNAL DrawFieldText

	VAR_INPUT
		fIndex : INT;
	END_VAR



END_FUNCTION
FUNCTION INTERNAL FieldsEnableOn : BOOL

	VAR_INPUT
		fIndex:INT;
	END_VAR


FieldsEnableOn := TRUE;


END_FUNCTION

FUNCTION EvaluateMaskEnable : BOOL

	VAR_INPUT
		maskIndex:INT;
	END_VAR
	VAR
		enabled:BOOL := TRUE;
	END_VAR


EvaluateMaskEnable := enabled;


END_FUNCTION

FUNCTION EvaluateLoopEnable : BOOL

	VAR_INPUT
		loopIndex:INT;
	END_VAR
	VAR
		enabled:BOOL := TRUE;
	END_VAR


EvaluateLoopEnable := enabled;


END_FUNCTION

FUNCTION INTERNAL IntPartLength : INT

	VAR_INPUT
		fieldID:UINT;
	END_VAR


IntPartLength := 4;


END_FUNCTION

FUNCTION INTERNAL ZeroSuppression : BOOL

	VAR_INPUT
		fieldID:UINT;
	END_VAR


ZeroSuppression := TRUE;


END_FUNCTION

FUNCTION GetRatio : INT

	VAR_INPUT
		fieldID:UINT;
	END_VAR


GetRatio := 10;


END_FUNCTION

FUNCTION INTERNAL LoadFieldsData
	VAR_INPUT
		maskID:UINT;
	END_VAR


	CASE maskID OF
		0 : 
			

	END_CASE;



END_FUNCTION

FUNCTION CheckMinReal : REAL

	VAR_INPUT
		newValue:REAL;
	END_VAR
	VAR_IN_OUT
		fIndex:UINT;
	END_VAR


IF newValue < MIN_REAL_VALUE THEN newValue := MAX_REAL_VALUE; END_IF;
CheckMinReal := newValue;


END_FUNCTION

FUNCTION CheckMaxReal : REAL

	VAR_INPUT
		newValue:REAL;
	END_VAR
	VAR_IN_OUT
		fIndex:UINT;
	END_VAR


IF newValue > MAX_REAL_VALUE THEN newValue := MIN_REAL_VALUE; END_IF;
CheckMaxReal := newValue;


END_FUNCTION

FUNCTION INTERNAL CheckMin : VARCONTENT

	VAR_INPUT
		fIndex:UINT;
		domain:USINT;
		newValue:VARCONTENT;
	END_VAR


	CASE domain OF
		3 : 
			CheckMin.INT := newValue.INT;
		4 : 
			CheckMin.UINT := CheckMax(fIndex,domain,newValue).UINT;
		7 : 
			CheckMin.SINT := newValue.SINT;
		8 : 
			CheckMin.USINT := CheckMax(fIndex,domain,newValue).USINT;
		9 : 
			CheckMin.DINT := newValue.DINT;
		10 : 
			CheckMin.UDINT := CheckMax(fIndex,domain,newValue).UDINT;
		5..6 : 
			CheckMin.REAL := CheckMinReal(GetRealTmpValue(newValue.DINT, fIndex), fIndex);

	END_CASE;



END_FUNCTION

FUNCTION INTERNAL CheckMax : VARCONTENT

	VAR_INPUT
		fIndex:UINT;
		domain:USINT;
		newValue:VARCONTENT;
	END_VAR


	CASE domain OF
		3 : 
			CheckMax.INT := newValue.INT;
		4 : 
			CheckMax.UINT := newValue.UINT;
		7 : 
			CheckMax.SINT := newValue.SINT;
		8 : 
			CheckMax.USINT := newValue.USINT;
		9 : 
			CheckMax.DINT := newValue.DINT;
		10 : 
			CheckMax.UDINT := newValue.UDINT;
		5..6 : 
			CheckMax.REAL := CheckMaxReal(GetRealTmpValue(newValue.DINT, fIndex), fIndex);

	END_CASE;



END_FUNCTION

FUNCTION INTERNAL GetConstantValue : STRING

	VAR_INPUT
		fIndex:INT;
	END_VAR


GetConstantValue := '';


END_FUNCTION

FUNCTION GetUoM : UOM

	VAR_INPUT
		uom_FieldIndex:UINT;
	END_VAR


GetUoM := 0;


END_FUNCTION

FUNCTION INTERNAL StartingField : UINT

	VAR_INPUT
		glassMaskIndex:INT;
	END_VAR


StartingField := 0;


END_FUNCTION


FUNCTION INTERNAL HandleAction
	VAR_INPUT
		fieldID:UINT;
		maskID:UINT;
		loopID:UINT;
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR


	CASE keyPressed OF
		15 : 
			/*KEY_DOWN*/ 
IF(guiInfo.fieldsInfo[gui.currentField].presentation = 2) THEN
GoToNextMask();
ELSE 
IF(fieldID = 0) THEN
SevenSegments.GoToNextMask();
ELSE 
SevenSegments.ActionFieldKeyDown(keyCounter);
END_IF;
END_IF;
		14 : 
			/*KEY_UP*/ 
IF(guiInfo.fieldsInfo[gui.currentField].presentation = 2) THEN
GoToPreviousMask();
ELSE 
IF(fieldID = 0) THEN
SevenSegments.GoToPreviousMask();
ELSE 
SevenSegments.ActionFieldKeyUp(keyCounter);
END_IF;
END_IF;
		5 : 
			/*KEY_PRG*/ 
IF(guiInfo.fieldsInfo[gui.currentField].presentation = -6) THEN
NextStringChar();
ELSE 
SevenSegments.GoToNextField();
END_IF;

	END_CASE;



END_FUNCTION

FUNCTION HandleEvent
	VAR_INPUT
		keyPressed:UINT;
		keyCounter:UINT;
	END_VAR


END_FUNCTION



FUNCTION INTERNAL DrawWidget
	VAR_INPUT
		i:INT;
	END_VAR


END_FUNCTION


FUNCTION GetWidgetBool : BOOL

	VAR_INPUT
		wID:INT;
		varIndex:USINT;
	END_VAR


GetWidgetBool := FALSE;


END_FUNCTION

FUNCTION SetWidgetBool
	VAR_INPUT
		wID:INT;
		varIndex:USINT;
	END_VAR


END_FUNCTION





{DEFINE UI_INCREMENT 1}


TYPE FieldInfo : STRUCT
	domain : USINT;
	presentation : SINT;
	row : UINT;
	column : UINT;
END_STRUCT;
END_TYPE

TYPE GUIInfoStruct : STRUCT
	loopsInfo : ARRAY[0..LOOP_COUNT-1] OF UINT;
	masksInfo : ARRAY[0..MASK_COUNT-1] OF UINT;
	fieldsInfo : ARRAY[0..FIELD_COUNT-1] OF FieldInfo;
END_STRUCT;
END_TYPE
TYPE GUIstruct : STRUCT
	init : BOOL := FALSE;
	blink : BOOL := FALSE;
	render : BOOL := TRUE;
	CustomMask : BOOL := FALSE;
	recentMasks : ARRAY[0..MAX_RECENT_MASKS] OF UINT;
	currentData : ARRAY[0..MAX_FIELD_PER_MASK - 1] OF POINTER TO VARCONTENT; //max field per mask count
	stringIndex : USINT; //scrollalbleText or editableString
	currentLoop : UINT;
	currentMask : UINT;
	currentField : UINT;
	tmpVarContent : VARCONTENT;
	lastRecentMask : UINT;
	currentZone : ZONE;
END_STRUCT;
END_TYPE

FUNCTION OnGUI
	VAR_INPUT
		keyPressed, keyCounter : UINT;
	END_VAR
	IF Init() THEN
		Draw(keyPressed, keyCounter);
		HandleLed(gui.currentMask);
	ELSE
		DrawString('ERR',0,0);
	END_IF;
END_FUNCTION

FUNCTION INTERNAL ManageInput
	VAR_INPUT
		keyPressed, keyCounter : UINT;
	END_VAR
	// if a key is pressed
	IF gui.CustomMask = FALSE THEN
	 	HandleAction(gui.currentField, gui.currentMask, gui.currentLoop, keyPressed, keyCounter);
	END_IF;
END_FUNCTION

FUNCTION INTERNAL Draw
	VAR_INPUT
		keyPressed, keyCounter : UINT;
	END_VAR
	
	ClearGraphics();
	ClearTexts();
	DrawCurrentMask(keyPressed, keyCounter);
END_FUNCTION

FUNCTION INTERNAL DrawMask
	VAR_INPUT
		keyPressed, maskIndex: UINT;
	END_VAR
	VAR
		i : INT;
		lastFieldIndex : INT;
	END_VAR;
	
	lastFieldIndex := TO_INT(GetLastFieldInMask(maskIndex));
	FOR i := TO_INT(guiInfo.masksInfo[maskIndex]) TO lastFieldIndex DO
		IF i = TO_INT(gui.currentField) AND NOT(guiInfo.fieldsInfo[gui.currentField].presentation = PRESENTATION_SCROLLABLETEXT) THEN
			IF(gui.render OR NOT fieldsSelectables(i)) THEN 
				DrawField(i, maskIndex,TO_INT(guiInfo.fieldsInfo[i].row), TO_INT(guiInfo.fieldsInfo[i].column)); 
			ELSE
				DrawPlaceHolderField(i, maskIndex, TO_INT(guiInfo.fieldsInfo[i].row),TO_INT(guiInfo.fieldsInfo[i].column)); 
			END_IF;
			IF keyPressed = NO_KEY THEN
				IF(gui.blink) THEN
					gui.render := NOT(gui.render);
				END_IF; 
			END_IF;
		ELSE
			DrawField(i, maskIndex,TO_INT(guiInfo.fieldsInfo[i].row), TO_INT(guiInfo.fieldsInfo[i].column));
		END_IF;
	END_FOR;

END_FUNCTION

FUNCTION INTERNAL ManageLed 

	VAR_INPUT
		    index : USINT;
            blink:BOOL;
            ONCONDITION:BOOL;
    END_VAR

	ArrayLED[index] := LedStatus#SWITCH_OFF;

    IF ONCONDITION THEN
        ArrayLED[index] := LedStatus#SWITCH_ON;
    ELSIF blink THEN 
        ArrayLED[index] := LedStatus#BLINKING;
    END_IF;

END_FUNCTION

FUNCTION INTERNAL DrawField
	VAR_INPUT
		i : INT; //field index
		maskID : UINT;
		row : INT;
	    column : INT;
	END_VAR
	VAR
		dataIndex : INT;
	END_VAR
	IF FieldsEnableOn(i) THEN
		DrawFieldText(i);
		dataIndex := i - TO_INT(guiInfo.masksInfo[maskID]);
		CASE guiInfo.fieldsInfo[i].presentation OF
{IF USED_PRESENTATION_SCROLLABLETEXT}
			PRESENTATION_SCROLLABLETEXT:
					DrawScrollableText(gui.currentData[dataIndex]^.STRPOINTER,
					ScrTxtLength(i),
					row ,column,
					(i = TO_INT(gui.currentField)));
{ENDIF}
{IF USED_PRESENTATION_WIDGET}
			PRESENTATION_WIDGET: 
				DrawWidget(i);
{ENDIF}
{IF USED_PRESENTATION_TEXT}
			PRESENTATION_TEXT:	// string
				DrawString(GetText(i), row, column);
{ENDIF}
{IF USED_PRESENTATION_VARIABLE}
			PRESENTATION_VARIABLE:	// variable
				IF GetUoM(TO_UINT(i))>0 THEN
					DrawUoMField(dataIndex, i, row, column);
				ELSE
					DrawVariable(gui.currentData[dataIndex]^, i, row, column, 0, guiInfo.fieldsInfo[i].domain, (i = TO_INT(gui.currentField)), guiInfo.fieldsInfo[i].domain <> DOMAIN_BYTE );
				END_IF;
{ENDIF}
{IF USED_PRESENTATION_BAR}
			PRESENTATION_BAR: //BAR/ABR
				BoolMultistate(TO_UINT(i), maskID, dataIndex);
{ENDIF}
{IF USED_PRESENTATION_IAR}
			PRESENTATION_IAR:	//IAR/AIR
				IntMultistate(TO_UINT(i), maskID, dataIndex);
{ENDIF}
{IF USED_PRESENTATION_SIMPLESTRING}
			PRESENTATION_SIMPLESTRING:
				DrawStringVariable(gui.currentData[dataIndex]^.STRPOINTER, row, column, i);
{ENDIF}
{IF USED_PRESENTATION_COMPACTFIELD}
			PRESENTATION_COMPACTFIELD: //compact field
				IF gui.currentField = TO_UINT(i) THEN
					IF GetUoM(TO_UINT(i))>0 THEN 
                        DrawUoMField(dataIndex, i, row, column);
                    ELSE 
    					DrawVariable(gui.currentData[dataIndex]^, i, row, column, guiInfo.fieldsInfo[i].presentation, guiInfo.fieldsInfo[i].domain,	(i = TO_INT(gui.currentField) AND fieldsSelectables(i)), FALSE);
                    END_IF;
				ELSE
					DrawString(CompactDesc(i), row, column);
				END_IF;
{ENDIF}
{IF USED_PRESENTATION_CONSTANT}
			PRESENTATION_CONSTANT: //constant
				DrawString(GetConstantValue(i), row, column);
{ENDIF}
{IF USED_PRESENTATION_VARIABLEWITHUOM}
			PRESENTATION_VARIABLEWITHUOM: //var with UoM
			    DrawUoMField(dataIndex, i, row, column);
				{IF DEF(UOM_SYMBOLS_SUPPORT)}
				GetUoMSymbol(i, row, column + 1);
				{ENDIF}
{ENDIF}
{IF USED_PRESENTATION_TIMEVARIABLE}
			PRESENTATION_TIMEVARIABLE: //time variable
				DrawDateAndTime(i, dataIndex, row, column,TO_UINT(i) = gui.currentField);
{ENDIF}
		END_CASE;
	END_IF;
END_FUNCTION

FUNCTION DrawDateAndTime
    VAR_INPUT
        fieldId : INT;
        dataIndex, row, col : INT;
        isSelected : BOOL;
	END_VAR
    VAR		
        dateTime : DateTime;
		timeStr : STRING;
	END_VAR
    IF isSelected AND UseTmpVarContent(TO_UINT(fieldId)) THEN
        CASE guiInfo.fieldsInfo[fieldId].domain OF
{IF USED_DOMAIN_TOD}
	    DOMAIN_TOD://TOD
            SPLIT_TOD(gui.tmpVarContent.TOD, dateTime);
{ENDIF}
{IF USED_DOMAIN_TIME}
        DOMAIN_TIME://TIME
            SPLIT_TIME(gui.tmpVarContent.TIME, dateTime);
{ENDIF}
{IF USED_DOMAIN_DT}
	    DOMAIN_DT://DT
            SPLIT_DT(gui.tmpVarContent.DT, dateTime);
{ENDIF}
        END_CASE;
    ELSE
        CASE guiInfo.fieldsInfo[fieldId].domain OF
{IF USED_DOMAIN_TOD}
	    DOMAIN_TOD://TOD
            SPLIT_TOD(gui.currentData[dataIndex]^.TOD, dateTime);
{ENDIF}
{IF USED_DOMAIN_TIME}
        DOMAIN_TIME://TIME
            SPLIT_TIME(gui.currentData[dataIndex]^.TIME, dateTime);
{ENDIF}
{IF USED_DOMAIN_DT}
	    DOMAIN_DT://DT
            SPLIT_DT(gui.currentData[dataIndex]^.DT, dateTime);
{ENDIF}
        END_CASE;
    END_IF;
    timeStr := FORMAT('%02d', dateTime.Hour) + ':' + FORMAT('%02d', dateTime.Minute);
    DrawString(timeStr, row, col);
END_FUNCTION

FUNCTION INTERNAL DrawPlaceHolderField
	VAR_INPUT
		i : INT; //field index
		maskID : UINT;
		row: INT;
		column : INT;
	END_VAR
	VAR
		dataIndex : INT;
		length : USINT;
	END_VAR
	IF FieldsEnableOn(i)  THEN
		DrawFieldText(i);
		dataIndex := i - TO_INT(guiInfo.masksInfo[maskID]);
		CASE guiInfo.fieldsInfo[i].presentation OF
{IF USED_PRESENTATION_SCROLLABLETEXT}
			PRESENTATION_SCROLLABLETEXT:	length := ScrTxtLength(i);
{ENDIF}
{IF USED_PRESENTATION_TEXT}
			PRESENTATION_TEXT:
				length := TO_USINT(LEN(GetText(i)));
{ENDIF}
{IF USED_PRESENTATION_VARIABLE}
			PRESENTATION_VARIABLE:
				length := TO_USINT(LEN(GetVarString(gui.currentData[dataIndex]^, i, guiInfo.fieldsInfo[i].domain, (i = TO_INT(gui.currentField)))));
{ENDIF}
{IF USED_PRESENTATION_SIMPLESTRING}
			PRESENTATION_SIMPLESTRING: 
				DrawStringVariable(gui.currentData[dataIndex]^.STRPOINTER, row,column, i);
{ENDIF}
{IF USED_PRESENTATION_COMPACTFIELD}
			PRESENTATION_COMPACTFIELD: //compact field
				IF gui.currentField = TO_UINT(i) THEN
					length := TO_USINT(LEN(GetVarString(gui.currentData[dataIndex]^, i, guiInfo.fieldsInfo[i].domain, (i = TO_INT(gui.currentField)))));
				ELSE
					length := TO_USINT(LEN(CompactDesc(i)));
				END_IF;
{ENDIF}
{IF USED_PRESENTATION_CONSTANT}
			PRESENTATION_CONSTANT://constant
				length := TO_USINT(LEN(GetConstantValue(i)));
{ENDIF}
		END_CASE;
		//Placehloder chars. X is a not supported digit in 7 segments display. In case of proble with this particular char, all
		//not supported digits are welcome
		CASE length OF
			0:
			1: DrawString('x', row, column);
			2: DrawString('xx', row, column);
			3: DrawString('xxx', row, column);
		END_CASE;
	END_IF;
END_FUNCTION


(** Moves the cursor to the next enabled and selectable field in the current mask. The order  of
    the fields is assigned left to right and top to bottom*)
FUNCTION GoToNextField
	VAR
		i/*, iRef */: INT := 0;
		maskIndex, fieldIndex, nextField : UINT;
		found : BOOL := FALSE;
		variableContent_p : POINTER TO VARCONTENT;
        support : VARCONTENT;
		dataIndex : UINT;
		lastFieldIndex : INT;
	END_VAR
	gui.stringIndex := 0;
	/*IF gui.isOnReferredMaskField >= 0 THEN
		maskIndex := TO_UINT(gui.isOnReferredMaskField);
		LoadFieldsData(maskIndex);
	ELSE*/
		maskIndex := gui.currentMask;
	//END_IF;
	// if current field is valid, a variable and selectable
	IF 	gui.currentField > 0 AND
		guiInfo.fieldsInfo[gui.currentField].domain > DOMAIN_IMAGE AND
		fieldsSelectables(TO_INT(gui.currentField)) AND
		UseTmpVarContent(gui.currentField) THEN
			dataIndex := gui.currentField - guiInfo.masksInfo[maskIndex];
			SetVariableValue(gui.currentData[dataIndex], TO_INT(gui.currentField), guiInfo.fieldsInfo[gui.currentField].domain);
	END_IF;
	fieldIndex := gui.currentField + 1;
	lastFieldIndex := TO_INT(GetLastFieldInMask(maskIndex));
	WHILE NOT(found)DO
		IF fieldIndex < guiInfo.masksInfo[maskIndex] THEN
			fieldIndex := guiInfo.masksInfo[maskIndex];
		END_IF;
		FOR i := TO_INT(fieldIndex) TO lastFieldIndex DO
			IF (fieldsSelectables(i) OR guiInfo.fieldsInfo[fieldIndex].presentation = PRESENTATION_COMPACTFIELD) AND FieldsEnableOn(i) THEN
				nextField := TO_UINT(i);
				found := TRUE; //exit also from the external while loop
				EXIT;
			END_IF;
		END_FOR;
		IF found THEN
			IF (guiInfo.fieldsInfo[fieldIndex].presentation <> PRESENTATION_WIDGET) THEN
				gui.blink := TRUE;
			ELSE
				gui.blink := FALSE;
				gui.render := TRUE;
			END_IF;
			EXIT;
		ELSE
			gui.blink := FALSE;
			gui.render := TRUE;
		END_IF;
		nextField := 0;
		found := TRUE;
	END_WHILE;
 	gui.currentField := nextField;
	SetCursor(TO_INT(guiInfo.fieldsInfo[gui.currentField].row), TO_INT(guiInfo.fieldsInfo[gui.currentField].column));
	IF maskIndex <> gui.currentMask THEN
		LoadFieldsData(maskIndex);
	END_IF;
	// if field is selectable variable
	IF 	guiInfo.fieldsInfo[gui.currentField].domain > DOMAIN_IMAGE AND
		guiInfo.fieldsInfo[gui.currentField].domain < DOMAIN_WIDGET AND
	    guiInfo.fieldsInfo[gui.currentField].presentation  <> PRESENTATION_SHAPE AND //avoid shape
		guiInfo.fieldsInfo[gui.currentField].presentation  <> PRESENTATION_TEXTAREA AND //and textArea
		fieldsSelectables(TO_INT(gui.currentField)) OR guiInfo.fieldsInfo[gui.currentField].presentation  = PRESENTATION_COMPACTFIELD AND
		UseTmpVarContent(gui.currentField) THEN

            variableContent_p := gui.currentData[i - TO_INT(guiInfo.masksInfo[maskIndex])];

            {IF DEF(MULTI_ZONE_UI)}
            IF GetUoM(gui.currentField) > 0 THEN //UoM
                support := ConvertFieldToZone(variableContent_p^, guiInfo.fieldsInfo[gui.currentField].domain,
                    GetUoM(gui.currentField));
            ELSE
            {ENDIF}
                support := variableContent_p^;
            {IF DEF(MULTI_ZONE_UI)}
            END_IF;
            {ENDIF}

        	IF(guiInfo.fieldsInfo[gui.currentField].domain = DOMAIN_REAL) THEN
        		gui.tmpVarContent.DINT := GetDintFromRealTmpValue(support.REAL, gui.currentField);
{IF USED_DOMAIN_LREAL}
        	ELSIF (guiInfo.fieldsInfo[gui.currentField].domain = DOMAIN_LREAL) THEN
        		gui.tmpVarContent.DINT := GetDintFromRealTmpValue(TO_REAL(support.LREAL), gui.currentField);
{ENDIF}
{IF USED_DOMAIN_BOOL}
        	ELSIF (guiInfo.fieldsInfo[gui.currentField].domain = DOMAIN_BOOL) THEN
        		gui.tmpVarContent.BOOL := GetBool(TO_INT(gui.currentField));
{ENDIF}
        	ELSE gui.tmpVarContent := support;
        	END_IF;

	END_IF;
END_FUNCTION

END_NAMESPACE

