generic
   type Element_Type is private;
package Max_Heap with
   SPARK_Mode => On
is
   type Heap_Type (Capacity : Positive) is private;

   --  Insert an element at the given priority.
   procedure Insert
     (Heap : in out Heap_Type; Element : Element_Type; Priority : Natural);

   --  Returns the highest priority element.
   procedure Pop (Heap : in out Heap_Type; Element : out Element_Type);

private
   type Heap_Entry is record
      Key     : Natural;
      Element : Element_Type;
   end record;

   type Heap_Array is array (Positive range <>) of Heap_Entry;

   type Heap_Type (Capacity : Positive) is record
      Size  : Natural;
      Store : Heap_Array (1 .. Capacity);
   end record with
      Dynamic_Predicate => Size <= Capacity;
end Max_Heap;
