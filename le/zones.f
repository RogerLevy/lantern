actor inherit  var zonetype  var 'trigger  var 'zonestart  class zone

: zone>  ( w h zonetype -- <code> )
  zone one  zonetype !  w 2v!  r> code> dup 'zonestart !  execute ;

: resetZone  ( zone -- )  me >r  as  'zonestart @ execute  r> as ;
: trigger    ( zone -- )  me >r  as  'trigger @ execute  r> as ;
: trigger>  r> code> 'trigger ! ;

zone start:  CZONE# cflags ! ;



\ dialog zone:

\  player is in a zone -> action button -> current zone -> trigger -> dialog & reassign trigger
\  there's different kinds of dialogs.
\    we need to be able to create a dialog that closes itself if the player moves out of the zone.



: pik  ( zone1 zone2 -- zone1 | zone2 )
    over 's zonetype @  over 's zonetype @ <= if  nip  else  drop then ;


detector: >zone  ( zone you=other flag -- zone flag )
  you zone is? -exit  ( flag )  >r  ( zone ) you  pik  r> ;

: current-zone ( me=actor -- zone | 0 )
  dummy  >zone  dup dummy = -exit  drop 0 ;

\ dialog stuff

: dialog>  'dialog on  ; \ r> code> 'dialog ! ;



\ zone stuff

: jumptable  create does> swap th @ execute ;

: talk/  'dialog off ;

jumptable zone/  ' noop , ' talk/ ,

: ?talk  <a> kpressed -exit  player 's current-zone trigger ;

jumptable ?trigger  ' noop , ' ?talk ,



: untrigger  ( zone -- )  ?dup -exit  dup resetZone  's zonetype @ zone/ ;



0 value lastZone
: zones
  player 's current-zone  dup if
    dup lastZone <> if  lastZone untrigger  then
    dup 's zonetype @ ?trigger
  else
    lastZone untrigger
  then
  ( zone ) to lastZone ;


: ?zone  ( -- zone | [earlyout] )  player 's current-zone ?dup ?exit r> drop ;

 
