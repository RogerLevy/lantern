bu: idiom dialog:
function: al_init_native_dialog_addon ( -- bool )
:noname al_init_native_dialog_addon 0= abort" Couldn't initialize the native dialog addon" ; execute
: dialog  ( zdefault ztitle zfilter ALLEGRO_FILECHOOSER_flags -- zstring|0 )  \ pick a file for save/load
    al_create_native_file_dialog  display over al_show_native_file_dialog drop
    dup al_get_native_file_dialog_count dup if  dup 0 al_get_native_file_dialog_path  then
    swap al_destroy_native_file_dialog ;
