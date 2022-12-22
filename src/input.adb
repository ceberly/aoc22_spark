with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

package body Input is
   package Line_Vector is new Ada.Containers.Vectors
      (Index_Type => Natural,
      Element_Type => Unbounded_String);

   use Line_Vector;

   function Read_Lines (Input_File : String) return Line_Array is
      F : File_Type;
      Lines : Vector := Empty_Vector;
   begin
      Open (F, In_File, Input_File);

      while not End_Of_File (F) loop
         Lines.Append (To_Unbounded_String (Get_Line (F)));
      end loop;

      Close (F);

      declare
         Result : Line_Array (1 .. Natural (Lines.Length));
      begin
         for I in Result'Range loop
            Result (I) := Lines.Element (I - 1);
         end loop;

         return Result;
      end;
   end Read_Lines;
end Input;
