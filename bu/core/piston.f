\ Values
0 value #frames \ frame counter.
0 value lag  \ completed ticks
0 value breaking?
0 value showerr
0 value steperr
0 value alt?  \ part of fix for alt-enter bug when game doesn't have focus

_private
  0 value 'go
  0 value 'step
  0 value 'show
_public

\ Flags
variable info  \ enables debugging mode display
variable allowwin  allowwin on
variable fs    \ is fullscreen enabled?

: poll  pollKB  pollJoys  [defined] dev [if] pause [then] ;
: break  true to breaking? ;
: -break  false to breaking? ;

\ [defined] dev [if]
\     : try  dup -exit ['] call catch ;
\ [else]
    : try  dup -exit call 0 ;
\ [then]

_private
    \ : alt?  e ALLEGRO_KEYBOARD_EVENT-modifiers @ ALLEGRO_KEYMOD_ALT and ;
    : wait  eventq e al_wait_for_event ;
    : std
      etype ALLEGRO_EVENT_DISPLAY_RESIZE = if
        display al_acknowledge_resize
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
_public


: fsflag  fs @ allowwin @ not or ;
: ?fs     display ALLEGRO_FULLSCREEN_WINDOW fsflag al_toggle_display_flag drop ;
: ?show  update? if  ?fs 'show try to showerr   al_flip_display  0 to lag   1 +to #frames  then ;
: ?step  etype ALLEGRO_EVENT_TIMER = if  poll  1 +to lag   'step try to steperr  then ;

: show>  r>  to 'show ;  ( -- <code> )
: step>  r>  to 'step ;  ( -- <code> )  \ has to be done this way or display update will never fire
: go>  r> to 'go   0 to 'step ;  ( -- <code> )

: ok
    resetkb  -break  -ide  +timer
    begin
        wait  begin
            std  'go try drop  ?step  ?show  eventq e al_get_next_event not  breaking? or
        until  ?show  \ again for sans timer
    breaking? until
    -timer ide  -break ;

