bu: idiom pen:

\ Pen
create penx  0 ,  here 0 ,  constant peny
: at   ( x y -- )  penx 2v! ;
: +at  ( x y -- )  penx 2v+! ;
: at@  ( -- x y )  penx 2v@ ;
\ : -at  ( x y -- )  2negate +at ;
