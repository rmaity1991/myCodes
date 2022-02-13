(*
    This library contains majorly used 
    functions required for development 
    of the Dover Food and Retail Case Platform.
    
    Initial Development: Joshua Meduoye
                         2/14/2020

*)

USING System.Math;
USING System;
USING System.Timer;
USING system.Text;



{DEFINE LIB_TIME_SPLIT_DT		 	16#0006000A}
{DEFINE LIB_TIME_GET_LOCAL_TIME     16#0006000C}

FUNCTION_BLOCK DFR_Saturation
    (*
        Inputs: In(Signal to be saturated)
                Min(Saturation Minimum
                Max(Saturation Maximum)
        Outputs:SaturatedSignal(Final Saturated ouput)
                Saturated_Status(True if saturated, false if within min and max)
        
                                                                                *)
    VAR_INPUT
       (**Input Variable**)
        In : REAL;
        Min : REAL;
        Max : REAL;
    END_VAR
    
    
    VAR_OUTPUT
        SaturatedSignal : REAL;
        Saturated_Status : Bool;
    END_VAR
   
   
    IF IN > Max THEN
        SaturatedSignal := Max;
        Saturated_Status := TRUE;
    ELSIF IN < MIN THEN
        SaturatedSignal := Min;
        Saturated_Status := TRUE;
    ELSE 
        SaturatedSignal := In;
        Saturated_Status := FALSE;
    END_IF;
    
END_FUNCTION_BLOCK


FUNCTION_BLOCK DFR_Counter
    (*
        
        Input:  Enable: If enable is true counter is active 
                Increment: How much should be incremented every execution
                UpperLimit: Maximum of timer
                Reset: Restarts the operation of timer to 0
                
        Output: Output: Current value of counter
                Reached: Counter Maximum value reached
    
                                                                            *)
    VAR_INPUT
       (**Input Variables**)
        Enable : BOOL;
        Reset : BOOL;
        Increment : REAL;
        UpperLimit : REAL;
    END_VAR
    
    
    VAR_OUTPUT
        Output : REAL;
        Reached : Bool;
    END_VAR
   
    (**If counter is enabled, **)
    IF Enable THEN
        Output := Output + Increment;
        
        
        IF Output >= UpperLimit THEN
            Reached := TRUE;
        ELSIF Reset THEN
            Output := 0; //Always resets to 0 
            Reached := FALSE;         
            
        END_IF;
        
    END_IF;
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_Average
    VAR_INPUT
       (**Input Variable**)
        In : REAL;
        Reset : BOOL;  // reset avg to 0
        Preset : REAL; // set the avg to Preset
    END_VAR

    VAR
        Total : REAL := 0;
        Count : REAL := 1;
    END_VAR

    VAR_OUTPUT
        OutAverage : REAL;
    END_VAR

    IF preset <> 0 THEN
        OutAverage := (preset + in) / 2;
    ELSE 
        IF reset = TRUE THEN
            Total := 0;
            count := 1;
        END_IF;
    
        Total := Total + In;
        OutAverage := Total / Count;
        Count := Count + 1;
    END_IF;
END_FUNCTION_BLOCK


FUNCTION_BLOCK DFR_Edge
    (*
        Inputs:  In(Signal to be detected)
                 Mode(To Select between diferent method to do edge detection raising, falling and both)
        Outputs: A pulse for Edge detected.
    *)
        
    VAR_INPUT
        (**Input Variable**)
        In : Bool;
        Mode : INT;
    END_VAR
    
    VAR_OUTPUT
        (**Outputs Variable**)
        Out : Bool; 
    END_VAR
    
    VAR 
        (**Local Variable**)
        Mem : BOOL := 0;
    END_VAR
    
    (** Case according to Mode value (0,1 and2)**)
    CASE Mode OF
    
        0:// Raising
        IF In AND NOT Mem  THEN 
            Out := TRUE; Mem := TRUE;            
        ELSE    
            Out := FALSE; 
            Mem := In;
            
        END_IF;
                      
        
           
        1://Falling
        IF NOT In AND NOT Mem THEN
            Out := FALSE;
        ELSIF NOT In AND Mem THEN
            Out := TRUE; Mem := FALSE;
           
        ELSE
            Out := FALSE;
            Mem := In;
        END_IF; 
      
        2://Raising and Falling
        IF In AND NOT Mem THEN
            Out := TRUE; Mem := TRUE;
        ELSIF NOT In AND Mem THEN
            Out := TRUE; Mem := FALSE;
            
        ELSE
            Out := FALSE;
            Mem := In;
        END_IF;
                        
        
        
        
        
    END_CASE;
END_FUNCTION_BLOCK





FUNCTION_BLOCK DFR_Hysterisis_Basic
    (*
        Inputs: In(Signal of reading variable)
                Setpoint(Value desired)  
                Threshold(Max limit after setpoint)      
    *)
    
    VAR_INPUT
        (**Input Variable**)
        In : REAL;
        Setpoint : REAL;
        Threshold : REAL; 
        
    END_VAR
    
    VAR_OUTPUT
        
        Out : BOOL;     
    END_VAR
    
    IF In > (Setpoint + Threshold) THEN
        Out := TRUE;
       
    ELSIF In < Setpoint THEN
        Out := FALSE;
        
    END_IF;  
    
END_FUNCTION_BLOCK
  (*Derivative function*)
FUNCTION_BLOCK DFR_DERIV
    VAR_INPUT
        Enable : BOOL;
        In : REAL;  (** Input for derivative. *)
        DerivativeTime : REAL; (** Cycle time. *)
        StpSze : REAL := 0.3;
    END_VAR
    VAR_OUTPUT
		(** Differentiated output. *)
        OutDeriv : REAL;
    END_VAR
	
    VAR
        previn : REAL;
        DFR_DerivTimer : DFR_Timer;
        DivByClamp : DFR_DIV_CLAMP;
        
    END_VAR
    DFR_DerivTimer(Ena := Enable, ProgramTime := DerivativeTime, PLCCycletime := Stpsze);
    
    IF Enable = TRUE THEN
        IF DFR_DerivTimer.Q = TRUE THEN
            DivByClamp(In1 := (In - previn), In2 := DerivativeTime, OUT => OutDeriv);
            DFR_DerivTimer(Ena := FALSE, ProgramTime := DerivativeTime, PLCCycletime := Stpsze);
            previn := In;	
        END_IF;
    ELSE
        OutDeriv := 0;
    END_IF;
         
END_FUNCTION_BLOCK

FUNCTION_BLOCK FB_RateOfChange
    VAR_INPUT
        CycleFreq : REAL := 2;
        In : REAL;
    END_VAR
    VAR
        PrevIn : REAL := 0;
        Init : BOOL := FALSE;
    END_VAR
    VAR_OUTPUT
        Out : REAL;
    END_VAR
    Out := (In - PrevIn) * CycleFreq;
    PrevIn := In;
    IF NOT Init THEN
        Out := 0;
        Init := TRUE;
    END_IF;
END_FUNCTION_BLOCK

  (*Counts the time in seconds based on enable*)
FUNCTION_BLOCK DFR_Timer  (**ON Timer*)
    VAR_INPUT
        Ena : BOOL;
        PLCCycletime : REAL;
        ProgramTime : REAL;
    END_VAR

    VAR
        timecount : REAL := 0;
    END_VAR
    
    VAR_OUTPUT
        Q : BOOL;    
    END_VAR

    Q := FALSE;
    IF Ena = TRUE THEN
        timecount := timecount + PLCCycletime;    
        IF timecount > ProgramTime THEN
            Q := TRUE;
        ELSE
            Q := FALSE;
        END_IF;
    ELSE
        Q := FALSE;
        timecount := 0.0;
    END_IF;       
END_FUNCTION_BLOCK


FUNCTION_BLOCK DFR_LATCH   (*Hold the value of the input signal until the next rising trigger is detected*)
    VAR_INPUT
        In, Enb : BOOL;   (*Input value, Enable the latch *)
    END_VAR  
    VAR
        CurrentIn, PrevIn : BOOL;
    END_VAR    
    VAR_OUTPUT
        Out : BOOL;   (*Output value *)
    END_VAR    
    CurrentIn := In;    
    IF Enb THEN
        IF CurrentIn AND (NOT PrevIn) AND (NOT Out) THEN
            Out := TRUE;
        ELSIF CurrentIn AND (NOT PrevIn) AND Out THEN 
            Out := FALSE;       
        END_IF;  
    ELSE
        Out := FALSE;  
    END_IF;
    PrevIn := CurrentIn;
END_FUNCTION_BLOCK

  (*Limits the input rate within rising and falling rate limits*)
FUNCTION_BLOCK DFR_RateLimiter
    VAR_INPUT
        Input  : REAL; (*Function value*)
        Dtime : REAL; (*Differentiation time*)
        Rise : REAL; (*Rising rate of input*)
        Fall : REAL; (*Falling Rate of input*)
        EnableRateLimiter : BOOL;
        StepD : REAL;
    END_VAR
    VAR_OUTPUT
        Out_Rate : REAL;
    END_VAR

    VAR
        Deriv1 : DFR_DERIV;
    END_VAR;
    Deriv1(Enable := EnableRateLimiter, In := Input, DerivativeTime := Dtime, StpSze := StepD, OutDeriv => Out_Rate);

    IF EnableRateLimiter = TRUE THEN
        IF Out_Rate > Rise THEN
            Out_Rate := Rise;
        END_IF;
    
        IF Out_Rate < Fall THEN
            Out_Rate := Fall;
        END_IF;
    ELSE
        Out_Rate := 0;
    END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_FixedStandardDev 
   
//Declare variables
    VAR_INPUT 
        SAMPLES : ARRAY[1..5] OF REAL;  /*These are the input values*/
    END_VAR

    VAR
        SUM : REAL;  /*This is an operations variable*/
        COUNT : INT := 1;   /*This is an operations variable*/
        COUNT2 : INT := 1;   /*This is an operations variable*/
        MEAN : REAL := 0;  /*This is an operations variable*/
        SQUARES : REAL := 0;   /*This is an operations varaible*/   
    END_VAR

    VAR_OUTPUT
        STD_DEV : REAL;    /*This is an output variable*/
    END_VAR
    

//Find the mean value of samples
    FOR COUNT := 1 TO 5 BY 1 DO
        SUM := SUM + SAMPLES[COUNT];
        MEAN := SUM / 5; 
    END_FOR;
    
//Find the sum of the squares
    FOR COUNT2 := 1 TO 5 BY 1 DO
        SQUARES := SQUARES + (SAMPLES[COUNT2] - MEAN) ** 2;  
    END_FOR; 

    
//Find the standard deviation
    IF SQUARES = 0 THEN
        STD_DEV := 0;
    ELSE
        STD_DEV := (SQUARES / 4) ** (0.5);
    END_IF;


END_FUNCTION_BLOCK


(**
LATCH_WITH_RESET - Latch with external reset
    Latch the output when the reset is false.
*)
FUNCTION_BLOCK DFR_LATCH_WITH_RESET
    VAR_INPUT
        (**  Input *)
        In : BOOL;
        (**  Reset *)
        Rst : BOOL;
    END_VAR  
    VAR
        CurrentIn, PrevIn : BOOL;
    END_VAR    
    VAR_OUTPUT
        (**  output *)
        Out : BOOL;
    END_VAR  
    (**  If reset is false latch the output*)
    CurrentIn := In;    
    IF NOT Rst THEN
        IF CurrentIn AND (NOT PrevIn) THEN
            Out := TRUE;
            PrevIn := CurrentIn;
        ELSE
            out := previn;  			
        END_IF;  
    (**  If reset is true output also will be false*)
    ELSE
        Out := FALSE;  
        PrevIn := FALSE;
    END_IF;
    
END_FUNCTION_BLOCK

(**
 *Temp Conv Function Block converts temperature to degree celsius or Farenheit *)
 
FUNCTION_BLOCK DFR_TEMP_CONV
    VAR_INPUT
		(** DegC-  0 or DegF--1 *)
        TYPE1 : UINT;
		(**** DegC-  0 or DegF-1 *)
        TYPE2 : UINT;
		(** Input Temperature *)
        In1  : REAL;
				
    END_VAR
    VAR_OUTPUT
		(**  output. *)
        OUT : REAL;
    END_VAR
    VAR
		(** Values for Temperature conversion  F =1.8C + 32  *)  
        X1 : REAL := 1.8;		
        X2 : REAL := 32.0;
               
    END_VAR
	(* Algorithm *)
	(* If Input Type is degC and Output type required is degF *)
    IF TYPE1 = 0 AND TYPE2 = 1 THEN
        OUT := X1 * In1 + X2;
    (* If Input Type is degF and Output type required is degC *)
    ELSIF TYPE1 = 1 AND TYPE2 = 0 THEN			
        OUT := (In1 - X2) / X1;
    ELSE
        OUT := In1;
    END_IF;
	
END_FUNCTION_BLOCK



(**
 *DIV CLAMP Function Block is a divide block avoiding division by zero *)
 
FUNCTION_BLOCK DFR_DIV_CLAMP
    VAR_INPUT
		(** Numerator *)
        In1  : REAL;
        (** Denominator *)
        In2  : REAL;
       				
    END_VAR
    VAR_OUTPUT
		(**  output. *)
        OUT : REAL;
    END_VAR
    VAR
		(** EPS  *)  
        eps : REAL;	
		              
    END_VAR
    eps := 0.0000000000000000000000001;
	(* Algorithm *)
	(* Add a very low value to denominator to avoid divide by zero *)
    IF In2 = 0 THEN
        OUT := In1 / (In2 + eps);
   
    ELSE
        OUT := In1 / In2;
    END_IF;
	
END_FUNCTION_BLOCK

(** This function block checks whether the value specified by In is between the limits specified by Min and Max.*)


FUNCTION DFR_RANGE_REAL : BOOL
    VAR_INPUT
        In : REAL;
        Min : REAL;
        Max : REAL;
    END_VAR
    IF In >= Min AND In <= Max THEN
        DFR_RANGE_REAL := TRUE;
    ELSE
        DFR_RANGE_REAL := FALSE;
    END_IF;    
END_FUNCTION
    
    
    (**  Two Point Interpolation  *)
FUNCTION DFR_Scaler : REAL
    VAR_INPUT
        (**Value to convert*)
        X : REAL;
        (**X-coordinate of the first point*)
        X1 : REAL;
        (**X-coordinate of the second point*)
        X2 : REAL;
        (**Y-coordinate of the first point*)
        Y1 : REAL;
        (**Y-coordinate of the second point*)
        Y2 : REAL;
    END_VAR
    IF (X2 = X1) THEN
        DFR_Scaler := -1.0;
    ELSE
        DFR_Scaler := Y1 + ((X - X1) * (Y2 - Y1)) / (X2 - X1);
    END_IF;
	
END_FUNCTION
    


(**
 *Look Up Table *)
 
FUNCTION_BLOCK DFR_INTERPOLATE
    VAR		 
        Index : DINT;		    	              
    END_VAR
    VAR_INPUT
		(** N*)
        X : REAL;
        (** Denominator *)
        Xin  : ARRAY[0..149]OF REAL;
        Yin  : ARRAY[0..149]OF REAL;
        MaxIdx : DINT;
				
    END_VAR    
    VAR_OUTPUT
		(**  output. *)
        Out : REAL;
    END_VAR
   	
    IF(X < Xin[0]) THEN Out := Yin[0];
    ELSIF(X > Xin[MaxIdx]) THEN Out := Yin[MaxIdx];
    ELSE
        FOR Index := 0 TO MaxIdx - 1 DO
            IF(Xin[Index] <= Xin[Index + 1]) THEN
                IF(DFR_Range_REAL(X, Xin[Index], Xin[Index + 1])) THEN
                    Out := DFR_Scaler(X, Xin[Index], Xin[Index + 1], Yin[Index], Yin[Index + 1]);
                    EXIT;
                END_IF;
            ELSE
                IF(DFR_Range_REAL(X, Xin[Index + 1], Xin[Index])) THEN
                    Out := DFR_Scaler(X, Xin[Index], Xin[Index + 1], Yin[Index], Yin[Index + 1]);
                    EXIT;
                END_IF;
            END_IF;
        END_FOR;
    END_IF;
	
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_MovingStandardDev
 
//Declare variables
    VAR_INPUT 
        SAMPLES : ARRAY[1..100] OF REAL; 
    END_VAR

    VAR
        PERIOD : INT := 0;
        INDEX : INT := 1;
        SUM : REAL;  
        MEAN : REAL := 0;   
        SQUARES : REAL := 0;    
    END_VAR

    VAR_OUTPUT
        STD_DEV : REAL;   
    END_VAR
    
    

//Find the mean value of samples in a given window of the input values array
    WHILE PERIOD < 95 DO
        SUM := SAMPLES[INDEX] + SAMPLES[INDEX + 1] + SAMPLES[INDEX + 2] + SAMPLES[INDEX + 3] + SAMPLES[INDEX + 4];
        MEAN := SUM / 5;
        SQUARES := ((SAMPLES[INDEX] - MEAN) ** 2) + ((SAMPLES[INDEX + 1] - MEAN) ** 2) + ((SAMPLES[INDEX + 2] - MEAN) ** 2) + ((SAMPLES[INDEX + 3] - MEAN) ** 2) + ((SAMPLES[INDEX + 4] - MEAN) ** 2);

//Find the standard deviation
        IF SQUARES = 0 THEN
            STD_DEV := 0;
        ELSE
            STD_DEV := (SQUARES / 4) ** (0.5);
        END_IF;
    
        PERIOD := PERIOD + 1;
        INDEX := INDEX + 1;  
        
    END_WHILE;
   
END_FUNCTION_BLOCK  


FUNCTION_BLOCK DFR_PIDController

    VAR_INPUT
        InValPID : REAL;
        Kp_PID : REAL;
        Ki_PID : REAL;
        Kd_PID : REAL;
        MinLimPID : REAL;
        SetPointPID : REAL;
        MaxLimPID : REAL;
        InValSteadyPID : REAL;
        EnableTi : BOOL;
        EnableTd : BOOL;
        InValTi : REAL;
        InValTd : REAL;
        NeutralBandPID : BOOL;
        LowerBandPID : REAL;
        UpperBandPID : REAL;
        ReversePID : BOOL;
        Cycletime : REAL;
    END_VAR

    VAR
        CurrErrPID : REAL;
        SumErrPID : REAL;
        PrevErrPID : REAL := 0;
        StatusIntegrationPaused : BOOL;
        CurrValPID : REAL := 0;
        IntegralGainVal : REAL := 0;
        DifferentialGainVal  : REAL := 0;
        DFR_Saturation1 : DFR_Saturation;
        DFR_TimerTi : DFR_Timer;
        DFR_TimerTd : DFR_Timer;
    END_VAR
    
    VAR_OUTPUT
        OutValPID : REAL;
    END_VAR

    IF ReversePID = FALSE THEN
        CurrErrPID := SetPointPID - InValPID;
    ELSE
        CurrErrPID := InValPID - SetPointPID;
    END_IF;
    
// SumErrPID := SumErrPID + CurrErrPID;

    IF StatusIntegrationPaused THEN
        SumErrPID := SumErrPID;
    ELSE
        SumErrPID := SumErrPID + CurrErrPID;
    END_IF;
    
(*TON time period to execute Ti*)
    DFR_TimerTi(Ena := EnableTi, PLCCycletime := Cycletime, ProgramTime := InValTi);

    IF EnableTi THEN
        IF DFR_TimerTi.Q THEN
            DFR_TimerTi(Ena := FALSE, PLCCycletime := Cycletime, ProgramTime := InValTi);
            IntegralGainVal := (Ki_PID * SumErrPID);
        END_IF;
    ELSE
        IntegralGainVal := (Ki_PID * SumErrPID);
    END_IF;
    
(*TON Time period to execute Td*)
    DFR_TimerTd(Ena := EnableTd, PLCCycletime := Cycletime, ProgramTime := InValTd);
    
    IF EnableTd THEN
        IF DFR_TimerTd.Q THEN
            DFR_TimerTd(Ena := FALSE, PLCCycletime := Cycletime, ProgramTime := InValTd);
            DifferentialGainVal := Kd_PID * (CurrErrPID - PrevErrPID);
        END_IF;
    ELSE 
        DifferentialGainVal := Kd_PID * (CurrErrPID - PrevErrPID);
    END_IF;

    CurrValPID := InValSteadyPID + (Kp_PID * CurrErrPID) + IntegralGainVal + DifferentialGainVal;

    DFR_Saturation1(In := CurrValPID, Min := MinLimPID, Max := MaxLimPID);
    OutValPID := DFR_Saturation1.SaturatedSignal;
    StatusIntegrationPaused := DFR_Saturation1.Saturated_Status;

    PrevErrPID := CurrErrPID;

    IF NeutralBandPID THEN
        IF InValPID < LowerBandPID THEN
            OutValPID := MinLimPID;
        ELSIF InValPID > UpperBandPID THEN
            OutValPID := MaxLimPID;
        END_IF;
    END_IF;
     
END_FUNCTION_BLOCK


FUNCTION_BLOCK DFR_PWMGenerator
    VAR_INPUT
        Enable : BOOL;
        Amplitude : REAL;
        TotTime : REAL;
        dutycycle : REAL;
        Cycletime : REAL;
    END_VAR

    VAR
        Ontime : REAL;
        Offtime : REAL;
        PWMTonTimer : DFRTimer;
        Select : DFR_Select_REAL;
        Status : BOOL;
        currentcycle : INT := 0;
    END_VAR

    VAR_OUTPUT
        Out : REAL;
    END_VAR

    
    IF Enable THEN
        IF currentcycle < 1 THEN
            Ontime := (dutycycle * TotTime);
            offtime := (TotTime - ontime);
        END_IF;
        PWMTonTimer(Ena := Enable, PLCCycletime := Cycletime, ProgramTime := TotTime);
        IF (PWMTonTimer.ElapsedTime <= Ontime) THEN
            Status := TRUE;
        ELSE
            Status := FALSE;
        END_IF;
        Select(Sel := Status, Inp1 := Amplitude, Inp2 := 0);
        Out := Select.Sel_REAL; 
    ELSE
        Out := 0;
    END_IF;
    
    IF PWMTonTimer.Q THEN    
        PWMTonTimer(Ena := FALSE, PLCCycletime := Cycletime, ProgramTime := TotTime);
        Ontime := (dutycycle * TotTime);
        currentcycle := currentcycle + 1;
    END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFRTimer  (**ON Timer with Elapsed Time*)
    VAR_INPUT
        Ena : BOOL;
        PLCCycletime : REAL;
        ProgramTime : REAL;
    END_VAR

    VAR
        timecount : REAL := 0;
    END_VAR
    
    VAR_OUTPUT
        Q : BOOL;
        ElapsedTime : REAL;
    END_VAR

    IF Ena = TRUE THEN
        timecount := timecount + PLCCycletime;
        ElapsedTime := timecount;
        IF timecount > ProgramTime THEN
            Q := TRUE;
            timecount := 0;
        ELSE
            Q := FALSE;
        END_IF;
    
    ELSE
        Q := FALSE;
        timecount := 0.0;
    END_IF;       
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_Select_REAL  (*Choosing one single real input out of two real inputs on select input*)
    VAR_INPUT
        Sel : BOOL;
        Inp1 : REAL;
        Inp2 : REAL;
    END_VAR
    VAR_OUTPUT
        Sel_REAL : REAL;
    END_VAR
    IF (Sel = TRUE) THEN
        Sel_REAL := Inp1;
    ELSE
        Sel_REAL := Inp2;
    END_IF;
END_FUNCTION_BLOCK

FUNCTION DFR_BITUNPACKING : ARRAY[0..7] OF BOOL  (*Unpacks integer value into boolean values*)
    VAR_INPUT
        Inp : INT;    
    END_VAR
    VAR
        a : ARRAY[0..7] OF INT;
        i  : INT;
        b : ARRAY[0..7] OF BOOL;
    END_VAR
    a := DFR_DECTOBIN(Inp);
    FOR i := 0 TO 7 DO
        IF a[i] = 0 THEN
            b[i] := FALSE;
        ELSE
            b[i] := TRUE;
        END_IF;
    END_FOR;
    DFR_BITUNPACKING := b;
END_FUNCTION

FUNCTION DFR_BITUNPACKING : ARRAY[0..15] OF BOOL
    VAR_INPUT
        Inp : DINT;    
    END_VAR
    VAR
        a : ARRAY[0..15] OF DINT;
        i  : INT;
        b : ARRAY[0..15] OF BOOL;
    END_VAR
    a := DFR_DECTOBIN(Inp);
    FOR i := 0 TO 15 DO
        IF a[i] = 0 THEN
            b[i] := FALSE;
        ELSE
            b[i] := TRUE;
        END_IF;
    END_FOR;
    DFR_BITUNPACKING := b;
END_FUNCTION

FUNCTION DFR_BITUNPACKING : ARRAY[0..63] OF BOOL
    VAR_INPUT
        Inp : LINT;    
    END_VAR
    VAR
        a : ARRAY[0..63] OF LINT;
        i  : INT;
        b : ARRAY[0..63] OF BOOL;
    END_VAR
    a := DFR_DECTOBIN(Inp);
    FOR i := 0 TO 63 DO
        IF a[i] = 0 THEN
            b[i] := FALSE;
        ELSE
            b[i] := TRUE;
        END_IF;
    END_FOR;
    DFR_BITUNPACKING := b;
END_FUNCTION

FUNCTION DFR_Bitpacking : INT
    VAR_INPUT
        Inp : ARRAY[0..7] OF BOOL;
    END_VAR

    VAR
        i : INT;
        a : ARRAY[0..7] OF BOOL;
        c : ARRAY[0..7] OF INT;
    END_VAR
 
    FOR i := 0 TO 7 DO
        a[i] := Inp[i];
    END_FOR;

    FOR i := 0 TO 7 DO
        IF a[i] = FALSE THEN
            c[i] := 0;
        ELSE
            c[i] := 1;
        END_IF;
    END_FOR;

    DFR_Bitpacking := c[0] * 128 + c[1] * 64 + c[2] * 32 + c[3] * 16 + c[4] * 8 + c[5] * 4 + c[6] * 2 + c[7] * 1;
END_FUNCTION

FUNCTION DFR_Bitpacking : DINT	(*Packs Boolean inputs into integer value*)
    VAR_INPUT
        Inp : ARRAY[0..15] OF BOOL;
    END_VAR

    VAR
        i : INT;
        a : ARRAY[0..15] OF BOOL;
        c : ARRAY[0..15] OF DINT;
    END_VAR
 
    FOR i := 0 TO 15 DO
        a[i] := Inp[i];
    END_FOR;

    FOR i := 0 TO 15 DO
        IF a[i] = FALSE THEN
            c[i] := 0;
        ELSE
            c[i] := 1;
        END_IF;
    END_FOR;

    DFR_Bitpacking := c[0] * 32768 + c[1] * 16384 + c[2] * 8192 + c[3] * 4096 + c[4] * 2048 + c[5] * 1024 + c[6] * 512 + c[7] * 256 + c[8] * 128 + c[9] * 64 + c[10] * 32 + c[11] * 16 + c[12] * 8 + c[13] * 4 + c[14] * 2 + c[15] * 1;
END_FUNCTION

FUNCTION DFR_Bitpacking : LINT
    VAR_INPUT
        Inp : ARRAY[0..63] OF BOOL;
    END_VAR

    VAR
        i : INT;
        a : ARRAY[0..63] OF BOOL;
        c : ARRAY[0..63] OF LINT;
    END_VAR
 
    FOR i := 0 TO 63 DO
        a[i] := Inp[i];
    END_FOR;

    FOR i := 0 TO 63 DO
        IF a[i] = FALSE THEN
            c[i] := 0;
        ELSE
            c[i] := 1;
        END_IF;
    END_FOR;

    DFR_Bitpacking := c[0] * 2147483648 + c[1] * 1073741824 + c[2] * 536870912 + c[3] * 268435456 + c[4] * 134217728 + c[5] * 67108864 + c[6] * 33554432 + c[7] * 16777216 + c[8] * 8388608 + c[9] * 4194304 + c[10] * 2097152 + c[11] * 1048576 + c[12] * 524288 + c[13] * 262144 + c[14] * 163072 + c[15] * 65536 + c[16] * 32768 + c[17] * 16384 + c[18] * 8192 + c[19] * 4096 + c[20] * 2048 + c[21] * 1024 + c[22] * 512 + c[23] * 256 + c[24] * 128 + c[25] * 64 + c[26] * 32 + c[27] * 16 + c[28] * 8 + c[29] * 4 + c[30] * 2 + c[63] * 1;
END_FUNCTION

FUNCTION_BLOCK DFR_FirstOrderFilter
    VAR_INPUT
        Enable : BOOL;
        Inp  : REAL;
        TimeConstant : REAL;
        cycletimeplc : REAL;
    END_VAR
    
    VAR
        exp : REAL;
        e : REAL;
        incrtime : REAL;
        DivByClamp1 : DFR_DIV_CLAMP;
    END_VAR
    VAR_OUTPUT
        Out : REAL;
    END_VAR
    e := 2.71828;

    IF Enable THEN
        incrtime := incrtime + cycletimeplc;
        DivByClamp1(In1 := incrtime, In2 := TimeConstant, Out => exp);
        Out := Inp * (1 - (e ** (exp *- 1)));
    ELSE
        Out := 0;
    END_IF;
END_FUNCTION_BLOCK

FUNCTION DFR_GETBIT : BOOL   (*Get Bit function with overloading*)
    VAR_INPUT
        Inp : INT;
        pos : INT;
    END_VAR
    VAR
        j : INT;
        bit : INT;
        b : ARRAY[0..7] OF INT;
    END_VAR
    b := DFR_DECTOBIN(Inp);
    FOR j := 0 TO 7 DO
        IF pos = j THEN
            bit := b[7 - j];
        END_IF;
    END_FOR;
    
    IF bit = 0 THEN
        DFR_GETBIT := FALSE;
    ELSE
        DFR_GETBIT := TRUE;
    END_IF;
END_FUNCTION

FUNCTION DFR_GETBIT: BOOL
    VAR_INPUT
        in     : ulint;
        pos    : int;
    END_VAR
        
    VAR
        x1    : ulint := 1;
        x3    : ulint := 0;
        x4    : real := 2.0;
    END_VAR

    x1 := to_ulint( expt(x4, pos));
    x3 := in / x1;
    
    IF((x3 MOD 2) = 1) THEN
        DFR_GETBIT := TRUE;
    ELSE
        DFR_GETBIT := FALSE;
    END_IF;
END_FUNCTION

FUNCTION DFR_GETBIT : BOOL
    VAR_INPUT
        Inp : DINT;
        pos : INT;
    END_VAR
    VAR
        j : INT;
        bit : DINT;
        b : ARRAY[0..15] OF DINT;
    END_VAR
    b := DFR_DECTOBIN(Inp);
    FOR j := 0 TO 15 DO
        IF pos = j THEN
            bit := b[15 - j];
        END_IF;
    END_FOR;
    
    IF bit = 0 THEN
        DFR_GETBIT := FALSE;
    ELSE
        DFR_GETBIT := TRUE;
    END_IF;
END_FUNCTION

FUNCTION DFR_GETBIT : BOOL
    VAR_INPUT
        Inp : LINT;
        pos : INT;
    END_VAR
    VAR
        j : INT;
        bit : LINT;
        b : ARRAY[0..63] OF LINT;
    END_VAR
    b := DFR_DECTOBIN(Inp);
    FOR j := 0 TO 63 DO
        IF pos = j THEN
            bit := b[63 - j];
        END_IF;
    END_FOR;
    
    IF bit = 0 THEN
        DFR_GETBIT := FALSE;
    ELSE
        DFR_GETBIT := TRUE;
    END_IF;
END_FUNCTION

FUNCTION DFR_DECTOBIN : ARRAY[0..7] OF INT   (*decimal to binary converter*)
    VAR_INPUT
        Inp  : INT;
    END_VAR

    VAR
        a : ARRAY[0..7] OF INT;
        i  : INT;
        swap : INT;
        j : INT := 7;
        b : ARRAY[0..7] OF INT;
    END_VAR

    IF Inp > 255 OR Inp < 0 THEN
        DFR_DECTOBIN := b;
        RETURN;
    END_IF;
    WHILE (Inp > 0) DO
        a[i] := Inp MOD 2;
        Inp := Inp / 2;
        i := i + 1;
    END_WHILE;

    FOR i := 0 TO 7 DO
        j := 7 - i;
        swap := a[i];
        b[j] := swap;
    END_FOR;    
    DFR_DECTOBIN := b;
END_FUNCTION

FUNCTION DFR_DECTOBIN : ARRAY[0..15] OF DINT
    VAR_INPUT
        Inp  : DINT;
    END_VAR

    VAR
        a : ARRAY[0..15] OF DINT;
        i  : INT;
        swap : DINT;
        j : INT := 15;
        b : ARRAY[0..15] OF DINT;
    END_VAR

    IF Inp > 65535 OR Inp < 0 THEN
        DFR_DECTOBIN := b;
        RETURN;
    END_IF;
    WHILE (Inp > 0) DO
        a[i] := Inp MOD 2;
        Inp := Inp / 2;
        i := i + 1;
    END_WHILE;

    FOR i := 0 TO 15 DO
        j := 15 - i;
        swap := a[i];
        b[j] := swap;
    END_FOR;
    
    DFR_DECTOBIN := b;
END_FUNCTION

FUNCTION DFR_DECTOBIN : ARRAY[0..63] OF LINT
    VAR_INPUT
        Inp  : LINT;
    END_VAR

    VAR
        a : ARRAY[0..63] OF LINT;
        i  : INT;
        swap : LINT;
        j : INT := 63;
        b : ARRAY[0..63] OF LINT;
    END_VAR

//IF Inp>4294967295 OR Inp<0 THEN
 //   DFR_DECTOBIN := b;
 //   RETURN;
//END_IF;
    WHILE (Inp > 0) DO
        a[i] := Inp MOD 2;
        Inp := Inp / 2;
        i := i + 1;
    END_WHILE;

    FOR i := 0 TO 63 DO
        j := 63 - i;
        swap := a[i];
        b[j] := swap;
    END_FOR;
    
    DFR_DECTOBIN := b;
END_FUNCTION


FUNCTION DFR_SQRT : LREAL     (*square root function with overloading*)
    VAR_INPUT
        BASE : LREAL;
    END_VAR
    DFR_SQRT := BASE ** 0.5;
END_FUNCTION

FUNCTION DFR_SQRT : REAL
    VAR_INPUT
        BASE : REAL;
    END_VAR
    DFR_SQRT := BASE ** 0.5;
END_FUNCTION

FUNCTION_BLOCK DFR_Superheat    (*superheat calculation function*)
    VAR_INPUT
        EvapCoilTemp : REAL;
        EvapPressure : REAL;
        RefrigerantType : INT;
    END_VAR
    VAR_TEMP
        P : ARRAY[0..149] OF REAL; (*Increased the array size to 149 in superheat*)
        T : ARRAY[0..149] OF REAL;
        Interpolation : DFR_INTERPOLATE;
        Interpolation_OUT : REAL;
    END_VAR
    VAR_OUTPUT
        SuperheatTemp : REAL;
    END_VAR
    CASE RefrigerantType OF
        0: (*CO2 REFRIGERANT*)
 
        P[0] := 9.3; P[1] := 9.5; P[2] := 9.7; P[3] := 9.9; P[4] := 10.1; P[5] := 10.3; P[6] := 10.6; P[7] := 10.8;
        P[8] := 11; P[9] := 11.3; P[10] := 11.5; P[11] := 11.7; P[12] := 12; P[13] := 12.2; P[14] := 12.5; P[15] := 12.8;
        P[16] := 13; P[17] := 13.3; P[18] := 13.5; P[19] := 13.8; P[20] := 14.1; P[21] := 14.4; P[22] := 14.7; P[23] := 14.9;
        P[24] := 15.2; P[25] := 15.5; P[26] := 15.8; P[27] := 16.1; P[28] := 16.4; P[29] := 16.7; P[30] := 17.1; P[63] := 17.4;
        P[32] := 17.7; P[33] := 18; P[34] := 18.4; P[35] := 18.7; P[36] := 19; P[37] := 19.4; P[38] := 19.7; P[39] := 20.1;
        P[40] := 20.4; P[41] := 20.8; P[42] := 21.2; P[43] := 21.5; P[44] := 21.9; P[44] := 22.3; P[45] := 22.7; P[46] := 23.1;
        P[47] := 23.5; P[48] := 23.8; P[49] := 24.3; P[50] := 24.7; P[51] := 25.1; P[51] := 25.5; P[52] := 25.9; P[53] := 26.3;
        P[54] := 26.8; P[55] := 27.2; P[56] := 27.6; P[57] := 28.1; P[58] := 28.5; P[59] := 29; P[60] := 29.5; P[61] := 29.9;
        P[61] := 30.4; P[62] := 30.9; P[63] := 63.4; P[64] := 63.8; P[65] := 32.3; P[66] := 32.8; P[67] := 33.3; P[68] := 33.9;
        P[69] := 34.4; P[70] := 34.9; P[71] := 35.4; P[72] := 35.9; P[73] := 36.5; P[74] := 37; P[75] := 37.6; P[76] := 38.1;
        P[77] := 38.7; P[78] := 39.3; P[79] := 39.8; P[80] := 40.4; P[81] := 41; P[82] := 41.6; P[83] := 42.2; P[84] := 42.8;
        P[85] := 43.4; P[86] := 44; P[87] := 44.6; P[88] := 45.3; P[89] := 45.9; P[90] := 46.6; P[91] := 47.2; P[92] := 47.9;
        P[93] := 48.5; P[94] := 49.2; P[95] := 49.9; P[96] := 50.6; P[97] := 51.2; P[98] := 51.9; P[99] := 52.7; P[100] := 53.4;
        P[101] := 54.1; P[102] := 54.8; P[103] := 55.5; P[104] := 56.3; P[105] := 57; P[106] := 57.8; P[107] := 58.6; P[108] := 59.3;
        P[109] := 60.1; P[110] := 60.9; P[111] := 61.7; P[112] := 62.5; P[113] := 63.3; P[114] := 64.2; P[115] := 65; P[116] := 65.9;
        P[117] := 66.7; P[118] := 67.6; P[119] := 68.4; P[120] := 69.3; P[121] := 70.2; P[122] := 71.1; P[123] := 72.1; P[124] := 72.8;
        P[125] := 71.5; P[126] := 72.8; P[127] := 74; P[128] := 75.2; P[129] := 76.5; P[130] := 77.7; P[131] := 79; P[132] := 80.2;
        P[133] := 81.4; P[134] := 82.6; P[135] := 83.9; P[136] := 85.1; P[137] := 86.3; P[138] := 87.6; P[139] := 88.8; P[140] := 90.1;
        P[141] := 91.2; P[142] := 92.5; P[143] := 93.7; P[144] := 95; P[145] := 96.2; P[146] := 97.4; P[147] := 98.7; P[148] := 99.9;
        P[149] := 100;

        T[0] := -39; T[1] := -38; T[2] := -37; T[3] := -36; T[4] := -35; T[5] := -34; T[6] := -33; T[7] := -32;
        T[8] := -63; T[9] := -30; T[10] := -29; T[11] := -28; T[12] := -27; T[13] := -26; T[14] := -25; T[15] := -24;
        T[16] := -23; T[17] := -22; T[18] := -21; T[19] := -20; T[20] := -19; T[21] := -18; T[22] := -17; T[23] := -16;
        T[24] := -15; T[25] := -14; T[26] := -13; T[27] := -12; T[28] := -11; T[29] := -12; T[30] := -11; T[63] := -10;
        T[32] := -9; T[33] := -8; T[34] := -7; T[35] := -6; T[36] := -5; T[37] := -4; T[38] := -3; T[39] := -2;
        T[40] := -1; T[41] := 0; T[42] := 1; T[43] := 2; T[44] := 3; T[44] := 4; T[45] := 5; T[46] := 6;
        T[47] := 7; T[48] := 8; T[49] := 9; T[50] := 10; T[51] := 11; T[51] := 12; T[52] := 13; T[53] := 14;
        T[54] := 15; T[55] := 16; T[56] := 17; T[57] := 18; T[58] := 19; T[59] := 20; T[60] := 21; T[61] := 22;
        T[61] := 23; T[62] := 24; T[63] := 25; T[64] := 26; T[65] := 27; T[66] := 28; T[67] := 29; T[68] := 30;
        T[69] := 63; T[70] := 32; T[71] := 33; T[72] := 34; T[73] := 35; T[74] := 36; T[75] := 37; T[76] := 38;
        T[77] := 39; T[78] := 40; T[79] := 41; T[80] := 42; T[81] := 43; T[82] := 44; T[83] := 45; T[84] := 46;
        T[85] := 47; T[86] := 48; T[87] := 49; T[88] := 50; T[89] := 51; T[90] := 52; T[91] := 53; T[92] := 54;
        T[93] := 55; T[94] := 56; T[95] := 57; T[96] := 58; T[97] := 59; T[98] := 60; T[99] := 61; T[100] := 62;
        T[101] := 63; T[102] := 64; T[103] := 65; T[104] := 66; T[105] := 67; T[106] := 68; T[107] := 69; T[108] := 70;
        T[109] := 71; T[110] := 72; T[111] := 73; T[112] := 74; T[113] := 75; T[114] := 76; T[115] := 77; T[116] := 78;
        T[117] := 79; T[118] := 80; T[119] := 81; T[120] := 82; T[121] := 83; T[122] := 84; T[123] := 85; T[124] := 86;
        T[125] := 87.8; T[126] := 81; T[127] := 82; T[128] := 83; T[129] := 84; T[130] := 85; T[131] := 86; T[132] := 87;
        T[133] := 88; T[134] := 89; T[135] := 90; T[136] := 91; T[137] := 92; T[138] := 93; T[139] := 94; T[140] := 95;
        T[141] := 96; T[142] := 97; T[143] := 98; T[144] := 99; T[145] := 100; T[146] := 101; T[147] := 102; T[148] := 103;
        T[149] := 105;

    
        Interpolation(X := DFR_PSIGTOBAR(EvapPressure), Xin := P, Yin := T, MaxIdx := 149);
        Interpolation_OUT := Interpolation.Out;
        SuperheatTemp := EvapCoilTemp - Interpolation_OUT;

        1 : (*R290 PROPANE REFRIGERANT*)

        P[0] := 0.124891683; P[1] := 0.152325933; P[2] := 0.174673210; P[3] := 0.1802635; P[4] := 0.208725069; P[5] := 0.237710641; P[6] := 0.267220213
; P[7] := 0.297274472; P[8] := 0.327866522; P[9] := 0.359003258; P[10] := 0.390705365; P[11] := 0.422959052; P[12] := 0.455785005;
        P[13] := 0.489190117; P[14] := 0.526374389; P[15] := 0.55775161; P[16] := 0.592921781; P[17] := 0.628691796; P[18] := 0.66506855;
        P[19] := 0.702093411; P[20] := 0.739669853; P[21] := 0.777935771; P[22] := 0.816822217; P[23] := 0.856329192; P[24] := 0.896525643;
        P[25] := 0.937342622; P[26] := 0.978849077; P[27] := 1.021045008; P[28] := 1.063861468; P[29] := 1.107436351; P[30] := 1.151663763;
        P[63] := 1.196585598; P[32] := 1.242228909; P[33] := 1.242228909; P[34] := 1.288561696; P[35] := 1.33558396; P[36] := 1.383433594;
        P[37] := 1.463903757; P[38] := 1.481201291; P[39] := 1.563257248; P[40] := 1.582002682; P[41] := 1.633575487; P[42] := 1.685837768;
        P[43] := 1.73892742; P[44] := 1.792844443; P[44] := 1.84751989; P[45] := 1.90295376; P[46] := 1.959283949; P[47] := 2.016372562;
        P[48] := 2.074288546; P[49] := 2.133063901; P[50] := 2.192671575; P[51] := 2.253069673; P[51] := 2.634364089; P[52] := 2.376554824;
        P[53] := 2.439572963; P[54] := 2.503418408; P[55] := 2.568229152; P[56] := 2.633936215; P[57] := 2.700470649; P[58] := 2.76797035;
        P[59] := 2.836366369; P[60] := 2.905658707; P[61] := 2.975916631; P[61] := 3.047139182; P[62] := 3.119258372; P[63] := 3.192342828;
        P[64] := 3.26639255; P[65] := 3.341407539; P[66] := 3.417387794; P[67] := 3.494402263; P[68] := 3.572381999; P[69] := 3.651327001;
        P[70] := 3.763306217; P[71] := 3.812639647; P[72] := 3.894367291; P[73] := 3.977449149; P[74] := 4.061496273; P[75] := 4.146646559; P[76] := 4.232900007;
        P[77] := 4.320118721; P[78] := 4.408509544; P[79] := 4.497934581; P[80] := 4.58846278; P[81] := 4.680025193; P[82] := 4.772759715; P[83] := 4.866597398; P[84] := 4.961538244;
        P[85] := 5.057651198; P[86] := 5.154867634; P[87] := 5.253255539; P[88] := 5.352746926; P[89] := 5.45347937; P[90] := 5.555634975; P[91] := 5.658391637; P[92] := 5.76257146;
        P[93] := 5.867992341; P[94] := 5.974654278; P[95] := 6.082488324; P[96] := 6.191563428; P[97] := 6.301879588; P[98] := 6.413436804; P[99] := 6.52616613; P[100] := 6.640274408;
        P[101] := 6.755554796; P[102] := 6.872145187; P[103] := 6.989907688; P[104] := 7.109187036; P[105] := 7.229845336; P[106] := 7.351196312; P[107] := 7.474609636; P[108] := 7.598714996;
        P[109] := 7.724889104; P[110] := 7.851752688; P[111] := 7.979995224; P[112] := 8.109616712; P[113] := 8.241306628; P[114] := 8.37368602; P[115] := 8.507444364; P[116] := 8.64258166;
        P[117] := 8.779787384; P[118] := 8.917682584; P[119] := 9.056956736; P[120] := 9.198299636; P[121] := 9.340363372; P[122] := 9.484463856; P[123] := 9.629911292; P[124] := 9.77676968;
        P[125] := 9.92500702; P[126] := 10.07462363; P[127] := 10.22630803; P[128] := 10.37868223; P[129] := 10.53632485; P[130] := 10.68894643; P[131] := 10.84614696; P[132] := 11.00541591;
        P[133] := 11.16537434; P[134] := 11.3274012; P[135] := 11.49149649; P[136] := 11.65628126; P[137] := 11.82633445; P[138] := 11.99136659; P[139] := 12.16166716; P[140] := 12.33265721;
        P[141] := 12.50640516; P[142] := 12.68084259; P[143] := 12.85734845; P[144] := 13.03592273; P[145] := 13.21518649; P[146] := 13.39720816; P[147] := 13.5799193; P[148] := 13.76469886;
        P[149] := 13.95154686;

        T[0] := -39; T[1] := -38; T[2] := -37; T[3] := -36; T[4] := -35; T[5] := -34; T[6] := -33; T[7] := -32;
        T[8] := -63; T[9] := -30; T[10] := -29; T[11] := -28; T[12] := -27; T[13] := -26; T[14] := -25; T[15] := -24;
        T[16] := -23; T[17] := -22; T[18] := -21; T[19] := -20; T[20] := -19; T[21] := -18; T[22] := -17; T[23] := -16;
        T[24] := -15; T[25] := -14; T[26] := -13; T[27] := -12; T[28] := -11; T[29] := -12; T[30] := -11; T[63] := -10;
        T[32] := -9; T[33] := -8; T[34] := -7; T[35] := -6; T[36] := -5; T[37] := -4; T[38] := -3; T[39] := -2;
        T[40] := -1; T[41] := 0; T[42] := 1; T[43] := 2; T[44] := 3; T[44] := 4; T[45] := 5; T[46] := 6;
        T[47] := 7; T[48] := 8; T[49] := 9; T[50] := 10; T[51] := 11; T[51] := 12; T[52] := 13; T[53] := 14;
        T[54] := 15; T[55] := 16; T[56] := 17; T[57] := 18; T[58] := 19; T[59] := 20; T[60] := 21; T[61] := 22;
        T[61] := 23; T[62] := 24; T[63] := 25; T[64] := 26; T[65] := 27; T[66] := 28; T[67] := 29; T[68] := 30;
        T[69] := 63; T[70] := 32; T[71] := 33; T[72] := 34; T[73] := 35; T[74] := 36; T[75] := 37; T[76] := 38;
        T[77] := 39; T[78] := 40; T[79] := 41; T[80] := 42; T[81] := 43; T[82] := 44; T[83] := 45; T[84] := 46;
        T[85] := 47; T[86] := 48; T[87] := 49; T[88] := 50; T[89] := 51; T[90] := 52; T[91] := 53; T[92] := 54;
        T[93] := 55; T[94] := 56; T[95] := 57; T[96] := 58; T[97] := 59; T[98] := 60; T[99] := 61; T[100] := 62;
        T[101] := 63; T[102] := 64; T[103] := 65; T[104] := 66; T[105] := 67; T[106] := 68; T[107] := 69; T[108] := 70;
        T[109] := 71; T[110] := 72; T[111] := 73; T[112] := 74; T[113] := 75; T[114] := 76; T[115] := 77; T[116] := 78;
        T[117] := 79; T[118] := 80; T[119] := 81; T[120] := 82; T[121] := 83; T[122] := 84; T[123] := 85; T[124] := 86;
        T[125] := 87; T[126] := 88; T[127] := 89; T[128] := 90; T[129] := 91; T[130] := 92; T[131] := 93; T[132] := 94;
        T[133] := 95; T[134] := 96; T[135] := 97; T[136] := 98; T[137] := 99; T[138] := 100; T[139] := 101; T[140] := 102;
        T[141] := 103; T[142] := 104; T[143] := 105; T[144] := 106; T[145] := 107; T[146] := 108; T[147] := 109; T[148] := 110;
        T[149] := 111;

        Interpolation(X := DFR_PSIGTOBAR(EvapPressure), Xin := P, Yin := T, MaxIdx := 149);
        Interpolation_OUT := Interpolation.Out;
        SuperheatTemp := EvapCoilTemp - Interpolation_OUT;
    
        2: (*R404 A REFRIGERANT*)
    
        P[0] := 6.8; P[1] := 8; P[2] := 9; P[3] := 11; P[4] := 12; P[5] := 13; P[6] := 15; P[7] := 17;
        P[8] := 19; P[9] := 20; P[10] := 21; P[11] := 22; P[12] := 23; P[13] := 25; P[14] := 28; P[15] := 30;
        P[16] := 32; P[17] := 34; P[18] := 37; P[19] := 39; P[20] := 40; P[21] := 42; P[22] := 44; P[23] := 46;
        P[24] := 48; P[25] := 52; P[26] := 54; P[27] := 56; P[28] := 58; P[29] := 60; P[30] := 63; P[63] := 65;
        P[32] := 67; P[33] := 69; P[34] := 71; P[35] := 72; P[36] := 74; P[37] := 76; P[38] := 80; P[39] := 82;
        P[40] := 84; P[41] := 86; P[42] := 88; P[43] := 90; P[44] := 92; P[44] := 93; P[45] := 95; P[46] := 98;
        P[47] := 101; P[48] := 104; P[49] := 108; P[50] := 112; P[51] := 116; P[51] := 120; P[52] := 123; P[53] := 125;
        P[54] := 128; P[55] := 132; P[56] := 134; P[57] := 136; P[58] := 139; P[59] := 142; P[60] := 144; P[61] := 146;
        P[61] := 149; P[62] := 152; P[63] := 155; P[64] := 159; P[65] := 162; P[66] := 164; P[67] := 167; P[68] := 170;
        P[69] := 175; P[70] := 180; P[71] := 184; P[72] := 188; P[73] := 190; P[74] := 192; P[75] := 194; P[76] := 196;
        P[77] := 200; P[78] := 202; P[79] := 204; P[80] := 205; P[81] := 208; P[82] := 209; P[83] := 210; P[84] := 211;
        P[85] := 212; P[86] := 213; P[87] := 215; P[88] := 217; P[89] := 219; P[90] := 220; P[91] := 221; P[92] := 222;
        P[93] := 223; P[94] := 225; P[95] := 227; P[96] := 230; P[97] := 263; P[98] := 234; P[99] := 235; P[100] := 238;
        P[101] := 240; P[102] := 241; P[103] := 242; P[104] := 243; P[105] := 245; P[106] := 246; P[107] := 247; P[108] := 249;
        P[109] := 250; P[110] := 251; P[111] := 252; P[112] := 260; P[113] := 262; P[114] := 265; P[115] := 266; P[116] := 267;
        P[117] := 270; P[118] := 272; P[119] := 273; P[120] := 275; P[121] := 276; P[122] := 278; P[123] := 280; P[124] := 281;
        P[125] := 282; P[126] := 283; P[127] := 284; P[128] := 285; P[129] := 286; P[130] := 287; P[131] := 288; P[132] := 289;
        P[133] := 290; P[134] := 291; P[135] := 292; P[136] := 293; P[137] := 294; P[138] := 295; P[139] := 296; P[140] := 297;
        P[141] := 298; P[142] := 299; P[143] := 300; P[144] := 301; P[145] := 302; P[146] := 303; P[147] := 304; P[148] := 305;
        P[149] := 306;
    
        T[0] := -39; T[1] := -38; T[2] := -37; T[3] := -36; T[4] := -35; T[5] := -34; T[6] := -33; T[7] := -32;
        T[8] := -63; T[9] := -30; T[10] := -29; T[11] := -28; T[12] := -27; T[13] := -26; T[14] := -25; T[15] := -24;
        T[16] := -23; T[17] := -22; T[18] := -21; T[19] := -20; T[20] := -19; T[21] := -18; T[22] := -17; T[23] := -16;
        T[24] := -15; T[25] := -14; T[26] := -13; T[27] := -12; T[28] := -11; T[29] := -12; T[30] := -11; T[63] := -10;
        T[32] := -9; T[33] := -8; T[34] := -7; T[35] := -6; T[36] := -5; T[37] := -4; T[38] := -3; T[39] := -2;
        T[40] := -1; T[41] := 0; T[42] := 1; T[43] := 2; T[44] := 3; T[44] := 4; T[45] := 5; T[46] := 6;
        T[47] := 7; T[48] := 8; T[49] := 9; T[50] := 10; T[51] := 11; T[51] := 12; T[52] := 13; T[53] := 14;
        T[54] := 15; T[55] := 16; T[56] := 17; T[57] := 18; T[58] := 19; T[59] := 20; T[60] := 21; T[61] := 22;
        T[61] := 23; T[62] := 24; T[63] := 25; T[64] := 26; T[65] := 27; T[66] := 28; T[67] := 29; T[68] := 30;
        T[69] := 63; T[70] := 32; T[71] := 33; T[72] := 34; T[73] := 35; T[74] := 36; T[75] := 37; T[76] := 38;
        T[77] := 39; T[78] := 40; T[79] := 41; T[80] := 42; T[81] := 43; T[82] := 44; T[83] := 45; T[84] := 46;
        T[85] := 47; T[86] := 48; T[87] := 49; T[88] := 50; T[89] := 51; T[90] := 52; T[91] := 53; T[92] := 54;
        T[93] := 55; T[94] := 56; T[95] := 57; T[96] := 58; T[97] := 59; T[98] := 60; T[99] := 61; T[100] := 62;
        T[101] := 63; T[102] := 64; T[103] := 65; T[104] := 66; T[105] := 67; T[106] := 68; T[107] := 69; T[108] := 70;
        T[109] := 71; T[110] := 72; T[111] := 73; T[112] := 74; T[113] := 75; T[114] := 76; T[115] := 77; T[116] := 78;
        T[117] := 79; T[118] := 80; T[119] := 81; T[120] := 82; T[121] := 83; T[122] := 84; T[123] := 85; T[124] := 86;
        T[125] := 87; T[126] := 88; T[127] := 89; T[128] := 90; T[129] := 91; T[130] := 92; T[131] := 93; T[132] := 94;
        T[133] := 95; T[134] := 96; T[135] := 97; T[136] := 98; T[137] := 99; T[138] := 100; T[139] := 101; T[140] := 102;
        T[141] := 103; T[142] := 104; T[143] := 105; T[144] := 106; T[145] := 107; T[146] := 108; T[147] := 109; T[148] := 110;
        T[149] := 111;
    
        Interpolation(X := DFR_PSIGTOBAR(EvapPressure), Xin := P, Yin := T, MaxIdx := 149);
        Interpolation_OUT := Interpolation.Out;
        SuperheatTemp := EvapCoilTemp - Interpolation_OUT;

        3 : (*R410A Refrigerant*)

        P[0] := 0.779728408; P[1] := 0.825095929; P[2] := 0.871290821; P[3] := 0.91845098; P[4] := 0.966507457; P[5] := 1.0155292; P[6] := 1.065447263; P[7] := 1.116330592;
        P[8] := 1.168179187; P[9] := 1.220993048; P[10] := 1.274772176; P[11] := 1.329585518; P[12] := 1.385433074; P[13] := 1.442634844; P[14] := 1.500161881; P[15] := 1.559112079;
        P[16] := 1.619165438; P[17] := 1.680253012; P[18] := 1.742443747; P[19] := 1.805737644; P[20] := 1.870134702; P[21] := 1.93570387; P[22] := 2.002376199; P[23] := 2.070220638;
        P[24] := 2.139237185; P[25] := 2.209425842; P[26] := 2.280855556; P[27] := 2.353457378; P[28] := 2.427300258; P[29] := 2.502384194; P[30] := 2.578709188; P[63] := 2.656344185;
        P[32] := 2.73522024; P[33] := 2.815406298; P[34] := 2.896902362; P[35] := 2.979708429; P[36] := 3.063893449; P[37] := 3.149388473; P[38] := 3.236262449; P[39] := 3.324515377;
        P[40] := 3.414147257; P[41] := 3.505227036; P[42] := 3.597685768; P[43] := 3.691592399; P[44] := 3.787015878; P[44] := 3.883818308; P[45] := 3.982206533; P[46] := 4.08197371;
        P[47] := 4.183326682; P[48] := 4.286196502; P[49] := 4.390652116; P[50] := 4.496624577; P[51] := 4.604182833; P[51] := 4.713326884; P[52] := 4.824056729; P[53] := 4.93637237;
        P[54] := 5.0504117; P[55] := 5.166036825; P[56] := 5.28338564; P[57] := 5.40232025; P[58] := 5.523047498; P[59] := 5.645429488; P[60] := 5.769604116; P[61] := 5.895502433;
        P[61] := 6.026324441; P[62] := 6.152539086; P[63] := 6.283746369; P[64] := 6.416746289; P[65] := 6.551607795; P[66] := 6.688330886; P[67] := 6.826846614; P[68] := 6.96715498;
        P[69] := 7.109876512; P[70] := 7.253976996; P[71] := 7.400145908; P[72] := 7.548383248; P[73] := 7.69799954; P[74] := 7.850373736; P[75] := 8.004126884; P[76] := 8.15994846;
        P[77] := 8.63852794; P[78] := 8.478486372; P[79] := 8.640513232; P[80] := 8.80460852; P[81] := 8.970772236; P[82] := 9.139693856; P[83] := 9.309994428; P[84] := 9.483052904;
        P[85] := 9.657490332; P[86] := 9.834685664; P[87] := 10.01394942; P[88] := 10.19528161; P[89] := 10.3793717; P[90] := 10.56553022; P[91] := 10.75375717; P[92] := 10.94405255;
        P[93] := 11.13710583; P[94] := 11.33222754; P[95] := 11.53010715; P[96] := 11.73005519; P[97] := 11.93207166; P[98] := 12.13684603; P[99] := 12.34368883; P[100] := 12.55328953;
        P[101] := 12.76564814; P[102] := 12.98007518; P[103] := 13.19726012; P[104] := 13.41651348; P[105] := 13.63852476; P[106] := 13.86329393; P[107] := 14.09016354; P[108] := 14.32041652;
        P[109] := 14.55276993; P[110] := 14.78788125; P[111] := 15.02575047; P[112] := 15.26568812; P[113] := 15.50907634; P[114] := 15.75521608; P[115] := 16.00342744; P[116] := 16.25508618;
        P[117] := 16.50881334; P[118] := 16.76598789; P[119] := 17.02592034; P[120] := 17.28792122; P[121] := 17.55336948; P[122] := 17.82226512; P[123] := 18.09322919; P[124] := 18.36764064;
        P[125] := 18.64480999; P[126] := 18.92473725; P[127] := 19.20811188; P[128] := 19.49424442; P[129] := 19.78382434; P[130] := 20.07616217; P[131] := 20.3712579; P[132] := 20.669801;
        P[133] := 20.97179149; P[134] := 21.27653988; P[135] := 21.58473566; P[136] := 21.89568933; P[137] := 22.21009039; P[138] := 22.52793882; P[139] := 22.84923464; P[140] := 23.17397784;
        P[141] := 23.50147894; P[142] := 23.83242742; P[143] := 24.16751275; P[144] := 24.50535599; P[145] := 24.84664661; P[146] := 25.19207409; P[147] := 25.54025947; P[148] := 25.8925817;
        P[149] := 26.24835132;
        
        T[0] := -39; T[1] := -38; T[2] := -37; T[3] := -36; T[4] := -35; T[5] := -34; T[6] := -33; T[7] := -32;
        T[8] := -63; T[9] := -30; T[10] := -29; T[11] := -28; T[12] := -27; T[13] := -26; T[14] := -25; T[15] := -24;
        T[16] := -23; T[17] := -22; T[18] := -21; T[19] := -20; T[20] := -19; T[21] := -18; T[22] := -17; T[23] := -16;
        T[24] := -15; T[25] := -14; T[26] := -13; T[27] := -12; T[28] := -11; T[29] := -12; T[30] := -11; T[63] := -10;
        T[32] := -9; T[33] := -8; T[34] := -7; T[35] := -6; T[36] := -5; T[37] := -4; T[38] := -3; T[39] := -2;
        T[40] := -1; T[41] := 0; T[42] := 1; T[43] := 2; T[44] := 3; T[44] := 4; T[45] := 5; T[46] := 6;
        T[47] := 7; T[48] := 8; T[49] := 9; T[50] := 10; T[51] := 11; T[51] := 12; T[52] := 13; T[53] := 14;
        T[54] := 15; T[55] := 16; T[56] := 17; T[57] := 18; T[58] := 19; T[59] := 20; T[60] := 21; T[61] := 22;
        T[61] := 23; T[62] := 24; T[63] := 25; T[64] := 26; T[65] := 27; T[66] := 28; T[67] := 29; T[68] := 30;
        T[69] := 63; T[70] := 32; T[71] := 33; T[72] := 34; T[73] := 35; T[74] := 36; T[75] := 37; T[76] := 38;
        T[77] := 39; T[78] := 40; T[79] := 41; T[80] := 42; T[81] := 43; T[82] := 44; T[83] := 45; T[84] := 46;
        T[85] := 47; T[86] := 48; T[87] := 49; T[88] := 50; T[89] := 51; T[90] := 52; T[91] := 53; T[92] := 54;
        T[93] := 55; T[94] := 56; T[95] := 57; T[96] := 58; T[97] := 59; T[98] := 60; T[99] := 61; T[100] := 62;
        T[101] := 63; T[102] := 64; T[103] := 65; T[104] := 66; T[105] := 67; T[106] := 68; T[107] := 69; T[108] := 70;
        T[109] := 71; T[110] := 72; T[111] := 73; T[112] := 74; T[113] := 75; T[114] := 76; T[115] := 77; T[116] := 78;
        T[117] := 79; T[118] := 80; T[119] := 81; T[120] := 82; T[121] := 83; T[122] := 84; T[123] := 85; T[124] := 86;
        T[125] := 87; T[126] := 88; T[127] := 89; T[128] := 90; T[129] := 91; T[130] := 92; T[131] := 93; T[132] := 94;
        T[133] := 95; T[134] := 96; T[135] := 97; T[136] := 98; T[137] := 99; T[138] := 100; T[139] := 101; T[140] := 102;
        T[141] := 103; T[142] := 104; T[143] := 105; T[144] := 106; T[145] := 107; T[146] := 108; T[147] := 109; T[148] := 110;
        T[149] := 111;
    
        Interpolation(X := DFR_PSIGTOBAR(EvapPressure), Xin := P, Yin := T, MaxIdx := 149);
        Interpolation_OUT := Interpolation.Out;
        SuperheatTemp := EvapCoilTemp - Interpolation_OUT;

        4: (*R448 A REFRIGERANT*)
    
        P[0] := 0.37244804; P[1] := 0.407735422; P[2] := 0.443719175; P[3] := 0.480413087; P[4] := 0.517824055; P[5] := 0.555965867; P[6] := 0.594845419; P[7] := 0.634476499;
        P[8] := 0.674859109; P[9] := 0.716020826; P[10] := 0.757940967; P[11] := 0.800619563; P[12] := 0.844194414; P[13] := 0.888458774; P[14] := 0.933619452; P[15] := 0.979607501;
        P[16] := 1.026353974; P[17] := 1.073996765; P[18] := 1.122535876; P[19] := 1.171902357; P[20] := 1.222165158; P[21] := 1.273255329; P[22] := 1.325630767; P[23] := 1.378262524;
        P[24] := 1.4321106; P[25] := 1.486923942; P[26] := 1.542633602; P[27] := 1.599377477; P[28] := 1.657017671; P[29] := 1.715626363; P[30] := 1.775262805; P[63] := 1.835867745;
        P[32] := 1.897437952; P[33] := 1.96011132; P[34] := 2.023749955; P[35] := 2.088422804; P[36] := 2.154198814; P[37] := 2.221009039; P[38] := 2.288853477; P[39] := 2.357801077;
        P[40] := 2.427851839; P[41] := 2.499005762; P[42] := 2.571363794; P[43] := 2.644692041; P[44] := 2.719293344; P[44] := 2.794928861; P[45] := 2.871805435; P[46] := 2.949854118;
        P[47] := 3.029074911; P[48] := 3.109467812; P[49] := 3.191101771; P[50] := 3.273976786; P[51] := 3.35802391; P[51] := 3.443381039; P[52] := 3.529910277; P[53] := 3.61774952;
        P[54] := 3.706898766; P[55] := 3.79728907; P[56] := 3.889058326; P[57] := 3.982068638; P[58] := 4.076388955; P[59] := 4.172088224; P[60] := 4.269166444; P[61] := 4.36755467;
        P[61] := 4.467390794; P[62] := 4.568536924; P[63] := 4.671130952; P[64] := 4.57612116; P[65] := 4.677543079; P[66] := 4.775103933; P[67] := 4.880524814; P[68] := 4.987393594;
        P[69] := 5.095641326; P[70] := 5.205405905; P[71] := 5.636618384; P[72] := 5.42934771; P[73] := 5.543593883; P[74] := 5.659287956; P[75] := 5.776567823; P[76] := 5.89529559;
        P[77] := 6.0156781; P[78] := 6.137577457; P[79] := 6.260993661; P[80] := 6.386064607; P[81] := 6.512721348; P[82] := 6.640963884; P[83] := 6.770861163; P[84] := 6.902344236;
        P[85] := 7.035416304; P[86] := 7.1705504; P[87] := 7.307066648; P[88] := 7.444961848; P[89] := 7.584925476; P[90] := 7.726957532; P[91] := 7.869679064; P[92] := 8.0151585;
        P[93] := 8.162016888; P[94] := 8.630254228; P[95] := 8.461249472; P[96] := 8.612934192; P[97] := 8.767376816; P[98] := 8.926398392; P[99] := 9.08039892; P[100] := 9.240357352;
        P[101] := 9.401694736; P[102] := 9.564411072; P[103] := 9.729885632; P[104] := 9.896738504; P[105] := 10.06566012; P[106] := 10.23665017; P[107] := 10.40901917; P[108] := 10.58414608;
        P[109] := 10.76065193; P[110] := 10.93922622; P[111] := 11.11986893; P[112] := 11.30258007; P[113] := 11.48735964; P[114] := 11.67420763; P[115] := 11.86632406; P[116] := 12.05410891;
        P[117] := 12.24716219; P[118] := 12.4422839; P[119] := 12.63947403; P[120] := 12.8387326; P[121] := 13.04005959; P[122] := 13.24345501; P[123] := 13.44891886; P[124] := 13.65714061;
        P[125] := 13.86743079; P[126] := 14.0797894; P[127] := 14.29421643; P[128] := 14.5107119; P[129] := 14.72996526; P[130] := 14.95128706; P[131] := 15.17467728; P[132] := 15.40013594;
        P[133] := 15.62835249; P[134] := 15.85932695; P[135] := 16.09168036; P[136] := 16.32679168; P[137] := 16.5646609; P[138] := 16.80459855; P[139] := 17.04660462; P[140] := 17.2913686;
        P[141] := 17.53820101; P[142] := 17.78779132; P[143] := 18.04013954; P[144] := 18.29455618; P[145] := 18.55173073; P[146] := 18.81097371; P[147] := 19.07297459; P[148] := 19.33773337;
        P[149] := 19.60456058;
    
        T[0] := -39; T[1] := -38; T[2] := -37; T[3] := -36; T[4] := -35; T[5] := -34; T[6] := -33; T[7] := -32;
        T[8] := -63; T[9] := -30; T[10] := -29; T[11] := -28; T[12] := -27; T[13] := -26; T[14] := -25; T[15] := -24;
        T[16] := -23; T[17] := -22; T[18] := -21; T[19] := -20; T[20] := -19; T[21] := -18; T[22] := -17; T[23] := -16;
        T[24] := -15; T[25] := -14; T[26] := -13; T[27] := -12; T[28] := -11; T[29] := -12; T[30] := -11; T[63] := -10;
        T[32] := -9; T[33] := -8; T[34] := -7; T[35] := -6; T[36] := -5; T[37] := -4; T[38] := -3; T[39] := -2;
        T[40] := -1; T[41] := 0; T[42] := 1; T[43] := 2; T[44] := 3; T[44] := 4; T[45] := 5; T[46] := 6;
        T[47] := 7; T[48] := 8; T[49] := 9; T[50] := 10; T[51] := 11; T[51] := 12; T[52] := 13; T[53] := 14;
        T[54] := 15; T[55] := 16; T[56] := 17; T[57] := 18; T[58] := 19; T[59] := 20; T[60] := 21; T[61] := 22;
        T[61] := 23; T[62] := 24; T[63] := 25; T[64] := 26; T[65] := 27; T[66] := 28; T[67] := 29; T[68] := 30;
        T[69] := 63; T[70] := 32; T[71] := 33; T[72] := 34; T[73] := 35; T[74] := 36; T[75] := 37; T[76] := 38;
        T[77] := 39; T[78] := 40; T[79] := 41; T[80] := 42; T[81] := 43; T[82] := 44; T[83] := 45; T[84] := 46;
        T[85] := 47; T[86] := 48; T[87] := 49; T[88] := 50; T[89] := 51; T[90] := 52; T[91] := 53; T[92] := 54;
        T[93] := 55; T[94] := 56; T[95] := 57; T[96] := 58; T[97] := 59; T[98] := 60; T[99] := 61; T[100] := 62;
        T[101] := 63; T[102] := 64; T[103] := 65; T[104] := 66; T[105] := 67; T[106] := 68; T[107] := 69; T[108] := 70;
        T[109] := 71; T[110] := 72; T[111] := 73; T[112] := 74; T[113] := 75; T[114] := 76; T[115] := 77; T[116] := 78;
        T[117] := 79; T[118] := 80; T[119] := 81; T[120] := 82; T[121] := 83; T[122] := 84; T[123] := 85; T[124] := 86;
        T[125] := 87; T[126] := 88; T[127] := 89; T[128] := 90; T[129] := 91; T[130] := 92; T[131] := 93; T[132] := 94;
        T[133] := 95; T[134] := 96; T[135] := 97; T[136] := 98; T[137] := 99; T[138] := 100; T[139] := 101; T[140] := 102;
        T[141] := 103; T[142] := 104; T[143] := 105; T[144] := 106; T[145] := 107; T[146] := 108; T[147] := 109; T[148] := 110;
        T[149] := 111;
    
        Interpolation(X := DFR_PSIGTOBAR(EvapPressure), Xin := P, Yin := T, MaxIdx := 149);
        Interpolation_OUT := Interpolation.Out;
        SuperheatTemp := EvapCoilTemp - Interpolation_OUT;
    END_CASE;    
END_FUNCTION_BLOCK

FUNCTION DFR_PSIGTOBAR : REAL   (*PSI TO BAR pressure converter*)
    VAR_INPUT
        Inp  : REAL;
    END_VAR
    DFR_PSIGTOBAR := Inp * 0.0689475728;
END_FUNCTION 

FUNCTION_BLOCK DFR_EULER_INTEGRATION
    VAR_INPUT
        In : REAL;  (*Input value*)
        IntStepsize : REAL; (*Integration Step Size/Cycle Time*)
        En_Integral : BOOL;
        Integraltime : REAL;
        InitVal : REAL;
    END_VAR
    VAR_OUTPUT
        Out : REAL; (*Output of Integration*)
    END_VAR
    VAR
        O : REAL; 
        DFR_Intgrl_Timer : DFR_Timer;
    END_VAR
    DFR_Intgrl_Timer(Ena := En_Integral, ProgramTime := Integraltime, PLCCycletime := IntStepsize);
    IF En_Integral = TRUE THEN    
        IF DFR_Intgrl_Timer.Q = TRUE THEN
            O := O + (In * Integraltime);
            DFR_Intgrl_Timer(Ena := FALSE, ProgramTime := Integraltime, PLCCycletime := IntStepsize);
        END_IF;
        Out := O + InitVal;
    ELSE
        Out := 0;
        O := 0;
    END_IF;
END_FUNCTION_BLOCK


(*BITWISE OR operator with function overloading*)

FUNCTION DFR_BITWISE_OR : BYTE
    VAR_INPUT
        (**  Input *)
        In1 : BYTE;
        (**  Input *)
        In2 : BYTE;
    END_VAR 
       
    DFR_BITWISE_OR := In1 | In2;

END_FUNCTION

FUNCTION DFR_BITWISE_OR : WORD
    VAR_INPUT
        (**  Input *)
        In1 : WORD;
        (**  Input *)
        In2 : WORD;
    END_VAR 
       
    DFR_BITWISE_OR := In1 | In2;

END_FUNCTION

FUNCTION DFR_BITWISE_OR : DWORD
    VAR_INPUT
        (**  Input *)
        In1 : DWORD;
        (**  Input *)
        In2 : DWORD;
    END_VAR 
       
    DFR_BITWISE_OR := In1 | In2;

END_FUNCTION

FUNCTION DFR_BITWISE_OR : INT
    VAR_INPUT
        (**  Input *)
        In1 : INT;
        (**  Input *)
        In2 : INT;
    END_VAR 
       
    VAR
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 7 DO
        q[i] := A[i] | B[i];   
    END_FOR;
    DFR_BITWISE_OR := DFR_Bitpacking(q);
END_FUNCTION


FUNCTION DFR_BITWISE_OR : DINT
    VAR_INPUT
        (**  Input *)
        In1 : DINT;
        (**  Input *)
        In2 : DINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 15 DO
        q[i] := A[i] | B[i];   
    END_FOR;
    DFR_BITWISE_OR := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_OR : LINT
    VAR_INPUT
        (**  Input *)
        In1 : LINT;
        (**  Input *)
        In2 : LINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 63 DO
        q[i] := A[i] | B[i];   
    END_FOR;
    DFR_BITWISE_OR := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_OR : ARRAY[0..63] OF BOOL
    VAR_INPUT
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    FOR i := 0 TO 63 DO
        q[i] := A[i] | B[i];   
    END_FOR;
    DFR_BITWISE_OR := q;
END_FUNCTION

FUNCTION DFR_BITWISE_OR : ARRAY[0..15] OF BOOL
    VAR_INPUT
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    FOR i := 0 TO 15 DO
        q[i] := A[i] | B[i];   
    END_FOR;
    DFR_BITWISE_OR := q;
END_FUNCTION

FUNCTION DFR_BITWISE_OR : ARRAY[0..7] OF BOOL
    VAR_INPUT
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    FOR i := 0 TO 7 DO
        q[i] := A[i] | B[i];   
    END_FOR;
    DFR_BITWISE_OR := q;
END_FUNCTION

(**Bitwise AND operator with Function Overloading**)

FUNCTION DFR_BITWISE_AND : BYTE
    VAR_INPUT
        (**  Input *)
        In1 : BYTE;
        (**  Input *)
        In2 : BYTE;
    END_VAR 
       
    DFR_BITWISE_AND := In1 & In2;

END_FUNCTION

FUNCTION DFR_BITWISE_AND : WORD
    VAR_INPUT
        (**  Input *)
        In1 : WORD;
        (**  Input *)
        In2 : WORD;
    END_VAR 
       
    DFR_BITWISE_AND := In1 & In2;

END_FUNCTION

FUNCTION DFR_BITWISE_AND : DWORD
    VAR_INPUT
        (**  Input *)
        In1 : DWORD;
        (**  Input *)
        In2 : DWORD;
    END_VAR 
       
    DFR_BITWISE_AND := In1 & In2;

END_FUNCTION

FUNCTION DFR_BITWISE_AND : INT
    VAR_INPUT
        (**  Input *)
        In1 : INT;
        (**  Input *)
        In2 : INT;
    END_VAR 
       
    VAR
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 7 DO
        q[i] := A[i] & B[i];   
    END_FOR;
    DFR_BITWISE_AND := DFR_Bitpacking(q);
END_FUNCTION


FUNCTION DFR_BITWISE_AND : DINT
    VAR_INPUT
        (**  Input *)
        In1 : DINT;
        (**  Input *)
        In2 : DINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 15 DO
        q[i] := A[i] & B[i];   
    END_FOR;
    DFR_BITWISE_AND := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_AND : LINT
    VAR_INPUT
        (**  Input *)
        In1 : LINT;
        (**  Input *)
        In2 : LINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 63 DO
        q[i] := A[i] & B[i];   
    END_FOR;
    DFR_BITWISE_AND := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_AND : ARRAY[0..63] OF BOOL
    VAR_INPUT
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    FOR i := 0 TO 63 DO
        q[i] := A[i] & B[i];   
    END_FOR;
    DFR_BITWISE_AND := q;
END_FUNCTION

FUNCTION DFR_BITWISE_AND : ARRAY[0..15] OF BOOL
    VAR_INPUT
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    FOR i := 0 TO 15 DO
        q[i] := A[i] & B[i];   
    END_FOR;
    DFR_BITWISE_AND := q;
END_FUNCTION

FUNCTION DFR_BITWISE_AND : ARRAY[0..7] OF BOOL
    VAR_INPUT
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    FOR i := 0 TO 7 DO
        q[i] := A[i] & B[i];   
    END_FOR;
    DFR_BITWISE_AND := q;
END_FUNCTION


(*BITIWISE NAND with function overloading*)

FUNCTION DFR_BITWISE_NAND : BYTE
    VAR_INPUT
        (**  Input *)
        In1 : BYTE;
        (**  Input *)
        In2 : BYTE;
    END_VAR 
    VAR
        A : BYTE;   
    END_VAR
    
    A := In1 & In2;
    DFR_BITWISE_NAND := NOT A;
END_FUNCTION

FUNCTION DFR_BITWISE_NAND : WORD
    VAR_INPUT
        (**  Input *)
        In1 : WORD;
        (**  Input *)
        In2 : WORD;
    END_VAR 
    VAR
        A : WORD;   
    END_VAR       
    A := In1 & In2;
    DFR_BITWISE_NAND := NOT A;
END_FUNCTION

FUNCTION DFR_BITWISE_NAND : DWORD
    VAR_INPUT
        (**  Input *)
        In1 : DWORD;
        (**  Input *)
        In2 : DWORD;
    END_VAR 
    VAR
        A : DWORD;   
    END_VAR
    A := In1 & In2;
    DFR_BITWISE_NAND := NOT A;
       

END_FUNCTION

FUNCTION DFR_BITWISE_NAND : INT
    VAR_INPUT
        (**  Input *)
        In1 : INT;
        (**  Input *)
        In2 : INT;
    END_VAR 
       
    VAR
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
        D : ARRAY[0..7] OF BOOL;
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 7 DO
        q[i] := A[i] & B[i];
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NAND := DFR_Bitpacking(D);
END_FUNCTION


FUNCTION DFR_BITWISE_NAND : DINT
    VAR_INPUT
        (**  Input *)
        In1 : DINT;
        (**  Input *)
        In2 : DINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
        i : INT;
        q : ARRAY[0..15] OF BOOL;
        D : ARRAY[0..15] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 15 DO
        q[i] := A[i] & B[i];
        D[i] := NOT q[i]; 
    END_FOR;
    DFR_BITWISE_NAND := DFR_Bitpacking(D);
END_FUNCTION

FUNCTION DFR_BITWISE_NAND : LINT
    VAR_INPUT
        (**  Input *)
        In1 : LINT;
        (**  Input *)
        In2 : LINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
        i : INT;
        q : ARRAY[0..63] OF BOOL;
        D : ARRAY[0..63] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 63 DO
        q[i] := A[i] & B[i];   
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NAND := DFR_Bitpacking(D);
END_FUNCTION

FUNCTION DFR_BITWISE_NAND : ARRAY[0..63] OF BOOL
    VAR_INPUT
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..63] OF BOOL;
        D : ARRAY[0..63] OF BOOL;
    END_VAR
    FOR i := 0 TO 63 DO
        q[i] := A[i] & B[i];  
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NAND := D;
END_FUNCTION

FUNCTION DFR_BITWISE_NAND : ARRAY[0..15] OF BOOL
    VAR_INPUT
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..15] OF BOOL;
        D : ARRAY[0..15] OF BOOL;
    END_VAR
    FOR i := 0 TO 15 DO
        q[i] := A[i] & B[i];   
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NAND := D;
END_FUNCTION

FUNCTION DFR_BITWISE_NAND : ARRAY[0..7] OF BOOL
    VAR_INPUT
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..7] OF BOOL;
        D : ARRAY[0..7] OF BOOL;
    END_VAR
    FOR i := 0 TO 7 DO
        q[i] := A[i] & B[i];
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NAND := D;
END_FUNCTION

