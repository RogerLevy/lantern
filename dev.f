\ Development environment loader
empty

cr .( NOTICE: Audio and other addons will not work on Windows unless you copy all of the )
cr .( dependency DLL's to Swiftforth's bin folder. I tried everything and they just would not )
cr .( work from the lib\ folder. I'm guessing it's a security measure. This shouldn't affect )
cr .( released applications; so long as the DLL's are in the same folder as the turnkey executable,)
cr .( they should load.  You can still load the Allegro DLL without doing this; you just won't )
cr .( be able to play anything but WAV files.)

defined dev 0<> nip not [if]
    s" envconfig.f" file-exists [if]
        include envconfig.f
    [then]
    include bu/lib/preamble         \ base dependencies, incl. Allegro, loaded once per session
    include bu/dev/ld
    true constant dev
    gild
[then]

include bu/core/core.f
gild
[defined] host-ide [if]
    >ide  ld autoexec
[else]
    ld bu/dev/sf/ide2  go
[then]
