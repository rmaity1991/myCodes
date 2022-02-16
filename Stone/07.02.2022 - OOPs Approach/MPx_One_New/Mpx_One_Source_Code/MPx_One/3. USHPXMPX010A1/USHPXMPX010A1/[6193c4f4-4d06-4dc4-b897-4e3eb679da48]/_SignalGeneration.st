{INCLUDE 'LibVer.g.st'}

NAMESPACE LibraryNamespaceAndVersion

USING System;
USING libs.GetTime;
USING System.Math;
    
    TYPE
ENUM_SIGN_GEN_MODE: 
    (
            (**Generator off*)    
        OFF,     
            (**Sine curve*)
        SINUS, 
            (**sawtooth increasing*)
        SAWTOOTH_RISE,
            (**triangular*)
        TRIANGULAR,
            (**Constant signal*)
        CONST       
//            (**rectangular switchin*)
//        RECTANGLE,
//            (**cosinus*)
//        COSINUS      
    );
END_TYPE

(**     Generate a cyclical programmed time sequence of impulses with cycle time precision.     *)
FUNCTION_BLOCK BlinkOnOff
        VAR_INPUT
            (**Activation*)
            In    : BOOL;
            (**Amount of time to keep the output true*)
            {ATTRIBUTE UOM SECOND}
            T_On  : UINT(0..65000);
            (**Amount of time to keep the output false*)
            {ATTRIBUTE UOM SECOND}
            T_Off : UINT(0..65000);
        END_VAR
        VAR_OUTPUT
            (**Output*)
            Out : BOOL;
        END_VAR    
        VAR
            (**Save current time in millisecond*)
            {ATTRIBUTE UOM MILLISECOND}
            MemT   : UDINT;
            IN_Old : BOOL;
            State  : BOOL;
        END_VAR
        VAR_TEMP
            (**Current system time*)
            {ATTRIBUTE UOM MILLISECOND}
            CurrSysTime : UDINT;
        END_VAR
        
        IF In THEN
            CurrSysTime := GetSystemTimeAdv();
            
            IF In <> IN_Old THEN
                In_Old  := TRUE;
                MemT    := CurrSysTime;
                State   := TRUE;
            END_IF;
            
            IF State THEN
                Out := TRUE;
                
                //subtraction cover limit of UDINT when time arrive at max value
                IF (CurrSysTime - MemT) > TO_UDINT(T_On)*1000 THEN
                    State := FALSE;
                    MemT  := CurrSysTime;
                END_IF;
            ELSE
                Out := FALSE;
                
                //subtraction cover limit of UDINT when time arrive at max value
                IF (CurrSysTime - MemT) > TO_UDINT(T_Off)*1000 THEN
                    State := TRUE;
                    MemT  := CurrSysTime;
                END_IF;                
            END_IF;
        ELSE
            Out    := FALSE;
            In_Old := FALSE;
        END_IF;
    END_FUNCTION_BLOCK


(**     Delay the change in a value by a programmed time with cycle time precision.     *)
FUNCTION_BLOCK DelayOnOff
    	VAR_INPUT
            (**Input value*)
    		In   : BOOL;
            (**Delay time*)
            {ATTRIBUTE UOM SECOND}
            Time : UINT(0..65000);
    	END_VAR
    	VAR_OUTPUT
            (**Output value*)
    		Out : BOOL;
    	END_VAR    
        VAR            
            In_Old : BOOL;
            (**Save current time*)
            {ATTRIBUTE UOM MILLISECOND}
            MemT   : UDINT;
            (**Check elapsed time*)
            CheckT : BOOL;
        END_VAR      
        VAR_TEMP
            (**Current system time*)
            {ATTRIBUTE UOM MILLISECOND}
            CurrSysTime : UDINT;
        END_VAR
        
        CurrSysTime := GetSystemTimeAdv();
        
        IF (IN AND NOT In_Old) OR (In_Old AND NOT In) THEN
            MemT := CurrSysTime;
        END_IF;
        
        In_Old := In;    
        CheckT := (CurrSysTime - MemT)/1000 >= TO_UDINT(Time);
        
        IF IN  AND CheckT THEN
            Out := TRUE;
        
        ELSIF Out AND CheckT THEN
            Out := FALSE;
        END_IF;
    END_FUNCTION_BLOCK


