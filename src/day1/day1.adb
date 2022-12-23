with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1;

with Aoc;

package body Day1 with
   SPARK_Mode => On
is
   procedure Run (Filename : String) is
      type Error_Type is (None, Unexpected_Character, Overflow);

      procedure Next_Sum
        (File  :     Ada.Text_IO.File_Type; Sum : out Natural;
         Error : out Error_Type) with
         Pre  => Is_Open (File) and then Ada.Text_IO.Mode (File) = In_File
      is
         C             : Character;
         Running_Value : Natural := 0;
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

                  if Natural'Last - Sum < Running_Value then
                     Error := Overflow;
                     return;
                  end if;

                  Sum           := Sum + Running_Value;
                  Running_Value := 0;
               when '0' .. '9' =>
                  if Running_Value >
                    (Natural'Last -
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
         Curr_Sum : Natural;
         Max_Sum  : Natural := 0;

         Prev_Max : Natural with
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

         if Error /= None then
            Put_Line ("day1 | part1: ERROR");
            return;
         end if;

         Put_Line ("day1 | part1: " & Natural'Image (Max_Sum));
      end Part1;

      procedure Part2 is
      begin
         Put_Line ("day1 | part2: " & Integer'Image (0));
      end Part2;

   begin
      Part1;
      Part2;
   end Run;
end Day1;
