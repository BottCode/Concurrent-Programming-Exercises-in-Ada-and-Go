with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Chunks_Utility;         use Chunks_Utility;
with Ada.Containers.Vectors; use Ada.Containers;
with Ada.Task_Identification;  use Ada.Task_Identification;

package Searcher is 

    task type SearcherManager;

    task type SearcherWorker;

    type SearcherWorker_Ref is access SearcherWorker;

    package WorkersVector is
        new Vectors(
            Index_Type => Natural,
            Element_Type => SearcherWorker_Ref
        );
    type WorkersVector_Ref is access WorkersVector.Vector;

    protected Buffer is
        entry GetChunks(Ch : out Chunk);
        procedure AppendChunks(Ch : Chunk);
        function isChunkingCompleted return Boolean;
        function isChunksEmpty return Boolean;
        function isChunksExplored return Boolean;
        procedure ChunkingDone; -- sets Chunking_Completed to TRUE
    private
        Chunks : ChunksVector.Vector;
        Chunking_Completed : Boolean := False;
        Index : Natural := 0;

    end Buffer;

end Searcher;
