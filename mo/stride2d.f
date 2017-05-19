bu: idiom stride2d:

0 value xt
: stride2d  ( xt pen=xy x2 y2 stridew strideh -- )  ( pen=xy w h -- )
  locals| sh sw y2 x2 |
  xt >r  to xt
  penx @
  y2 #1 + peny @  do
    x2 #1 + over do
      i j at  sw sh  x2 y2 i j 2- 2min  xt execute
    sw +loop
  sh +loop
  drop
  r> to xt ;
