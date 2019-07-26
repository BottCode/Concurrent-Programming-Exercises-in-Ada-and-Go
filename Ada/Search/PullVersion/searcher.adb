package body Searcher is

    Number_Of_Workers : Integer :=24;
    Workers : WorkersVector.Vector;
    W_aux : SearcherWorker_Ref;
    Word_To_Find : Ada.Strings.Unbounded.Unbounded_String 
                        := Ada.Strings.Unbounded.To_Unbounded_String("dffbbgb");

    task body SearcherManager is -- creates and start searcher worker.
    begin
        for I in 1 .. Number_Of_Workers loop
            W_aux := new SearcherWorker;
            WorkersVector.Append(Workers,W_aux);
        end loop;
    end SearcherManager;

    task body SearcherWorker is
        Chunk_To_Analyze : Chunk;
        Words_Counter : Integer := 1;
    begin

        -- la prima condizione dice se il chuncking di tutti i file è stato eseguito.
        -- La seconda dice se ho controllato tutti i chunck nel buffer
        while not Buffer.isChunkingCompleted or not Buffer.isChunksExplored loop
            
            Buffer.GetChunks(Chunk_To_Analyze);
            Search_Loop:
            for Word of Chunk_To_Analyze.Words loop
                if Word = Word_To_Find then
                    Put_Line(Ada.Strings.Unbounded.To_String(Chunk_To_Analyze.File_Name) & ": " 
                                & Ada.Strings.Unbounded.To_String(Word) & " is the " 
                                & Integer'Image((Chunk_To_Analyze.Progressive_Id  * 200) + Words_Counter) & "-th word.");
                    null;
                end if;
                Words_Counter := Words_Counter + 1;
            end loop Search_Loop;
            
            Words_Counter := 1;
        end loop;
        
    end SearcherWorker;

    protected body Buffer is

        entry GetChunks(Ch : out Chunk) when 
                                    not isChunksExplored
                                        or 
                                    isChunkingCompleted is
        begin
            Ch := ChunksVector.Element(Chunks, Index);
            Index := Index + 1;
        end GetChunks;

        procedure AppendChunks(Ch : Chunk) is    
        begin
            ChunksVector.Append(Chunks,Ch);
        end AppendChunks;
        
        function isChunkingCompleted return Boolean is
        begin
            return Chunking_Completed;
        end isChunkingCompleted;

        function isChunksEmpty return Boolean is
        begin
            return ChunksVector.Is_Empty(Chunks);
        end isChunksEmpty;

        function isChunksExplored return Boolean is
        begin
            return ChunksVector.Length(Chunks) <= Ada.Containers.Count_Type(Index);
        end isChunksExplored;

        procedure ChunkingDone is
        begin
            Chunking_Completed := True;
        end ChunkingDone;

    end Buffer;

end Searcher;