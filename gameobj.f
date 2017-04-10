\ game object system (inheritance-based)
\  adapted from Dark Blue

nodelist stage0      \ default stage
stage0 value stage   \ current stage

\ Every game object and actor has its own private idiom.
\ These fields implicitly address based on the ME pointer.
\ To change the ME pointer in a scalable way, use [[ ]] (set and fetch ME) and 's (access a field)
\ The prompt is extended to display the current object's address and class.
0 value me
: [[  " to me" evaluate ;  immediate
: ]]  " me" evaluate ;  immediate
: as  " to me" evaluate ; immediate
: as>  r>  me >r  rot to me  call  r> to me ;

: 's
  state @ if
    " me >r  to me " evaluate  bl parse evaluate  " r> as" evaluate
  else
    " me swap to me " evaluate  bl parse evaluate  " swap to me" evaluate
  then
; immediate
[defined] dev [if]
: field  create over , + does> @ me + ;
[else]
: field  create over , + immediate does> @ " me ?lit + " evaluate ;  \ faster but less debuggable version
[then]
: var  cell field ;
: flag  ( offset bitmask -- <name> offset bitmask<<1 )  ( -- bitmask adr )
    create dup , over , 1 <<
    does>  dup @ swap cell+ @ me + ;
: set?   @ and ;
: set    dup @ rot or swap ! ;
: unset  dup @ rot invert and swap ! ;
: xorset dup @ rot xor swap ! ;

\ basic game object: gameobj
\  simple enough to use for particles.
\  they don't store any transform info except for position.
\  physics, collision detection and transformation needs to be done programmatically for each kind of particle.
\  this is good for performance, since there is no "standard" rendering or collision detection forced on all particles
node inherit  var x  var y  var vx  var vy  var 'show  var 'act  var flags  subclass gameobj

0 's flags  #1
    flag hflip#  flag vflip#  flag en#  flag vis#  flag pers#  flag rst#  flag unl#  flag static#
value gameobj-flags  drop

\ static vars
staticvar 'onInit  \ XT executed when gameobj is created
staticvar 'onStart \ XT executed when gameobj is actually started

\ stage management
: all>  ( n nodelist -- )  ( n -- n )  \ shallow iteration.
    r> swap
        me >r
        ( nodelist )  first @  begin  dup while  dup next @ >r  over >r  as  call  r> r> repeat
        2drop
        r> to me
    drop ;
: (unload)  \ remove game object from its parent.  persistent objects are not removed or recycled.  static objects are not recycled.
    unl# unset
    pers# set? ?exit     me remove
    static# set? ?exit   me heap recycle ;
: sweep  0 stage all>  unl# set? -exit  (unload) ;
: unload  as> unl# set ;
\ clear everything from stage except persistent stuff immediately.  frees game object memory.
: cleanup  0 stage all>  pers# set? ?exit  (unload) ;
\ clear everything from stage including persistent stuff.   frees game object memory.
: clear  0 stage all>  pers# unset  (unload) ;
: #actors  stage length @ ;

\ internal game object logic
: start              me class @ 'onStart @ execute  rst# unset ;
: init   rst# unset  me class @ 'onInit @ execute ;
: ?show  'show @ call ;
: ?act   rst# set? if  start  then  'act @ call ;

\ low-level game object scripting
: shows>  r> code> 'show !  vis# set ;                                             ( -- <code> )
: acts>   r> code> 'act ! ;                                                        ( -- <code> )
: one  ( class -- me=obj )
    heap portion >r
    r@ instance!  r> dup to me  stage pushnode  at@ x 2v!  ( oneInit )  init ;
: become  ( class -- )  me class !  init ;


\ set up gameobj prototype
\ gameobj proto @ to me
\     ' noop >code  dup 'show !  'act !
\     en# set  rst# set
