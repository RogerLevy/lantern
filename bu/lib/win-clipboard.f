create clp 256 allot
: clipb  ( -- adr c )
    HWND OpenClipboard drop
    CF_TEXT GetClipboardData GlobalLock
      dup zcount clp place
    GlobalUnlock drop
    CloseClipboard drop
    clp count ;

