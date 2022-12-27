with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1;

with Aoc;
with Max_Heap;

package body Day1 with
   SPARK_Mode => On
is
   type Sum_Type is new Natural with Default_Value => 0;

   procedure Run (Filename : String) is
      type Error_Type is (None, Unexpected_Character, Overflow);

      procedure Next_Sum
        (File  :     Ada.Text_IO.File_Type; Sum : out Sum_Type;
         Error : out Error_Type) with
         Pre => Is_Open (File) and then Ada.Text_IO.Mode (File) = In_File
      is
         C             : Character;
         Running_Value : Sum_Type;
      begin
         Error := None;
         Sum   := 0;

         while not End_Of_File (File) loop
            Get_Immediate (File, C);

            case C is
               when Ada.Characters.Latin_1.LF =>
                  if Running_Value = 0 then
                     return;
                  end if;

                  if Sum_Type'Last - Sum < Running_Value then
                     Error := Overflow;
                     return;
                  end if;

                  Sum           := Sum + Running_Value;
                  Running_Value := 0;
               when '0' .. '9' =>
                  if Running_Value >
                    (Sum_Type'Last -
                       (Character'Pos (C) - Character'Pos ('0'))) /
                      10
                  then
                     Error := Overflow;
                     return;
                  end if;

                  Running_Value :=
                    10 * Running_Value +
                    (Character'Pos (C) - Character'Pos ('0'));
               when others =>
                  Error := Unexpected_Character;
                  return;
            end case;
         end loop;
      end Next_Sum;

      procedure Part1 is
         File     : Ada.Text_IO.File_Type;
         Error    : Error_Type;
         Curr_Sum : Sum_Type;
         Max_Sum  : Sum_Type;

         Prev_Max : Sum_Type with
            Ghost;

      begin
         Aoc.Open_File (File, Filename);

         loop
            Next_Sum (File, Curr_Sum, Error);
            exit when Curr_Sum = 0 or else Error /= None;

            Prev_Max := Max_Sum; -- ghost
            if Curr_Sum > Max_Sum then
               Max_Sum := Curr_Sum;
            end if;

            pragma Loop_Invariant
              (if Curr_Sum >= Prev_Max then Max_Sum = Curr_Sum
               else Max_Sum = Prev_Max);
         end loop;

         Ada.Text_IO.Close (File);

         if Is_Open (File) or else Error /= None then
            Put_Line ("day1 | part1: ERROR");
            return;
         end if;

         Put_Line ("day1 | part1: " & Sum_Type'Image (Max_Sum));
      end Part1;

      procedure Part2 is

         File     : Ada.Text_IO.File_Type;
         Error    : Error_Type;
         Curr_Sum : Sum_Type;
         Total    : Sum_Type;
         Element  : Sum_Type;

         --  Priority and natural element types are redundant here,
         --  we could just use the priority, itself. However, it's helpful
         --  for other challenges to have a generic heap...
         package Natural_Heap is new Max_Heap (Element_Type => Sum_Type);
         H : Natural_Heap.Heap_Type (3_000);
      begin
         Aoc.Open_File (File, Filename);

         loop
            Next_Sum (File, Curr_Sum, Error);
            exit when Curr_Sum = 0 or else Error /= None;

            --  see note above
            if Natural_Heap.Full (H) then
               Put_Line ("day1 | part2: ERROR - Heap full");
               return;
            end if;

            Natural_Heap.Insert (H, Curr_Sum, Natural (Curr_Sum));
         end loop;

         Ada.Text_IO.Close (File);

         if Is_Open (File) or else Error /= None then
            Put_Line ("day1 | part2: ERROR");
            return;
         end if;

         for I in 1 .. 3 loop
            if Natural_Heap.Empty (H) then
               Put_Line ("day1 | part2: ERROR - Heap empty");
               return;
            end if;

            Natural_Heap.Pop (H, Element);

            if Sum_Type'Last - Total < Element then
               Put_Line ("day1 | part2: ERROR - Total overflow");
               return;
            end if;

            Total := Total + Element;
         end loop;

         Put_Line ("day1 | part2: " & Sum_Type'Image (Total));
      end Part2;

   begin
      Part1;
      Part2;
   end Run;
end Day1;
