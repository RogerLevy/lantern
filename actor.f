\ actor.
\  more sophisticated features are (going to be eventually) available:
\   [ ] - advanced scripts (multitasking)
\   [ ] - scripted scaling/rotation/flipping/tint/blend mode/shader
\   [ ] - advanced sprite animation and spriter support
\   [ ] - dynamic hitbox
\   [ ] - HP/Attack/Defense
\   [ ] - optional rigid-body physics (Box2D? ODE? Chipmunk2D? Physx???)
\   [ ] - remember starting position
gameobj inherit  var boxx  var boxy  var boxw  var boxh  var hp  var maxHP  var atk  var def  var ang  var sx  var sy  var orgx  var orgy  var cflags  var cmask  var 'hit  var startx  var starty  var fr  var fg  var fb  var fa  var bmode  class actor

\ add multitasking capability to actor
include le/task

\ color words
create fcolor 4 cells allot
: !color   ( r g b a -- )  1af swap 1af 2swap 1af swap 1af fcolor ~!+ ~!+ ~!+ ! ;
: byt  dup $ff and c>p ;
: hex>color  byt >r 8 >> byt >r 8 >> byt >r 8 >> byt nip r> r> r> ;
: !hex    ( i -- )  hex>color !color ;

\ set up the actor prototype
actor proto @ to me
    1.0 1.0 sx 2v!            \ initialize scale to 1,1 (fixed-points)
    1e 1sf dup dup dup fr 4!  \ initialize color to 1,1,1,1 (singles)
    ' noop >code  'hit !
