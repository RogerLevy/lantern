\ Simple memory management
\ For now, only supports one memory allocation size and one heap (with a fixed size of 4MB).
\ Later you'll be able to have more than one heap each with a different allocation size.

bu: idiom portion:
    import mo/cellstack

\ ----------------------------------------- not API -----------------------------------------------
\ I was going to make these compile-time configurable but for simplicity's sake they are fixed. 6/5/2017
\ [undefined] /portion [if] 64 cells constant /portion [then]
\ [undefined] /heap [if] 8 megs constant /heap [then]
\ /heap /portion / constant #portions
    128 cells constant /portion
    16.0 megs constant /heap
    /heap /portion / constant #portions
    #portions s>p cellstack free-portions
\ -------------------------------------------------------------------------------------------------
decimal

here /portion + #1 - dup /portion mod -
    dup h !    /heap allot \ SwiftForth's /allot can't handle counts that are too large!
constant heap

: reset-heap  ( heap -- )  drop
    free-portions vacate  heap  #portions 1i 0 do  dup free-portions push  /portion +  loop  drop ;
: portion  ( heap -- adr )  drop  free-portions pop ;
: recycle  ( adr heap -- )  drop  free-portions push ;
: dims  ( heap -- /portion #portions ) drop  /portion  #portions ;
heap reset-heap
