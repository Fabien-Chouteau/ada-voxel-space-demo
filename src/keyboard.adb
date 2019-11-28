with SDL.Events;           use SDL.Events;
with SDL.Events.Events;    use SDL.Events.Events;
with SDL.Events.Keyboards; use SDL.Events.Keyboards;

package body Keyboard is

   Is_Pressed : array (Key_Kind) of Boolean := (others => False);

   ------------
   -- Update --
   ------------

   procedure Update is
      Event   : SDL.Events.Events.Events;
      Pressed : Boolean;
   begin
      while SDL.Events.Events.Poll (Event) loop

         if Event.Common.Event_Type in Key_Down | Key_Up then

            Pressed := Event.Common.Event_Type = Key_Down;

            case Event.Keyboard.Key_Sym.Scan_Code is
            when Scan_Code_Left =>
               Is_Pressed (Left) := Pressed;
            when Scan_Code_Right =>
               Is_Pressed (Right) := Pressed;
            when Scan_Code_Down =>
               Is_Pressed (Backward) := Pressed;
            when Scan_Code_Up =>
               Is_Pressed (Forward) := Pressed;
            when Scan_Code_Page_Down =>
               Is_Pressed (Down) := Pressed;
            when Scan_Code_Page_Up =>
               Is_Pressed (Up) := Pressed;
            when Scan_Code_Escape =>
               Is_Pressed (Esc) := Pressed;
            when others =>
               null;
            end case;
         end if;
      end loop;
   end Update;

   -------------
   -- Pressed --
   -------------

   function Pressed (Key : Key_Kind) return Boolean
   is (Is_Pressed (Key));

end Keyboard;

