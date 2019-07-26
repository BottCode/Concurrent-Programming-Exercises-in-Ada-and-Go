with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Task_Identification;  use Ada.Task_Identification;

package body Subproduct is

    task body Worker_Sub_Prod_Task is
        Sub_Result : Long_Long_Integer := 1;
        G : Ada.Numerics.Float_Random.Generator;
        P: Float; -- failure probaility
        Factors : Factor_Array_Ref;

        begin
            accept SubCompute(Factors_Ref : Factor_Array_Ref) do
                Factors := Factors_Ref;
            end SubCompute;

            P := Float(Random(G));
            if P <= 0.4 then -- failed
                Failure_Mgmt.Fail(Factors);
            else 
                for I in Factors'Range loop
                    Sub_Result := Sub_Result * Long_Long_Integer(Factors(I));
                end loop;
                Super_Vis.CollectSubRes(Sub_Result); 
                Failure_Mgmt.setCompleted(GetCounter);
            end if;

    end Worker_Sub_Prod_Task;

    function getNumberOfProcess return Long_Long_Integer is
    begin  
        return getK;
    end;

    protected body Failure_Mgmt is
        entry WhoFailed(Failed : out Factors_Ref_Vectors.Vector) when not Factors_Ref_Vectors.Is_Empty(Sub_P_Failed)
                                                                             or Completed >= K is
        begin 
            Failed := Sub_P_Failed;
            Factors_Ref_Vectors.Clear(Sub_P_Failed); 
        end whoFailed;

        procedure Fail(Sub_P : Factor_Array_Ref) is
        begin
            Factors_Ref_Vectors.Append(Sub_P_Failed,Sub_P);
        end Fail;

        procedure setCompleted(Val : Long_Long_Integer) is 
        begin
            Completed := Val;
        end setCompleted;

        function TaskCompleted return Long_Long_Integer is
        begin
            return GetCounter;
        end TaskCompleted;
        

    end Failure_Mgmt;

end Subproduct;

