\ Workspaces
\  Development-time Overlay

\  An IDE that integrates an interactive commandline and a GUI system for making game dev tools.
\  Is based daround a future-proof data file called a Session that stores the state of users'
\  interfaces in a human readable format.  Sessions store containers called Figures, which are
\  full of objects.
\  FUTURE: Figures will be able to store source code.  (To be used by the future independent interpreter)
\  In the factory default state, there is a single workspace that acts as a home screen.
\  From here, you can load and enter other workspaces either by clicking a button or typing a command.
\  Workspaces can implement their own internal workspace-loading-and-switching mechanisms, for
\  convenience and to control what the user can do.  For instance, a planned app called Game Tools
\  will contain at least 3 predetermined workspaces that can be switched between.  All 3 of these
\  workspaces can't be deleted and are stored in session files that embody Game Tools.  Additional
\  workspaces can be created by the user (if allowed) and added to the session file.
\  In the future, a unified browser-like navigation system may be implemented.
\  Workspaces supports switching between a running app (typically a game) and the IDE.

\ UI elements
\  [ ] Textbox
\  [ ] Panel
\  [ ] Button
\  [ ] Scrollarea
\  [ ] Pagearea

\ Container-type elements
\  Workspace - the container to which "master" tool application code is assigned.
\  Domain - an instance-able template of objects that can reference eachother by ID.
\  Figure - an instance-able template of objects.  it can reference its named children directly but nothing outside.
\  (Domains and Figures are nestable within each other.
\  (All containers have their own idioms?)

\ Visual elements
\  [ ] Lineseg
\  [ ] Rectangle
\  [ ] Oval
\  [ ] Grid
\  [ ] Polygon?
\  [ ] Imagearea
\  [ ] Textfield

\ Custom objects can be defined by tools.  The source code for unknown tools is loaded on-the-fly,
\  although this is only supported when running a registered SwiftForth install.  So normally,
\  a tool application has already been compiled into the host Forth image, including all the
\  custom objects it uses.  Objects that the system doesn't understand will not be loaded into
\  the workspace.

bu: idiom ws:
import mo/porpoise
import mo/node
import mo/draw
import mo/pen
import mo/rect
import mo/portion

xmessage paint   ( obj -- obj )
xmessage respond ( allegro-event obj -- obj )
quality template   \ a container

node inherit
    /rect xfield span
    xvar atr  \ attributes
    container sizeof @ xfield kids
    xvar color1 \ 32-bit primary color    (outline, tint) 0 = nothing
    xvar color2 \ 32-bit secondary color  (fill)    0 = nothing
subclass element
$ffffffff element proto @ color1 !


\ visual stuff
element inherit  subclass rectangle
element inherit  subclass lineseg
element inherit  xvar font  xvar ustr  xvar jtype  subclass textarea  \ ustr is [ count , zstr... ]
element inherit  xvar bmp  /rect xfield region  subclass imagearea



: flag  ( offset bitmask -- <name> offset bitmask<<1 )  ( obj -- bitmask adr )
    create dup , over , 1 <<
    does>  dup @ swap cell+ @  rot + ;

: ?nest ( obj xt -- obj )  ( obj -- )
    over kids itterate ;

\ attributes:  word wrap, image flip

: paint-drop  paint drop ;

: color32   hex>color color ;
: ?color1   dup color1 @ ?dup 0= if r> drop then  color32 ;
: at-span   dup span @xy at ;

rectangle :m paint ( obj -- obj )
    at-span
    dup color2 @ ?dup if  color32  dup span @wh rectf  then
    dup color1 @ ?dup if  color32  dup span @wh rect   then ;

lineseg :m paint ( obj -- obj )
    ?color1 at-span  dup span @xy2 line ;

imagearea :m paint ( obj -- obj )
    ?color1 at-span  dup bmp @  over span @wh  0 sdrawf ;

textarea :m paint ( obj -- obj )
    dup ustr @ -exit
    ?color1 at-span
    dup font @ ?dup 0= if  default-font  then  fnt !
    dup ustr @ @+ text ;

: !ustr  ( text count textarea -- )
    &o for>    ( text count )
    o ustr @ free drop
    dup cell+ allocate throw o ustr !
    o ustr @ cell+ swap move ;

\ ui stuff
rectangle inherit  subclass panel
textarea inherit  subclass textbox  \ editable
textbox inherit  subclass button

\ container rstuff
element inherit  subclass workspace
$6a76e9 workspace proto @ color2 ! 
workspace :m paint  ( obj -- obj )
     dup color2 @ 3hex>color clear-to-color
     ['] paint-drop ?nest ;
;


workspace instance home
home value screen

: attach  ( element dest-element -- )  kids pushnode ;
: detach  ( element -- )  remove ;
: make  ( class -- element )  heap portion dup >r  instance!  r> dup screen attach ;

: .screen  screen paint drop ;

: ws
    go>
    render> .screen
;


rectangle make constant r
20 50 100 200 r span !xywh

ws ok
