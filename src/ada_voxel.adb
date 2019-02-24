
with Ada.Numerics.Generic_Elementary_Functions;

package body Ada_Voxel is

   package Float_Functions is
     new Ada.Numerics.Generic_Elementary_Functions (Float);

   ------------
   -- Render --
   ------------

   procedure Render (Cam_X        : Float;
                     Cam_Y        : Float;
                     Cam_Angle    : Float;
                     Cam_Height   : Float;
                     Horizon      : Float;
                     Distance     : Float;
                     Scale_Height : Float)
   is
      Y_Buffer : array (0 .. Screen_Width - 1) of Integer := (others => Screen_Height);
      Dz       : Float := 1.0;
      Z        : Float := 1.0;
   begin
      while Z < Distance loop
         declare
            Sin              : Float := Float_Functions.Sin (Cam_Angle);
            Cos              : Float := Float_Functions.Cos (Cam_Angle);
            Left_X           : Float := (-Cos * Z - Sin * Z) + Cam_X;
            Left_Y           : Float := ( Sin * Z - Cos * Z) + Cam_Y;

            Right_X          : Float := ( Cos * Z - Sin * Z) + Cam_X;
            Right_Y          : Float := (-Sin * Z - Cos * Z) + Cam_Y;

            Dx               : constant Float := (Right_X - Left_X) / Float (Screen_Width);
            Dy               : constant Float := (Right_Y - Left_Y) / Float (Screen_Width);
            Height_On_Screen :          Float;
         begin

            for A in 0 .. Screen_Width - 1 loop

               Height_On_Screen := Cam_Height - Float (Height_Map (Integer (Left_X), Integer (Left_Y)));
               Height_On_Screen := Float (Height_On_Screen / Z) * Scale_Height + Horizon;

               Draw_Vertical_Line (A,
                                   Integer (Height_On_Screen),
                                   Integer (Y_Buffer (A)),
                                   Color_Map (Integer (Left_X), Integer (Left_Y)));

               if Integer (Height_On_Screen) < Y_Buffer (A) then
                  Y_Buffer (A) := Integer (Height_On_Screen);
               end if;

               Left_X := Left_X + Dx;
               Left_Y := Left_Y + Dy;
            end loop;
         end;

         Z := Z + Dz;
         Dz := Dz + 0.01;

      end loop;
   end Render;

end Ada_Voxel;
