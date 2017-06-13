bu: idiom array2d:


\ ----------------------------- 2d arrays support -----------------------------
: clip  ( col row #cols #rows #destcols #destrows -- col row #cols #rows )
  2>r  2over 2+  0 0 2r@ 2clamp  2swap  0 0 2r> 2clamp  2swap 2over 2- ;
: batch  ( ... addr #cells xt -- ... )  ( ... addr -- ... )
  >code -rot  cells bounds do  i swap dup >r call  r>  cell +loop  drop ;
: `batch  ( ... addr xt -- ... )  ( ... addr -- ... )  \ -1 is terminator
  >code begin  over @ 0 >=  while  2dup 2>r  call  r> r> cell+ swap repeat  2drop ;
: 2move  ( src /stride dest /stride #rows /bytes -- )
  locals| #bytes #rows deststride dest srcstride src |
  #rows 0 do
    src dest #bytes move
    srcstride +to src  deststride +to dest
  loop ;
\ ---------------------------------- array2d ----------------------------------

node inherit
    xvar numcols  xvar numrows  0 xfield data
subclass array2d-class

: array2d  ( numcols numrows -- <name> )  ( -- data )
  2pfloor 2dup  create array2d-class obj  numcols 2v!  * cells /allot ;
: dims  ( array2d -- numcols numrows )  numcols 2v@ ;
: count2d ( array2d -- data #cells )  dup data swap numcols 2v@ * ;

: (clamp)  ( col row array2d -- same )
  >r  0 0 r@ numcols 2v@ 2clamp  r> ;

\ BUG: this is incomplete!
\      if dest col/row are negative, we need to adjust the source start address!!
: (clip)   ( col row #cols #rows array2d -- same )
  dims 1 1 2- clip ;

: addr  ( col row array2d -- addr )
  (clamp) >r  r@ numcols @ * +  cells  r> data + ;

: >stride  numcols @ cells ;
: addr-stride  ( col row array2d -- addr /stride )  dup >r addr r> >stride ;

\ -----------------------------------------------------------------------------
\ use the SRC and DEST "registers":
: write2d  ( src-addr stride destcol destrow #cols #rows -- )
  dest (clip)  2swap dest addr-stride  2swap  swap cells 2move ;

: move2d  ( srcrow srccol destcol destrow #cols #rows -- )
  2>r 2>r  src addr-stride  2r> 2r> write2d ;
\ -----------------------------------------------------------------------------

: some2d  ( ... col row #cols #rows array2d XT -- ... )  ( ... addr #cells -- ... )
  >r >r  r@ (clip)   2swap r> addr-stride
  r> locals| xt stride src #rows #cols |
  #rows 0 do  src #cols xt execute  stride +to src  loop ;

:noname  third ifill ;
: fill2d  ( val col row #cols #rows array2d -- )  literal some2d  drop ;

: each2d  ( ... array2d xt -- ... )  ( ... addr #cells -- ... )
  >r >r  0  0  r@ dims  r> r> some2d ;

\ : some2d>  r> code> some2d ;
\ : each2d>  r> code> each2d ;

:noname  cr  cells bounds do  i ?  cell +loop ;
\ : 2d.  literal each2d ;
: 2d.  >r 0 0 r@ dims 16 100 2min  r> literal some2d  ;


\ test
marker dispose
10 15 array2d a
12 7 array2d b
a count2d 5 ifill
b count2d 10 ifill
\ quit
cr .( ARRAY2D tests passed. )
dispose


