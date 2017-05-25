\ Values
0 value #frames \ frame counter.
0 value renderr
0 value steperr
0 value alt?  \ part of fix for alt-enter bug when game doesn't have focus
0 value breaking?
0 value lag  \ completed ticks
0 value 'go
0 value 'step
0 value 'render

\ Flags
variable info  \ enables debugging mode display
variable allowwin  allowwin on
variable fs    \ is fullscreen enabled?

create fse  /ALLEGRO_ANY_EVENT /allot  \ fullscreen event
#999 constant EVENT_FULLSCREEN 

: poll  pollKB  pollJoys  [defined] dev [if] pause [then] ;
: break  true to breaking? ;
: -break  false to breaking? ;

\ [defined] dev [if]
\     : try  dup -exit ['] call catch ;
\ [else]
    : try  dup -exit call 0 ;
\ [then]

private:
    \ : alt?  e ALLEGRO_KEYBOARD_EVENT-modifiers @ ALLEGRO_KEYMOD_ALT and ;
    : wait  eventq e al_wait_for_event ;
    : std
      etype ALLEGRO_EVENT_DISPLAY_RESIZE = if
        -timer  display al_acknowledge_resize  +timer  \ we have to turn off the timer to avoid a race condition
                                                       \ where bitmaps aren't recreated before trying to draw to them
      then
      etype ALLEGRO_EVENT_DISPLAY_SWITCH_OUT = if  -timer  then
      etype ALLEGRO_EVENT_DISPLAY_SWITCH_IN = if  clearkb  +timer false to alt?  then
      etype ALLEGRO_EVENT_DISPLAY_CLOSE = if  0 ExitProcess  then
      etype ALLEGRO_EVENT_KEY_DOWN = if
        e ALLEGRO_KEYBOARD_EVENT-keycode @ case
          <alt>    of  true to alt?  endof
          <altgr>  of  true to alt?  endof
          <enter>  of  alt? -exit  fs toggle  endof
          <f4>     of  alt? -exit  0 ExitProcess endof
          <f5>     of  refresh  endof
          <f12>    of  break  endof
          <tilde>  of  alt? -exit  info toggle  endof
        endcase
      then
      etype ALLEGRO_EVENT_KEY_UP = if
        e ALLEGRO_KEYBOARD_EVENT-keycode @ case
          <alt>    of  false to alt?  endof
          <altgr>  of  false to alt?  endof
        endcase
      then ;
    : update?  lag dup -exit drop  eventq al_is_event_queue_empty  lag 4 >= or ;
public:


: fsflag  fs @ allowwin @ not or ;
: ?fserr  0= if fs off  " Fullscreen is not supported by your driver." alert  then ;
variable winx  variable winy
: ?poswin   \ save/restore window position when toggling in and out of fullscreen
    display al_get_display_flags ALLEGRO_FULLSCREEN_WINDOW and if
        fs @ 0= if  r> call  display winx @ winy @ al_set_window_position  then
    else
        fs @ if     display winx winy al_get_window_position  then
    then ;

variable newfs
: ?fs
    ?poswin  display ALLEGRO_FULLSCREEN_WINDOW fsflag al_toggle_display_flag ?fserr
    fs @  newfs @ 0= and if
        fse EVENT_FULLSCREEN emit-user-event
    then
    fs @ newfs ! ;

: render  ?fs  1-1  'render try to renderr   al_flip_display  0 to lag ;
: ?render  update? -exit  1 +to #frames  render ;
: ?step  etype ALLEGRO_EVENT_TIMER = if  poll  1 +to lag   'step try to steperr  then ;

: render>  r>  to 'render ;  ( -- <code> )  ( -- )
: step>  r>  to 'step ;  ( -- <code> )  ( -- )
: go>  r> to 'go   0 to 'step ;  ( -- <code> )  ( -- )

: ok
    resetkb  -break  >display  +timer  render
    begin
        wait  begin
            std  'go try drop  ?step  ?render  eventq e al_get_next_event not  breaking? or
        until  ?render  \ again for sans timer
    breaking? until
    -timer  >ide  -break ;

: wait  -timer  1 to lag ;
