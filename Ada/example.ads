task type T is
    entry A;
    entry B(X : Integer);
end T;

task body T is
    Y : Natural := 0;
    Z : Positive := 1;
begin
    stm_1;
    accept A do
        stm_2;
    end A;
    stm_3;
    accept B(X : Integer) do
        stm_4;
    end B;
    stm_5;
end T;

task body T is
begin
    select
        accept A do
            stm_A;
        end A;
    OR
        accept B do
            stm_B;
        end B;
    end select;
end T;

 protected type Buffer_T is
      entry Put (Item: Integer);
      entry Get (Item: out Integer);
   private
      A_Container: Container;
      Size: Natural := 0;
   end Buffer_T;

   protected body Buffer_T is
      entry Put (Item : Integer) when Size < LIMIT is
      begin
         A_Container(Size) := Item;
         Size := Size + 1;
      end Put;

      entry Get(Item : out Integer) when Size > 0 is
      begin
         Item := A_Container(Size - 1);
         Size := Size - 1;
      end Get;
   end Buffer_T;