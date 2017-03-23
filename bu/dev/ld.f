\ interactive testing tool LD

create workdir 256 allot  " . " workdir place
create lastld  256 allot
: ld  ( -- <filespec> )  \ if filespec is nothing, loads last loaded file
    bl parse  dup 0= if  2drop  lastld count  then
    s[ ]s default.ext lastld place
    workdir c@ if
        workdir count  " \" strjoin  lastld count  strjoin  2dup file-exists if  included  exit then
        2drop
    then
    lastld count  included  ;
: make  workdir count " \make.bat" strjoin >shell ;
