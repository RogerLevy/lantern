\ TODO

320 240 fullscreen
" data\tiles.bmp" 0 loadtiles

1000 group water class field ic field sy field c
: h2o water add y @ sy ! draw ic @ tile sprite ;
: icon ic ! ;
: gravity [ 1 8 1*/ ] literal vy +! ;
: lasting c ! do c @ 0 = if remove then c -- ;
: hop 30000 rand -2 flit + vy ! 50000 rand - 25000 + 5 6 */ vx ! ;
: past sy @ + y @ swap > ;
: droplet h2o 4 icon hop do gravity 0 past if remove then ;
: splash remove h2o 3 icon { 4 for droplet loop } 3 lasting ;
: fall gravity 320 past if { generate splash } then ;
: waterdrop h2o 2 icon do fall ;


: gen ( inkey 255 and 13 = ) <enter> key if 3 for randpos -280 + 5 3 */ -10 u+ at waterdrop loop then ;
: rain just 5 sleep gen grey screen all ;  rain go

