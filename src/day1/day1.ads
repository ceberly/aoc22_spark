package Day1
   with SPARK_Mode => On
is
   procedure Run (Filename : String)
      with
         Pre => Filename'Length /= 0;
end Day1;
