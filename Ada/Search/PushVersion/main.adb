
with Analyzer;                  use Analyzer;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with WordsVector;               use WordsVector;
with Ada.Calendar;              use Ada.Calendar;


procedure Main is

    type File_Index_Array is range 0 .. 2;
    type Name_Array is array (File_Index_Array) of Ada.Strings.Unbounded.Unbounded_String;
    Files : Name_Array := ( 
                            Ada.Strings.Unbounded.To_Unbounded_String ("../files/file_1.txt"),
                            Ada.Strings.Unbounded.To_Unbounded_String ("../files/file_2.txt"),
                            Ada.Strings.Unbounded.To_Unbounded_String ("../files/file_3.txt")
                           );

    type Analyzer_Array is array (File_Index_Array) of File_Manager_Task_Ref;
    File_Manager_Array : Analyzer_Array;
    --startTime, endTime : Time;
    --milliS : Duration;

begin

    --startTime := Clock;
    for I in File_Index_Array loop
        File_Manager_Array(I) := new File_Manager_Task;
        File_Manager_Array(I).setFileName(Files(I));
    end loop;

    --endTime := Clock; milliS := (endTime - startTime) * 1000; put_line("Runtime = " & Duration'Image(milliS) & " milliseconds.");
 
end Main;