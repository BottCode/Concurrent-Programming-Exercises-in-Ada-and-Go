with Ada.Text_IO;
use Ada.Text_IO;

with Subproduct;
use Subproduct;

with Ada.Calendar; 
use Ada.Calendar;



procedure Main is

    First_Number : Long_Long_Integer := 1;
    Number_Of_Worker : Integer := 5;
    Worker : Worker_Sub_Prod_Task_Ref_T;
    Sub_Products : Factors_Ref_Vectors.Vector;
    Factors : Factor_Array_Ref;
    startTime, endTime : Time;
    milliS : Duration;

    begin
        -- Let's build the subproducts. Each subproduct has no more than 2 factors

        startTime := Clock;
        if X rem 2 = 1 then
            First_Number := 2;
        end if; 

        for I in 0 .. Number_Of_Worker - 1 loop
            Worker := new Worker_Sub_Prod_Task;
        end loop; 

        for I in 0 .. Number_Of_Sub_Products - 1 loop
            Factors := new Factor_Array;
            for J in 0 .. Sub_P_Size - 1 loop
                -- X is the last number. This formula generate pairs of this type: 1,20 | 2,19 | 3,18 | and so on...
                -- J is 0 or 1
                Factors(J) := ((First_Number + I)) + (J * ((X - I) - (First_Number + I)));
            end loop;
            Sub_List_Mgmt.AppendSubProd(Factors);
        end loop;

        while Sub_List_Mgmt.TaskCompleted < Number_Of_Sub_Products loop
            if Sub_List_Mgmt.GetFailed > 0 then
                Worker := new Worker_Sub_Prod_Task;
            end if;
        end loop;

        endTime := Clock;
        milliS := (endTime - startTime) * 1000;
        put_line("Runtime = " & Duration'Image(milliS) & " milliseconds.");

    end Main;
