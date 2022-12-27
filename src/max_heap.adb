package body Max_Heap with
   SPARK_Mode => On
is
   function Parent (Index : Positive) return Positive is (Index / 2) with
      Pre => Index > 1;

   function Left_Child (Index : Positive) return Positive is (Index * 2);

   function Right_Child (Index : Positive) return Positive is
     (Left_Child (Index) + 1);

   procedure Heapify (Heap : in out Heap_Type; Index : Positive) is
      Left    : constant Positive := Left_Child (Index);
      Right   : constant Positive := Right_Child (Index);
      Largest : Positive          := Index;
   begin
      if Left <= Heap.Size
        and then Heap.Store (Left).Key > Heap.Store (Index).Key
      then
         Largest := Left;
      end if;

      if Right <= Heap.Size
        and then Heap.Store (Right).Key > Heap.Store (Largest).Key
      then
         Largest := Right;
      end if;

      if Largest /= Index then
         declare
            Tmp : constant Heap_Entry := Heap.Store (Index);
         begin
            Heap.Store (Index)   := Heap.Store (Largest);
            Heap.Store (Largest) := Tmp;
         end;

         Heapify (Heap, Largest);
      end if;
   end Heapify;

   procedure Insert
     (Heap : in out Heap_Type; Element : Element_Type; Priority : Natural)
   is
      Index : Positive;
      P     : Positive;
      T     : constant Heap_Entry := (Priority, Element);
   begin
      Heap.Size := Heap.Size + 1;
      Index     := Heap.Size;

      loop
         exit when Index = 1;
         P := Parent (Index);
         exit when Heap.Store (P).Key >= T.Key;

         Heap.Store (Index) := Heap.Store (P);
         Index              := P;
      end loop;

      Heap.Store (Index) := T;
   end Insert;

   procedure Pop (Heap : in out Heap_Type; Element : out Element_Type) is
   begin
      Element := Heap.Store (1).Element;

      Heap.Store (1) := Heap.Store (Heap.Size);
      Heap.Size      := Heap.Size - 1;

      Heapify (Heap, 1);
   end Pop;
   --   function Has_Max_Heap return Boolean is
   --     (for all K in 2 .. Max_Heap.Size =>
--        Store (Parent (K)).Key <= Store (K).Key);
--

--
--   function Has_Max_Heap_Property (H : Heap) return Boolean is
--      (for all K in 2 .. H.Size => H.Store (Parent (K)) >= H.Store (K));
--
end Max_Heap;
