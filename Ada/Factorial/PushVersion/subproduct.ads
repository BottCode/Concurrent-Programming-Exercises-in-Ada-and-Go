with Supervisor;
use Supervisor;

with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

with Ada.Containers.Vectors;
use Ada.Containers;

package Subproduct is


    X : Constant Long_Long_Integer  := 20; -- Factorial to compute
    K : Constant Long_Long_Integer := getK; -- Number of subproduct
    Remainder : Constant Long_Long_Integer := (X - 1) rem K;
    type Factor_Array is array (Long_Long_Integer range <>) of Long_Long_Integer;
    type Factor_Array_Ref is access Factor_Array;

    task type Worker_Sub_Prod_Task is
        entry SubCompute(Factors_Ref : Factor_Array_Ref);
    end Worker_Sub_Prod_Task;

    type Worker_Sub_Prod_Task_Ref_T is access Worker_Sub_Prod_Task;

    subtype Worker_Index is Long_Long_Integer range 0 .. (K - 1);
    type Worker_Array is array (Worker_Index) of Worker_Sub_Prod_Task_Ref_T; -- Array of process which compute the partial products

    subtype Factor_Index is Long_Long_Integer range 0 .. (((X - 1) / K) - 1);
    subtype Factor_Index_Unbalanced is Long_Long_Integer range 0 .. (((X - 1) / K)); 

    Type Sub_Product_Array is array (Worker_Index) of Factor_Array_Ref;
    
    Sub_Products : Sub_Product_Array;

    package Factors_Ref_Vectors is
        new Vectors(
            Index_Type => Natural,
            Element_Type => Factor_Array_Ref
        );

 
    Failed_Sub_P : Factors_Ref_Vectors.Vector;

    function getNumberOfProcess return Long_Long_Integer;

    protected Failure_Mgmt is
        entry WhoFailed(Failed : out Factors_Ref_Vectors.Vector); -- return the subproduct of the failed tasks
        procedure Fail(Sub_P : Factor_Array_Ref); -- register a failure in Sub_P_Failed
        function TaskCompleted return Long_Long_Integer;
        procedure setCompleted(Val : Long_Long_Integer);
    private
        Sub_P_Failed : Factors_Ref_Vectors.Vector;
        Completed : Long_Long_Integer := 0; -- how many subproducts are completed?
    end Failure_Mgmt;

end Subproduct;