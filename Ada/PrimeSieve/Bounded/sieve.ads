
package Sieve is

    task Generator;

    protected GenBuff is
        entry getCounter(C: out Natural);
        procedure setCounter(C: Natural);
    private
        Counter : Natural := 0;
    end GenBuff;

end Sieve;