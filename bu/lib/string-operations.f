: " postpone s" ; immediate

\ zero-term strings

[undefined] zcount [if]
: zcount ( zaddr -- addr n )   dup dup if  65535 0 scan drop over - then ;
: zlength ( zaddr -- n )   zcount nip ;
: zplace ( from n to -- )   tuck over + >r  cmove  0 r> c! ;
: zappend ( from n to -- )   zcount + zplace ;
[then]

\ ------------------------------------------------------------------------------
\ string concatenation
\ NOTE: this is not implemented the best way and is probably due for a rehaul

create $buffers  16384 allot  \ string concatenation buffer stack (circular)
variable >s                   \ pointer into $buffers

\ intent: begin a builder-string
\ usage: <string> s[
: s[  ( adr c - )  \ begin a string.  NOTE: this component not implemented the best way and is due for a rehaul!
  >s @ 256 + 16383 and >s !  >s @ $buffers + place ;

\ intent: concatenate string to current builder-string (call s[ first)
\ usage: <string> +s
: +s  ( adr c - )  \ append a string to current string
  >s @ $buffers + append ;

\ intent: concatenate a character to current builder-string (call s[ first)
\ usage: <character> c+s
: c+s  ( c - )  \ append a char to current string
  >s @ $buffers + count + c!  1 >s @ $buffers + c+! ;

create $outbufs  16384 allot \ output buffers; circular stack of buffers
variable >out

\ intent: finish building the string and fetch the finished counted string  (call s[ then +s or c+s first)
\ usage: ]s
: ]s  ( - adr c )  \ fetch finished string
  >s @ $buffers + count >out @ $outbufs + place
  >out @ $outbufs + count
  >out @ 256 + 16383 and >out !
  >s @ 256 - 16383 and >s ! ;

\ MINI STRING-BUILDING TUTORIAL
\ If you want to build the string " This is a test" from the four words
\ You can use the following example code
\ : mini-string-building-tutorial  ( - )  \ example code for string building
\   " This" s[  \ start builder-string
\   "  is" +s   \ append to builder-string
\   "  a" +s    \ append to builder-string
\   "  test" +s \ append to builder-string
\   ]s          \ finish building the string and fetch the finished counted string
\   ;

\ intent: counted string to zstring conversion
\ usage: <string> zstring
: zstring  ( addr c - zaddr )  \ convert string to zero-terminated string
  >out @ $outbufs + zplace  >out @ $outbufs +  >out @ 256 + 16383 and >out ! ;

\ intent: append a character to the end of a counted string
\ usage: <character> <addr> cappend
: cappend  ( c adr - )  \ append char
  dup >r  count + c!  1 r> c+! ;

\ intent: reverse the count operation on a counted string
\ usage: <string> uncount
: uncount  ( adr c - adr-1 )  \ 'undo' the count word's operation
  drop 1 - ;

\ intent: concatenate two strings
\ usage: <string1> <string2> strjoin
: strjoin  ( first c second c - first+second c )  \ concat strings
  2swap s[ +s ]s ;

\ intent: provide a means to get string input from the user
\ usage: <buffer> <size> input
: input  ( adr c - )  \ get a string from the user
  over 1 +  swap accept  swap  c! ;

: <filespec>  ( -- <rol> addr c )  0 parse -trailing bl skip ;                  \ rol=remainder of line
: <zfilespec> ( -- <rol> addr )  <filespec> zstring ;
