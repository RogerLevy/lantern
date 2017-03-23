\ relies on: x y vx vy tileprop@ maploc@ tilesize
\ note: this code is not re-entrant
\ one advantage of this algorithm is that it only checks along the edges
\ tileprop bits:   0000rlfc   right left floor ceiling

\ collisions with map tiles
\ property table negate 8-bit, up/down/left/right solid flags

[swes] idiom [tilemap-collision]


_private

: vector
   create 0 , here 0 , 0 , constant ;

_public

defer tileprop@  ( n -- n )
defer map-collide   ' drop is map-collide  ( n -- )
\ use these to detect on what sides the object collided
variable lwall?
variable rwall?
variable floor?
variable ceiling?

_private

: cel? 1 and ; \ ' ceiling '
: flr? 2 and ; \ ' floor '
: wlt? 4 and ; \ ' wall left '
: wrt? 8 and ; \ ' wall right '
\ : p@ tileprops + c@ ;
aka tileprop@ p@

vector w h
vector nx ny
variable t

tilesize s>p constant fgap

: fx x @ ;
: fy y @ ;

\ point
: pt  2p>s maploc@ dup t ! p@ ;

\ increment coordinates
: ve+ swap fgap + w @ 1 - fx + min swap ;
: he+ fgap + h @ 1 - ( fy ) ny @ + min ;


: +vy ny +! ny @ ( $ffff0000 and dup ny ! ) fy - vy ! ;
\ push up/down
: pu ( xy ) nip fgap mod negate +vy  floor? on  t @ map-collide  ;
: pd ( xy ) nip fgap mod negate fgap + +vy  ceiling? on  t @ map-collide  ;



\ check up/down
: cu w @ fgap / 2 + for 2dup pt cel? if pd r> drop exit then ve+ next 2drop ;
: cd w @ fgap / 2 + for 2dup pt flr? if pu r> drop exit then ve+ next 2drop ;



: +vx nx +! nx @ ( $ffff0000 and dup nx ! ) fx - vx ! ;

\ push left/right
: pl ( xy ) drop fgap mod negate ( -1.0 + ) +vx rwall? on t @ map-collide ;
: pr ( xy ) drop fgap mod negate fgap + +vx lwall? on t @ map-collide ;


\ check left/right
: cl h @ fgap / 2 + for 2dup pt wrt? if pr r> drop exit then he+ next 2drop ;
: crt h @ fgap / 2 + for 2dup pt wlt? if pl r> drop exit then he+ next 2drop ;

\ check if object's path crosses tile boundaries in the 4 directions...
: dcros? fy h @ 1- + fgap /  ny @ h @ 1- + fgap / < ;
: ucros? fy fgap /  ny @ fgap /  > ;
: rcros? fx w @ 1- + fgap /  nx @ w @ 1- + fgap / < ;
: lcros? fx fgap /  nx @ fgap /  > ;

: ud vy @ -exit vy @ 0 < if ( ucros? -exit ) fx ny @ cu exit then ( dcros? -exit ) fx ny @ h @ + cd ;
: lr vx @ -exit vx @ 0 < if ( lcros? -exit ) nx 2@ cl exit then ( rcros? -exit ) nx @ w @ + ny @ crt ;

: init   2s>p w 2! x 2@ vx 2@ 2+ nx 2! lwall? off rwall? off floor? off ceiling? off ;

_public
: collide-map    ( w h -- ) init ud lr ;
