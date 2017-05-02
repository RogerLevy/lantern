\ Actor system - Actor class and initialization
le:

\ --------------------------------------------------------------------------------------------------
\ particle parent class; quicker to instantiate than the full Actor class
node inherit
    var x  var y  var vx  var vy  var 'show  var 'act  var flags
    container sizeof @ field kids  \ likely not needed by most particles but simplifies processing of Actors
subclass particle

\ flags
0 's flags  #1
    flag hflip#  flag vflip#  flag en#  flag vis#  flag pers#  flag rst#  flag unl#  flag static#
value particle-flags  drop

\ static vars
quality 'init    \ XT executed when particle is created
quality 'start   \ XT executed when particle is actually started
include le/script
: particle-inherit  script-inherit ;
: particle-subclass  script-subclass ;

\ --------------------------------------------------------------------------------------------------
\ particle words
: start   me class @ 'start @ execute  rst# unset ;
: ?start  rst# set? -exit  start ;
: init   me class @ 'init @ execute ;
: ?show  vis# set? -exit  'show @ call ;
: ?act   rst# set? if  start  then  'act @ call ;
: show>  r> 'show !  vis# set ;                                             ( -- <code> )
: act>   r> 'act ! ;                                                        ( -- <code> )
: become  ( class -- )  me instance!  init ;
: dbg  ( particle -- ) dup be  class @ script @ set-idiom  private: ;
: :start  ( class -- ) :noname  over 'start !  script @ set-idiom private: ;

\ redefine `inherit` and `subclass`  to save and restore the current idiom.
\  NOTE: this cannot be done using the hooks due to when they are executed.
0 value ('idiom)  0 value (privately)
: inherit  'idiom @ to ('idiom)  privately @ to (privately)  inherit ;
: subclass  ('idiom) set-idiom  (privately) dup privately !  if private: else public: then  subclass ;
: extension  ('idiom) set-idiom  (privately) dup privately !  if private: else public: then
    extension ;

\ set up the particle base class.
particle proto @ to me                     \ set up the prototype
    ' noop >code 'show !
    ' noop >code 'act !
    vis# set  en# set  rst# set

'idiom @ inherit-idiom particle script !   \ create base idiom

' particle-inherit particle on-inherit !    \ set up the inherit/subclass hooks, to create the idiom tree.
' particle-subclass particle on-subclass !


\ --------------------------------------------------------------------------------------------------
\ The full actor class
particle inherit
    var boxx  var boxy  var boxw  var boxh  var hp  var maxHP  var atk  var def  var ang
    var sx  var sy  var orgx  var orgy  var cflags  var cmask  var 'hit  var startx  var starty
    var fr  var fg  var fb  var fa  var bmode
subclass actor

actor script:
    \ set up the actor prototype
    1.0 1.0 sx 2v!            \ initialize scale to 1,1 (fixed-points)
    1e 1sf dup dup dup fr 4!  \ initialize color to 1,1,1,1 (singles)
    ' noop >code  'hit !

    \ add multitasking capability to actor
    include le/task

    \ color tinting tools
    create fcolor 4 cells allot
    : !color   ( r g b a -- )  1af swap 1af 2swap 1af swap 1af fcolor ~!+ ~!+ ~!+ ! ;
    : !color32    ( i -- )  hex>color !color ;
    : !color24    ( i -- )  3hex>color 1 !color ;

