
create oldblender  6 cells allot
: blend>  ( op src dest aop asrc adest -- )
  oldblender dup cell+ dup cell+ dup cell+ dup cell+ dup cell+ al_get_separate_blender
  al_set_separate_blender  r> call
  oldblender @+ swap @+ swap @+ swap @+ swap @+ swap @ al_set_separate_blender ;

: write-rgba  ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ZERO ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ZERO ;
: add-rgba    ALLEGRO_ADD ALLEGRO_ALPHA ALLEGRO_ONE  ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ONE  ;
: blend-rgba  ALLEGRO_ADD ALLEGRO_ALPHA ALLEGRO_INVERSE_ALPHA  ALLEGRO_ADD ALLEGRO_ONE ALLEGRO_ONE ;

blend-rgba al_set_separate_blender 
