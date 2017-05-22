\ Simpler IDE, library-style.
\  This is a one-way street.  A default piston is configured, but from now on TYPE and friends
\   are redefined.  (For now, we're using SwiftForth's PERSONALITY facility to save
\   time.  Later, a complete replacement for all text output words will need to be implemented...)

\ go> words:
\   REPL  ( -- )  processes commandline events.
\ render> words:
\   BOTTOM  ( -- x y )  gives x,y where commandline should be positioned for it to appear at the bottom of the screen.
\   .CMDLINE  ( -- )  displays the commandline at given pen position and font, including the current idiom and the stack
\   .OUTPUT  ( -- )  displays commandline output
\ misc words:
\   CMDFONT  a VALUE containing the current font for the commandline
\   /CMDLINE  ( -- )  initializes the commandline.
\   MARGINS  ( -- rect )  dimensions for the command history.  defaults to the entire screen, minus 40 pixels at the bottom
\   TABBED  ( -- adr )  variable, when set to ON, the commandline is active.

bu: idiom ide2:
[defined] linux [if]  [else]  include bu/lib/win-clipboard.f  [then]
import mo/draw
import mo/rect

variable consolas
consolas constant cmdfont
private:
    0  xvar x  xvar y  4 cells xfield color  struct /cursor
public:
create cursor  /cursor /allot
variable scrolling  scrolling on
create testbuffer #256 /allot
create history  #256 /allot
create ch  0 c, 0 c,
create margins  0 , 0 , 0 , 0 ,   \ margins for the command history
create attributes
  1 , 1 , 1 , 1 ,
  0 , 0 , 0 , 1 ,
  0.3 , 1 , 0.3 , 1 ,
  1 , 1 , 0.3 , 1 ,
  1 , 1 , 0 , 1 ,
transform baseline
variable output   \ output bitmap

: fontw  z" A" al_get_text_width s>p ;
: fonth  al_get_font_line_height s>p ;
: fw  cmdfont @ fontw ;
: fh  cmdfont @ fonth ;
: cols  fw * ;
: rows  fh * ;
: #cmdrows  margins @h 1 - fh / pfloor ;
: rm  margins @x2  displayw min ;
: bm  margins @y2  displayh min ;
: lm  margins @x  displayw >= if  0  else  margins @x  then ;
: tm  margins @y  displayh >= if  0  else  margins @y  then ;
: ?call  ?dup -exit call ;
: ?.catch  ?dup -exit .catch ;
: recall  history count testbuffer place ;
: store   testbuffer count history place ;
: typechar  testbuffer count + c!  #1 testbuffer c+! ;
: rub       testbuffer c@  #-1 +  0 max  testbuffer c! ;
: paste     clpb testbuffer append ;
: ?paused  pause @ if  -timer  0 +to lag   else  +timer  then ;
: keycode  e ALLEGRO_KEYBOARD_EVENT-keycode @ ;
: unichar  e ALLEGRO_KEYBOARD_EVENT-unichar @ ;
private:
  : ctrl?  e ALLEGRO_KEYBOARD_EVENT-modifiers @ ALLEGRO_KEYMOD_CTRL and ;
  : alt?  e ALLEGRO_KEYBOARD_EVENT-modifiers @ ALLEGRO_KEYMOD_ALT and ;
public:

\ --------------------------------------------------------------------------------------------------
\ Input handling
: special
  case
    [char] v of  paste  endof
    [char] p of  pause toggle  endof
  endcase ;
: idekeys
    \ always processed...
    etype ALLEGRO_EVENT_KEY_DOWN = if
        keycode dup #37 < if  drop exit  then
            case
                <tab> of  tabbed toggle  endof
            endcase
    then

    \ only when cmdline has tabbed...
    tabbed @ -exit
    etype ALLEGRO_EVENT_KEY_CHAR = if
        ctrl? if
            unichar $60 + special
        else
            unichar #32 >= unichar #126 <= and if
            unichar typechar  exit
        then
        keycode case
            <up> of  recall  endof
            <down> of  cancel  endof
            <enter> of  alt? ?exit  obey  endof
            <backspace> of  rub  endof
        endcase
    then
