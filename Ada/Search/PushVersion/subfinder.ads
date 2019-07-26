with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

with WordsVector;
use WordsVector;

package SubFinder is

    task type Sub_Finder_Worker is
        entry PassWords( X : Words_Array;
                         File : Ada.Strings.Unbounded.Unbounded_String;
                         Array_Size : Natural;
                         Chunk_Of_Words_Counter : Integer);
    end Sub_Finder_Worker;

    type Ref_To_Sub_Finder_Worker is access Sub_Finder_Worker;

    
end Subfinder;