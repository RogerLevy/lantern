\ Private game object idioms
le:

quality script   \ game object's private idiom, automatically created when you subclass
: script:  dup proto @ be   script @ set-idiom  private: ;

\ create a child idiom of the superclass's idiom.
0 value (script)
: script-inherit  ( superclass -- )
    script @ inherit-idiom to (script)  (script) set-idiom  private: ;
: script-subclass  ( class -- )
    (script) swap script ! ;
