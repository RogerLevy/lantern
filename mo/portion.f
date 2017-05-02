\ Simple memory management
\ For now, only supports one memory allocation size and one heap (with a fixed size of 4MB).
\ Later you'll be able to have more than one heap each with a different allocation size.

bu: idiom portion:
    import mo/cellstack

public:

\ I was going to make these configurable but for simplicity's and future enhancements' sake
\ they are now going to be fixed. 4/2/2017
\ [undefined] /portion [if] 64 cells constant /portion [then]
\ [undefined] /heap [if] 8 megs constant /heap [then]
\ /heap /portion / constant #portions
private:
    128 cells constant /portion
    16 megs constant /heap
    /heap /portion / constant #portions
    #portions cellstack free-portions
public:

\ Maybe later make this ALLOCATE'd so it doesn't take up disk space?
create heap /heap /allot
: reset-heap  ( heap -- )  drop
    free-portions vacate  heap  #portions 0 do  dup free-portions push  /portion +  loop  drop ;
: portion  ( heap -- adr )  drop  free-portions pop ;
: recycle  ( adr heap -- )  drop  free-portions push ;
heap reset-heap
