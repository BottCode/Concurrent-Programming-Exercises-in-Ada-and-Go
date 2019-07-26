
with WordsVector;
use WordsVector;

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package Analyzer is


    task type File_Manager_Task is
        entry setFileName(File : Ada.Strings.Unbounded.Unbounded_String);
    end File_Manager_Task;

    type File_Manager_Task_Ref is access File_Manager_Task;

end Analyzer;