(*BITWISE NOR function with overloading*)

FUNCTION DFR_BITWISE_NOR : BYTE
    VAR_INPUT
        (**  Input *)
        In1 : BYTE;
        (**  Input *)
        In2 : BYTE;
    END_VAR 
    VAR
        A : BYTE;   
    END_VAR
    
    A := In1 | In2;
    DFR_BITWISE_NOR := NOT A;
END_FUNCTION

FUNCTION DFR_BITWISE_NOR : WORD
    VAR_INPUT
        (**  Input *)
        In1 : WORD;
        (**  Input *)
        In2 : WORD;
    END_VAR 
    VAR
        A : WORD;   
    END_VAR       
    A := In1 | In2;
    DFR_BITWISE_NOR := NOT A;
END_FUNCTION

FUNCTION DFR_BITWISE_NOR : DWORD
    VAR_INPUT
        (**  Input *)
        In1 : DWORD;
        (**  Input *)
        In2 : DWORD;
    END_VAR 
    VAR
        A : DWORD;   
    END_VAR
    A := In1 | In2;
    DFR_BITWISE_NOR := NOT A;
       

END_FUNCTION

FUNCTION DFR_BITWISE_NOR : INT
    VAR_INPUT
        (**  Input *)
        In1 : INT;
        (**  Input *)
        In2 : INT;
    END_VAR 
       
    VAR
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
        D : ARRAY[0..7] OF BOOL;
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 7 DO
        q[i] := A[i] | B[i];
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NOR := DFR_Bitpacking(D);
END_FUNCTION


