with Ada.Text_IO;
use Ada.Text_IO;

with Subproduct;
use Subproduct;

with Ada.Calendar; use Ada.Calendar;



procedure Main is
    Result : Integer := 0; 
    K : Long_Long_Integer := getNumberOfProcess; -- Number of subproduct
    subtype Worker_Index is Long_Long_Integer range 0 .. (K - 1);
    type Worker_Array is array (Worker_Index) of Worker_Sub_Prod_Task_Ref_T; -- Array of process which compute the partial products
    
    Workers : Worker_Array;
    Restarted : Worker_Sub_Prod_Task_Ref_T;
    startTime, endTime : Time;
    milliS : Duration;

    begin


        startTime := Clock;
        for I in Worker_Index loop
            
            -- Sub_Products(I) is the i-th subproducts to compute
            if I <= Remainder - 1 then 
                Sub_Products(I) := new Factor_Array(Factor_Index_Unbalanced); 
            else
                Sub_Products(I) := new Factor_Array(Factor_Index);
            end if;

            for J in Sub_Products(I)'Range loop
                -- X is the factorial to compute
                -- K is the number of process
                Sub_Products(I)(J) := X - I - (K * J); -- X - I is the starting point in order to collect the factors regarding the subproduct
            end loop;
            
        end loop;
        
        for I in Worker_Index loop
            Workers(I) := new Worker_Sub_Prod_Task;
            Workers(I).SubCompute(Sub_Products(I));
        end loop;

        while Failure_Mgmt.TaskCompleted < K loop 
            Failure_Mgmt.WhoFailed(Failed_Sub_P);
            for E of Failed_Sub_P loop
                Restarted := new Worker_Sub_Prod_Task;
                Restarted.SubCompute(E);
            end loop;
        end loop;

        endTime := Clock;
        milliS := (endTime - startTime) * 1000;
        --put_line("Runtime = " & Duration'Image(milliS) & " milliseconds.");

    end Main;
