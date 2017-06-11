\ Development environment loader
empty

defined dev 0<> nip not [if]
    include bu/lib/preamble         \ base dependencies, incl. Allegro, loaded once per session
    include dev/ld
    true constant dev
    s" envconfig.f" file-exists [if]
        include envconfig.f
    [then]
    gild
[then]

include bu/core/core.f  >ide
gild
ld dev/sf/ide2  go
