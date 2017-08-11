\ Could probably speed things up by not using a counter var but
\ replace it with a time threshold var so we're referencing the single #FRAMES counter

empty
include le/le
import bu/mo/rsort

autodata ex/le/ct
    21 36 2200man.image subdivide
    18 20 alfador.image subdivide
    21 28 fairgirl.image subdivide

\ ENUM doesn't work as expected...
0 constant DIR_DOWN
1 constant DIR_UP
2 constant DIR_RIGHT
3 constant DIR_LEFT

var dir    \ direction, see above enums
var img    \ current image used for animation; tied to animation data (flipbooks)
var data   \ static NPC data, like animation pointers
    \ internal:
    var anm  \ animation pointer
    var ctr  \ animation counter
    var spd  \ higher is slower; set by ANIMATE; note there is a hardcoded value passed by NPC-SPRITE

: ?anmloop  anm @ @ 0 >= ?exit  anm @ cell+ @ anm ! ;
: animate  ( speed -- adr | 0 )  \ adr points to a cell in the animation data
    spd !
    anm @ if  1 ctr +!  ctr @ spd @ >= if  0 ctr !  cell anm +!  ?anmloop  then  anm @
    else  0  then ;

: flipbook:  ( -- <name> [data] loopdest )  \ first cell should be an image
    create  here cell+ ( loopdest )  [char] ; parse evaluate  -1 ,  ( loopdest ) ,
    does>   @+  img !  anm !  ;
: [loop]  drop here ;

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
: chrw  img @ subw @ ;
: sprh  img @ subh @ ;
: chrh  16 ;
: >feet  ( y -- y )  sprh - 4 + ;
: npc-sprite  16 animate @ img @ afsubimg  at@ >feet 2af  flip@  al_draw_bitmap_region ;
: npc   ( -- <name> )  ( me=obj -- )    create
    does>  data !  DIR_DOWN turn  draw> npc-sprite ;

npc girl  ' girl-down , ' girl-up , ' girl-left , ' girl-left ,
                    0 ,         0 ,      FLIP_H ,           0 ,

npc man   ' man-down , ' man-up , ' man-left , ' man-left ,
                   0 ,        0 ,     FLIP_H ,          0 ,

npc cat   ' cat-down , ' cat-up , ' cat-left , ' cat-left ,
                   0 ,        0 ,     FLIP_H ,          0 ,


: compiled  ( addr -- addr cells )  here over - cell/ s>p ;

\ Depthsort by Y position
\ : zdepth@  's zdepth @ ;
: objy@  's y @ ;
: sort  ['] objy@ rsort ;

\ Not sure if I need to factor any of this or just copy and paste.
: drawem  ( addr cells -- )  cells bounds do  i @ me!  draw  cell +loop ;
: enqueue  objects each>  hide @ ?exit  me , ;
: draw-sorted  here dup  enqueue  compiled  2dup sort  drawem  reclaim ;



\ Random walking logic; doing it without tasks to avoid unnecessary coupling
\ quick n' dirty !!!
var wc  \ walk counter, at 0 NPC will stop and after a bit turn in a random direction and walk.
        \ if the NPC hits the boundaries it will just be impeded by a force field.

defer wander
defer walk
: walkv  dir @ case
        DIR_DOWN  of 0 0.5   exit endof
        DIR_UP    of 0 -0.5  exit endof
        DIR_RIGHT of 0.5 0   exit endof
        DIR_LEFT  of -0.5 0  exit endof
    endcase
    0 0 ;
: -wc  wc --  wc @ -1 > ;
: ?turn  4 rnd turn ;
: aboutface  dir @ 1 xor turn ;
: limit
    x @ 0 <  x @ displayw 3 / chrw - > or
    y @ chrh < or  y @ displayh 3 / > or if  aboutface  walk  then
    x 2v@  0 chrh  displaywh 3 3 2/  chrw 0 2- 2clamp  x 2v!
    ;
: :is  :noname  postpone [  [compile] is  ] ;
:is walk   walkv vx 2v!
    0.5 2 between fps * wc !
    act>  limit  -wc ?exit  wander ;
:is wander  0 0 vx 2v!
    1 3 between fps * wc !
    act>  limit  -wc ?exit  ?turn walk ;


\ Create a bunch of randomized NPC's
create roster  ' girl , ' man , ' cat ,
: someone   3 rnd cells roster + @  execute ;
: sprinkle  0 do  displaywh 3 3 2/ 2rnd at  one  someone  ?turn  wander  loop ;

\ 3X scaling
transform m0  m0 3 3 2af  al_scale_transform
: magnified  grey backdrop  m0 al_use_transform  ;


\ Do it
' magnified is prerender
' draw-sorted is render
250 sprinkle
