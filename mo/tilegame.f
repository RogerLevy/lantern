\ Global tileset system
\  Display and (coming soon) collision detection (maybe by using an external mixin)
\  Maximum 4096 tiles; you're not meant to use this for ALL your graphics, if you're going
\   to be doing a lot of stuff that would be inappropriate as tiles anyway.

\ TODO:
\  unloadtiles - destroy all subbitmaps and clear the cellstack
\  tile collision
\  tilemap? display and other routines...

bu: idiom tilegame:
import mo/image
import mo/cellstack

4096 cellstack tiles
: tile  4095 and tiles [] @ ;
: +tiles  tiles @length swap  dup subcount @ 0 do  i over imgsubbmp  tiles push  loop  drop ;
: loadtiles ( image tilew tileh -- firstn ) third subdivide  +tiles ;

