empty
include le/le
le: idiom rain:
import mo/tilegame
image tiles.img le/ex/tiles.png
tiles.img 20 20 loadtiles drop

role  var ic  var sy  var c  \ sy=starting y  c=counter
: h2o  objects one  y @ sy !  draw> ic @ tile blit ;
: icon  ic ! ;
: gravity  0.125 vy +! ;
: lasting  c !  act>  c @ 0 = if  me delete  exit then  c -- ;
: hop  0.91 rnd 2 - vy !  1.526 rnd negate 0.763 + 0.833 * vx ! ;
: past  sy @ + y @ swap > ;
: droplet  h2o  4 icon  hop  act>  gravity  0 past if  me delete  then ;
: splash  me delete  h2o  3 icon  { 4 0 do  droplet  loop }  3 lasting ;
: fall  gravity  displayh past if  { 0 0 from  splash }  then ;
: waterdrop  h2o  2 icon  act> fall ;

: randpos  displaywh 2rnd ;
: gen  6 0 do  randpos 10 displayh 2-  at  waterdrop  loop ;
: world  dmagenta backdrop  hold>  objects each> draw ;
: physics  objects each> adv ;
: rain  go>  render>  world  step>  gen  physics ;  objects scene \ rain

