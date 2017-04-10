bu: idiom safetables:

\ safe tables are allocated using the system heap so that they can grow
\ independently of the dictionary.

0  xvar m  xvar nextid  xvar entrysize  constant /table

: ?fallback  ( n max -- n|0 )  over u> and ;

: id>  ( n table -- entry )
  >r  r@ nextid @ ?fallback  r@ entrysize @ * r> m @ + ;

: *id ( table -- entry id )
  dup nextid @ >r   dup nextid ++
  r@ 1 + 3 and 0= if
    dup 2v@ 4 + third entrysize @ * resize throw over m !
  then
  r@ swap id>  r> ;

: safetable  ( /entrysize -- <name> )  \ entrysize must be in bytes
  create /table allotment >r
  r@ entrysize !
  r@ entrysize @ 4 * allocate throw r> m ! ;

: entry  ( table -- <name> entry )  *id ( entry id )  constant  ( entry ) ;

\ : FreeSafetable  m @ free drop ;
