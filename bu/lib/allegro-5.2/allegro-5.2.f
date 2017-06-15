decimal

\ intent: define chunk of code as a string which will be executed when given <name> is executed.
\ usage: #define <name> <code>
: #define  ( - <name> <code> )  \ fake preprocessor code definition
  create 0 parse bl skip string, immediate
  does>
    ( addr ) >r
    base @ ints @ get-order
    r> ( addr )
    fdepth >r
    ( addr ) decimal count evaluate
    state @ 0 = r> fdepth = and if  \ if interpreting and fstack has not changed
      >r set-order ints ! base ! r>
    else
      set-order ints ! base !  \ otherwise, assume the data stack has not changed
    then ;

: field  create over , + does> @ + ;
: var  cell field ;
: fload   include ;
: ?constant  constant ;

\ intent: speeding up some often-used short routines
\ usage: macro:  <some code> ;  \ entire declaration must be a one-liner!
: macro:  ( - <code> ; )  \ define a macro; the given string will be evaluated when called
  create immediate
  [char] ; parse string,
  does> count evaluate ;


#define ALLEGRO_VERSION          5
#define ALLEGRO_SUB_VERSION      2
#define ALLEGRO_WIP_VERSION      3
#define ALLEGRO_RELEASE_NUMBER   0


[defined] linux [if]
    : linux-library  library ;
    library /usr/lib/i386-linux-gnu/liballegro.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_memfile.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_primitives.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_acodec.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_audio.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_color.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_font.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_image.so.5.2
    library /usr/lib/i386-linux-gnu/liballegro_font.so.5.2
[else]
    cd bu/lib/allegro-5.2
    : linux-library  0 parse 2drop ;
    [defined] allegro-debug [if]
      library allegro_monolith-debug-5.2.dll
    [else]
      library allegro_monolith-5.2.dll
    [then]
    cd ../../..
    warning off
[then]

ALLEGRO_VERSION 24 lshift
ALLEGRO_SUB_VERSION 16 lshift or
ALLEGRO_WIP_VERSION 8 lshift or
ALLEGRO_RELEASE_NUMBER or
constant ALLEGRO_VERSION_INT

: void ;

: /* postpone \ ; immediate

\ ----------------------------- load files --------------------------------

include bu/lib/allegro-5.2/01_allegro5_general.f
include bu/lib/allegro-5.2/02_allegro5_events.f
include bu/lib/allegro-5.2/03_allegro5_keys.f
include bu/lib/allegro-5.2/04_allegro5_audio.f
include bu/lib/allegro-5.2/05_allegro5_graphics.f
include bu/lib/allegro-5.2/06_allegro5_fs.f
include bu/lib/allegro-5.2/tools.f

\ =============================== END ==================================

warning on

