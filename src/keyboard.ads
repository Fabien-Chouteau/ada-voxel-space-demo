package Keyboard is

   type Key_Kind is (Up, Down, Left, Right, Forward, Backward, Esc);

   procedure Update;

   function Pressed (Key : Key_Kind) return Boolean;

end Keyboard;
