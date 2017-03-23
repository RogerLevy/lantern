\ code packer
\  drills the file structure for .f files, compiling them into the dictionary as
\  words identified by their relative path.


\  loading this file loads everything from the top, starting at main.f, not dev.f

\  INCLUDE is redefined twice.
\    first, we extend it to bring the file in as a word of the same name, including the path.  also interpret it.
\    after loading everything, we redefine it to look for the source in the dictionary,
\     and set the interpreter to interpret that.
