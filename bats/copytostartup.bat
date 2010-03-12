:: Script to copy stuff to startup folder. 

::				  ::
:: :: path_from needs defining :: ::
::				  ::

@echo off
set path_from=\\jup-rmt07\bats\??
set path_to=%USERPROFILE%/start menu/programs/startup/
set copy_cmd=copy /AVZ

%copy_cmd% "%path_from%" "%path_to%"