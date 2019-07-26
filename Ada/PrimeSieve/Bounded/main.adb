with Sieve;                     use Sieve;
with Ring ;                     use Ring;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Task_Identification;   use Ada.Task_Identification;
with Ada.Calendar;              use Ada.Calendar;

procedure Main is
    Checkers : Checker_Array;
    -- Number of prime buffered
    Size : Natural := 0;
    --Primes Buffered
    Primes : Big_Container;
    -- Number of number discarded
    Discarded : Natural := 0;
    -- Checker process to which update its local primes container
    Turn : Positive := 2;
    -- Array containing pointer to list local primes of each task
    Ref_To_Local_Lists : Local_List_Array;
    Number_to_generate : Natural := 0;

    startTime, endTime : Time;
    milliS : Duration;

begin

    for I in 1 .. Num_Of_Proc loop
        Checkers(I) := new Checker_T(I);
        Shared_Status.SubscribeCheckers(I, Checkers(I));
        Checkers(I).SetRefToNext;
    end loop;

    startTime := Clock;
    -- retrieve reference to all prime local list
    Shared_Status.GetLocalLists(Ref_To_Local_Lists);
    Ref_To_Local_Lists(1).Put(2);
    
    while Shared_Status.GetNumberOfPrimeComputed < N loop
        Shared_Status.GetUpdate(Size, Primes, Discarded);
        --Number_to_generate := Size + Discarded;
        if Size > 0 then -- if there are some prime number buffered (i.e. declared prime but still not managed by some checker)
            for I in 1 .. Size loop
                Ref_To_Local_Lists(Turn).Put(Primes(I));
                if Turn = Num_Of_Proc then  
                    Turn := 1;
                else
                    Turn := Turn + 1;
                end if;
            end loop;
        end if;
        --Generator.GenerateNumbers(Size + Discarded);
        GenBuff.setCounter(Size + Discarded);
    end loop;

    --endTime := Clock; milliS := (endTime - startTime) * 1000; Put_Line("Runtime = " & Duration'Image(milliS) & " milliseconds.");
    Checkers(1).Kill;

end Main;