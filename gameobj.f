\ game object system (inheritance-based)
\  adapted from Dark Blue
[bu] [le] idiom [gameobj]
import mo/node

[bu] _public
64 cells constant /portion
1 megs constant /heap

[bu] [le] [gameobj]
import mo/portion

0 value stage

\ Every game object and actor has its own private idiom.
\ These fields implicitly address based on the ME pointer.
\ To change the ME pointer in a scalable way, use {{ }} (set and fetch ME) and 's (access a field)
\ The prompt is extended to display the current object's address and class.
0 value me
: {{  " to me" evaluate ;  immediate
: }}  " me" evaluate ;  immediate
: 's
  state @ if
    " me >r  to me " evaluate  bl parse evaluate  " r> as" evaluate
  else
    " me swap to me " evaluate  bl parse evaluate  " swap to me" evaluate
  then
; immediate
[defined] dev [if]
: field  create over , + does> @ me + ;
[else]
: field  create over , + immediate does> @ " me ?lit + " evaluate ;  \ faster but less debuggable version
[then]
: var  cell field ;




\ basic game object: gameobj
\  simple enough to use for particles.
\  they don't store any transform info except for position.
\  physics, collision detection and transformation needs to be done programmatically for each kind of particle.
\  this is good for performance, since there is no "standard" rendering or collision detection forced on all particles
node inherit  var x  var y  var vx  var vy  var 'draw  var 'act  var flags  class gameobj


\ actor.
\  more sophisticated features are available:
\   [ ] - advanced scripts (multitasking)
\   [ ] - scripted scaling/rotation/flipping/tint/blend mode/shader
\   [ ] - advanced spriter animation and spriter support
\   [ ] - dynamic hitbox
\   [ ] - HP/Attack/Defense
\   [ ] - optional rigid-body physics (Box2D? ODE? Chipmunk2D? Physx???)
\   [ ] - remember starting position
gameobj inherit  var boxx  var boxy  var boxw  var boxh  var hp  var maxHP  var atk  var def  var flip  var ang  var sx  var sy  var orgx  var orgy  var cflags  var cmask  var 'hit  var startx  var starty  var fr  var fg  var fb  var fa  var bmode  class actor

1.0 actor proto @ 's sx !  1.0 actor proto @ 's sy !
1e actor proto @ 's fr sf!  1e actor proto @ 's fg sf!  1e actor proto @ 's fb sf!  1e actor proto @ 's fa sf!


\ add multitasking capability to actor
include le/task

\ color words
create fcolor 4 cells allot
: !color   ( r g b a -- )  1af swap 1af 2swap 1af swap 1af fcolor ~!+ ~!+ ~!+ ! ;
_private
    : 8b  dup $ff and c>p ;
_public
: hex>color  8b >r 8 >> 8b >r 8 >> 8b >r 8 >> 8b nip r> r> r> ;
: !hex    ( i -- )  hex>color !color ;
