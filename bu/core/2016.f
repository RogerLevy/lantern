decimal

\ Cleaner strings
: "  postpone s" ; immediate

\ Random numbers
HERE VALUE seed
: /rnd  ucounter drop to seed ;
: random ( -- u ) seed $107465 * $234567 + DUP TO seed ;
: rnd ( n -- 0..n-1 ) random um* nip ;

\ -----------------------------------------------------------------------------
[defined] linux [if]
    : alert  type ;
[else]
    : alert  ( addr c -- )  \ show windows OS message box
      zstring 0 swap z" Alert" MB_OK MessageBox drop ;
[then]
: --  -1 swap +! ;
\ -----------------------------------------------------------------------------
fixed
: 2v@  ( addr -- x y )  dup @ swap cell+ @ ;
: 2v!  ( x y addr -- )  dup >r cell+ ! r> ! ;
: 2v+! ( x y addr -- )  dup >r cell+ +! r> +! ;
: 2v?  2v@ 2. ;
: x@   @ ;
: y@   cell+ @ ;
: x!   ! ;
: y!   cell+ ! ;
: x+!   +! ;
: y+!   cell+ +! ;
\ -----------------------------------------------------------------------------
decimal
: or!  ( n adr -- )  dup @ rot or swap ! ;
: and!  ( n adr -- ) dup @ rot and swap ! ;
: xor!  ( n adr -- ) dup @ rot xor swap ! ;
: not!  ( n adr -- ) dup @ rot invert and swap ! ;
: toggle  dup @ not swap ! ;
[undefined] third [if] : third  >r over r> swap ; [then]
[undefined] @+ [if] : @+  dup @ swap cell+ swap ; [then]
: u+  rot + swap ;  \ "under plus"
: ?lit  state @ if postpone literal then ; immediate
\ faster but less debuggable version
: xfield  create over , + immediate does> @ ?dup if " ?lit + " evaluate then ;  ( total size -- <name> total+size )
\ : xfield  create over , + does> @ + ;                                         ( total size -- <name> total+size )
: xvar    cell xfield ;                                                         ( total -- <name> total+cell )
: struct  value ;  \ NTS: later i'm gonna change the semantics.  see Developer Guide
: 2min  rot min >r min r> ;
: 2max  rot max >r max r> ;
: 2+  rot + >r + r> ;
: 2-  rot swap - >r - r> ;
: 2*  rot * >r * r> ;
: 2/  rot swap / >r / r> ;
: 2mod  rot swap mod >r mod r> ;
: 2negate  negate swap negate swap ;
: 2rnd  rnd swap rnd swap ; 
: do postpone ?do ; immediate
: allotment  here swap /allot ;
: copy,      here over allot swap move ;
\ : ?next  @+ dup 0 >= ;
: h?  @ h. ;
: validate  ( id -- id true | false )  dup 0< not dup ?exit nip ;
: reclaim  h ! ;
: ]#  ] postpone literal ;
: << lshift ;
: >> rshift ;
fixed
: th  cells + ;
: bit  dup constant  1 << ;
-1 constant none

: clamp  ( n low high -- n ) -rot max min ;
: 2clamp  ( x y lowx lowy highx highy -- x y ) 2>r 2max 2r> 2min ;


\ Swiftforth-specific?
: l locate ;


0 value src
0 value dest
: src!  to src ;
: dest!  to dest ;

[undefined] @+ [if] [then]
[undefined] !+ [if] [then]
[undefined] ~!+ [if] [then]

: ifill  ( c-addr count val - )  -rot  0 do  over !+  loop  2drop ;
: ierase   0 ifill ;
: imove  ( from to count - )  cells move ;

: time?  ucounter 2>r  execute  ucounter 2r> d-  d>s  i. ;                      ( xt - )  \ print time given XT takes in microseconds

\ fixed-point-to-floats-on-stack primitives (mainly for ALlegro 5)
: 1af  1f 1sf ;
: 2af  1f 1f 1sf 1sf ;
: 3af  1f 1f 1f 1sf 1sf 1sf ;
: 4af  1f 1f 1f 1f 1sf 1sf 1sf 1sf ;

: 4@  @+ swap @+ swap @+ swap @ ;
: 4!  >r  r@ 2 cells + 2v!  r> 2v! ;

: kbytes  #1024 * ;
: megs  #1024 * 1024 * ;

: udup  over swap ;
: 2,  swap , , ;
: 3,  rot , swap , , ;
: 4,  2swap swap , , swap , , ;
