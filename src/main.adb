with Interfaces;    use Interfaces;
with Ada.Real_Time; use Ada.Real_Time;

with Ada_Voxel;
with SDL_Display;
with Color_Map;
with Height_Map;
with Keyboard;

with Ada.Numerics.Generic_Elementary_Functions;

procedure Main is

   Screen_Width  : constant := 800;
   Screen_Height : constant := 600;

   package Float_Functions is
     new Ada.Numerics.Generic_Elementary_Functions (Float);

   package Display is new SDL_Display (Screen_Width, Screen_Height);

   function Color_Map (X, Y : Integer) return Display.SDL_Pixel;

   function Height_Map (X, Y : Integer) return Integer;

   package Voxel is new Ada_Voxel
     (Color              => Display.SDL_Pixel,
      Screen_Width       => Screen_Width,
      Screen_Height      => Screen_Height,
      Color_Map          => Color_Map,
      Height_Map         => Height_Map,
      Draw_Vertical_Line => Display.Draw_Vertical_Line);

   ---------------
   -- Color_Map --
   ---------------

   function Color_Map (X, Y : Integer) return Display.SDL_Pixel is
      C   : constant Unsigned_8 :=
        Standard.Color_Map.Map ((Integer (X) mod 1024) + 1024 * (Integer (Y) mod 1024));
      RGB : constant Standard.Color_Map.RGB := Standard.Color_Map.Palette (C);
   begin
      return Display.To_SDL_Color (RGB.R, RGB.G, RGB.B);
   end Color_Map;

   ----------------
   -- Height_Map --
   ----------------

   function Height_Map (X, Y : Integer) return Integer is
   begin
      return Integer (Standard.Height_Map.Map ((Integer (X) mod 1024) + 1024 * (Integer (Y) mod 1024)));
   end Height_Map;

   Cam_X      : Float := 1060.0;
   Cam_Y      : Float := -350.0;
   Cam_Angle  : Float := 5.4;
   Cam_Height : Float := 120.0;

   Period       : constant Time_Span := To_Time_Span (1.0 / 60.0);
   Next_Release : Time := Clock + Period;

begin
   loop
      Keyboard.Update;
      if Keyboard.Pressed (Keyboard.Up) then
         Cam_Height := Cam_Height + 0.75;
      end if;
      if Keyboard.Pressed (Keyboard.Down) then
         Cam_Height := Cam_Height - 0.75;
      end if;
      if Keyboard.Pressed (Keyboard.Left) then
         Cam_Angle := Cam_Angle + 0.03;
      end if;
      if Keyboard.Pressed (Keyboard.Right) then
         Cam_Angle := Cam_Angle - 0.03;
      end if;
      if Keyboard.Pressed (Keyboard.Forward) then
         Cam_X := Cam_X - Float_Functions.Sin (Cam_Angle);
         Cam_Y := Cam_Y - Float_Functions.Cos (Cam_Angle);
      end if;
      if Keyboard.Pressed (Keyboard.Backward) then
         Cam_X := Cam_X + Float_Functions.Sin (Cam_Angle);
         Cam_Y := Cam_Y + Float_Functions.Cos (Cam_Angle);
      end if;
      if Keyboard.Pressed (Keyboard.Esc) then
         return;
      end if;

      if Cam_Height < Float (Height_Map (Integer (Cam_X), Integer (Cam_Y))) + 15.0 then
         Cam_Height := Float (Height_Map (Integer (Cam_X), Integer (Cam_Y))) + 15.0;
      end if;

      Display.Start_Render;

      Display.Fill (Display.To_SDL_Color (135, 206, 250));

      Voxel.Render (Cam_X,
                    Cam_Y,
                    Cam_Angle,
                    Cam_Height,
                    Horizon      => 60.0,
                    Distance     => 400.0,
                    Scale_Height => 200.0);
      Display.End_Render;

--        delay until Next_Release;
--        Next_Release := Next_Release + Period;
   end loop;
end Main;