FUNCTION DFR_BITWISE_NOR : DINT
    VAR_INPUT
        (**  Input *)
        In1 : DINT;
        (**  Input *)
        In2 : DINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
        i : INT;
        q : ARRAY[0..15] OF BOOL;
        D : ARRAY[0..15] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 15 DO
        q[i] := A[i] | B[i];
        D[i] := NOT q[i]; 
    END_FOR;
    DFR_BITWISE_NOR := DFR_Bitpacking(D);
END_FUNCTION

FUNCTION DFR_BITWISE_NOR : LINT
    VAR_INPUT
        (**  Input *)
        In1 : LINT;
        (**  Input *)
        In2 : LINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
        i : INT;
        q : ARRAY[0..63] OF BOOL;
        D : ARRAY[0..63] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 63 DO
        q[i] := A[i] | B[i];   
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NOR := DFR_Bitpacking(D);
END_FUNCTION

FUNCTION DFR_BITWISE_NOR : ARRAY[0..63] OF BOOL
    VAR_INPUT
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..63] OF BOOL;
        D : ARRAY[0..63] OF BOOL;
    END_VAR
    FOR i := 0 TO 63 DO
        q[i] := A[i] | B[i];  
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NOR := D;
END_FUNCTION

FUNCTION DFR_BITWISE_NOR : ARRAY[0..15] OF BOOL
    VAR_INPUT
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..15] OF BOOL;
        D : ARRAY[0..15] OF BOOL;
    END_VAR
    FOR i := 0 TO 15 DO
        q[i] := A[i] | B[i];   
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NOR := D;
END_FUNCTION

