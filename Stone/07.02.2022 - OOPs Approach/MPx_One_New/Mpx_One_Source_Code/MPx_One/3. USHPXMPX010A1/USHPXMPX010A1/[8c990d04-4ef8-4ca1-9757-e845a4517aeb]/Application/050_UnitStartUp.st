NAMESPACE LibraryNamespaceAndVersion
    
PROGRAM UnitStartUpMng
    
    //wait restore default   
    IF SW_Update THEN
        RETURN;
    END_IF;    
    
    // At startup keep the regulation off
    StartupTimeTON(IN := firstCycle AND NOT StartupReset, PT := StartupTime);
    IF StartupTimeTON.Q THEN
        firstCycle := FALSE;
    END_IF;
    
    // Stop regolation
    IF StartupReset THEN
        firstCycle := TRUE;
    END_IF;
    
    // Display changed ?
    IF NewDispPrompt THEN
        firstCycle := TRUE;
    END_IF;
    
END_PROGRAM
    
END_NAMESPACE
