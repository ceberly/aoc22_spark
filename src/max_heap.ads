generic
   type Element_Type is private;
package Max_Heap with
   SPARK_Mode => On
is
   subtype Index_Type is Positive;
   --  Prevents overflow on Left() and Right() functions which multiply
   --  a value by 2 or 2 + 1, respectively.
   subtype Capacity_Type is Index_Type range Index_Type'First .. Index_Type'Last / 2 - 1;

   type Heap_Type (Capacity : Capacity_Type) is private;

   function Empty (Heap : Heap_Type) return Boolean;
   function Full (Heap : Heap_Type) return Boolean;

   --  Insert an element at the given priority.
   procedure Insert
     (Heap : in out Heap_Type; Element : Element_Type; Priority : Natural) with
      Pre => not Full (Heap);

      --  Returns the highest priority element.
   procedure Pop (Heap : in out Heap_Type; Element : out Element_Type) with
      Pre => not Empty (Heap);

private
   type Heap_Entry is record
      Key     : Natural := 0;
      Element : Element_Type;
   end record;

   type Heap_Array is array (Index_Type range <>) of Heap_Entry;

   type Heap_Type (Capacity : Capacity_Type) is record
      Size  : Natural                    := 0;
      Store : Heap_Array (1 .. Capacity) := (others => <>);
   end record with
      Dynamic_Predicate => Size <= Capacity;
end Max_Heap;
