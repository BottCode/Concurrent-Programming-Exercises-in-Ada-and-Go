with Ada.Text_IO;
use Ada.Text_IO;

package body Supervisor is

task body Super_Vis is
    begin
        for I in Integer range 1 .. Number_Of_Sub_Products loop
            
            accept CollectSubRes(SubRes : in Long_Long_Integer) do
                Counter := Counter + 1;
                Sub_Res := SubRes;
            end CollectSubRes;
            Partial_Product := Partial_Product * Sub_Res;
            if Counter >= Number_Of_Sub_Products then
                Put_Line("FINAL " & Long_Long_Integer'Image(Partial_Product)); 
            end if;

        end loop;

    end Super_Vis;

    function getCounter return Long_Long_Integer is
    begin   
        return Long_Long_Integer(Counter);
    end;

    function getSubPSize return Long_Long_Integer is
    begin
        return Long_Long_Integer(Sub_P_Size);
    end;

    function getNumberOfSubP return Long_Long_Integer is
    begin
        return Long_Long_Integer(Number_Of_Sub_Products);
    end;

    function getX return Long_Long_Integer is
    begin
        return X;
    end getX;

end Supervisor;