FUNCTION DFR_BITWISE_NOR : ARRAY[0..7] OF BOOL
    VAR_INPUT
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..7] OF BOOL;
        D : ARRAY[0..7] OF BOOL;
    END_VAR
    FOR i := 0 TO 7 DO
        q[i] := A[i] | B[i];
        D[i] := NOT q[i];
    END_FOR;
    DFR_BITWISE_NOR := D;
END_FUNCTION

(*BITWISE NOT function with overloading*)

FUNCTION DFR_BITWISE_NOT : BYTE
    VAR_INPUT
        (**  Input *)
        In : BYTE;
    END_VAR 
    
    DFR_BITWISE_NOT := NOT In;
END_FUNCTION

FUNCTION DFR_BITWISE_NOT : WORD
    VAR_INPUT
        (**  Input *)
        In : WORD;
    END_VAR 
    
    DFR_BITWISE_NOT := NOT In;
END_FUNCTION

FUNCTION DFR_BITWISE_NOT : DWORD
    VAR_INPUT
        (**  Input *)
        In : DWORD;
    END_VAR 
    
    DFR_BITWISE_NOT := NOT In;
END_FUNCTION

FUNCTION DFR_BITWISE_NOT : INT
    VAR_INPUT
        (**  Input *)
        In : INT;
    END_VAR 
       
    VAR
        A : ARRAY[0..7] OF BOOL;
        D : ARRAY[0..7] OF BOOL;
        i : INT;
    END_VAR
    A := DFR_BITUNPACKING(In);

    FOR i := 0 TO 7 DO
        D[i] := NOT A[i];
    END_FOR;
    DFR_BITWISE_NOT := DFR_Bitpacking(D);
