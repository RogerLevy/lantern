\ Fruitflies.f
\ Based on 10+ year old code written for Win32Forth

empty
include le/le
include le/oe/task
le: idiom fruitflies:

\ This program was inspired by the motion of flies.
\ Usually the flies die out before things get interesting or they
\ overpopulate and prosper indefinitely.
300 constant lifespan
defer *fly
role  var life  var r  var g  var b  var a   var s  \ s=size
: oranges  0 0 vx 2!  1 0.5 0 1 r 4!  20 rnd 0 ?do  i s !  yield  loop ;     \ temporary; these should draw extra stuff under the green center
: apples   0 0 vx 2!  1 0 0 1 r 4!    50 rnd 0 ?do  i s !  yield  4 +loop ;  \ temporary; these should draw extra stuff under the green center
: randmove  0 1 0 1 r 4!  8 s !  5 rnd 2.5 -  5 rnd 2.5 -  vx 2!  8 yields ;
: ?bore  7 rnd pfloor 0= if { 0 0 from *fly } then ;
: live  200 rnd lifespan + life ! ;
: darker  0.99 * ; \  0.95 0.95 2*  2>r  0.95 0.95 2*  2r> ;
: fadeout  200 0 do  r 4@ darker r 4!  yield  loop ;
: die  0 0 vx 2!   50 yields  0.5 0.5 0.5 1  r 4!  2 secs  fadeout  me delete ;
: ?die  life @ 0 <= -exit  die ;
: mortal  act> life -- ;
: script  0 perform>  live  begin  apples randmove oranges randmove ?bore ?die  again ;
:noname  [ is *fly ]  objects one  mortal  script  0 1 0 1 r 4!  draw>  r 4@ color  s @ circlef ; 

objects scene
displaywh 0.5 0.5 2* at  *fly  named og

: world  black backdrop  hold>  objects each> draw ;
: physics  objects each> adv ;
: fruitflies  go>  render>  world  step>  physics  objects multi ;

fruitflies
