with Interfaces; use Interfaces;

generic

   Screen_Width  : Natural;
   Screen_Height : Natural;

package SDL_Display is

   subtype SDL_Pixel is Unsigned_16;

   function Rendering return Boolean;

   procedure Start_Render
     with Pre => not Rendering,
         Post => Rendering;

   procedure Draw_Vertical_Line (X, Start_Y, Stop_Y : Integer; C : SDL_Pixel)
     with Pre => Rendering;

   procedure Fill (C : SDL_Pixel)
     with Pre => Rendering;

   procedure End_Render
     with Pre => Rendering,
         Post => not Rendering;

   function To_SDL_Color (R, G, B : Unsigned_8) return SDL_Pixel;

end SDL_Display;
