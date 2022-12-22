with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Input is
   type Line_Array is array (Positive range <>) of Unbounded_String;

   function Read_Lines (Input_File : String) return Line_Array;
end Input;
