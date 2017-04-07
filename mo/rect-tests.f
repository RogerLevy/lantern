\ to use, define R to point to a rect struct containing 1, 2, 3, 4.
marker dispose
1 2 3 4 rect r
: test   <> abort" rect test failed" ;
r @x r @y r !xy
r @x 1 test
r @y 2 test
r @w r @h r !wh
r @w 3 test
r @h 4 test
r @x2 4 test  r @y2 6 test
11 r !x2  r @w 10 test
22 r !y2  r @h 20 test
31 42 r !xy2
r @wh 40 test
      30 test
-1 dup r !x r @x test
-2 dup r !y r @y test
-3 dup r !w r @w test
-4 dup r !h r @h test
5 6 7 8 r !rect
r @rect 8 test
        7 test
        6 test
        5 test
dispose
