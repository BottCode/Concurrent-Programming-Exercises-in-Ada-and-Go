
with Ada.Calendar; use Ada.Calendar;

package body SubFinder is

    Word_To_Find : Ada.Strings.Unbounded.Unbounded_String 
                        := Ada.Strings.Unbounded.To_Unbounded_String("dffbbgb");
    
    task body Sub_Finder_Worker is
        Words : Words_Array;
        Word_To_Check : Ada.Strings.Unbounded.Unbounded_String;
        File_Name : Ada.Strings.Unbounded.Unbounded_String;
        Size : Natural;
        Chunk_Of_Words : Integer;
        Words_Counter : Integer := 1;
        --startTime, endTime : Time;
        --milliS : Duration; totTime : Duration := 0.0;
    begin
        
        --startTime := Clock;
        accept PassWords(   X : Words_Array;
                            File : Ada.Strings.Unbounded.Unbounded_String;
                            Array_Size : Natural;
                            Chunk_Of_Words_Counter : Integer) do
            Words := X;
            File_Name := File;
            Size := Array_Size;
            Chunk_Of_Words := Chunk_Of_Words_Counter;
        end PassWords;

            for I in 1 .. Size loop
                Word_To_Check := Words(I);
                if Word_To_Check = Word_To_Find then
                    Put_Line(Ada.Strings.Unbounded.To_String(File_Name) & ": " 
                            & Ada.Strings.Unbounded.To_String(Word_To_Check) & " is the " 
                            & Integer'Image((Chunk_Of_Words * 200) + Words_Counter) & "-th word.");
                    null;
                end if;
                Words_Counter := Words_Counter + 1;
            end loop;

    end Sub_Finder_Worker;


end SubFinder;