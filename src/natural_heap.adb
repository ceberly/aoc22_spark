package body Natural_Heap
   with SPARK_Mode => On
is
   procedure Insert (H : in out Heap; E : Positive) is
      function Parent (I : Natural) return Natural is
      begin
         return I / 2;
      end;
   begin
      null;
   end Insert;
end Natural_Heap;
