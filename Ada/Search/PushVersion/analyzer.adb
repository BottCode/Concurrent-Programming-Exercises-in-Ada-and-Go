with Ada.Text_IO;   use Ada.Text_IO; 
with SubFinder;     use SubFinder;
with Ada.Calendar;  use Ada.Calendar;


package body Analyzer is



    task body File_Manager_Task is
        Finder_Worker : Ref_To_Sub_Finder_Worker;
        File_Name : Ada.Strings.Unbounded.Unbounded_String;
        Input : File_Type;
        Words_Readed_Counter : Natural := 0;
        Chunk_Of_Words_Counter : Integer := 0;
        Words_Readed_Array : Words_Array;
        Word_Readed : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.To_Unbounded_String("");
        My_String : STRING(1..8);
        --startTime, endTime : Time;
        --milliS : Duration; totTime : Duration := 0.0;

    begin

        accept setFileName(File : Ada.Strings.Unbounded.Unbounded_String) do
            File_Name := File;
        end setFileName;

        Open(   File => Input,  
                Mode => In_File,  
                Name => Ada.Strings.Unbounded.To_String(File_Name));
        --startTime := Clock;
        loop
            exit when End_Of_File(Input);
            Get(Input, My_String);
            Word_Readed := Ada.Strings.Unbounded.To_Unbounded_String(My_String(1..7));
            Words_Readed_Counter := Words_Readed_Counter + 1;
            Words_Readed_Array(Words_Readed_Counter) := Word_Readed;

            if Words_Readed_Counter >= 200 OR End_Of_File(Input) then
                    Finder_Worker := new Sub_Finder_Worker;
                    Finder_Worker.PassWords(Words_Readed_Array, File_Name, Words_Readed_Counter, Chunk_Of_Words_Counter);
                    Words_Readed_Counter := 0;
                    Chunk_Of_Words_Counter := Chunk_Of_Words_Counter + 1;
            end if;
        end loop;
        --endTime := Clock; milliS := (endTime - startTime) * 1000; put_line(Ada.Strings.Unbounded.To_String(File_Name) & " IN " & Duration'Image(milliS) & " milliseconds.");
    end File_Manager_Task;

end Analyzer;