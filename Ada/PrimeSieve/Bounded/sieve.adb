with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Task_Identification;   use Ada.Task_Identification;
with Ring;                      use Ring;

package body Sieve is

    task body Generator is
        NextToken : Token;
        Last_Number_Generated : Positive := 1;
        First_Checker : Checker_Ref_T;
        Counter : Natural := 0;
    begin
        Shared_Status.GetRefToFirstChecker(First_Checker);
        for I in 3 .. Num_Of_Proc + 1 loop
            NextToken := (I, 1);
            First_Checker.PassNumber(NextToken);
            Last_Number_Generated := I;
        end loop;

        while Shared_Status.GetNumberOfPrimeComputed < N loop
            GenBuff.GetCounter(Counter);
            -- if counter > 0
            for I in 1 .. Counter loop
                Last_Number_Generated := Last_Number_Generated + 1;
                NextToken := (Last_Number_Generated, 1);
                First_Checker.PassNumber(NextToken);
            end loop;
        end loop;

    end Generator;

    protected body GenBuff is
        entry GetCounter(C: out Natural) when Counter > 0 OR Shared_Status.GetPrimesComputed >= N is
        begin
            C := Counter;
            Counter := 0;
        end GetCounter;

        procedure SetCounter(C: Natural) is
        begin
            Counter := Counter + C;
        end SetCounter;
    end GenBuff;
end Sieve;