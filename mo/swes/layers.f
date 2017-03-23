[swes] idiom [layer]

\ GPU

\ provides a lexicon for setting up a fantasy 2D game console (tile plane bg + sprites )
\   with whatever specs we want.
\ it's not really like a GPU; it uses the stage.
\ features:
\  - up to 16 plane priorities (16 planes displayed at once)
\  - plane priorities are totally programmable (you can draw planes in any order)
\  - up to 65536 (integer) priority levels for game objects per plane (actors)
\  - up to 8191 actors per plane (based on maximum sortable items in id-radixsort.f)
\  - one scrolling tilemap per plane


\ internals
\  [x] indexed source images
\  [x] indexed sprite structures
\  [x] indexed sprite frames

\ future ideas:
\  [ ] transformation matrix modification / specification words
\  [ ] special multi-effects shaders
\  [ ] 8-bit images and palette swapping shader
\  [ ] viewports and viewport-wide effects
\  [ ] raster effects

\ -----------------------------------------------------------------------------
\ sorted object drawing
\ DrawOBJS acts as a filter, adding actors to a temporary array (queue) if it
\ meets some conditions.
\ after that's done, we sort the array by zdepth (all forward rendering for now)
\ and then we Draw the actors of the resulting array in order.

$f0000000 constant DEPTHMASK

: enqueue  me , ;
: showem  ( addr -- addr )  here over ?do  i @ as  ?draw  cell +loop ;
: @zdepth  [ zdepth me - ]# + @ [ DEPTHMASK invert ]# and ;
: sort  dup here over - cell/ s>p ['] @zdepth irsort
         ; \ dup here over - .s idump ;
: dfilter  ( n -- ) stage all>  vis @ -exit  dup zdepth @ DEPTHMASK and = if  enqueue  then ;

\ -----------------------------------------------------------------------------
\ tile buffer

256 256 array2d tilebuf

: DrawTilebuf  tilebuf DrawTiles ;

\ -----------------------------------------------------------------------------
\ planes
\  a plane defines an optional scrollable tilemap,
\  and zdepth mask (binary range) for actors to display over the tilemap.

0 value curPlane

: lvar  create dup , cell +  immediate  does> @ " curPlane ?lit +" evaluate ;

0
  lvar bgX  lvar bgY
  lvar bgTileset
  lvar bgCols  lvar bgRows
  lvar enOBJ  lvar enBG  lvar enSort
  lvar depthrange
  \ xvar parallax
  \ xvar bgtint
safetable planes

: >curPlane  planes id> to curPlane ;

\ initialize a plane
: initBG ( -- )
  bgTileset @ validate -exit
    >tileset subw 2v@ gfxw gfxh 2swap 2/  1 1 2+ bgCols 2v!
  enBG on ;
  
: initPlane  ( tileset-id|-1 depthrange -- )
  enOBJ on  enSort on  depthrange !  bgTileset !  initBG ;

\ define a plane
: plane  ( tileset-id|-1  depthrange -- <name> )
  planes entry to curPlane  initPlane ;

\ Draw a plane
: DrawBG  ( -- )
  enBG @ -exit
  bgTileset @ >tileSrc  bgX 2v@ scrolled bgCols 2v@ DrawTilebuf ;

: ?sort  enSort @ -exit  sort ;
: DrawDepthRange  ( depthrange ) here  swap dfilter  ?sort  showem  reclaim ;
: DrawObjs  ( -- )  enOBJ @ -exit  depthrange @ DrawDepthRange ;
: DrawPlane  ( plane -- )  >curPlane  DrawBG  DrawObjs ;
