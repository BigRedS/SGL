#! /bin/bash

# set variable to command line
ExecuteEditor="/usr/bin/gvim filename.ext"
# execute external command.
#ExecuteEditor &
file=filename.txt

echo "$VISUAL $file &"
