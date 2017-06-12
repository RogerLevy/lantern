bu: idiom cgrid:

\ : extents  0 0 4096 4096 ;

\ Fast collision manager object.  Does efficient collision checks of massive
\ numbers of AABB (axis-aligned bounding boxes).
\ Very useful for broad-phase collision checks.

\ Notes:
\  - Doesn't support hitboxes bigger than sectw x secth

0 value cgrid  \ current cgrid

: cgrid-var  create dup , cell+ does> @ cgrid + ;

private:
  0
    xvar x1    xvar y1
    xvar x2    xvar y2
    xvar s1    xvar s2  \ sectors
    xvar s3    xvar s4
  struct /cbox

public: : /cbox /cbox ;

: cbox!  ( x y w h cbox -- )  &o for>  2over 2+  #1 #1 2-  o x2 2v!  o x1 2v! ;
: cbox@  ( cbox -- x y w h ) dup >r x1 2v@ r> x2 2v@  2over 2-  #1 #1 2+ ;
: 4@  ( cbox -- x1 y1 x2 y2 ) dup 2v@ rot cell+ cell+ 2v@ ;

private:
  #8 #12 + constant bitshift
public:
256 constant sectw
256 constant secth
\ the size of each sector is a constant.
\  use a smaller size if you're going to have lots of small objects.
\  use a larger size if you're going to have lots of large objects.

private:
  \ variable topleft
  \ variable topright
  \ variable btmleft
  variable lastsector
  variable lastsector2

  defer collide  ( ... true cbox1 cbox2 -- ... keepgoing? )
  \ defer cfilter  ( cbox1 cbox2 ... cbox1 cbox2 flag )  ' true is cfilter

public:

0
  cgrid-var cols
  cgrid-var rows
  cgrid-var sectors         \ link to array of sectors
  cgrid-var links           \
  cgrid-var i.link          \ points to structure in links:  link to next ( i.link , box , )
struct /cgrid


private:

  decimal
  : sector  ( x y -- addr )
    ( y ) bitshift >> cols @ p* swap ( x ) bitshift >> + cells sectors @ + ;
  fixed

    : overlap? ( xyxy xyxy -- flag )
      2swap 2rot rot > -rot <= and >r rot >= -rot < and r> and ;
      \ find if 2 rectangles (x1,y1,x2,y2) and (x3,y3,x4,y4) overlap.

  : link  ( box sector -- )
    >r
    i.link @ cell+ !  \ 1. link box
    r@ @ i.link @ !  \ 2. link the i.link to address in sector
    i.link @ r> !   \ 3. store current link in sector
    2 cells i.link +! ;  \ 4. and increment current link

  : box>box?  ( box1 box2 -- box1 box2 flag )
    2dup = if  false  exit  then                                                \ boxes can't collide with themselves!
    \ cfilter not if  false exit  then
    2dup >r  4@  r> 4@   overlap? ;

  0 value cnt
  : checkSector  ( cbox1 sector -- flag )
    0 to cnt
    swap true locals| flag cbox1 |
    begin ( sector ) @ ( link|0 ) dup flag and while
      ( link ) >r  cbox1  r@ cell+ @  box>box? if
        flag -rot  collide  to flag
      else
        ( box box ) 2drop
      then
      r> ( link )
      1 +to cnt
    repeat
    ( link|0 ) drop
    flag
    ;

  : ?checkSector  ( cbox1 sector|0 -- flag )  \ check a cbox against a sector
    dup if  checkSector  else  nip  then ;

  : ?corner  ( x y -- 0 | sector )  \ see what sector the given coords are in & cull already checked corners
    sector
    ;
    \ dup lastsector @ = if  drop 0  exit  then
    \ dup lastsector2 @ = if  drop 0  exit  then
    \ lastsector @ lastsector2 !
    \ dup  lastsector ! ;

public:

: resetGrid ( cgrid -- )
  to cgrid
  sectors @ cols 2v@ * ierase
  links @ i.link ! ;

: addCbox  ( cbox cgrid -- )
  to cgrid
  ( box ) &o for>  lastsector off  lastsector2 off
  o x1 2v@       ?corner ?dup if  dup o s1 !  o swap link  else  o s1 off  then
  o x2 @ o y1 @  ?corner ?dup if  dup o s2 !  o swap link  else  o s2 off  then
  o x1 @ o y2 @  ?corner ?dup if  dup o s4 !  o swap link  else  o s4 off  then
  o x2 2v@       ?corner ?dup if  dup o s3 !  o swap link  else  o s3 off  then
  ( topleft off topright off btmleft off ) ;

\ perform collision checks.  assumes box has already been added to the cgrid.
\   this avoids unnecessary work for the CPU.
: checkGrid  ( cbox1 xt cgrid -- )  \ xt is the response; see COLLIDE
  to cgrid  is collide
  &o for>
  o dup s1 @ ?checkSector -exit
  o dup s2 @ ?checkSector -exit
  o dup s3 @ ?checkSector -exit
  o dup s4 @ ?checkSector drop ;

\ this doesn't require the box to be added to the cgrid
: checkCbox  ( cbox1 xt cgrid -- )  \ xt is the response; see COLLIDE
  to cgrid  is collide
  &o for>  lastsector off lastsector2 off
    o dup x1 2v@       ?corner  ?checkSector -exit
    o dup x2 @ o y1 @  ?corner  ?checkSector -exit
    o dup x1 @ o y2 @  ?corner  ?checkSector -exit
    o dup x2 2v@       ?corner  ?checkSector drop ;

: >#sectdims  sectw 1 - secth 1 - 2+  sectw secth 2/  2pfloor ;

: collisionGrid  ( maxboxes width height -- <name> )
  create  /cgrid allotment  to cgrid
  >#sectdims
  2dup cols 2v!  here sectors !  ( cols rows ) * cells /allot
                 here links !    ( maxboxes )  4 * 2 cells * /allot ;

: cgridSize  ( cgrid -- w h )
  to cgrid  cols 2v@  sectw secth 2* ;

