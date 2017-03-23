[swes] idiom [tileset]

\ NTS: later add attributes like collision

/image safetable tilesets

: tileset  ( tilew tileh image -- <name> )  ( -- id )
  tilesets entry >r  r@ /image move  r> subdivide ;
  
: >tileset  tilesets id> ;
