with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;

package Sieve is

    -- the process generating the numbers to check
    task Generator;

    -- Each checker is associated to a prime number, namely Id_Number.
    task type Checker_T(Id_Number : Natural) is
        entry CheckNumber(X : Natural);
        entry Kill;
    end Checker_T;

    subtype Next_Checker_T is Checker_T;

    type Checker_Ref_T is access Checker_T;

    protected PrimeCounter is
        procedure incrementCounter;
        function getPrimeNumberComputed return Natural;
    private
        Prime_Numbers_Computed : Natural := 0;
    end PrimeCounter;


end Sieve;