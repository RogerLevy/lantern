\ Basic graphics wordset
bu:
    import mo/pen    \ by doing this, the Pen module is available to Bubble with no extra work
                     \ (and Draw inherits the imported Pen.)
    idiom draw:

private:
    : push postpone >r ; immediate
    : pop postpone r> ; immediate
    : 2push  postpone push postpone push ; immediate
    : 2pop  postpone pop postpone pop ; immediate
public:

create fore 4 cells allot
: colorf  ( f: r g b a )  4sf 2swap fore 2v! fore 2 cells + 2v! ;
: color   ( r g b a )  2af 2swap 2af fore 2v! fore 2 cells + 2v! ;
: color@af  fore @+ swap @+ swap @+ swap @ ;
: color32   ( $AARRGGBB -- )  hex>color color ;

\ Bitmaps, backbuffer
: onto  pop  al_get_target_bitmap push  swap al_set_target_bitmap  call  pop al_set_target_bitmap ;
: movebmp  ( src sx sy w h ) write-rgba blend>  at@ 0 al_draw_bitmap ;
: bmp   ( w h -- bmp ) 2i al_create_bitmap ;
: clearbmp  ( r g b a bmp )  onto 4af al_clear_to_color ;
: backbuf  display al_get_backbuffer ;
: loadbmp  zstring al_load_bitmap ;
: savebmp  push zstring pop al_save_bitmap ;
: subbmp   ( bmp w h ) at@ 2i 2swap 2i al_create_sub_bitmap ;
: backdrop  backbuf onto  color@af al_clear_to_color ;

\ Predefined Colors
fixed
: 8>p  s>f 255e f/ f>p ;
: createcolor create 8>p swap 8>p rot 8>p , , , 1 ,  does> 4@ color ;
hex
00 00 00 createcolor black 40 40 40 createcolor dgrey
80 80 80 createcolor grey b0 b0 b0 createcolor lgrey
ff ff ff createcolor white f8 e0 a0 createcolor beige
ff 80 ff createcolor pink ff 00 00 createcolor red
80 00 00 createcolor dkred ff 80 00 createcolor orange
80 40 00 createcolor brown ff ff 00 createcolor yellow
80 80 00 createcolor dyellow 80 ff 00 createcolor neon
00 ff 00 createcolor green 00 80 00 createcolor dgreen
00 ff ff createcolor cyan 00 80 80 createcolor dcyan
00 00 ff createcolor blue 00 00 80 createcolor dblue
80 80 ff createcolor lblue 80 00 ff createcolor violet
40 00 80 createcolor dviolet ff 00 ff createcolor magenta
80 00 80 createcolor dmagenta ff ff 80 createcolor lyellow
e0 e0 80 createcolor khaki
fixed

\ Bitmap drawing utilities - f stands for flipped
\  All of these words use the current color.
\  Not all effect combinations are available; these are
\  intended as conveniences.  For more flexibility or
\  speed use Allegro's drawing or primitive functions directly.
\  To draw regions of bitmaps, use Allegro's draw bitmap region functions directly
\  or use sub bitmaps (see subbmp).
\  After each call to one of these words, the current color is reset to white.

: drawf  ( bmp flip )  push  color@af  at@ 2af  pop al_draw_tinted_bitmap  white ;
: rdrawf ( bmp ang flip )
    locals| flip ang bmp |
    bmp  color@af  0 0 ang 3af  flip  al_draw_tinted_rotated_bitmap  white ;
: sdrawf  ( bmp dw dh flip )
    locals| flip dh dw bmp |
    bmp  color@af  0 0 bmp bmpwh 4af  at@ dw dh 4af  flip  al_draw_tinted_scaled_bitmap white ;
: srdrawf ( bmp sx sy ang flip )
    locals| flip ang sy sx bmp |
    bmp  0 0 bmp bmpwh 4af  color@af  0 0 at@ 4af  sx sy ang 3af  flip  al_draw_tinted_scaled_rotated_bitmap  white ;
: udrawf  ( bmp scale flip )
    locals| flip scale bmp |
    bmp  color@af  0 0 bmp bmpwh 4af  at@ bmp bmpwh scale dup 2* 4af  flip  al_draw_tinted_scaled_bitmap  white ;

: draw   ( bmp ) 0 drawf ;
: rdraw  ( bmp ang )  0 rdrawf ;
: sdraw  ( bmp dw dh )  0 sdrawf ;
: srdraw  ( bmp sx sy ang )  0 srdrawf ;
: nudraw  ( bmp sx sy )  0 dup srdrawf ;
: udraw  ( bmp scale )  0 udrawf ;

\ Text
variable fnt
: text  ( str count -- )  zstring push  color@af fnt @ at@ 2af ALLEGRO_ALIGN_LEFT pop al_draw_text ;
: rtext ( str count -- )  zstring push  color@af fnt @ at@ 2af ALLEGRO_ALIGN_RIGHT pop al_draw_text ;
: ctext ( str count -- )  zstring push  color@af fnt @ at@ 2af ALLEGRO_ALIGN_CENTER pop al_draw_text ;

\ Primitives
\ -1 = hairline thickness
: line   at@ 2swap 4af color@af -1e 1sf al_draw_line ;
: +line  at@ 2+ line ;
: line+  2dup +line +at ;
: pixel  at@ 2af  color@af  al_draw_pixel ;
: tri  ( x y x y x y ) 2push 4af 2pop 2af color@af -1e 1sf al_draw_triangle ;
: trif  ( x y x y x y ) 2push 4af 2pop 2af color@af al_draw_filled_triangle ;
: rect  ( w h )  at@ 2swap 2over 2+ 4af color@af -1e 1sf al_draw_rectangle ;
: rectf  ( w h )  at@ 2swap 2over 2+ 4af color@af al_draw_filled_rectangle ;
: capsule  ( w h rx ry )  2push at@ 2swap 2over 2+ 4af 2pop 2af color@af -1e 1sf al_draw_rounded_rectangle ;
: capsulef  ( w h rx ry )  2push at@ 2swap 2over 2+ 4af 2pop 2af color@af al_draw_filled_rounded_rectangle ;
: circle  ( r ) at@ rot 3af color@af -1e 1sf al_draw_circle ;
: circlef ( r ) at@ rot 3af color@af al_draw_filled_circle ;
: ellipse  ( rx ry ) at@ 2swap 4af color@af -1e 1sf al_draw_ellipse ;
: ellipsef ( rx ry ) at@ 2swap 4af color@af al_draw_filled_ellipse ;
: arc  ( r a1 a2 )  push at@ 2swap 4af pop 1af color@af -1e 1sf al_draw_arc ;

: untinted  white ;
