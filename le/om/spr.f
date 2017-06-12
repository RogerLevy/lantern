\ Sprite game object mixin

\ no idioms are established or declared; this is meant to be re-compiled as needed,
\ presumably into roles.


obj:
import mo/draw
var sx var sy var ang var orgx var orgy var flip
var r var g var b var a
\ var bmode
\ used @ to parms

(  ALLEGRO_BITMAP-*bitmap float-sx float-sy float-sw float-sh float-r float-g float-b float-a float-cx float-cy float-dx float-dy float-xscale float-yscale float-angle int-flags -- )
: spritereg  ( bmp fx fy fw fh -- )  r 4@ 4af  orgx 2@ at@ 4af  sx 2@  ang @  3af  flip @
    al_draw_tinted_scaled_rotated_bitmap_region ;

: sprite  ( bmp -- )  r 4@ color  sx 2@  ang @  flip @  csrblitf ;

: /sprite  1 1 sx 2!  1 1 1 1 r 4! ;

[defined] dev [if]
    import mo/draw
    import mo/image
    image cat.image le/om/macak04.png
    : center  imagedims 0.5 0.5 2* orgx 2! ;
    : *cat  one  /sprite  cat.image center  draw>  cat.image bmp @ sprite  0.01 ang +! ;
    : world   grey backdrop  objects each> draw ;
    : physics  ;
    : test  go> render> world step> physics ;
    scene  displaywh 0.5 0.5 2* at  *cat  me value cat  2 2 sx 2!
[then]
