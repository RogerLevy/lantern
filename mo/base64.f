
: 64,  ( base64-src count -- )
  str-new >r  r@ b64-decode here over allot swap move  r> str-free ;
