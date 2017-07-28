empty
include le/le
import bu/mo/rsort

autodata ex/le/ct
    21 36 2200man.image subdivide
    18 20 alfador.image subdivide
    21 28 fairgirl.image subdivide

0
    enum DIR_DOWN
    enum DIR_UP
    enum DIR_RIGHT
    enum DIR_LEFT
drop

var dir
var img
var data
    \ internal:
    var anm
    var ctr
    var spd  \ higher is slower

: ?anmloop  anm @ @ 0 >= ?exit  anm @ cell+ @ anm ! ;
: animate  ( speed -- adr | 0 )  \ adr points to a cell in the animation data
    spd !
    anm @ if  1 ctr +!  ctr @ spd @ >= if  0 ctr !  cell anm +!  ?anmloop  then  anm @
    else  0  then ;

variable loopdest
: flipbook:  ( -- <name> [data] )  \ first cell should be an image
    create  here cell+ loopdest !  [char] ; parse evaluate  -1 , loopdest @ ,
    does>   @+  img !  anm !  ;
: [loop]  here loopdest ! ;

flipbook: girl-down  fairgirl.image , 0 , 1 , 0 , 2 , ;
flipbook: girl-left  fairgirl.image , 3 , 4 , 3 , 4 , ;
flipbook: girl-up    fairgirl.image , 5 , 6 , 5 , 7 , ;
flipbook: man-down   2200man.image  , 1 , 2 , 3 , 4 , ;
flipbook: man-left   2200man.image  , 5 , 6 , 5 , 7 , ;
flipbook: man-up     2200man.image  , 9 , 10 , 11 , 12 , ;
flipbook: cat-down   alfador.image  , 1 , 2 , 3 , 4 , ;
flipbook: cat-left   alfador.image  , 6 , 7 , 8 , 7 , ;
flipbook: cat-up     alfador.image  , 10 , 11 , 12 , 13 , ;


: data@   ( n -- value )  cells data @ + @ ;
: flipdata@  4 + data@ ;
: sprite  ( dir -- )   pfloor data@ execute ;
: turn    ( dir -- )   pfloor dup dir !  sprite ;
: flip@  dir @ flipdata@ ;
: npc-sprite  16 animate @ img @ afsubimg  at@ 2af  flip@  al_draw_bitmap_region ;
: npc   ( -- <name> )  ( -- me=newobj )    create
    does>  objects one  data !  DIR_DOWN turn  draw> npc-sprite ;

npc girl  ' girl-down , ' girl-up , ' girl-left , ' girl-left ,
                            0 ,         0 ,      FLIP_H ,           0 ,

npc man   ' man-down , ' man-up , ' man-left , ' man-left ,
                            0 ,         0 ,      FLIP_H ,           0 ,

npc cat   ' cat-down , ' cat-up , ' cat-left , ' cat-left ,
                            0 ,         0 ,      FLIP_H ,           0 ,

create roster  ' girl , ' man , ' cat ,

: someone   3 rnd cells roster + @  execute ;
: sprinkle  0 do  displaywh 3 3 2/ 2rnd at  someone  4 rnd turn  loop ;

transform m0  m0 3 3 2af  al_scale_transform
: 3x  grey backdrop  m0 al_use_transform  ;
' 3x is prerender

250 sprinkle
