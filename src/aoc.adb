package body Aoc
   with SPARK_Mode => On
is
   procedure Open_File (File : in out Ada.Text_IO.File_Type;
      Filename : String) is
   begin
      Ada.Text_IO.Open (File, Ada.Text_IO.In_File, Filename);
   end Open_File;
end Aoc;
