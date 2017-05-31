\ Actor system - Stage
le:

\ stage management
: skim>  ( n container -- )  ( me=object n -- n )  \ shallow iteration on game objects
    dup 0= if  r> drop  2drop  exit  then
    dup first @ 0=  if  r> drop  2drop  exit  then
    r>  me >r  swap first @ begin  be  ( code )  dup >r  call  r>  me next @ dup 0= until
    drop  2drop  r> to me ;
0 value (allcode)
: (all)  skim>  kids length @ if  ( n ) dup  kids  recurse  then  (allcode) call ;
: all>  ( n container -- )  ( me=object n -- n )  \ deep iteration of monster's and actors; children first.  not re-entrant.
    r> to (allcode)  (all) ;
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
: one  ( class -- me=object )
    heap portion >r
    ( class ) r@ instance!  r> be
        me stage pushnode
        at@ x 2v!  init ;

