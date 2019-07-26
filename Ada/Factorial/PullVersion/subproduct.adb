with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Task_Identification;  use Ada.Task_Identification;

package body Subproduct is


    task body Worker_Sub_Prod_Task is
        Sub_Result : Long_Long_Integer := 1;
        P: Float; -- failure probaility
        Factors : Factor_Array_Ref;
        T_ID : Task_Id;

        begin
            while Sub_List_Mgmt.TaskCompleted < getNumberOfSubP loop
                P := Float(Random(G));
                Sub_List_Mgmt.GetSubProd(Factors);
                if P <= 0.4 then -- failed
                    Sub_List_Mgmt.AppendSubProd(Factors);
                    Sub_List_Mgmt.IncFailed;
                    EXIT;
                else 
                    Sub_Result := 1;
                    for I in Factors'Range loop
                            --Put_Line(Long_Long_Integer'Image(Factors(I)) & "*");
                            Sub_Result := Sub_Result * Long_Long_Integer(Factors(I));
                    end loop;
                    Super_Vis.CollectSubRes(Sub_Result); 
                    Sub_List_Mgmt.setCompleted(GetCounter);
                end if;
            end loop;

        end Worker_Sub_Prod_Task;


    protected body Sub_List_Mgmt is

        entry GetSubProd(Sub_P : out Factor_Array_Ref) when not Factors_Ref_Vectors.Is_Empty(Sub_Products) 
                                                                or TaskCompleted >= getNumberOfSubP is  
        begin
            Sub_P := Factors_Ref_Vectors.Last_Element(Sub_Products);
            Factors_Ref_Vectors.Delete_Last(Sub_Products); 
        end GetSubProd;

        procedure SetArraySubProd(Array_Sub_P : Factors_Ref_Vectors.Vector) is
        begin
            Sub_Products := Array_Sub_P;
            for El of Sub_Products loop
                for I in Factor_Index loop
                    Put_Line(Long_Long_Integer'Image(El(I)));
                end loop;
            end loop;
        end;

        procedure AppendSubProd(Sub_P : Factor_Array_Ref) is
        begin
            Factors_Ref_Vectors.Append(Sub_Products, Sub_P);
        end AppendSubProd;

        procedure setCompleted(Val : Long_Long_Integer) is 
        begin
            Completed := Val;
        end setCompleted;

        function TaskCompleted return Long_Long_Integer is
        begin
            return GetCounter;
        end TaskCompleted;

        function GetFailed return Natural is
        begin
            return Failed;
        end GetFailed;

        procedure IncFailed is
        begin
            Failed := Failed + 1;
        end IncFailed;

        procedure DecFailed is
        begin
            Failed := Failed - 1;
        end DecFailed;

    end Sub_List_Mgmt;

end Subproduct;