END_FUNCTION

FUNCTION DFR_BITWISE_NOT : DINT
    VAR_INPUT
        (**  Input *)
        In : DINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..15] OF BOOL;
        D : ARRAY[0..15] OF BOOL;
        i : INT;
    END_VAR
    A := DFR_BITUNPACKING(In);

    FOR i := 0 TO 15 DO
        D[i] := NOT A[i];
    END_FOR;
    DFR_BITWISE_NOT := DFR_Bitpacking(D);
END_FUNCTION

FUNCTION DFR_BITWISE_NOT : LINT
    VAR_INPUT
        (**  Input *)
        In : LINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..63] OF BOOL;
        D : ARRAY[0..63] OF BOOL;
        i : INT;
    END_VAR
    A := DFR_BITUNPACKING(In);

    FOR i := 0 TO 63 DO
        D[i] := NOT A[i];
    END_FOR;
    DFR_BITWISE_NOT := DFR_Bitpacking(D);
END_FUNCTION


FUNCTION DFR_BITWISE_NOT : ARRAY[0..63] OF BOOL
    VAR_INPUT
        A : ARRAY[0..63] OF BOOL;
    END_VAR
    VAR
        i : INT;
        D : ARRAY[0..63] OF BOOL;
    END_VAR
    FOR i := 0 TO 63 DO 
        D[i] := NOT A[i];
    END_FOR;
    DFR_BITWISE_NOT := D;
