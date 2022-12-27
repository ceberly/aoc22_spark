with Ada.Text_IO; use Ada.Text_IO;

package Aoc with
   SPARK_Mode => On
is
   --  https://github.com/Fabien-Chouteau/adventofcode-ada/blob/459fc82b5ea3a32ce964bc7ba6c3bbf8ac28e687/2022/src/aoc-resources.ads#L11
   procedure Open_File
     (File : in out Ada.Text_IO.File_Type; Filename : String) with
      Pre    => not Is_Open (File),
      Post   => Is_Open (File) and then Ada.Text_IO.Mode (File) = In_File,
      Global => (In_Out => Ada.Text_IO.File_System);

   procedure Close_File
      (File : in out Ada.Text_IO.File_Type) with
      Pre => Is_Open (File),
      Post => not Is_Open (File),
      Global => (In_Out => Ada.Text_IO.File_System);
end Aoc;
