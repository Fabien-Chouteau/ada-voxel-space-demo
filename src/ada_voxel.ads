generic
   type Color (<>) is private;

   Screen_Width  : Positive;
   Screen_Height : Positive;

   with function Color_Map (X, Y : Integer) return Color;
   with function Height_Map (X, Y : Integer) return Integer;
   with procedure Draw_Vertical_Line (X, Start_Y, Stop_Y : Integer; C : Color);

package Ada_Voxel is

   procedure Render (Cam_X        : Float;
                     Cam_Y        : Float;
                     Cam_Angle    : Float;
                     Cam_Height   : Float;
                     Horizon      : Float;
                     Distance     : Float;
                     Scale_Height : Float);

end Ada_Voxel;