END_FUNCTION

FUNCTION DFR_BITWISE_NOT : ARRAY[0..15] OF BOOL
    VAR_INPUT
        A : ARRAY[0..15] OF BOOL;
    END_VAR
    VAR
        i : INT;
        D : ARRAY[0..15] OF BOOL;
    END_VAR
    FOR i := 0 TO 15 DO 
        D[i] := NOT A[i];
    END_FOR;
    DFR_BITWISE_NOT := D;
END_FUNCTION

FUNCTION DFR_BITWISE_NOT : ARRAY[0..7] OF BOOL
    VAR_INPUT
        A : ARRAY[0..7] OF BOOL;
    END_VAR
    VAR
        i : INT;
        D : ARRAY[0..7] OF BOOL;
    END_VAR
    FOR i := 0 TO 7 DO 
        D[i] := NOT A[i];
    END_FOR;
    DFR_BITWISE_NOT := D;
END_FUNCTION


(*BITWISE XOR with Function Overloading*)

FUNCTION DFR_BITWISE_XOR : BYTE
    VAR_INPUT
        (**  Input *)
        In1 : BYTE;
        (**  Input *)
        In2 : BYTE;
    END_VAR 
       
    DFR_BITWISE_XOR := (In1 & (NOT In2)) | ((NOT In1) & In2);

END_FUNCTION

FUNCTION DFR_BITWISE_XOR : WORD
    VAR_INPUT
        (**  Input *)
        In1 : WORD;
        (**  Input *)
        In2 : WORD;
    END_VAR 
       
    DFR_BITWISE_XOR := (In1 & (NOT In2)) | ((NOT In1) & In2);

END_FUNCTION

FUNCTION DFR_BITWISE_XOR : DWORD
    VAR_INPUT
        (**  Input *)
        In1 : DWORD;
        (**  Input *)
        In2 : DWORD;
    END_VAR 
       
    DFR_BITWISE_XOR := (In1 & (NOT In2)) | ((NOT In1) & In2);
END_FUNCTION

FUNCTION DFR_BITWISE_XOR : INT
    VAR_INPUT
        (**  Input *)
        In1 : INT;
        (**  Input *)
        In2 : INT;
    END_VAR 
       
    VAR
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 7 DO
        q[i] := (A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]);   
    END_FOR;
    DFR_BITWISE_XOR := DFR_Bitpacking(q);
END_FUNCTION


FUNCTION DFR_BITWISE_XOR : DINT
    VAR_INPUT
        (**  Input *)
        In1 : DINT;
        (**  Input *)
        In2 : DINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 15 DO
        q[i] := (A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]);;   
    END_FOR;
    DFR_BITWISE_XOR := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_XOR : LINT
    VAR_INPUT
        (**  Input *)
        In1 : LINT;
        (**  Input *)
        In2 : LINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 63 DO
        q[i] := (A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]);   
    END_FOR;
    DFR_BITWISE_XOR := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_XOR : ARRAY[0..63] OF BOOL
    VAR_INPUT
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    FOR i := 0 TO 63 DO
        q[i] := (A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]); 
    END_FOR;
    DFR_BITWISE_XOR := q;
END_FUNCTION

FUNCTION DFR_BITWISE_XOR : ARRAY[0..15] OF BOOL
    VAR_INPUT
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    FOR i := 0 TO 15 DO
        q[i] := (A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]);  
    END_FOR;
    DFR_BITWISE_XOR := q;
END_FUNCTION

FUNCTION DFR_BITWISE_XOR : ARRAY[0..7] OF BOOL
    VAR_INPUT
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    FOR i := 0 TO 7 DO
        q[i] := (A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]);   
    END_FOR;
    DFR_BITWISE_XOR := q;
END_FUNCTION

(*BITWISE X-NOR Function with Overloading*)

FUNCTION DFR_BITWISE_XNOR : BYTE
    VAR_INPUT
        (**  Input *)
        In1 : BYTE;
        (**  Input *)
        In2 : BYTE;
    END_VAR 
       
    DFR_BITWISE_XNOR := NOT ((In1 & (NOT In2)) | ((NOT In1) & In2));

END_FUNCTION

FUNCTION DFR_BITWISE_XNOR : WORD
    VAR_INPUT
        (**  Input *)
        In1 : WORD;
        (**  Input *)
        In2 : WORD;
    END_VAR 
       
    DFR_BITWISE_XNOR := NOT ((In1 & (NOT In2)) | ((NOT In1) & In2));

END_FUNCTION

FUNCTION DFR_BITWISE_XNOR : DWORD
    VAR_INPUT
        (**  Input *)
        In1 : DWORD;
        (**  Input *)
        In2 : DWORD;
    END_VAR 
       
    DFR_BITWISE_XNOR := NOT ((In1 & (NOT In2)) | ((NOT In1) & In2));
END_FUNCTION

FUNCTION DFR_BITWISE_XNOR : INT
    VAR_INPUT
        (**  Input *)
        In1 : INT;
        (**  Input *)
        In2 : INT;
    END_VAR 
       
    VAR
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 7 DO
        q[i] := NOT ((A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]));   
    END_FOR;
    DFR_BITWISE_XNOR := DFR_Bitpacking(q);
END_FUNCTION


FUNCTION DFR_BITWISE_XNOR : DINT
    VAR_INPUT
        (**  Input *)
        In1 : DINT;
        (**  Input *)
        In2 : DINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 15 DO
        q[i] := NOT ((A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]));;   
    END_FOR;
    DFR_BITWISE_XNOR := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_XNOR : LINT
    VAR_INPUT
        (**  Input *)
        In1 : LINT;
        (**  Input *)
        In2 : LINT;
    END_VAR 
       
    VAR
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    A := DFR_BITUNPACKING(In1);
    B := DFR_BITUNPACKING(In2);
    FOR i := 0 TO 63 DO
        q[i] := NOT ((A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]));   
    END_FOR;
    DFR_BITWISE_XNOR := DFR_Bitpacking(q);
END_FUNCTION

FUNCTION DFR_BITWISE_XNOR : ARRAY[0..63] OF BOOL
    VAR_INPUT
        A : ARRAY[0..63] OF BOOL;
        B : ARRAY[0..63] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..63] OF BOOL;
    END_VAR
    FOR i := 0 TO 63 DO
        q[i] := NOT ((A[i] & (NOT B[i])) | ((NOT A[i]) & B[i])); 
    END_FOR;
    DFR_BITWISE_XNOR := q;
END_FUNCTION

FUNCTION DFR_BITWISE_XNOR : ARRAY[0..15] OF BOOL
    VAR_INPUT
        A : ARRAY[0..15] OF BOOL;
        B : ARRAY[0..15] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..15] OF BOOL;
    END_VAR
    FOR i := 0 TO 15 DO
        q[i] := NOT ((A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]));  
    END_FOR;
    DFR_BITWISE_XNOR := q;
END_FUNCTION

FUNCTION DFR_BITWISE_XNOR : ARRAY[0..7] OF BOOL
    VAR_INPUT
        A : ARRAY[0..7] OF BOOL;
        B : ARRAY[0..7] OF BOOL;
    END_VAR
    VAR
        i : INT;
        q : ARRAY[0..7] OF BOOL;
    END_VAR
    FOR i := 0 TO 7 DO
        q[i] := NOT ((A[i] & (NOT B[i])) | ((NOT A[i]) & B[i]));   
    END_FOR;
    DFR_BITWISE_XNOR := q;
END_FUNCTION

