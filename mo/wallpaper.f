bu: module wallpaper:

\ repeating image display
\  image's dimensions must be power of 2.d

private:
    create v
    \ x y z u v r g b a
      0e sf, 0e sf, 0e sf,           0e sf, 0e sf,            1e sf, 1e sf, 1e sf, 1e sf,
      gfxw 1f sf, 0e sf, 0e sf,      gfxh 1f sf, 0e sf,       1e sf, 1e sf, 1e sf, 1e sf,
      0e sf, gfxh 1f sf, 0e sf,      0e sf, gfxh 1f sf,       1e sf, 1e sf, 1e sf, 1e sf,
      gfxw 1f sf, gfxh 1f sf, 0e sf,  gfxw 1f sf, gfxh 1f sf,  1e sf, 1e sf, 1e sf, 1e sf,


    : uv[]  /ALLEGRO_VERTEX * v + ALLEGRO_VERTEX-u ;
    : uv!  uv[]  >r 2af r> 2v! ;
public:

: draw-wallpaper  ( image x y -- )
  2dup 0 uv!  2dup gfxw u+ 1 uv!  2dup gfxh + 2 uv!  gfxw gfxh 2+ 3 uv!
  v 0 rot bmp @ 0 #4 ALLEGRO_PRIM_TRIANGLE_STRIP al_draw_prim drop ;
