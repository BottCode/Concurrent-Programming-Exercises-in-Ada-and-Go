with Supervisor;
use Supervisor;

with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

with Ada.Containers.Vectors;
use Ada.Containers;

package Subproduct is


    X : Constant Long_Long_Integer  := getX; -- Factorial to compute
    Sub_P_Size : Long_Long_Integer := getSubPSize; -- number of factors in a subproducts
    Number_Of_Sub_Products : Long_Long_Integer := getNumberOfSubP;
    G : Ada.Numerics.Float_Random.Generator;

    subtype Factor_Index is Long_Long_Integer range 0 .. 1;
    type Factor_Array is array (Factor_Index) of Long_Long_Integer;
    type Factor_Array_Ref is access Factor_Array;

    task type Worker_Sub_Prod_Task;

    type Worker_Sub_Prod_Task_Ref_T is access Worker_Sub_Prod_Task;

    subtype Sub_P_Index is Long_Long_Integer range 0 .. Number_Of_Sub_Products - 1;
    type Sub_Product_Array is array (Sub_P_Index) of Factor_Array_Ref;
    type Sub_Product_Array_Ref is access Sub_Product_Array;
    Sub_Products : Sub_Product_Array;

    package Factors_Ref_Vectors is
        new Vectors(
            Index_Type => Natural,
            Element_Type => Factor_Array_Ref
        );

    type Sub_Product_Vector_Ref is access Factors_Ref_Vectors.Vector;

    protected Sub_List_Mgmt is
        entry GetSubProd(Sub_P : out Factor_Array_Ref);
        procedure SetArraySubProd(Array_Sub_P : Factors_Ref_Vectors.Vector);
        procedure AppendSubProd(Sub_P : Factor_Array_Ref);
        procedure setCompleted(Val : Long_Long_Integer);
        function TaskCompleted return Long_Long_Integer;
        function GetFailed return Natural;
        procedure IncFailed; -- increment failed
        procedure DecFailed; -- decrement failed

    private    
        Sub_Products : Factors_Ref_Vectors.Vector;
        Completed : Long_Long_Integer := 0; -- how many subproducts are completed?
        Failed : Natural := 0; -- number of aborted tasks that need to be recovered
    end Sub_List_Mgmt;


end Subproduct;