
\ Some graphics helpers
: clear-to-color  ( r g b -- ) 1 4af al_clear_to_color ;
: bmpw   al_get_bitmap_width  s>p ;
: bmph   al_get_bitmap_height  s>p ;
: bmpwh  dup bmpw swap bmph ;
: soft  ( -- )
  al_get_new_bitmap_flags
  [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or ] literal or
  al_set_new_bitmap_flags ;
: crisp  ( -- )
  al_get_new_bitmap_flags
  [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or invert ] literal and
  al_set_new_bitmap_flags ;
16 cells struct /transform
: transform  create  here  /transform allot  al_identity_transform ;
transform m0
: 1-1  m0 al_use_transform ;

decimal
    : hold>  ( -- <code> )  1 al_hold_bitmap_drawing  r> call  0 al_hold_bitmap_drawing ;
    0 constant FLIP_NONE
    1 constant FLIP_H
    2 constant FLIP_V
    3 constant FLIP_HV
fixed
