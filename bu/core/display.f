\ display
\   need only one
\   if in the future we need more ... i don't think there's much kus from supporting them

0 value default-font
0 value displaytimer
0 value fps
0 value allegro?
0 value eventq
0 value display
0 value mixer

create ues  32 cells /allot  \ user event source

: emit-user-event  ( event type -- )
    over ALLEGRO_EVENT_TYPE-type !
    ues swap 0 al_emit_user_event drop 
;

\ --------------------------- initializing allegro ----------------------------

: -audio
    mixer 0 al_set_mixer_playing drop
    0 al_set_default_voice drop
    cr ." Audio disabled"
;

: +audio
    #16 al_reserve_samples not if  " Allegro: Error reserving samples." alert -1 abort  then
    al_get_default_mixer to mixer
    \ mixer al_get_default_voice al_attach_mixer_to_voice drop
    mixer #1 al_set_mixer_playing drop
    cr ." Audio enabled"
;

: init-audio
    al_init_acodec_addon not if  " Allegro: Couldn't initialize audio codec addon." alert -1 abort  then
    al_install_audio not if  " Allegro: Couldn't initialize audio." alert -1 abort  then
    +audio
;

: assertAllegro
  allegro? ?exit
  true to allegro?
  al_init
  not if  " INIT-ALLEGRO: Couldn't initialize Allegro." alert     -1 abort then
  al_init_image_addon
  not if  " Allegro: Couldn't initialize image addon." alert      -1 abort then
  al_init_primitives_addon
  not if  " Allegro: Couldn't initialize primitives addon." alert -1 abort then
  al_init_font_addon
  not if  " Allegro: Couldn't initialize font addon." alert       -1 abort then
  al_init_ttf_addon
  not if  " Allegro: Couldn't initialize TTF addon." alert       -1 abort then
  al_install_mouse
  not if  " Allegro: Couldn't initialize mouse." alert            -1 abort then
  al_install_keyboard
  not if  " Allegro: Couldn't initialize keyboard." alert         -1 abort then
  al_install_joystick
  not if  " Allegro: Couldn't initialize joystick." alert         -1 abort then
  ues al_init_user_event_source
  init-audio
;

assertAllegro

\ -------------------- starting/stopping the frame timer ----------------------

: +timer  displaytimer al_get_timer_started ?exit
          al_flip_display  displaytimer al_start_timer ;
: -timer  displaytimer al_stop_timer ;
: timer?  displaytimer al_get_timer_started 0<> ;

\ ----------------------- initializing the display ----------------------------

: initDisplay  ( w h -- )
  assertAllegro
  al_create_event_queue  to eventq
  eventq ues al_register_event_source
  ALLEGRO_VSYNC #1 ALLEGRO_SUGGEST  al_set_new_display_option
  #0 #40 al_set_new_window_position

  0
    ALLEGRO_WINDOWED or
    ALLEGRO_RESIZABLE or
    ALLEGRO_OPENGL_3_0 or
    ALLEGRO_PROGRAMMABLE_PIPELINE or
    al_set_new_display_flags

  2i  al_create_display  to display
  display #0 #0 al_set_window_position
  al_create_builtin_font to default-font
  eventq  display       al_get_display_event_source  al_register_event_source

  displaytimer not if
    1e
      display al_get_display_refresh_rate s>p
      ?dup 0= if 60 then
      dup to fps
      f f/ 1df al_create_timer
        to displaytimer
      eventq  displaytimer  al_get_timer_event_source    al_register_event_source
      eventq                al_get_mouse_event_source    al_register_event_source
      eventq                al_get_keyboard_event_source al_register_event_source
  then

;

: valid?  ['] @ catch nip 0 = ;

fixed
: +display  display valid? ?exit  640 480 initDisplay ;
: -display  display valid? -exit
    display al_destroy_display  0 to display
    eventq al_destroy_event_queue  0 to eventq
    displaytimer  al_destroy_timer  0 to displaytimer ;
: -allegro  -display  false to allegro?  al_uninstall_system ;

\ ------------------------ words for switching windows ------------------------
[defined] linux [if]
    : focus  drop ;
    : >display ;  : >ide ;
[else]
    : focus  ( winapi-window - )                                                    \ force window via handle to be the active window
      dup #1 ShowWindow drop  dup BringWindowToTop drop  SetForegroundWindow drop ;
    : >display  ( -- )  display al_get_win_window_handle focus ;                         \ force allegro display window to take focus
    defer >ide
    :noname [ is >ide ]  ( -- )  HWND focus ;                                                     \ force the Forth prompt to take focus
    >ide
[then]

create native  /ALLEGRO_DISPLAY_MODE /allot
  al_get_num_display_modes #1 -  native  al_get_display_mode

: nativew   native x@ s>p ;
: nativeh   native y@ s>p ;
: nativewh  nativew nativeh ;
: displayw  display al_get_display_width s>p ;
: displayh  display al_get_display_height s>p ;
: displaywh  displayw displayh ;

+display
