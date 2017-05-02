\ include stranger/stranger.f [stranger]
cr
cr .( Directory: )
cr

\ : project
\     create cr  last @ count type  space space space  0 parse 2dup type
\             string,
\     does> count lastld place  lastld count included ;
\
\ project dumbtest ex/dumbtest/main
\ \ project race relayrace/main
\ project arnie arnie/dev
