package body Max_Heap with
   SPARK_Mode => On
is
   function Parent (Index : Index_Type) return Index_Type is (Index / 2) with
      Pre => Index > 1;

   function Left_Child (Index : Index_Type) return Index_Type is
     (Index * 2) with
      Pre => Index <= (Index_Type'Last / 2);

   function Right_Child (Index : Index_Type) return Index_Type is
     (Left_Child (Index) + 1) with
      Pre => Index <= (Index_Type'Last / 2 - 1);

   function Empty (Heap : Heap_Type) return Boolean is (Heap.Size = 0);

   function Full (Heap : Heap_Type) return Boolean is
     (Heap.Size = Heap.Capacity);

   function Size_Increased_One
     (Heap_Old : Heap_Type; Heap : Heap_Type) return Boolean is
     (Heap.Size = Heap_Old.Size + 1);

   function Size_Decreased_One
     (Heap_Old : Heap_Type; Heap : Heap_Type) return Boolean is
     (Heap_Old.Size = Heap.Size + 1);

   procedure Heapify (Heap : in out Heap_Type; Index : Index_Type) with
      Pre  => Index <= Heap.Size,
      Post => Heap'Old.Size = Heap.Size
   is
      Left    : constant Index_Type := Left_Child (Index);
      Right   : constant Index_Type := Right_Child (Index);
      Largest : Index_Type          := Index;

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
      Index : Index_Type;
      P     : Index_Type;
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

         pragma Loop_Invariant (Index <= Heap.Size);
      end loop;

      Heap.Store (Index) := T;
   end Insert;

   procedure Pop (Heap : in out Heap_Type; Element : out Element_Type) is
   begin
      Element := Heap.Store (1).Element;

      Heap.Store (1) := Heap.Store (Heap.Size);
      Heap.Size      := Heap.Size - 1;

      if Heap.Size > 0 then
         Heapify (Heap, 1);
      end if;
   end Pop;
end Max_Heap;
