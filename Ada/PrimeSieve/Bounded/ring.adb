with Ada.Text_IO;               use Ada.Text_IO;
package body Ring is

    task body Checker_T is
        Next_Checker : Checker_Ref_T := NULL;
        Local_Primes : aliased Local_Container;
        Token_To_Check : Token;
        Number_To_Check : Positive;
        Divider : Positive;
        Token_Array_Size : Natural := 0;
        Killed : Boolean := False;
    begin
        accept SetRefToNext;
        if Id_Number = Num_Of_Proc then
            Shared_Status.GetRefOfId(1, Next_Checker);
        else
            Shared_Status.GetRefOfId(Id_Number+1, Next_Checker);
        end if;

        Shared_Status.SubscribeLocalList(Id_Number, Local_Primes'Unchecked_Access);

        while True loop
            select 
                accept PassNumber(X : Token) do
                    Token_To_Check := X;
                end PassNumber;
            OR
                accept Kill do
                    if Id_Number /= Num_Of_Proc then
                        Next_Checker.Kill;
                    end if;
                    Killed := True;
                end Kill;
            end select;

            if Killed then EXIT; end if;

            Number_To_Check := Token_To_Check.Number_To_Check;
            Local_Primes.SetLevelRequested(Token_To_Check.Level_To_Read);   
            Local_Primes.Get(Divider);
            if Shared_Status.GetNumberOfPrimeComputed < N then
                if Divider * Divider > Number_To_Check  then -- if Divider > sqrt(n)
                    -- Number_to_check IS prime
                    Put_Line("P"&Positive'Image(Id_Number) & ": "&Positive'Image(Number_To_Check) & " IS PRIME BY P" & Positive'Image(Id_Number));
                    Shared_Status.Put(Number_To_Check);
                elsif Number_To_Check mod Divider = 0 then
                    -- Number_to_check is NOT prime
                    Shared_Status.Discard;
                else 
                    if Id_Number = Num_Of_Proc then
                        Token_To_Check.Level_To_Read := Token_To_Check.Level_To_Read + 1;
                    end if;
                    Next_Checker.PassNumber(Token_To_Check);                 
                end if;
            end if;
        end loop;

    end Checker_T;


    ------------------------------------
    ------- LOCAL CONTAINER ------------
    ------------------------------------
    protected body Local_Container is
        
        procedure Put(Item : Positive) is 
        begin
            Depth := Depth + 1;
            Numbers(Depth) := Item;
        end Put;

        entry Get(Item : out Positive) when (Level_Requested /= 0 
                                            AND Level_Requested <= Depth AND Depth /= 0) OR Shared_Status.GetPrimesComputed >= N is
        begin
            Item := Numbers(Level_Requested);
        end Get;

        function GetWait return boolean is
        begin
            return ((Level_Requested /= 0 AND Level_Requested <= Depth) OR Shared_Status.GetPrimesComputed >= N);
        end GetWait;

        function IsLevelExisting(Level : Natural) return Boolean is
        begin
            return (Level <= Depth and Depth /= 0);
        end IsLevelExisting;

        procedure SetLevelRequested(Level : Natural) is
        begin
            Level_Requested := Level;
        end SetLevelRequested;

        function GetDepth return Natural is
        begin   
            return Depth;
        end GetDepth;

        procedure incDepth is
        begin
            Depth := Depth + 1;
        end incDepth;

    end Local_Container;

    ------------------------------------
    ------- SHARED STATUS ------------
    ------------------------------------
    
    protected Body Shared_Status is

        entry GetUpdate(Size : out Natural; Primes : out Big_Container; Discarded : out Natural) 
                when (Depth > 0 OR Number_Of_Discarded > 0) OR Shared_Status.Primes_Computed = N is
        begin
            Size := Depth;
            Discarded := Number_Of_Discarded;
            if Size > 0 then
                Depth := 0;
                Primes := Numbers;
            end if;

            if Discarded > 0 then
                Number_Of_Discarded := 0;
            end if;
        end GetUpdate;

        entry GetCheckersArray(Ch : out Checker_Array) when Subscribed = Num_Of_Proc is
        begin
            Ch := Ref_To_Checkers;
        end GetCheckersArray;

        entry GetRefToFirstChecker(F : out Checker_Ref_T) when Subscribed > 0 is
        begin   
            F := Ref_To_Checkers(1); -- Reference to the first checker
        end GetRefToFirstChecker;

        entry GetRefOfId(Id : Natural; F : out Checker_Ref_T) when Subscribed = Num_Of_Proc is
        begin   
            F := Ref_To_Checkers(Id);
        end GetRefOfId;

        entry GetLocalLists(L : out Local_List_Array) when List_Subscribed = Num_Of_Proc is
        begin
            L := Ref_To_Local_List;
        end GetLocalLists;

        entry Put(Item : Positive) when Depth < Num_Of_Proc - 1 OR Shared_Status.Primes_Computed >= N is
        begin
            Depth := Depth + 1;
            Numbers(Depth) := Item;
            Primes_Computed := Primes_Computed + 1;
        end Put;

        procedure GetAll(Size : out Natural; Primes : out Big_Container) is
        begin 
            Size := Depth;
            Depth := 0;
            Primes := Numbers;
        end GetAll;

        procedure ResetDiscarded is
        begin
            Number_Of_Discarded := 0;
        end ResetDiscarded;

        function GetDepth return Natural is
        begin
            return Depth;
        end GetDepth;

        function GetNumbOfDiscarded return Natural is
        begin
            return Number_Of_Discarded;
        end GetNumbOfDiscarded;

        function GetNumberOfPrimeComputed return Natural is
        begin
            return Primes_Computed;
        end GetNumberOfPrimeComputed;        

        procedure Discard is
        begin
            Number_Of_Discarded := Number_Of_Discarded + 1;
        end Discard;

        function GetCheckers return Checker_Array is
        begin
            return Ref_To_Checkers;
        end GetCheckers;

        procedure SubscribeCheckers(Id : Natural; Ref : Checker_Ref_T) is
        begin
            Ref_To_Checkers(Id) := Ref;
            Subscribed := Subscribed + 1;
        end SubscribeCheckers;

        procedure SubscribeLocalList(Id : Natural; List_Ref: access Local_Container) is
        begin
            Ref_To_Local_List(Id) := List_Ref;
            List_Subscribed := List_Subscribed + 1;
        end SubscribeLocalList;

        function GetPrimesComputed return Natural is
        begin
            return Primes_Computed;
        end GetPrimesComputed;

    end Shared_Status;

    ------------------------------------
    -------     BUFFER      ------------
    ------------------------------------

    protected body Buffer is

        entry PassToFirst(Item : Token) when Numb_Of_Token < Num_Of_Proc - 1 is
        begin
            First_Buffer(Numb_Of_Token) := Item;
            Numb_Of_Token := Numb_Of_Token + 1;
        end PassToFirst;

        entry GetAll(X : out Token_Array; Size : out Natural) when Numb_Of_Token > 0 is
        begin
            Size := Numb_Of_Token;
            X := First_Buffer;
            Numb_Of_Token := 0;
        end GetAll;

    end Buffer;

end Ring;