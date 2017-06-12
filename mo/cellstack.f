\ [ ] overflow checking
bu: idiom stack:
: cellstack  ( max-size -- <name> )  create 0 , cells /allot ;
: @length  @ ;
: vacate  0 swap ! ;
: pop  ( stack -- val )  >r  r@ @ 0= abort" ERROR: Stack object underflow." r@ dup @ cells + @  -1 r> +! ;
: push  ( val stack -- )  >r  1 r@ +!   r> dup @ cells + !  ;
: []  ( n stack -- addr )  swap 1 + cells + ;
: pushes  ( ... stack n -- ) swap locals| s |  0 ?do  s push  loop ;
: pops    ( stack n -- ... ) swap locals| s |  0 ?do  s pop  loop ;
