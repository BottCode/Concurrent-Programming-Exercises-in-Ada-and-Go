package Supervisor is

    Partial_Product : Long_Long_Integer := 1;
    Sub_Res : Long_Long_Integer := 1;
    Counter : Integer := 0;
    K : Integer := 5; -- Number of subproduct

    function getCounter return Long_Long_Integer;
    function getK return Long_Long_Integer;


    task Super_Vis is
        entry CollectSubRes(SubRes : in Long_Long_Integer); 
    end Super_Vis;

end Supervisor;