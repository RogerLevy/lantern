bu: idiom walkdir:
private:
    0 value stop?
public:
: (walkdir)  ( dir-fsentry xt recursive? -- )  ( fsentry -- stop? )
    locals| recursive? xt dir |
    dir al_open_directory 0= abort" WALKDIR: Could not open directory."
    begin  dir al_read_directory ?dup  stop? 0= and  while
        ( file-fsentry ) dup al_get_fs_entry_mode ALLEGRO_FILEMODE_ISDIR and  recursive? and if
            ( dir ) xt true recurse
        else
            dup >r  xt execute  to stop?
            r> ( file ) al_destroy_fs_entry
        then
    repeat
    dir al_close_directory 0= abort" WALKDIR: Could not close directory."
    dir al_destroy_fs_entry ;
: walkdir  ( path c xt -- )  ( path c -- stop? )
    0 to stop?  >r  zstring al_create_fs_entry  r>  false (walkdir) ;
: walkdirs  ( path c xt -- )  ( path c -- stop? )  \ recursive walk
    0 to stop?  >r  zstring al_create_fs_entry  r>  true (walkdir) ;
: >filename  al_get_fs_entry_name zcount ;
