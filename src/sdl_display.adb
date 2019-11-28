with SDL;
with SDL.Video.Windows;
with SDL.Video.Windows.Makers;
with SDL.Video.Surfaces;
with SDL.Video.Palettes; use SDL.Video.Palettes;
with SDL.Video.Pixels;
with SDL.Video.Pixel_Formats; use SDL.Video.Pixel_Formats;
with SDL.Video.Textures; use SDL.Video.Textures;
with SDL.Video.Textures.Makers;
with SDL.Video.Renderers;
with SDL.Video.Renderers.Makers;
use SDL.Video;

with Interfaces.C; use Interfaces.C;
with Ada.Unchecked_Conversion;
with System; use System;

package body SDL_Display is

   W          : SDL.Video.Windows.Window;
   Renderer   : SDL.Video.Renderers.Renderer;
   Texture    : SDL.Video.Textures.Texture;
   SDL_Pixels : System.Address := System.Null_Address;

   type Texture_1D_Array is array (Natural range <>)
     of aliased SDL_Pixel;

   procedure Lock is new SDL.Video.Textures.Lock
     (Pixel_Pointer_Type => System.Address);
   
   function Rendering return Boolean
   is (SDL_Pixels /= System.Null_Address);

   ------------------
   -- Start_Render --
   ------------------

   procedure Start_Render is
   begin
      Lock (Texture, SDL_Pixels);
   end Start_Render;

   ------------------------
   -- Draw_Vertical_Line --
   ------------------------

   procedure Draw_Vertical_Line
     (X, Start_Y, Stop_Y : Integer;
      C : SDL_Pixel)
   is
      Width         : constant Natural := Texture.Get_Size.Width;
      Height        : constant Natural := Texture.Get_Size.Height;
      Bounded_Start : constant Natural := (if Start_Y > 0 then Start_Y else 0);
   begin
      if X in 0 .. Width - 1 then
         declare
            Actual_Pixels : Texture_1D_Array (0 .. Natural (Width * Height - 1))
              with
                Address => SDL_Pixels;
            
         begin
            for Y in Bounded_Start .. Integer'Min (Stop_Y, Height - 1) loop
               Actual_Pixels (X + Y * Natural (Width)) := C;
            end loop;
         end;
      end if;
   end Draw_Vertical_Line;

   ----------
   -- Fill --
   ----------

   procedure Fill (C : SDL_Pixel) is
      Width      : constant Natural := Texture.Get_Size.Width;
      Height     : constant Natural := Texture.Get_Size.Height;
   begin
      declare
         Actual_Pixels : Texture_1D_Array (0 .. Natural (Width * Height - 1))
           with
             Address => SDL_Pixels;

      begin
         for Elt of Actual_Pixels loop
            Elt := C;
         end loop;
      end;
   end Fill;

   ----------------
   -- End_Render --
   ----------------

   procedure End_Render is
      Width  : constant Natural := Texture.Get_Size.Width;
      Height : constant Natural := Texture.Get_Size.Height;
   begin
      Texture.Unlock;
      SDL_Pixels := System.Null_Address;
      Renderer.Clear;
      Renderer.Copy (Texture, To => (0,
                                     0,
                                     int (Width),
                                     int (Height)));
      Renderer.Present;
   end End_Render;

   ------------------
   -- To_SDL_Color --
   ------------------

   function To_SDL_Color (R, G, B : Unsigned_8) return SDL_Pixel is
      RB : constant Unsigned_16 :=
        Shift_Right (Unsigned_16 (R), 3) and 16#1F#;
      GB : constant Unsigned_16 :=
        Shift_Right (Unsigned_16 (G), 2) and 16#3F#;
      BB : constant Unsigned_16 :=
        Shift_Right (Unsigned_16 (B), 3) and 16#1F#;
   begin
      return (Shift_Left (RB, 11) or Shift_Left (GB, 5) or BB);
   end To_SDL_Color;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      if not SDL.Initialise (Flags => SDL.Enable_Screen) then
         raise Program_Error with "SDL Video init failed";
      end if;

      SDL.Video.Windows.Makers.Create
        (W, "Ada Voxel",
         0,
         0,
         Screen_Width,
         Screen_Height,
         Flags    => SDL.Video.Windows.Resizable);

      SDL.Video.Renderers.Makers.Create (Renderer, W);

      SDL.Video.Textures.Makers.Create
        (Tex      => Texture,
         Renderer => Renderer,
         Format   => SDL.Video.Pixel_Formats.Pixel_Format_RGB_565,
         Kind     => SDL.Video.Textures.Streaming,
         Size     => (Screen_Width,
                      Screen_Height));
   end Initialize;

begin
   Initialize;
end SDL_Display;