(**  Function block for generating sine wave   *)
FUNCTION_BLOCK SineWave
    VAR_INPUT
        Max             : REAL;
        Min             : REAL;
        (**Angular phase (deg)*)
        Phi             : REAL;
        (**Wave period*)
        {ATTRIBUTE UOM MINUTE}
        P               : REAL;
        (**Current time*)
        {ATTRIBUTE UOM SECOND}
        CurrTime        : REAL;
        (**Block enabling*)
        En_SineWave     : BOOL;
    END_VAR
    VAR_OUTPUT
        (**Output signal*)
        Y : real;
    END_VAR
    
    VAR
        (**Angular frequency (rad/s)*)
        w   : REAL;
        (**Initial time*)
        {ATTRIBUTE UOM SECOND}
        t0 : REAL;
        (**Actual time*)
        {ATTRIBUTE UOM SECOND}
        t : real;
    END_VAR    
    
    IF P=0.0 THEN
        RETURN;
    ELSIF NOT En_SineWave OR (En_SineWave AND t0 = 0.0) THEN
       t0   := CurrTime;
    END_IF;    
    
    IF En_SineWave THEN
        (*
            A := (Max - Min)/2.0; 
        	B := (Max + Min)/2.0;
        	y := A * SIN(w*(t-to) + Phi) + B;
        *)
        t   := CurrTime;
        w   := 2.0 * PI / (P * 60.0);        
        Phi := PI / 180.0 * Phi;                            //Conversion of Phi: deg to rad
    END_IF;
     Y := (0.5 * ((Max - Min) * SIN(w * (t - t0) + Phi) + Max + Min)) * TO_REAL(En_SineWave);
END_FUNCTION_BLOCK    

(**  Function block for generating cosine wave   *)
FUNCTION_BLOCK CosineWave
    VAR_INPUT
        Max             : REAL;
        Min             : REAL;
        (**Angular phase (deg)*)
        Phi             : REAL;
        (**Wave period*)
        {ATTRIBUTE UOM MINUTE}
        P               : REAL;
        (**Current time*)
        {ATTRIBUTE UOM SECOND}
        CurrTime        : REAL;
        (**Block enabling*)
        En_CosineWave   : BOOL;
    END_VAR
    
    VAR_OUTPUT
        (**Output signal*)
        Y : REAL;
    END_VAR
    
    VAR        
        (**Angular frequency (rad/s)*)
        w  : REAL;
        (**Initial time*)
        {ATTRIBUTE UOM SECOND}
        t0 : REAL;
        (**Actual time*)
        {ATTRIBUTE UOM SECOND}
        t  : REAL;
    END_VAR    
    
    IF P=0.0 THEN
        RETURN;
    ELSIF NOT En_CosineWave OR (En_CosineWave AND t0 = 0.0) THEN
       t0   := CurrTime;
    END_IF;    
    
    IF En_CosineWave THEN
        (*
            A := (Max - Min)/2.0; 
        	B := (Max + Min)/2.0;
        	y := A * SIN(w*(t-to) + Phi) + B;
        *)
        t   := CurrTime;
        w   := 2.0 * PI / (P * 60.0);        
        Phi := PI / 180.0 * Phi;                            //Conversion of Phi: deg to rad
    END_IF;
    
     Y := (0.5 * ((Max - Min) * COS(w * (t - t0) + Phi) + Max + Min)) * TO_REAL(En_CosineWave);
END_FUNCTION_BLOCK




