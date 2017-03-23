create output 256 allot
: clpb  ( -- adr c )
  HWND OpenClipboard drop
  CF_TEXT GetClipboardData GlobalLock
    dup zcount output place
  GlobalUnlock drop
  CloseClipboard drop
  output count ;