(*Sample and Hold with Boolean I/O's*)
FUNCTION_BLOCK DFR_SAMPLE_HOLD_BOOL
    VAR_INPUT
        (**  Input *)
        In : BOOL;
        (**  sample signal *)
        S : BOOL;
    END_VAR  
    VAR
        PrevIn : BOOL;
    END_VAR    
    VAR_OUTPUT
        (**  output *)
        Out : BOOL;
    END_VAR
    (**  If sample signal is true the output will be same as input*)      
    IF S THEN
        Out := In;
        PrevIn := In;
    (**  If sample signal is false the output will be the previous input value*)  
    ELSE   
        Out := PrevIn;        
    END_IF;   
    
END_FUNCTION_BLOCK


(*Sample and Hold with Real I/O's*)
FUNCTION_BLOCK DFR_SAMPLE_HOLD_REAL
    VAR_INPUT
        (**  Input *)
        In : REAL;
        (**  sample signal *)
        S : BOOL;
    END_VAR  
    VAR
        PrevIn : REAL;
    END_VAR    
    VAR_OUTPUT
        (**  output *)
        Out : REAL;
    END_VAR
    (**  If sample signal is true the output will be same as input*)      
    IF S THEN
        Out := In;
        PrevIn := In;
    (**  If sample signal is false the output will be the previous input value*)  
    ELSE   
        Out := PrevIn;        
    END_IF;   
    
END_FUNCTION_BLOCK


(*Modified the DFR_Occurence function because of compile issues due to Syscall functions in the new version of Stone *)
FUNCTION_BLOCK DFR_Occurence (*Calculates the total no. of occurences of an event based on Boolean trigger input*)
    VAR_INPUT
        Trigger : BOOL; (*Input trigger signal*)
        MaxDayCount : INT; (*Maximum Day Count for the function*)
        MaxMonthCount : INT; (*Maximum Month Count for the function*)
        MaxWeekCount : INT; (*Maximum Week Count for the function*)
        CounterType : INT;
        Reset : BOOL; (*Sets the current count to '0' and MaxCount Signal to 'FALSE'*)
    END_VAR
    VAR
        Event1 : DateTime;  (*Current Year, Month, Date, Hour, Min and Second Information*)
        Timex : DFR_HOURSMONITOR;  (*Daily Hours Monitor*) 
        daylim : UINT;  (*Total no. of Days counted by Hours Monitor*)
        Day1 : UINT;    (*Current Day*)
        Month1 : UINT;  (*Current Month*)
        year1 : UINT;   (*Current Year*)
    END_VAR
    VAR_OUTPUT
        Count : INT := 0; (*Increments by 1 based on input trigger signal and current date*)
        MaxCountSignal : BOOL; (*Is True when maximum occurence count for days, month and year is over*)
    END_VAR 
    DFR_GetLocalTime(Event1);

    CASE CounterType OF
        0: (*Count the occurences based on Current Day*)
    
        IF Trigger THEN
            IF Day1 <> Event1.Day AND Month1 <> Event1.Month AND year1 <> Event1.Year THEN
                Count := 0;
            ELSE
                Count := Count + 1;
            END_IF;        
        END_IF;
    
        IF Count > MaxDayCount THEN
            MaxCountSignal := TRUE;
        ELSE
            MaxCountSignal := FALSE;
        END_IF;
    
        IF Reset THEN
            Count := 0;
            MaxCountSignal := FALSE;
        END_IF;

        1: (*Count the occurences based on Current Month*)

        IF Trigger THEN
            IF Month1 <> Event1.Month AND year1 <> Event1.Year THEN
                Count := 0;
            ELSE
                Count := Count + 1;
            END_IF;        
        END_IF;
    
        IF Count > MaxMonthCount THEN
            MaxCountSignal := TRUE;
        ELSE
            MaxCountSignal := FALSE;
        END_IF;
    
        IF Reset THEN
            Count := 0;
            MaxCountSignal := FALSE;
        END_IF;
    
        2: (*Count the occurences based on Current Week*)
        daylim := timex.DayCount;
        IF Trigger AND year1 <> Event1.Year AND Month1 <> event1.Month THEN
            Count := 0;
        ELSIF Trigger AND daylim <= 21 THEN (*Instances of Daylim is set based on the PLC Cycle time*)
            Timex(Ena := Trigger);
            Count := Count + 1;
            IF Timex.Q THEN
                Timex(Ena := FALSE);
            END_IF;
        ELSIF Trigger AND daylim > 21 THEN
            Count := 0;
            daylim := 0;
        END_IF;
    
        IF Count > MaxWeekCount THEN
            MaxCountSignal := TRUE;
        ELSE
            MaxCountSignal := FALSE;
        END_IF;
    
        IF Reset THEN
            Count := 0;
            MaxCountSignal := FALSE;
        END_IF;

    END_CASE;    
    
    Day1 := Event1.Day;
    Month1 := Event1.Month;
    Year1 := Event1.Year;
    
END_FUNCTION_BLOCK


FUNCTION_BLOCK DFR_HOURSMONITOR
    VAR_INPUT
        Ena : BOOL; (*Input to Enable the Hours Monitor Block*)
    END_VAR
    VAR
        currHr, CurrMin, CurrSec : UINT; (*Current Hour, Min and Sec in RTC*)
        EventX : DateTime;
    END_VAR
    VAR_OUTPUT
        Q : BOOL;
        DayCount : UINT;
    END_VAR
    DFR_GetLocalTime(EventX);
    currHr := EventX.Hour;
    CurrMin := EventX.Minute;
    CurrSec := EventX.Second;
    IF Ena THEN
        IF currHr = 23 AND CurrMin = 59 AND CurrSec = 59 THEN  (*Time Instant of a day - occurs only once per day*)
            Q := TRUE;
            DayCount := DayCount + 1;
        ELSE 
            Q := FALSE;
        END_IF;
    ELSE
        Q := FALSE;
    END_IF;
END_FUNCTION_BLOCK

FUNCTION DFR_GetLocalTime : UINT
    VAR_IN_OUT
            (** Current date time. *)
        dateTime : DateTime;
    END_VAR
    VAR
        dateAndTime : DATE_AND_TIME;
    END_VAR
    DFR_GetLocalTime := GetLocalTime(dateAndTime);
    SPLIT_DT(dateAndTime, dateTime);
END_FUNCTION


FUNCTION DFR_Dewpoint : REAL
    VAR_INPUT 
        TempC : REAL;
        REL_HUM : REAL;
    END_VAR

    VAR
        RH : REAL;
    END_VAR

    IF REL_HUM < 0.0 THEN				(*0 RH*)
        RH := 0.0;
    ELSIF REL_HUM > 100.0 THEN			(*100 RH*)
        RH := 100.0;
    ELSE
        RH := REL_HUM;
    END_IF;

    DFR_Dewpoint := TempC - ((100.0 - RH) / 5.0);        ///// Applying the Simple Dewpoint Equation (Dewpoint Temp = Current Temp -(100-RelativeHumidity)/5.0)
END_FUNCTION

FUNCTION_BLOCK DFR_TempFault
    VAR_INPUT 
        Enable : BOOL;       // Fault failure time will start when the logic is enabled and Input Temp is out of Range
        TempSP : REAL;
        TempIn : REAL;    
        Offset : REAL;       // Using Configurable Offset to change the desired temperature range 
        Timex : TIME;
       
    END_VAR
    VAR_OUTPUT
        timercount : TIME;
        temp_fault : BOOL;
    END_VAR
    VAR
        In_Range : BOOL;
        Min_Temp : REAL;
        Max_temp : REAL;
        TON_1 : TON; 
        
    END_VAR
  
    Min_Temp := TempSP - Offset;
    Max_Temp := TempSP + Offset;
    In_Range := DFR_RANGE_REAL(TempIn, Min_Temp, Max_temp);   //Using Range_Real function to keep a check on Input Temp Value
    
    
    IF Enable THEN
        IF NOT In_Range THEN
            TON_1(IN := TRUE, PT := Timex);
            timercount := TON_1.ET;
            IF TON_1.Q THEN
                temp_fault := TRUE;
            ELSE    
                temp_fault := FALSE;
            END_IF;   
        ELSE
            TON_1(IN := FALSE, PT := Timex);
            temp_fault := FALSE;
        END_IF;
    ELSE
        temp_fault := FALSE;
    END_IF;    
END_FUNCTION_BLOCK


FUNCTION DFR_CINControlComponent : BOOL
    VAR_INPUT
        Inp : INT;
    END_VAR  
    
    V_CSM_FeatureInfo := to_ulint(C_CSM_FeatureInfo4);
    V_CSM_FeatureInfo := V_CSM_FeatureInfo + to_ulint(65536) * to_ulint(C_CSM_FeatureInfo3); 
    V_CSM_FeatureInfo := V_CSM_FeatureInfo + to_ulint(4294967296) * to_ulint(C_CSM_FeatureInfo2); 
    V_CSM_FeatureInfo := V_CSM_FeatureInfo + to_ulint(281474976710656) * to_ulint(C_CSM_FeatureInfo1);
    
    IF V_CSM_FeatureInfo <= 0 AND NOT WIZDONE THEN
        V_CSM_InvalidCIN_Flag := TRUE;
    ELSIF WizDone AND V_CSM_FeatureInfo > 0 THEN
        DFR_CINControlComponent := DFR_GETBIT(V_CSM_FeatureInfo, Inp - 1);
        V_CSM_InvalidCIN_Flag := FALSE;
    END_IF;
END_FUNCTION

    
FUNCTION DFR_CINCaseSystemComponent : INT  
    VAR_INPUT
        comp_num : INT;
    END_VAR
    VAR
        out_info    : string;
        length      : int;
        str1        : string;
        str2        : string;
        str3        : string;
        str4        : string;
        str5        : string;
        str6        : string;
    END_VAR  
    
  //  V_CSM_CaseSystemInfo := '05052021121065001113237';
    
    str1 := format('%04u', C_CSM_CaseSystemInfo1);
    str2 := format('%04u', C_CSM_CaseSystemInfo2);
    str3 := format('%04u', C_CSM_CaseSystemInfo3);
    str4 := format('%04u', C_CSM_CaseSystemInfo4);
    str5 := format('%04u', C_CSM_CaseSystemInfo5);
    str6 := format('%03u', C_CSM_CaseSystemInfo6);
    
    V_CSM_CaseSystemInfo := str1 + str2 + str3 + str4 + str5 + str6;
    
    length := to_int(len(V_CSM_CaseSystemInfo));
    
    IF length <= 1 AND NOT WIZDONE THEN
        V_CSM_InvalidCIN_Flag := TRUE;
        out_info := '0';
    ELSE
         V_CSM_InvalidCIN_Flag := FALSE;
        CASE comp_num OF
            1: // Case date
                out_info := left(V_CSM_CaseSystemInfo, 2);
            2: // Case month
                out_info := mid(V_CSM_CaseSystemInfo, 2, 2);
            3: // Case year
                out_info := mid(V_CSM_CaseSystemInfo, 4, 4); 
            4: // Case Series
                out_info := mid(V_CSM_CaseSystemInfo, 3, 8); 
            5: // Refrigerant : 1-R-22, 2-R-404A, 3-R-407A, 4-R-410A, 5-R-422D, 6-R-507A, 7-R-448A, 8-R-449A, 9-CO2 DX, 10-CO2 SC, 11-Glycol SC
                out_info := mid(V_CSM_CaseSystemInfo, 2, 11); 
            6: // Doors : 0,1,2,3,4,5,6
                out_info := mid(V_CSM_CaseSystemInfo, 1, 13); 
            7: // Length in feet : 0,4,6,8,10,12
                out_info := mid(V_CSM_CaseSystemInfo, 2, 14); 
            8: // Evaporator : 0-Standard , 1- NRG
                out_info := mid(V_CSM_CaseSystemInfo, 1, 16); 
            9: // Control Temp : 0 -Dual,1-LT ,2-MT
                out_info := mid(V_CSM_CaseSystemInfo, 1, 17); 
            10: // Defrost Type : 0-Off-time, 1-Electric, 2-Hotgas
                out_info := mid(V_CSM_CaseSystemInfo, 1, 18); 
            11: // Metering Device Type : 0-None, 1-TXV, 2-PWM, 3-Stepper
                out_info := mid(V_CSM_CaseSystemInfo, 1, 19); 
            12: // Temperature Control Type : 1-Self Contained, 2-Remote
                out_info := mid(V_CSM_CaseSystemInfo, 1, 20); 
            13: // Controller Type : 1- Dixell, 2- MPXOne, 3 – Cpco Mini 
                out_info := mid(V_CSM_CaseSystemInfo, 2, 21);
            ELSE
                out_info := '0';
        END_CASE;
    END_IF;
    DFR_CINCaseSystemComponent := to_int(out_info);
END_FUNCTION

FUNCTION DFR_CINSerialNumber : LINT
    VAR
        Num : STRING; 
        V_CSM_SerialNumber : LINT;
    END_VAR
    Num := TO_STRING(C_CSM_SerialNumber1) + TO_STRING(C_CSM_SerialNumber2);
    IF V_CSM_SerialNumber <= 0 AND NOT WIZDONE THEN
        V_CSM_InvalidCIN_Flag := TRUE;
    ELSIF WizDone AND V_CSM_SerialNumber > 0 THEN
        V_CSM_SerialNumber := TO_LINT(Num);
        DFR_CINSerialNumber := V_CSM_SerialNumber;
        V_CSM_InvalidCIN_Flag := FALSE;  
    END_IF;
END_FUNCTION




FUNCTION_BLOCK DFR_Diag_ProbeRate
    VAR_INPUT
        Inp : REAL;
        ProbeTime : REAL;
        In_Status : BOOL;
    END_VAR
    VAR
        Deriv : DFR_DERIV; 
        DerivTimer : DFRTimer;
    END_VAR
    VAR_OUTPUT
        Rate : REAL;
        Out_Status : BOOL;
        TimerDone : BOOL;
    END_VAR
    
    DerivTimer(Ena := In_Status, PLCCycletime := 0.5, ProgramTime := ProbeTime);
    
    IF In_Status THEN
        Deriv(Enable := In_Status, In := Inp, DerivativeTime := ProbeTime, StpSze := 0.5);
        IF DerivTimer.Q THEN
            Out_Status := TRUE;
            TimerDone := TRUE;
            Rate := Deriv.OutDeriv;
        ELSE
            Out_Status := FALSE;
            TimerDone := FALSE;
        END_IF;
    ELSE
        Rate := 0;
    END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_Sensor_Diag
    VAR_INPUT
        Inp : REAL;
        In_Status : BOOL;
        Inp_LowerThreshold : REAL;
        Inp_HighThreshold : REAL;
        ProbeTime : REAL;
    END_VAR
    VAR
        SensorTimer : DFRTimer;
    END_VAR
    
    VAR_OUTPUT
        Sensor_Status : INT;
        Out_Status : BOOL;
        TimerDone : BOOL;
    END_VAR
    
    IF(In_Status = TRUE) THEN
        SensorTimer.Ena := TRUE;
        Out_Status      := FALSE;
    ELSE
        SensorTimer.Ena := FALSE;
    END_IF;
    
    SensorTimer(PLCCycletime := 0.5, ProgramTime := ProbeTime);
    TimerDone := SensorTimer.Q;
    
    IF SensorTimer.Q THEN
        IF Inp < Inp_LowerThreshold OR Inp > Inp_HighThreshold THEN
            Sensor_Status := 1;              // Sensor Error 
        ELSE 
            Sensor_Status := 0;              // Sensor Healthy
            Out_Status := TRUE;
        END_IF;
    END_IF;
END_FUNCTION_BLOCK

// EEV Diagnostic Test Function ///

FUNCTION_BLOCK DFR_DiagEEV
    VAR_INPUT
        Inp : BOOL;
        ProbeInp : REAL;
        PressureProbeTime : REAL;
    END_VAR
    VAR
        EEVProbeTimer : DFR_Diag_ProbeRate;
    END_VAR
    VAR_OUTPUT
        Out : INT;
        OutStatus : BOOL;
    END_VAR

    IF Inp THEN
        Out := 10;
    ELSE
        Out := 0;
    END_IF;

    EEVProbeTimer(Inp := ProbeInp, ProbeTime := PressureProbeTime, In_Status := Inp);
    IF EEVProbeTimer.Rate < 0 THEN
        OutStatus := TRUE;
    ELSE
        OutStatus := FALSE;
    END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_EEV_Check
    VAR_INPUT
        Ena : BOOL;
        Inp : REAL;
        TotTime : REAL;
    END_VAR
    VAR
        RegEEVTimer : DFRTimer;
    END_VAR
    VAR_OUTPUT
        Out : REAL;
        OutStatus : BOOL;
        TimerDone : BOOL;
    END_VAR

    IF Ena THEN
        RegEEVTimer(Ena := TRUE, PLCCycleTime := 0.5, ProgramTime := TotTime);
        Out := Inp;
        IF RegEEVTimer.Q THEN
            TimerDone := TRUE;
            RegEEVTimer(Ena := FALSE, PLCCycleTime := 0.5, ProgramTime := TotTime);
            IF Inp = 0 AND Out <= 0.1 THEN
                OutStatus := TRUE;
            ELSIF Inp = 100 AND Out >= 95 THEN
                OutStatus := TRUE;
            ELSE
                OutStatus := FALSE;
            END_IF;     
        END_IF;
    ELSE
        RegEEVTimer(Ena := FALSE);
    END_IF;
END_FUNCTION_BLOCK

/// SENSOR SWAP TEST FUNCTION ///

(* Coil Outlet Vs Discharge Air *)

FUNCTION_BLOCK DFR_Diag_SensorSwap_RegEEV
    VAR_INPUT
        In_Status : BOOL;
        TotTime : REAL;    
    END_VAR
    VAR
        Setpoint : REAL; // Setpoint to regulate the EEV
        RegEEVTimer : DFRTimer;
    END_VAR
    VAR_OUTPUT
        Out : REAL; // Current Open/Close % Status of EEV Valve
        TimerDone : BOOL; // When Defrost Timer is Complete
    END_VAR
    
    TimerDone := TRUE;
    IF In_Status THEN
        Setpoint := 100.0;
        Out := Setpoint;
        IF Setpoint = 100.0  THEN
            RegEEVTimer(Ena := TRUE, PLCCycletime := 0.5, ProgramTime := TotTime);
            IF RegEEVTimer.Q THEN
                TimerDone := TRUE;
                RegEEVTimer(Ena := FALSE);
            END_IF;    
        END_IF;
    END_IF;    
END_FUNCTION_BLOCK

(* Defrost Temp Vs Disharge Air *)

FUNCTION_BLOCK DFR_Diag_SensorSwap_DfrOn
    VAR_INPUT
        In_Status : BOOL; // Enable the DFR_SensorSwap_DfrOn Function
        TotTime : REAL; // Total Time to keep the Defrost Heater On
    END_VAR
    VAR
        SensorSwap_DfrOn : DFRTimer;
    END_VAR
    VAR_OUTPUT
        TimerDone : BOOL; // When Sensor Swap Timer is Complete
    END_VAR
    
    TimerDone := FALSE;
    
    IF In_Status THEN
        
            SensorSwap_DfrOn(Ena := TRUE, PLCCycletime := 0.5, ProgramTime := TotTime);
            IF SensorSwap_DfrOn.Q THEN
                TimerDone := TRUE;
                SensorSwap_DfrOn(Ena := FALSE);
            END_IF;    
    END_IF;    

END_FUNCTION_BLOCK

/// Drain Heater Function ///

FUNCTION_BLOCK DFR_DiagDrainheater
    VAR_INPUT
        Inp : BOOL;
        Trigger : BOOL;
        //TotTime : REAL; 
    END_VAR
    
    VAR
        //DrainHtrTimer : DFRTimer;
    END_VAR
    VAR_OUTPUT
        Output : BOOL;
        //TimerDone : BOOL;
        Test_Status : STRING;
    END_VAR
    IF Inp AND NOT Trigger THEN
        Output := TRUE;
        Test_Status := 'NA';
    ELSIF (Inp AND Trigger) THEN
        Output := FALSE;
        Test_Status := 'PAS';
    END_IF;
END_FUNCTION_BLOCK

/// Defrost Heater Function ///

FUNCTION_BLOCK DFR_DefrostHeater
    VAR_INPUT
        Inp : BOOL;
    END_VAR
    VAR_OUTPUT
        Out : BOOL;
    END_VAR
    IF Inp THEN
        Out := TRUE;
    ELSE
        Out := FALSE;
    END_IF;
    
    
END_FUNCTION_BLOCK

VAR_GLOBAL
    DefrostDiagTimer : DFRTimer;
END_VAR

///  Fan Function ///

FUNCTION_BLOCK DFR_DiagFans
    VAR_INPUT
        Inp : BOOL;
    END_VAR
    VAR_OUTPUT
        Out : BOOL;
    END_VAR
    IF Inp THEN
        Out := TRUE;
    ELSE
        Out := FALSE;
    END_IF;
END_FUNCTION_BLOCK

/// Anti Sweat Heater Function ///

FUNCTION_BLOCK DFR_DiagAntiSweatHeater
    VAR_INPUT
        Inp : BOOL;
        Trigger : BOOL;
        //TotTime : REAL;
    END_VAR
    VAR
        //ASHtrTimer : DFRTimer;
    END_VAR
    VAR_OUTPUT
        Out1 : BOOL;
        Out2 : REAL;
        //TimerDone : BOOL;
        Test_Status : STRING;
    END_VAR
    IF Inp AND NOT Trigger THEN
        Out1 := TRUE;
        Out2 := 100;
        Test_Status := 'NA';
    ELSIF (Inp AND Trigger) THEN
        Out1 := FALSE;
        Out2 := 0;
        Test_Status := 'PAS';
    END_IF;
END_FUNCTION_BLOCK

/// Light Function ///

FUNCTION_BLOCK DFR_DiagLights
    VAR_INPUT
        Inp : BOOL;
        TotTime : REAL;
    END_VAR
    VAR_OUTPUT
        Out : BOOL;
        TimerDone : BOOL;
    END_VAR
    VAR
        LightTimer : DFRTimer;
    END_VAR
    IF Inp THEN
        LightTimer(Ena := Inp, PLCCycletime := 0.5, ProgramTime := TotTime);
        IF LightTimer.ElapsedTime <= (TotTime / 10) THEN
            Out := TRUE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 10) AND LightTimer.ElapsedTime <= (TotTime / 7.5) THEN
            Out := FALSE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 7.5) AND LightTimer.ElapsedTime <= (TotTime / 5) THEN
            Out := TRUE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 5) AND LightTimer.ElapsedTime <= (TotTime / 2.5) THEN
            Out := FALSE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 2.5) AND LightTimer.ElapsedTime <= (TotTime / 2) THEN
            Out := TRUE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 2) AND LightTimer.ElapsedTime <= (TotTime / 1.5) THEN
            Out := FALSE;
        ELSIF LightTimer.ElapsedTime > (TotTime / 1.5) AND LightTimer.ElapsedTime <= (TotTime / 1.25) THEN
            Out := TRUE;
        ELSE
            Out := FALSE;
        END_IF;
        IF LightTimer.Q THEN
            LightTimer(Ena := FALSE);
            TimerDone := TRUE;
        END_IF;
    ELSE
        Out := FALSE;
        TimerDone := FALSE;
        LightTimer(Ena := FALSE);
        
    END_IF;    
