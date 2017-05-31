le:
decimal
: jstate ( joy# button# -- 0 ~ 1.0 )
    cells swap joystick[] ALLEGRO_JOYSTICK_STATE-buttons + @  PGRAN 32767 */ ;
