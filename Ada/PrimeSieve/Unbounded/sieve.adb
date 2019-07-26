package body Sieve is

    -- compute the first N prime numbers
    N : Natural := 10 - 1; 

    task body Generator is
        First_Checker : Checker_Ref_T := new Checker_T(2);
        Number_To_Check : Natural := 3;
        startTime, endTime : Time;
        milliS : Duration;
    begin       
        
        startTime := Clock;
        while PrimeCounter.getPrimeNumberComputed < N loop
    
            First_Checker.CheckNumber(Number_To_Check);
            Number_To_Check := Number_To_Check + 1;
        end loop;
        --endTime := Clock; milliS := (endTime - startTime) * 1000; Put_Line("Runtime = " & Duration'Image(milliS) & " milliseconds.");
        First_Checker.Kill;

    end Generator;


    task body Checker_T is
        Next_Checker : Checker_Ref_T := NULL;
        Reminder : Natural;
        Number_To_Check : Natural;
        Killed : Boolean := False;
    begin
        while True loop

            select
                accept CheckNumber(X : Natural) do
                    Number_To_Check := X;
                end CheckNumber;
            OR   
                accept Kill do
                    Killed := True;
                end Kill;
            end select;
            
            if Killed then
                if (Next_Checker /= NULL) then
                    Next_Checker.Kill;
                end if;
                EXIT;
            end if;

            Reminder := Number_To_Check mod Id_Number;
            if Reminder /= 0 and Next_Checker = NULL and PrimeCounter.getPrimeNumberComputed < N then
                Put_Line(Natural'Image(Number_To_Check));
                PrimeCounter.incrementCounter;
                Next_Checker := new Next_Checker_T(Number_To_Check);
            elsif Reminder /= 0 and PrimeCounter.getPrimeNumberComputed < N then
                Next_Checker.CheckNumber(Number_To_Check);
            end if;

        end loop;
    end Checker_T;



    protected body PrimeCounter is
        procedure incrementCounter is
        begin
            Prime_Numbers_Computed := Prime_Numbers_Computed + 1;
        end incrementCounter;

        function getPrimeNumberComputed return Natural is
        begin
            return Prime_Numbers_Computed;
        end getPrimeNumberComputed;

    end PrimeCounter;

end Sieve;