END_FUNCTION_BLOCK

/// ************  EOL Run Test Functions ************///


/// EOL Pull Down Test Function ///

FUNCTION_BLOCK DFR_Feature_PullDownTest
    VAR_INPUT 
        Enable             : BOOL; // To Enable the Regulation 
        CycleTime          : REAL; // To change the Cycle Time of the Pull Down Test Function
        Preset_RegTime     : REAL; // Regulation Timer
        Preset_RegFailTime : REAL; // Regulation Fail Timer
        Preset_WaitTime    : REAL; // Regulation Wait Timer
        In1                : REAL; // Discharge Air Temp
        In2                : REAL; // Defrost Temp 
        Reg_SP             : REAL; // Regulation Setpoint
        FanSP              : REAL; // Fan Setpoint
        FanHystSP          : REAL; // Fan Hysterisis SP            
  
    END_VAR
    VAR
        Reg_Fail_Timer     : DFRTimer; // Enable the Fail Timer if Discharge Air Temp fails to meet the SP
        RegulationTimer    : DFRTimer; // Enable Regulation Timer to monitor Discharge Air temp
        
    END_VAR
    VAR_OUTPUT
        DFR_Regulation_Sts : STRING; // DFR Regulation Test Status
        Out1               : BOOL; // CDU Enable - V_OM_Solenoid_Flag 
        Out2               : BOOL; // Fan Enable - V_OM_Fans_Flag
    END_VAR
    
    IF Enable AND (V_CSM_EOL_Test_Result = 0 OR V_CSM_EOL_Test_Result = 3) THEN
        Out1 := TRUE;
        IF In1 <= Reg_SP THEN
            RegulationTimer(Ena := TRUE, PLCCycletime := CycleTime, ProgramTime := Preset_RegTime);
            Reg_Fail_Timer(Ena := FALSE);
            IF RegulationTimer.Q THEN
                DFR_Regulation_Sts := 'PAS';
                RegulationTimer(Ena := FALSE);
            END_IF;
        ELSE 
            Reg_Fail_Timer(Ena := TRUE, PLCCycletime := CycleTime, ProgramTime := Preset_RegFailTime);
            RegulationTimer(Ena := FALSE);
            IF Reg_Fail_Timer.Q THEN
                DFR_Regulation_Sts := 'FAL';
                Reg_Fail_Timer(Ena := FALSE);
            END_IF;
        END_IF;            
    
        IF  (DFR_CINCaseSystemComponent(6) = 0) OR (DFR_CINCaseSystemComponent(9) = 2) THEN // No Door Case and MT Case 
            Out2 := TRUE;
        ELSIF (NOT (DFR_CINCaseSystemComponent(6) = 0) AND (DFR_CINCaseSystemComponent(9) = 1)) THEN // LT Door Case Only
            IF In2 <= FanSP THEN // Fans will be turned On if Defrost Temp is less than Fan Setpoint
                Out2 := TRUE;
            ELSIF In2 > FanSP + FanHystSP THEN
                Out2 := FALSE;
            END_IF;
        ELSE
            Out2 := FALSE;
        END_IF;
    ELSIF (DFR_Regulation_Sts = 'FAL') OR(DFR_Regulation_Sts = 'PAS') THEN
        RegulationTimer(Ena := FALSE);
        Reg_Fail_Timer(Ena := FALSE);
    END_IF;
END_FUNCTION_BLOCK 

/// Defrost Cycle Test Function  ///

FUNCTION_BLOCK DFR_Feature_DefrostCycleTest
    VAR_INPUT 
        Enable : BOOL;       // To Enable the Defrost Cycle Test 
        CycleTime : REAL;
        Preset_DefFailTime : REAL;
        In1 : REAL; // Defrost Termination Temperature OR Discharge Air Temp (If Defrost Probe is absent)
        SetPoint : REAL;  // Defrost Termination Temperature SP
  
    END_VAR
    VAR
        Def_Fail_Timer : DFRTimer; // Enable the Fail Timer if change in Defrost Term Temp fails to meet the SP
        TempDelta : REAL;
        PrevIn : REAL;
        SaveFlag : bool := FALSE;
    END_VAR
    
    VAR_OUTPUT
        DFR_DefrostCycle_Sts : STRING; // DFR Defrost Cycle Test Status
        Out1 : BOOL; // CDU Disable - V_OM_Solenoid_Flag
        Out2 : BOOL; // Defrost Enable - V_OM_Defrost_Flag
        Out3 : BOOL; // Fan Disable - V_OM_Fans_Flag
        Out4 : BOOL; // Drain Heater - V_OM_DrainHeat_Flag
    END_VAR
    
    Def_Fail_Timer(Ena := Enable, PLCCycletime := CycleTime, ProgramTime := Preset_DefFailTime);
    IF Enable AND (V_CSM_EOL_Test_Result = 0 OR V_CSM_EOL_Test_Result = 3) THEN
        IF(NOT SaveFlag) THEN
            SaveFlag := TRUE;
            //PrevIn := In1; 
        //ELSE
            //TempDelta := (In1 - PrevIn); // Discharge Air Temp difference
        END_IF;
            
        Out2 := TRUE; // Defrost Should be Enabled
        Out1 := FALSE; // CDU should be Disabled
        IF Out2 AND NOT Out1 THEN
            IF In1 > Setpoint THEN
                Def_Fail_Timer(Ena := FALSE);
                DFR_DefrostCycle_Sts := 'PAS';                 
            ELSE
                ;
            END_IF;
        END_IF;
            
        IF Def_Fail_Timer.Q THEN
            DFR_DefrostCycle_Sts := 'FAL';
            Def_Fail_Timer(Ena := FALSE);
        END_IF;
            
        IF  (DFR_CINCaseSystemComponent(6) = 0) OR (DFR_CINCaseSystemComponent(9) = 2) THEN // No Door Case and MT Case 
            Out3 := TRUE; // Fans are ON
            Out4 := FALSE; // Drain Heater are Disabled
        ELSIF (NOT (DFR_CINCaseSystemComponent(6) = 0) AND (DFR_CINCaseSystemComponent(9) = 1)) THEN // LT Door Case Only
            Out3 := FALSE; // Fans are OFF
            Out4 := TRUE; // Drain Heater are Enabled
        ELSE
            Out3 := FALSE; // Fans are OFF
            Out4 := FALSE; // Drain Heater are Disabled
        END_IF;
    ELSE
        PrevIn := In1;
        TempDelta := 0;
        SaveFlag := FALSE;
        DFR_DefrostCycle_Sts := 'NA';
        Def_Fail_Timer(Ena := FALSE);
    END_IF;

END_FUNCTION_BLOCK 
/*
FUNCTION_BLOCK DFR_MOV_AVERAGE
    VAR_INPUT
        in_sample : real;
        in_count  : uint := 1; //It should be less than total no. of array samples
    END_VAR
    
    VAR
        array_real : ARRAY[1..64] OF real;
        sum        : real;
        index      : uint := 1;
    END_VAR
    
    VAR_OUTPUT
        out_mean : real;
    END_VAR
    
    sum := sum - array_real[index] + in_sample;
    array_real[index] := in_sample;
    index := index + 1;
    
    IF(index >= in_count) THEN
        index := 1;
    END_IF;
    
    out_mean := sum / UINT_TO_REAL(in_count);
END_FUNCTION_BLOCK
*/
FUNCTION_BLOCK DFR_FB_CompressorProtection
    VAR_INPUT
        in_CompressorStatus         : BOOL;
        in_T1Mins                   : USINT     := 60;
        in_T2Mins                   : USINT     := 5;
        in_Count1                   : USINT     := 2;      
        in_Count2                   : USINT     := 4;
        in_Reset                    : BOOL      := FALSE;
        in_CompShutdownOn           : BOOL      := FALSE;
    END_VAR
    VAR_OUTPUT
        out_ShutdownCommand         : BOOL      := FALSE;
        out_WarningLow              : BOOL      := FALSE;
        out_WarningMedium           : BOOL      := FALSE;
        out_WarningSevere           : BOOL      := FALSE;
    END_VAR
    VAR
        fb_Timer1                   : TON;
        fb_Timer2                   : TON;
        fb_FTrig1                   : F_TRIG; 
        fb_RTrig1                   : R_TRIG;
        b_init                      : BOOL           := FALSE;    
        b_EnableTimer1              : BOOL           := FALSE;
        b_EnableTimer2              : BOOL           := FALSE;
        n_Counter                   : USINT          := 0;
    END_VAR
    {REGION INIT}
    IF (NOT b_init) THEN
        fb_Timer1.PT                := to_time(in_T1Mins) * (60 * 1000);    // minutes to milli-seconds
        fb_Timer2.PT                := to_time(in_T2Mins) * (60 * 1000);
        out_ShutdownCommand         := FALSE;
        out_WarningLow              := FALSE;
        out_WarningMedium           := FALSE;
        out_WarningSevere           := FALSE;
        b_init                      := TRUE;
    ELSE
    END_IF;
    {ENDREGION}
    {REGION RESET LOGIC}
    fb_RTrig1(CLK := in_Reset);
    IF fb_RTrig1.Q THEN
        n_Counter := 0;
        fb_Timer1(IN    := FALSE);
        fb_Timer2(IN    := FALSE);
        fb_FTrig1(CLK   := FALSE);
        out_ShutdownCommand         := FALSE;
        out_WarningLow              := FALSE;
        out_WarningMedium           := FALSE;
        out_WarningSevere           := FALSE;
    ELSE
    END_IF;
    {ENDREGION}
    {REGION FALL COUNT}   
    fb_FTrig1(CLK := in_CompressorStatus);
    IF fb_FTrig1.Q THEN
        n_Counter           := n_Counter + 1;
        IF(n_Counter = 1) THEN
            b_EnableTimer1      := TRUE;
        ELSE
        END_IF;
    END_IF;
    
    fb_Timer1(IN := b_EnableTimer1);
    
    IF fb_Timer1.Q THEN
        n_Counter           := 0;
        b_EnableTimer1      := FALSE;
    ELSE
    END_IF;
    
    IF (n_Counter < in_Count1) THEN
        out_WarningLow          := FALSE;
    ELSIF (n_Counter >= in_Count1) AND (n_Counter < in_Count2) THEN 
        out_WarningLow          := TRUE;
    ELSIF(n_Counter >= in_Count2) THEN 
        out_WarningSevere       := TRUE;
        out_ShutdownCommand     := in_CompShutdownOn;
    ELSE
    END_IF;
    {ENDREGION}
    {REGION DURATION}
    b_EnableTimer2 := NOT (in_CompressorStatus);
    fb_Timer2(IN := b_EnableTimer2);
    IF (fb_Timer2.Q) THEN
        out_WarningMedium   := TRUE;
    ELSE
        out_WarningMedium   := FALSE;
    END_IF;
    {ENDREGION}
END_FUNCTION_BLOCK

FUNCTION DFR_F_Bitpacking : INT
    VAR_INPUT
        in : ARRAY[0..15] OF BOOL;
    END_VAR

    VAR
        i : INT;
        b : REAL := 2;
    END_VAR
    DFR_F_Bitpacking := 0;
    FOR i := 0 TO 15 DO
        DFR_F_Bitpacking := DFR_F_Bitpacking + TO_INT(expt(b, i)) * TO_INT(in[i]);
    END_FOR;

END_FUNCTION

TYPE
    U_BITPACK : UNION
        arr : ARRAY[0..15] OF bool;
        i : UINT;
    END_UNION;
END_TYPE

TYPE
    T_SP_SYSTEM : STRUCT
        info           : U_BITPACK;
        alarm          : U_BITPACK;
        alarmflag      : BOOL;
        infoflag       : BOOL;
    END_STRUCT;
END_TYPE



TYPE
    T_SP_HPX : STRUCT
        system   : T_SP_SYSTEM;
        comp     : T_SP_SYSTEM;
        cond     : T_SP_SYSTEM;
        evap     : T_SP_SYSTEM;
        metering : T_SP_SYSTEM;
        comm     : T_SP_SYSTEM;
        device   : T_SP_SYSTEM;
    END_STRUCT;
END_TYPE

FUNCTION_BLOCK DFR_FB_Blinker
    VAR_INPUT
        InSignal : bool := FALSE;
        DelaySecs : int := 60;
        Count : int := 2;
    END_VAR
        
    VAR_OUTPUT
        Out : bool := FALSE;
    END_VAR
    
    VAR
        OnDelay : ton;
        OnPulse : tp;
        OutCount : r_trig;
        InRise : r_trig;
        OutEnable : bool := FALSE;
        Counter : int := 0;
    END_VAR
    
    OnDelay.PT := to_time(DelaySecs) * 1000;    // seconds to milliseconds
    OnPulse.PT := to_time(DelaySecs) * 1000;
    
    InRise(CLK := InSignal);
    IF(InRise.Q) THEN
        Counter := 0;
        OutEnable := TRUE;
    ELSE
    END_IF;
    
    OutCount(CLK := Out);
    IF(OutCount.Q) THEN
        Counter := Counter + 1;
    ELSE
    END_IF;
    
    IF(Counter >= Count) THEN
        OutEnable := FALSE;
    ELSE
    END_IF;
    
    OnDelay(IN := (InSignal AND NOT OnPulse.Q AND OutEnable));
    OnPulse(IN := OnDelay.Q);
    
    Out := NOT(OnPulse.Q);
END_FUNCTION_BLOCK

FUNCTION WizDone_Action : REAL;
END_FUNCTION

FUNCTION_BLOCK DFR_EnterProg
    VAR_INPUT
        In : BOOL;
    END_VAR
    IF In THEN
        En_GlobalSwitch_Override  := TRUE;
        En_DrainHeaterOverwrite   := TRUE;
        En_RailHeaterOverwrite    := TRUE;
        En_LightOverwrite         := TRUE;
        En_FansOverwrite          := TRUE;
        En_FansModulOverwrite     := TRUE;
        En_ValveModulOverwrite    := TRUE;
        En_HeatersModulOverwrite  := TRUE;
    END_IF;
    
END_FUNCTION_BLOCK
        
FUNCTION_BLOCK DFR_DrainHeater_Enable
    VAR_INPUT
        In : BOOL;
    END_VAR
    IF In THEN
        En_GlobalSwitch_Override := TRUE;
        En_DrainHeaterOverwrite := TRUE;
    ELSE
        En_DrainHeaterOverwrite := FALSE;
    END_IF;
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_RailHeater_Enable
    VAR_INPUT
        In : BOOL;
    END_VAR
    IF In THEN
        En_GlobalSwitch_Override := TRUE;
        En_RailHeaterOverwrite   := TRUE;
        En_HeatersModulOverwrite := TRUE;
    ELSE
        En_RailHeaterOverwrite   := FALSE;
        En_HeatersModulOverwrite := FALSE;
    END_IF;
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_Lights_Enable
    VAR_INPUT
        In : BOOL;
    END_VAR
    IF In THEN
        En_GlobalSwitch_Override := TRUE;
        En_LightOverwrite        := TRUE;
    ELSE
        En_LightOverwrite        := FALSE;
    END_IF;
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_Fans_Enable
    VAR_INPUT
        In : BOOL;
    END_VAR
    IF In THEN
        En_GlobalSwitch_Override := TRUE;
        En_FansOverwrite         := TRUE;
        En_FansModulOverwrite    := TRUE;
    ELSE
        En_FansOverwrite      := FALSE;
        En_FansModulOverwrite := FALSE;
    END_IF;
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_EEV_Enable
    VAR_INPUT
        In : BOOL;
    END_VAR
    IF In THEN
        En_GlobalSwitch_Override := TRUE;
        En_ValveModulOverwrite   := TRUE;
    ELSE
        En_ValveModulOverwrite   := FALSE;
    END_IF;
    
END_FUNCTION_BLOCK
    


    


        

