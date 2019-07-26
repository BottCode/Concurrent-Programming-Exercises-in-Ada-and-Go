with Ada.Text_IO;
use Ada.Text_IO;

package body Supervisor is

task body Super_Vis is
    begin
        for I in Integer range 1 .. K loop
            accept CollectSubRes(SubRes : in Long_Long_Integer) do
                Counter := Counter + 1;
                Sub_Res := SubRes;
            end CollectSubRes;
            
            Partial_Product := Partial_Product * Sub_Res;
        end loop;

        Put_Line("FINAL " & Long_Long_Integer'Image(Partial_Product));

    end Super_Vis;

    function getCounter return Long_Long_Integer is
    begin   
        return Long_Long_Integer(Counter);
    end;

    function getK return Long_Long_Integer is
    begin
        return Long_Long_Integer(K);
    end;

end Supervisor;