(** Generate a signal waweform 
    0 - OFF
	1 - Sine curve
	2 - Sawtooth_rise
	3 - Triangular 
	4 - Costant
*)
FUNCTION_BLOCK SignalGenerator
    VAR_INPUT
        (** Output Max value*)
        Ymax   : REAL;
        (** Output Min value*)
        Ymin   : REAL;
        (** Period [minute] i.e 1.5 = 1m 30s*)
        Period : REAL;
        (** Angoular Phase [°] i.e 160.5 = 160° 5' *)
        Phase  : REAL; 
        (** output signal type
        		0 - OFF
				1 - Sine curve
				2 - Sawtooth_rise
				3 - Triangular 
				4 - Costant *)
        Mode   : ENUM_SIGN_GEN_MODE;
        (** FALSE = Stop, TRUE = Start*)
        Run    : BOOL;
    END_VAR    
        
    VAR_OUTPUT 
        (** Output signal value *)
        Y     : REAL;
        (** Last cycle Time value [ms]*)
        cycleT : UDINT;
    END_VAR
    
    VAR
        (** Current system time (ms) *)
        {ATTRIBUTE UOM MILLISECOND}
        CurrSysT    : UDINT;
        (** curren time [ms]*)
        t           : UDINT;
        (** Start time (ms)*)
        t_o         : UDINT; 
        (** Previous cicle program time (ms)*)
        t_p         : UDINT; 
        (** Pulse (rad/sec)*)
        w           : REAL; 
        (**: Signal phase (rad)*)
        phi         : REAL;
        (** Amplitude peak to peak *)
        A           : REAL;
        (** Offset *)
        B           : REAL; 
    END_VAR

    CurrSysT := GetSystemTimeAdv();
    //inizialize time
    IF Run AND t_o = 0 THEN 
        t_o := CurrSysT;
    END_IF;
    
    IF Run THEN 
        (*==== Time ====*)
        t_p     := t;         // Start of last cycle time
        t       := CurrSysT;  // Actual time
        cycleT  := t - t_p;   // Duration of last cycle
        
        (*==== Period in second ====*)
        Period := Period * 60.0;
        
        (*==== Angoular Frequency [rad/s] ===*)
        // Note: with Period = 0 force w=0 to avoid division by 0 
        IF Period <> 0.0 THEN
            w := 2.0 * PI / Period;
        ELSE 
            w := 0.0;
        END_IF;
        
        (*==== Phase  [rad] ====*)
        phi := Phase * PI / 180.0;
        
        CASE Mode OF 
            ENUM_SIGN_GEN_MODE#OFF:  
                Y := 0.0; 
            
            ENUM_SIGN_GEN_MODE#SINUS:  
                A := (YMAX - YMIN)/2.0; 
                B := (YMAX + YMIN)/2.0;
                Y := A * SIN(w * TO_REAL(t - t_o)/1000 + phi) + B;
            
            ENUM_SIGN_GEN_MODE#SAWTOOTH_RISE:  
                A := (YMIN - YMAX)/2.0; (* always < 0 *)
		        B := (YMIN + YMAX)/2.0;
		        Y := 2.0 * A / PI * ATAN(1.0 / TAN(PI * TO_REAL(t - t_o)/1000 / Period + phi)) + B;
            
            ENUM_SIGN_GEN_MODE#TRIANGULAR:  
		        A := YMAX - YMIN;
		        B := (YMAX + YMIN)/2.0; 
		        Y := A / PI * ASIN(SIN(w * TO_REAL(t - t_o)/1000 + phi)) + B;
            
            ENUM_SIGN_GEN_MODE#CONST: 
                Y := YMAX;
            
        END_CASE;

        t_p := CurrSysT;
        t   := CurrSysT;
        
    ELSE
        (*Generator off*)
        Y     := 0.0;
        t_o   := CurrSysT;       // Initial time
        t_p   := t;              // Previou cycle time
        t     := CurrSysT;       // Actual iime
        cycleT:= t - t_p;        // Duration of last cycle

    END_IF;

END_FUNCTION_BLOCK

END_NAMESPACE
