with Searcher;              use Searcher;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Chunks_Utility;        use Chunks_Utility;
with Ada.Calendar;          use Ada.Calendar;



procedure Main is 

    Input : File_Type;
    Words_Readed_Counter : Integer := 0;
    Chunk_Of_Words_Counter : Integer := 0;
    type File_Index_Array is range 0 .. 2;
    type Name_Array is array (File_Index_Array) of Ada.Strings.Unbounded.Unbounded_String;
    Files : Name_Array := ( Ada.Strings.Unbounded.To_Unbounded_String ("../files/file_1.txt"),
                            Ada.Strings.Unbounded.To_Unbounded_String ("../files/file_2.txt"),
                            Ada.Strings.Unbounded.To_Unbounded_String ("../files/file_3.txt") 
                           );
    Word_Readed : Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.To_Unbounded_String("");                       
    WorkerTaskManager : SearcherManager;
    Words_Readed_Array : Words_Array;
    Ch : Chunk;
    startTime, endTime : Time;
    milliS : Duration;
    My_String : STRING(1..8);

begin
    startTime := Clock;
    for I in File_Index_Array loop
        Open(   File => Input,  
                Mode => In_File,  
                Name => Ada.Strings.Unbounded.To_String(Files(I)));
        loop      
            exit when End_Of_File(Input);
            Get(Input, My_String);
            Word_Readed := Ada.Strings.Unbounded.To_Unbounded_String(My_String(1..7));
            Words_Readed_Counter := Words_Readed_Counter + 1;
            Words_Readed_Array(Words_Readed_Counter) := Word_Readed;

            if Words_Readed_Counter >= 200 OR End_Of_File(Input) then
                Ch := (Words => Words_Readed_Array,
                            File_Name => Files(I),
                            Progressive_Id => Chunk_Of_Words_Counter);
                Buffer.AppendChunks(Ch);
                Word_Readed := Ada.Strings.Unbounded.To_Unbounded_String("");
                Words_Readed_Counter := 0;
                Chunk_Of_Words_Counter := Chunk_Of_Words_Counter + 1;
            end if;
            
        end loop;


    Close(Input);
    Chunk_Of_Words_Counter := 0;

    end loop;


    Buffer.ChunkingDone;

    --endTime := Clock; milliS := (endTime - startTime) * 1000; put_line("Searching in = " & Duration'Image(milliS) & " milliseconds.");

 

end Main;