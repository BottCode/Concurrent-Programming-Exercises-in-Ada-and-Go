package Supervisor is

    Partial_Product : Long_Long_Integer := 1;
    Sub_Res : Long_Long_Integer := 1;
    Counter : Integer := 0;
    X : Constant Long_Long_Integer  := 20; -- Factorial to compute
    Sub_P_Size : Integer := 2; -- number of factors in a subproducts
    Number_Of_Sub_Products : Integer := Integer(X) / Sub_P_Size;

    function getCounter return Long_Long_Integer;
    function getSubPSize return Long_Long_Integer;
    function getNumberOfSubP return Long_Long_Integer;
    function getX return Long_Long_Integer;

    task Super_Vis is
        entry CollectSubRes(SubRes : in Long_Long_Integer); -- K is the number of subproducts/process which computes subproducts
    end Super_Vis;

end Supervisor;