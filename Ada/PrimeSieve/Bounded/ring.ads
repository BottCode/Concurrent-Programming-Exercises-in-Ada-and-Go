package Ring is
    -- Number of prime numbers to compute.
    N : constant Positive := 10 - 1; -- the first one (i.e. 2) is not computed 

    -- Number of process checking if a number is prime.
    Num_Of_Proc : constant Positive := 4; 

    -- Max number of local prime number for each task.
    Limit : Positive := Positive ( Float'Ceiling( Float(N) / Float(Num_Of_Proc) ) + 1.0 );

    type Token is record
        Number_To_Check : Positive;
        Level_To_Read : Natural;
    end record;
    type Token_Ref is access Token;

    type Small_Container is array (1 .. Limit) of Positive;
    type Big_Container is array (1 .. Num_Of_Proc - 1) of Positive;
    -- this buffer is to communicate with the first checker (used by last checker and generator)
    type Token_Array is array (0 .. Num_Of_Proc - 1) of Token;


    task type Checker_T(Id_Number : Natural) is
        entry PassNumber(X : Token);
        entry SetRefToNext;
        entry Kill;
    end Checker_T;
    type Checker_Ref_T is access Checker_T;
    
    subtype Next_Checker_T is Checker_T;
    type Checker_Array is array (1 .. Num_Of_Proc) of Checker_Ref_T; 

    protected type Local_Container is
        procedure Put(Item : Positive);
        entry Get(Item : out Positive);
        function IsLevelExisting(Level : Natural) return Boolean;
        procedure SetLevelRequested(Level : Natural);
        function GetDepth return Natural;
        procedure incDepth;
        function GetWait return boolean;
    private
        Numbers : Small_Container;
        Depth : Natural := 0;
        Level_Requested : Natural := 0;
    end Local_Container;

    type Local_List_Array is array (1 .. Num_Of_Proc) of access Local_Container;

    -- Note: this protected resource is NOT a protected type.
    protected Shared_Status is
        entry GetUpdate(Size : out Natural; Primes : out Big_Container; Discarded : out Natural);
        entry GetCheckersArray(Ch : out Checker_Array);
        entry GetRefToFirstChecker(F : out Checker_Ref_T);
        -- get the reference to the Checkers identified with Id 
        entry GetRefOfId(Id : Natural; F : out Checker_Ref_T);
        entry GetLocalLists(L : out Local_List_Array);
        entry Put(Item : Positive);

        -- invoked by Generator
        procedure GetAll(Size : out Natural; Primes : out Big_Container);
        procedure ResetDiscarded;
        -- entry GetAll ?
        function GetDepth return Natural;
        function GetNumbOfDiscarded return Natural;
        function GetNumberOfPrimeComputed return Natural;
        -- invoked by checker task
        procedure Discard; 
        function GetCheckers return Checker_Array;
        procedure SubscribeCheckers(Id : Natural; Ref : Checker_Ref_T);
        procedure SubscribeLocalList(Id : Natural; List_Ref: access Local_Container);
        function GetPrimesComputed return Natural;
    private
        Numbers : Big_Container;
        Depth : Natural := 0; -- How many prime number are buffered?
        Number_Of_Discarded : Natural := 0;
        Primes_Computed : Natural := 0; -- How many prime number did we find?
        Ref_To_Checkers : Checker_Array;
        Ref_To_Local_List : Local_List_Array;
        List_Subscribed : Natural := 0;
        Subscribed : Natural := 0;
    end Shared_Status;

    protected Buffer is
        entry PassToFirst(Item : Token);
        entry GetAll(X : out Token_Array; Size : out Natural);
    private
        First_Buffer : Token_Array;
        Numb_Of_Token : Natural := 0;
    end Buffer;

end Ring;