;

\ --------------------------------------------------------------------------------------------------
\ Output words
private:
    : get-xy  ( -- #col #row )  cursor x 2v@  lm tm 2-  fw fh 2/ 2i ;
    : at-xy   ( #col #row -- )  2s>p fw fh 2*  lm tm 2+  cursor x 2v! ;
    : clear  ( x y w h )
      write-rgba blend
      output onto  2over 2+ 1 1 2+ 4af   0 1af dup dup dup  al_draw_filled_rectangle
    ;
    : outputw  rm lm - ;
    : outputh  bm tm - ;
    : .stack
      lm  outputh fh / 3 - fh *   rm lm - fh 2 *  clear
        scrolling off
            get-xy 2>r  0 outputh fh / 3 - 2i at-xy  .s  2r> at-xy
        scrolling on
    ;
    : scroll
      lm  bm   rm lm -  outputh third - clear
      write-rgba blend
      output onto  output  0  fh negate  2af  0  al_draw_bitmap
      fh negate cursor y +!
    ;
    : cr
        lm cursor x !
        fh cursor y +!
        scrolling @ -exit
        cursor y @ bm >= if  scroll  then
    ;
    : 4@af  @+ swap @+ swap @+ swap @+ nip 4af ;
    : (emit)
        ch c!  0 ch #1 + c!
        sysfont  cursor color 4@af  cursor x 2v@ 2af  0  ch al_draw_text
        fw cursor x +!
        cursor x @ rm >= if  cr  then
    ;
    : emit  output onto  (emit) ;
    decimal
        : type  output onto  bounds  do  i c@ (emit)  loop ;
        : ?type  ?dup if type else 2drop then ;
    fixed
    : attribute  s>p 4 cells * attributes +  cursor color  4 cells move ;
    : page  output onto  0 0 0 0 backdrop  0 0 at-xy ;

    create console-personality
      4 cells , #19 , 0 , 0 ,
      ' noop , \ INVOKE    ( -- )
      ' noop , \ REVOKE    ( -- )
      ' noop , \ /INPUT    ( -- )
      ' emit , \ EMIT      ( char -- )
      ' type , \ TYPE      ( addr len -- )
      ' ?type , \ ?TYPE     ( addr len -- )
      ' cr , \ CR        ( -- )
      ' page , \ PAGE      ( -- )
      ' attribute , \ ATTRIBUTE ( n -- )
      ' dup , \ KEY       ( -- char )  \ not yet supported
      ' dup , \ KEY?      ( -- flag )  \ not yet supported
      ' dup , \ EKEY      ( -- echar ) \ not yet supported
      ' dup , \ EKEY?     ( -- flag )  \ not yet supported
      ' dup , \ AKEY      ( -- char )  \ not yet supported
      ' 2drop , \ PUSHTEXT  ( addr len -- )  \ not yet supported
      ' at-xy ,  \ AT-XY     ( x y -- )
      ' get-xy , \ GET-XY    ( -- x y )
      ' 2dup , \ GET-SIZE  ( -- x y )
      ' drop , \ ACCEPT    ( addr u1 -- u2)  \ not yet supported
public:
\ --------------------------------------------------------------------------------------------------


: cancel   testbuffer off ;
: echo     cursor color 4@  #4 attribute  cr  testbuffer count type space  cursor color 4! ;
: interp   echo  testbuffer count evaluate ;
: obey     store  ['] interp catch ?.catch  cancel ;

: bottom  0  bm 2 rows - ;

: ?half  tabbed @ if 1 else 0.5 then ;
: .output  output  1 1 1 ?half 4af  outputw outputh 2af  0  al_draw_tinted_bitmap ;

: /cmdline
    z" dev/data/dev/consolas16.png" al_load_bitmap_font  consolas !
    nativew nativeh 2i al_create_bitmap  output !
    1 1 1 1 cursor color ~!+ ~!+ ~!+ ~!+ drop
    0 0 displayw displayh 40 - margins !xywh

;  /cmdline

: repl  idekeys ;
