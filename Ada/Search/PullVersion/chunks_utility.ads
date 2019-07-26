with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors; use Ada.Containers;

package Chunks_Utility is

    type Words_Array is array (1 .. 200) of Ada.Strings.Unbounded.Unbounded_String;

    type Chunk is record
        Words : Words_Array;
        File_Name : Ada.Strings.Unbounded.Unbounded_String;
        Progressive_Id : Integer;
    end record;
    type Chunk_Ref is access Chunk;

    package ChunksVector is
        new Vectors(
            Index_Type => Natural,
            Element_Type => Chunk
        );
    type ChunksVector_Ref is access ChunksVector.Vector;

end Chunks_Utility;