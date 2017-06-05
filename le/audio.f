le:
: sfx  ( -- <name> <path> )
  create  <filespec> zstring al_load_sample ,
  does> @ 1 0 1 3af ALLEGRO_PLAYMODE_ONCE 0 al_play_sample ;
