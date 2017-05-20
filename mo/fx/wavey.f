\ wavey render effect.  render a bitmap row-by-row with sine based offset

\ this version performs the wavey effect on the destination X
: draw-bitmap-wavey  ( bitmap sx sy sw sh dx dy angle speed strength -- )
    locals| strength speed angle dy dx sh sw sy sx bitmap |
    sy sh bounds do
        bitmap  sx  i  sw  1  4af  dx angle sin strength * +  dy  2af  0 al_draw_bitmap_region
        speed +to angle
        1 +to dy
    loop ;

\ this version performs the wavey effect on the source X
: draw-bitmap-wavey'  ( bitmap sx sy sw sh dx dy angle speed strength -- )
    locals| strength speed angle dy dx sh sw sy sx bitmap |
    sy sh bounds do
        bitmap  sx  angle sin strength * +   i  sw  1  4af  dx dy 2af  0 al_draw_bitmap_region
        speed +to angle
        1 +to dy
    loop ;

