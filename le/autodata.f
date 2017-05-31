\ [ ] sanitize filenames automatically for forth
\ [x] recognize file extensions
le:
import mo/walkdir

private:
    : replace-char ( source n oldch newch -- )
       2swap begin ( old new a n)
          dup while
          fourth scan
          dup if 3dup drop c! then
       repeat 2drop 2drop ;

    : sanitize ( adr c -- adr c )
        -trailing
        2dup bl [char] - replace-char
        2dup [char] _ [char] - replace-char ;

    \ note: the spaces at the end of the strings are important.
    : path>imagename  -path -ext " .image" strjoin sanitize ;
    : path>sfxname  " *" s[  -path -ext +s  " *" +s ]s sanitize ;

    : .evaluate  cr 2dup type evaluate ;

    : *image  ( path count -- )
        2>r  " image "  2r@ path>imagename  strjoin  "  " strjoin  2r> strjoin  .evaluate ;
    : *sfx  ( path count -- )
        2>r  " sfx "  2r@ path>sfxname  strjoin  "  " strjoin  2r> strjoin  .evaluate ;

    : uncount  s[ ]s drop #1 - ;
    : lookup   -trailing uncount find 0= if  " Asset symbol not found.  Exiting..." alert bye  then ;

    : /image  ( path count -- )
        2dup zstring al_load_bitmap -rot  path>imagename lookup >body bmp ! ;
    : /sfx  ( path count -- )
        2dup zstring al_load_sample -rot  path>sfxname lookup >body ! ;

    0 enum TYPE_OTHER enum TYPE_IMAGE enum TYPE_SFX drop
    : type:   ( type -- <ext> ) constant ;

    : wordlist:  get-current  wordlist constant  last @ name> >body @ +order  definitions ;
    : ;wordlist  previous  set-current ;

    wordlist: types
        TYPE_IMAGE type: jpg
        TYPE_IMAGE type: jpeg
        TYPE_IMAGE type: png
        TYPE_IMAGE type: bmp
        TYPE_IMAGE type: gif
        TYPE_IMAGE type: pcx
        TYPE_IMAGE type: tif
        TYPE_IMAGE type: tiff
        TYPE_SFX type: wav
        TYPE_SFX type: ogg
        TYPE_SFX type: mp3
        TYPE_SFX type: wma
        TYPE_SFX type: aif
        TYPE_SFX type: aiff
        TYPE_SFX type: flac
    ;wordlist

    : ext  [char] . scan #1 /string ;

    : filetype  ( path c -- type-enum )
        ext types search-wordlist if  execute  else  TYPE_OTHER  then ;

    : (declare)  >filename  2dup filetype
        case
            TYPE_IMAGE of *image endof
            TYPE_SFX of *sfx endof
            2drop
        endcase
        0 ;
    : (load)  >filename  cr 2dup type  2dup filetype
        case
            TYPE_IMAGE of /image endof
            TYPE_SFX of /sfx endof
            2drop
        endcase
        0 ;

public:

\ automatically declare/load data
: autodata ( -- <path> )  bl parse  ['] (declare) walkdirs ;

\ automatically reload data (turnkey / live-update)
: autoload ( path c --  ) ['] (load) walkdirs ;
