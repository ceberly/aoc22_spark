package Natural_Heap 
   with SPARK_Mode => On
is
   type Heap_Array is array (Positive range <>) of Natural;

   type Heap (Array_Size : Positive) is record
      A : Heap_Array (1 .. Array_Size);
      Heap_Size : Natural;
   end record;

   procedure Insert (H : in out Heap; E : Positive);
end Natural_Heap;
