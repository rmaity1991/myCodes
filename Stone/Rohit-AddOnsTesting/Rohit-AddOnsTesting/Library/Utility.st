USING System.Math;
USING System;
USING System.Timer;
USING system.Text;


FUNCTION_BLOCK DFR_MOV_AVER
(***
    Always define array size for proper calculations 
**)    
    VAR_INPUT
        in_sample : REAL; // real time samples
        sampling : BOOL:=FALSE; // sample choice True=From Real Time False= From manual array
        manual_sample_array : ARRAY[0..10] OF REAL; // manual data array
    END_VAR
    
    VAR_OUTPUT
        mean : REAL; // output mean
    END_VAR
    
    VAR INTERNAL
        master_array : ARRAY[0..11,0..11] OF REAL; // array for iteration
        sampling_iter : DINT; // sampling iterator
        cycle_iter : DINT; // column iterator
        calc_iter : DINT; // row iterator
        array_keys : DINT; // variable for holding array size in calculations
        sum : REAL; // sum of averages
        i : DINT:=0;
        array_size : DINT(1..10):=5; // size of iteration array
    END_VAR
{REGION Sampling of Data}   
IF(sampling=TRUE) THEN
   FOR sampling_iter:=0 TO array_size-1 BY 1 DO
      master_array[0,sampling_iter] := in_sample;
   END_FOR;
ELSE
   FOR sampling_iter:=0 TO array_size-1 BY 1 DO
      master_array[0,sampling_iter] := manual_sample_array[sampling_iter];
   END_FOR;    
END_IF;
    
FOR sampling_iter:=array_size TO 11 BY 1 DO
       master_array[0, sampling_iter]:=0;
END_FOR;

{ENDREGION}
    
{REGION Iteration of Data}
   
array_keys := array_size;
i := 0;   
    
    FOR cycle_iter:=0 TO (array_size-1) BY 1 DO
        FOR calc_iter:=0 TO (array_keys-2) BY 1 DO 
           sum := (master_array[cycle_iter, calc_iter] + master_array[cycle_iter, calc_iter + 1]) / 2;
           master_array[cycle_iter + 1, calc_iter] := sum ;
        END_FOR;
        array_keys := array_keys - 1;   
    END_FOR;  
    
{ENDREGION}
    
    mean := master_array[cycle_iter-1, 0];
    
END_FUNCTION_BLOCK

FUNCTION_BLOCK DFR_MOV_AVER_V1
(***
    Always define array size for proper calculations 
**)    
    VAR_INPUT
        in_sample : REAL; // real time samples
        sampling : BOOL:=FALSE; // sample choice True=From Real Time False= From manual array
        manual_sample_array : ARRAY[0..10] OF REAL; // manual data array
        calculate_mean : BOOL;
        sampling_time : TIME:=T#60s;
    END_VAR
    
    VAR_OUTPUT
        mean : REAL; // output mean
        previous_means : ARRAY[0..10] OF REAL;
    END_VAR
    
    VAR PRIVATE
        master_array : ARRAY[0..11,0..11] OF REAL; // array for iteration
        sampling_iter : DINT; // sampling iterator
        cycle_iter : DINT; // column iterator
        calc_iter : DINT; // row iterator
        array_keys : DINT; // variable for holding array size in calculations
        sum : REAL; // sum of averages
        i : DINT:=0;
        array_size : DINT(1..10):=5; // size of iteration array
        Sampling_Timer : TON;
    END_VAR
    Sampling_Timer(PT := sampling_time);

{REGION Sampling of Data}   
IF(sampling=TRUE) THEN
    Sampling_Timer.IN := TRUE;
    IF(sampling_iter>(array_size-1)) THEN
        sampling_iter := 0;
    END_IF; 
    WHILE(Sampling_Timer.Q) DO
        master_array[0, sampling_iter] := in_sample;
        sampling_iter := sampling_iter + 1;
        Sampling_Timer.IN := FALSE;
        EXIT;
    END_WHILE;
          
ELSE
   FOR sampling_iter:=0 TO array_size-1 BY 1 DO
      master_array[0,sampling_iter] := manual_sample_array[sampling_iter];
   END_FOR;    
END_IF;
 
/*    
FOR sampling_iter:=array_size TO 11 BY 1 DO
       master_array[0, sampling_iter]:=0;
END_FOR;
*/


{ENDREGION}
    
{REGION Iteration of Data}
    
IF(calculate_mean) THEN
   
    array_keys := array_size;   
    
    FOR cycle_iter:=0 TO (array_size-1) BY 1 DO
        FOR calc_iter:=0 TO (array_keys-2) BY 1 DO 
           sum := (master_array[cycle_iter, calc_iter] + master_array[cycle_iter, calc_iter + 1]) / 2;
           master_array[cycle_iter + 1, calc_iter] := sum ;
        END_FOR;
        array_keys := array_keys - 1;   
    END_FOR;
    
    mean := master_array[cycle_iter-1, 0];
    
    IF(i<10) THEN
        previous_means[i] := mean;
        i := i + 1;
    ELSIF (i>=10) THEN 
        i := 0;
    END_IF;
    
    calculate_mean := FALSE;
END_IF;
    
{ENDREGION}
   
END_FUNCTION_BLOCK

FUNCTION_BLOCK Randomizer
    
    VAR_INPUT   
    Start : DINT;
    Stop : DINT;      
    END_VAR
    
    VAR_OUTPUT
        Out : REAL;
    END_VAR
    
    VAR
        index : DINT;
        range : DINT;
        sum : REAL := 0;
        Timer : TON;
    END_VAR
    
    range := Stop - Start;
    Timer.PT := T#10ms;
    
    Timer();
    
    WHILE(index<range+1) DO       
        
        Timer(IN := TRUE);
        
        IF(Timer.Q) THEN
            IF (sum<TO_REAL(start)) THEN
                sum := TO_REAL(start)+0.1;
            ELSE
                sum := sum + 0.1;
            END_IF;
                
                out := sum;
            Timer.IN := FALSE;           
        END_IF;
        
        IF(sum>=TO_REAL(Stop)) THEN
        sum := To_REAL(Start);
        END_IF;
        index := index + 1;
                      
    END_WHILE;
    
    IF(index>=Range) THEN
        index := 0;
    END_IF;
       
      
END_FUNCTION_BLOCK