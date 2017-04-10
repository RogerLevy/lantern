bu: idiom gameutils:

: 4dup  2over 2over ;

decimal
: lowerupper  ( n n -- lower higher )  2dup > if  swap  then ;
: between  ( n n -- n )  lowerupper  over -  1 +  rnd + ;
:noname ; constant ..
: 1clamp  ( n -- n )  0.0 1.0 clamp ;
\ : xywh  ( x y x y -- x y width height )  2over 2- ;

fixed
: vary  ( n rnd -- n )  dup 0.5 *  -rot rnd +  swap - ;
: 2vary  ( n n rnd rnd -- n n )  rot swap vary >r vary r> ;
: either  ( a b - a | b )  2 rnd if  drop  else  nip  then ;
: located  ( x y w h xfactor. yfactor. - x y )  2* 2+ ;
: middle  ( x y w h - x y )  0.5 0.5 located ;

: 2halve  0.5 0.5 2* ;
: center  ( w1 h1 x y w2 h2 - x y )  2halve 2rot 2halve 2- 2+ ;
\ center a rectangle (1) in the middle of another one (2).  returns x/y of top-left corner.

: somewhere  ( x y w h - x y )  2rnd 2+ ;
\ find a random position in the rectangle (x,y,x+w,y+h)

: overlap? ( xyxy xyxy - flag )
  2swap 2rot rot > -rot <= and >r rot >= -rot < and r> and ;
\ find if 2 rectangles (x1,y1,x2,y2) and (x3,y3,x4,y4) overlap.

:noname noop ; constant ..
