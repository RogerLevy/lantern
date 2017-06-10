le: idiom tiled:
import mo/nodes
import mo/xml

create bgObjTable 1024 cells /allot \ bitmaps
quality firstgid

defer onLoadBox  ( pen=xy -- )
:noname [ is onLoadBox ] cr ." WARNING: onLoadBox is not defined!" ;


quality 'onMapLoad  ( O=node -- )
: onMapLoad:  ( class -- <code;> )  :noname swap 'onMapLoad ! ;
: onMapLoad  ( O=node -- )  me class @ 'onMapLoad @ execute ;

: gid>class  ( n -- class )
  locals| n |
  lastClass @
  begin  dup firstgid @ 1 - n u<  over prevClass @ 0 =  or  not while
    prevClass @
  repeat  ;

: clearbgimages
    bgObjTable 1024 0 do @+ ?dup if al_destroy_bitmap then loop  drop
    bgObjTable 1024 ierase ;

: addBGImage  ( dest path c -- dest+cell )
    " data/maps/" s[ +s ]s zstring al_load_bitmap !+ ;

: bgobjtile ( dest node -- dest )  " image" 0 el  &o for>  " source" attr$ addBGImage ;

: bgobj?   " name" attr$ " bgobj" compare 0= ;

: readTileset  ( node -- )
  &o for>
  " firstgid" attr   " name" attr$ script  firstgid !
  bgobj? -exit  clearbgimages  bgobjtable  o " tile" ['] bgobjtile eachel  drop ;

\ utility word ?PROP: read custom object property
\ use the O register

\ children only consists of elements called "property" so no need to check the names of the elements
: (prop)  ( addr c node -- addr c  continue | node stop )
  &o for>  o element? -exit  2dup " name" attr$ compare 0= if O true else 0 then ;

: ?prop$  ( addr c -- false | adr c )
  o " properties" 0 ?el 0= if 2drop false exit then
  ['] (prop) scan   nip nip  dup -exit  &o for>  " value" attr$ ;

: ?prop  ( adr c -- false | val true )  ?prop$ dup -exit  evaluate true ;

: instance  ( class -- )  one  onMapLoad ;
: *instance  ( gid -- )  gid>class instance ;

: fixY  " height" attr negate peny +! ;

: readObject  ( node -- )
  &o for>
  " x" attr " y" attr  at
  " gid" ?attr if  drop fixY  then
  cr o .element 
  " name" ?attr$ if  evaluate
  else
    " gid" ?attr if  *instance
                 else  onLoadBox  then
  then
;

: readObjectGroup  " object" ['] readObject eachel ;
: (tilesets)  " tileset" ['] readTileset eachel ;
: (objgroups)  " objectgroup" ['] readObjectgroup eachel ;

: clearGIDs  ( -- )
  firstClass @  begin  ?dup while  #-1 over firstGID !  nextClass @  repeat ;

0 value tmx

: loadTMX  ( path count -- )
  me >r
  clearGIDs
  file@  2dup xml  to tmx
    drop free throw
  fixed
  tmx " map" 0 ?el not abort" File is not TMX format!"
    dup (tilesets) (objgroups)
  r> as ;

