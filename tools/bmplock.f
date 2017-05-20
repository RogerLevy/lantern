bu: idiom bmplock:
ALLEGRO_LOCK_WRITEONLY constant w/o
ALLEGRO_LOCK_READONLY constant r/o
ALLEGRO_LOCK_READWRITE constant r/w
: lock  ( bitmap method -- region ) ALLEGRO_PIXEL_FORMAT_ARGB_8888 swap al_lock_bitmap ;
: unlock  ( bitmap -- )  al_unlock_bitmap ;
: lock>  ( bitmap method -- region <code> ) over >r lock r> r> swap >r call r> unlock ;
: pitch+  ( data region -- data+pitch )  ALLEGRO_LOCKED_REGION-pitch @ + ;
: >rgndata   ( region -- data )  ALLEGRO_LOCKED_REGION-data @ ;
