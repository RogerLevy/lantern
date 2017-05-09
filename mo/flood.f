bu: idiom flood:

decimal

: ALLEGRO_COLOR  create 4 cells allot ;
ALLEGRO_COLOR oldClr
ALLEGRO_COLOR newClr
ALLEGRO_COLOR retClr

private:
    0 value s  \ stack memory top
    : empty?  sp@ s = ;
    : color=  4 cells dup -rot compare 0= ;
public:

: processPoint  ( oldx oldy x y -- x y oldx oldy | oldx oldy )
    locals| y x |
    retClr al_get_target_bitmap x y al_get_pixel
    oldClr retClr color= -exit
        x y 2swap
            2over newClr 4@ al_put_pixel
;
: al-floodfill  ( x y r g b a -- )
    4af newClr 4!
    2i
    al_get_target_bitmap dup bmpwh 2i locals| bmph bmpw bmp y x |
    bmp ALLEGRO_PIXEL_FORMAT_ANY ALLEGRO_LOCK_READWRITE al_lock_bitmap  drop
    oldClr bmp x y al_get_pixel
    oldClr newClr color= not if  \ if same color, nothing to do.
        518400 2 * cells allocate drop dup >r  518399 2 * cells + to s
        sp@ >r  s sp!
        x y
            2dup newClr 4@ al_put_pixel
        begin
            over ( x ) 0 > if  2dup -1 0 2+  processPoint  then
            dup  ( y ) 0 > if  2dup 0 -1 2+  processPoint  then
            over ( x ) bmpw 1 - < if  2dup 1 0 2+  processPoint  then
            dup  ( y ) bmph 1 - < if  2dup 0 1 2+  processPoint  then
            2drop
        empty? until
    then
    bmp al_unlock_bitmap
    r> sp!  r> free drop
;
