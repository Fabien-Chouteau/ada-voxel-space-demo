with Interfaces.C;    use Interfaces.C;
with SDL_SDL_h;       use SDL_SDL_h;
with SDL_SDL_video_h; use SDL_SDL_video_h;

package body SDL_Display is

   Display : access SDL_Surface;

   ------------------------
   -- Draw_Vertical_Line --
   ------------------------

   procedure Draw_Vertical_Line
     (X, Start_Y, Stop_Y : Integer;
      C : SDL_Pixel)
   is
      Buffer : array (0 .. Natural (Display.w * Display.h - 1))
        of SDL_Pixel
          with Address => Display.pixels;
   begin
      if X in 0 .. Screen_Width - 1 and then Start_Y in 0 .. Screen_Height - 1 then
         for Y in Start_Y .. Integer'Min (Stop_Y, Screen_Height - 1) loop
            Buffer (X + Y * Natural (Display.w)) := C;
         end loop;
      end if;
   end Draw_Vertical_Line;

   ----------
   -- Fill --
   ----------

   procedure Fill (C : SDL_Pixel) is
      Buffer : array (0 .. Natural (Display.w * Display.h - 1))
        of SDL_Pixel
          with Address => Display.pixels;
   begin
      for Elt of Buffer loop
         Elt := C;
      end loop;
   end Fill;

   ------------
   -- Update --
   ------------

   procedure Update is
   begin
      SDL_UpdateRect (Display, 0, 0, 0, 0);
   end Update;

   ------------------
   -- To_SDL_Color --
   ------------------

   function To_SDL_Color (R, G, B : Unsigned_8) return SDL_Pixel
   is (SDL_Pixel (SDL_MapRGB (Display.format,
                              unsigned_char (R),
                              unsigned_char (G),
                              unsigned_char (B))));

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin

      if SDL_Init (SDL_INIT_VIDEO) < 0 then
         raise Program_Error with "SDL Video init failed";
         return;
      end if;

      Display := SDL_SetVideoMode (int (Screen_Width),
                                   int (Screen_Height),
                                   SDL_Pixel'Size,
                                   SDL_SWSURFACE);

      if Display = null then
         raise Program_Error with "Cannot create SDL display";
      end if;
   end Initialize;

begin
   Initialize;
end SDL_Display;
