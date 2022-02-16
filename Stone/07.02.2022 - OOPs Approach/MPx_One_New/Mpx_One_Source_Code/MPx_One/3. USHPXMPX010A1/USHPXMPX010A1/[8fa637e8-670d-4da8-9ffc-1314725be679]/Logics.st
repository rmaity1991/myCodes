{INCLUDE 'LibVer.g.st'}

NAMESPACE LibraryNamespaceAndVersion

    USING System.Timer;

    (**   Detect the variation of a BOOL variable.   *)
    FUNCTION_BLOCK RF_TRIG
        VAR_INPUT
            (** Input variable of which to test edge. *)
            CLK : BOOL;    
        END_VAR 
        
        VAR_OUTPUT
            (** TRUE if recognized a rising edge. *)
            Q : BOOL;
        END_VAR
        
        VAR
            (**TRIGGER: Value that the INPUT variable had on the previous program cycle *)
            CLK_Old : BOOL;
        END_VAR
        
    	Q       := CLK XOR CLK_Old;    
        CLK_Old := CLK;    
    END_FUNCTION_BLOCK   
    
    //********************************************************************************
    
    (**   Detect the variation of a REAL variable.   *)
    FUNCTION_BLOCK F_TRIG_REAL 
        
        VAR_INPUT
            (**Input trigger*)
            In    : REAL;
            (**Threshold to be crossed *)
            Thrld : REAL;
        END_VAR
        
        VAR        
            RTrg : R_TRIG;
        END_VAR
        
        VAR_OUTPUT
            (** TRUE if In < Thrld *)
            Q : BOOL;
        END_VAR
        
        RTrg(CLK := In < Thrld, Q => Q);
        
    END_FUNCTION_BLOCK

    (**   Detect the variation of a REAL variable.   *)
    FUNCTION_BLOCK R_TRIG_REAL 
        
        VAR_INPUT
            (**Input trigger*)
            In    : REAL;
            (**Threshold to be crossed *)
            Thrld : REAL;
        END_VAR
        
        VAR        
            RTrg : R_TRIG;
        END_VAR
        
        VAR_OUTPUT
            (** TRUE if In > Thrld *)
            Q : BOOL;
        END_VAR
        
        RTrg(CLK := In > Thrld, Q => Q);
        
    END_FUNCTION_BLOCK

    (**   Detect the variation of a REAL variable.   *)
    FUNCTION_BLOCK RF_TRIG_REAL
        VAR_INPUT
            (**Input trigger*)
            In : REAL;    
        END_VAR
        
        VAR_OUTPUT
            (**Output value*)
            Q : BOOL;
        END_VAR
        
        VAR
            (**TRIGGER: Value that the INPUT variable had on the previous program cycle *)
            InOld : REAL;
        END_VAR
    	 
    	Q :=  In <> InOld;

        InOld := In;        
    END_FUNCTION_BLOCK


END_NAMESPACE
