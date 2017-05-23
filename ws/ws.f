\ Workspaces
\  Development-time Overlay

\  An IDE that integrates an interactive commandline and a GUI system for making game dev tools.
\  Is based around a future-proof data file called a Session that stores the state of users'
\  interfaces in a human readable format.  Sessions store containers called Figures, which are
\  full of objects.
\  FUTURE: Figures will be able to store source code.  (To be used by the future independent interpreter)
\  In the factory default state, there is a single workspace that acts as a home screen.
\  From here, you can load and enter other workspaces either by clicking a button or typing a command.
\  Workspaces can implement their own internal workspace-loading-and-switching mechanisms, for
\  convenience and to control what the user can do.  For instance, a planned app called Game Tools
\  will contain at least 3 predetermined workspaces that can be switched between.  All 3 of these
\  workspaces can't be deleted and are stored in session files that store the state of Game Tools as well
\  as tell the Workspaces how to reconstruct the Game Tools interface.  In this way, a large degree
\  of potential customization of the interface is afforded to the user - as much as the developer allows.
\  Even additional workspaces can be created by the user (unless this feature is disabled) and
\  added to the session file.
\  In the future, a unified browser-like navigation system may be implemented.
\  Workspaces supports switching between a running app (typically a game) and the session.
\  The game screen will be implemented as a second default workspace.

\ UI elements
\  [ ] Textbox
\  [ ] Panel
\  [ ] Button
\  [ ] Scrollarea
\  [ ] Pagearea

\ Container-type elements
\  [ ] Workspace - the container to which "master" tool application code is assigned.
\  [ ] Domain - an instance-able template of objects that can reference eachother by ID.
\  [ ] Figure - an instance-able template of objects.  it can reference its named children directly but nothing outside.
\  [ ] Toolbox
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
import mo/rect
import mo/portion

xmessage paint   ( obj -- obj )
xmessage respond ( obj -- obj )
\ quality template   \ a container

node inherit
    /rect xfield span
    xvar atr  \ attributes
    container sizeof @ xfield kids
    xvar color1 \ 32-bit primary color    (outline, tint) 0 = nothing
    xvar color2 \ 32-bit secondary color  (fill)    0 = nothing
subclass element
$ffffffff element proto @ color1 !
element :m respond  ;
element :m paint   ;

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


: color32   hex>color color ;
: ?color1   dup color1 @ ?dup 0= if r> drop then  color32 ;
: +translate   dup span @xy +at ;
: -translate   dup span @xy 2negate +at ;
: ?error  drop ;
: paint-kid  +translate ['] paint catch swap -translate drop ?error ;


rectangle :m paint ( obj -- obj )
    dup color2 @ ?dup if  color32  dup span @wh rectf  then
    dup color1 @ ?dup if  color32  dup span @wh rect   then ;

lineseg :m paint ( obj -- obj )
    ?color1  dup span @xy2 line ;

imagearea :m paint ( obj -- obj )
    ?color1  dup bmp @  over span @wh  0 sblitf ;

textarea :m paint ( obj -- obj )
    dup ustr @ -exit
    ?color1
    dup font @ ?dup 0= if  default-font  then  fnt !
    dup ustr @ @+ text ;

: !ustr  ( text count textarea -- )
    &o for>    ( text count )
    o ustr @ free drop
    dup cell+ allocate throw o ustr !
    o ustr @ cell+ swap move ;

: !bmp  ( bitmap w h imagearea -- )
    &o for>  o span !wh  o bmp ! ;

\ ui stuff
rectangle inherit  subclass panel
textarea inherit  subclass textbox  \ editable
textbox inherit  subclass button

\ container stuff
element inherit  subclass figure
figure :m paint  ( obj -- obj )
     ['] paint-kid ?nest ;
;

figure inherit  subclass workspace
figure inherit  subclass panel

$6a76e9 workspace proto @ color2 ! 
workspace :m paint  ( obj -- obj )
     dup color2 @ 3hex>color clear-to-color
     ['] paint-kid ?nest ;
;




workspace instance home
home value screen          \ current workspace

: attach  ( element dest-element -- element )  udup kids pushnode ;
: detach  ( element -- element )  dup remove ;
: make  ( class -- element )  heap portion dup >r  instance!  r> screen attach ;

: .screen  screen paint drop ;

0 value hovering  \ element under mouse.
create hoverpos 0 , 0 ,
0 value focus     \ element that has keyboard focus.

: emousexy  e ALLEGRO_MOUSE_EVENT-x 2v@ ;
: overlap? ( xyxy xyxy - flag )  2swap 2rot rot > -rot <= and >r rot >= -rot < and r> and ;
: >relspan  ( element -- x y x y ) span @xywh 2>r at@ 2+ 2r> 2over 2+ ;
: (/hover)  ( element -- )
    &o for>
    emousexy 2dup  o >relspan 4i
        overlap? if  o to hovering  emousexy o span @xy 2- 2s>p hoverpos 2v! then
    o [ LAST @ NAME> ] literal ?nest
    drop ;
: /hover  0 0 at  screen to hovering  screen ['] (/hover) ?nest drop ;
: ?respond  ?dup -exit respond drop ;
: listen
    etype ALLEGRO_EVENT_MOUSE_AXES =
    etype ALLEGRO_EVENT_MOUSE_WARPED = or
        if  /hover  then
    etype ALLEGRO_EVENT_MOUSE_AXES =
    etype ALLEGRO_EVENT_MOUSE_BUTTON_DOWN = or
    etype ALLEGRO_EVENT_MOUSE_BUTTON_UP = or
    etype ALLEGRO_EVENT_MOUSE_WARPED = or
        if  hovering ?respond  then
    etype ALLEGRO_EVENT_KEY_DOWN =
    etype ALLEGRO_EVENT_KEY_CHAR = or
    etype ALLEGRO_EVENT_KEY_UP   = or
        if  focus ?respond  then
;

: ws  -timer  go>  listen  render> .screen ;

: put  ( element x y -- element )  third span !xy ;
: resize  ( element w h -- element )  third span !wh ;

: ?mdown  ( -- #button|0 )
    etype ALLEGRO_EVENT_MOUSE_BUTTON_DOWN =  e ALLEGRO_MOUSE_EVENT-button @  and ;
: ?mup  ( -- #button|0 )
    etype ALLEGRO_EVENT_MOUSE_BUTTON_UP =  e ALLEGRO_MOUSE_EVENT-button @  and ;
: mx  ( element -- element x )  hoverpos x@ ;
: my  ( element -- element y )  hoverpos y@ ;
: hovered?  ( -- flag )  etype ALLEGRO_EVENT_MOUSE_AXES =  etype ALLEGRO_EVENT_MOUSE_WARPED = ;


\ === TEST ===
rectangle make constant r
20 50 100 200 r span !xywh

imagearea inherit subclass clickme
clickme :m respond  ?mdown ?dup if  cr ." HELLO WORLD!!!!!!! " h.  mx . my . then ;
clickme make constant b
z" ws/data/images/testcard.png" al_load_bitmap dup bmpwh b !bmp


ws ok
