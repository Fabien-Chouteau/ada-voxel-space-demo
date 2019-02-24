with Interfaces; use Interfaces;

generic

   Screen_Width  : Natural;
   Screen_Height : Natural;

package SDL_Display is

   subtype SDL_Pixel is Unsigned_16;

   procedure Draw_Vertical_Line (X, Start_Y, Stop_Y : Integer; C : SDL_Pixel);

   procedure Fill (C : SDL_Pixel);

   procedure Update;

   function To_SDL_Color (R, G, B : Unsigned_8) return SDL_Pixel;

end SDL_Display;
