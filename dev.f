\ Development environment loader
empty

defined dev 0<> nip not [if]
    include bu/lib/preamble         \ base dependencies, incl. Allegro, loaded once per session
    include dev/ld   including -name workdir place
    true constant dev
    s" envconfig.f" file-exists [if]
        include envconfig.f
    [then]
    : /autoexec  " ld " s[  workdir count +s  " \autoexec" +s  ]s evaluate ;
    gild
[then]

include bu/core/core.f  >ide
gild
/autoexec

\ [defined] USE_IDE [if]
\     include bu/core/core.f ide
\     gild
\     /autoexec
\ [else]
\ \    include dev//ide.f ide
\ [then]
