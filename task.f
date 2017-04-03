\ Actor tasking system.

\ The following words should only be used within a task:
\  YIELD END FRAMES SECS
\ The following words should never be used within a task:
\  - External calls
\  - Console output (this might be able to be worked around)
\  - EXIT or ; from the "root" (the definition containing PERFORM> )

include le/taskdata
include le/taskverbs
