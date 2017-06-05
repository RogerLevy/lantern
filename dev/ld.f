\ interactive testing tool LD (Windows only...)

create lastld  256 allot

: fullpath ( adr c -- adr c )
    tempbuf 0 locals| dummy outbuf |
    zstring #255 outbuf &of dummy GetFullPathName GetLastError ?dup if zcount ?abort then
    outbuf swap ;

: ld  ( -- <filespec> )  \ if filespec is nothing, displays last loaded file
    bl parse  dup 0= if
        2drop  lastld count type exit
    else
        2dup  s[ ]s default.ext  fullpath lastld place
    then
    included  ;

: rld
    cr ." Press Enter to reload the following file, or any other key to cancel:"
    cr lastld count type
    key dup 0 =  swap #13 =  or  -exit
    lastld count included ;

: make  " make.bat" >shell ;
