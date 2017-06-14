le:
: sfx  ( -- <name> <path> )
    create  <filespec> zstring al_load_sample ,
    does> @ 1 0 1 3af ALLEGRO_PLAYMODE_ONCE 0 al_play_sample ;


0 value s  \ pointer to a variable
: stream  ( path c playmode variable -- )   to s  >r
    zstring #3 #1024 al_load_audio_stream s !
    s @ r> al_set_audio_stream_playmode drop
    s @ mixer al_attach_audio_stream_to_mixer drop ;

: fin  ( variable -- )  @ ?dup -exit  dup  al_set_audio_stream_playing drop  al_destroy_audio_stream ;

variable bgm
: play  ( path c -- )  bgm fin  ALLEGRO_PLAYMODE_LOOP bgm stream ;

: recite  ( path c variable -- variable )  dup >r   ALLEGRO_PLAYMODE_ONCE r@ stream  r> ;
