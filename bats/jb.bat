::Copy and register ocx files
copy "\\jup-svr02\apps\job bag\latest update\0 july05 2.12.1 install all\mscomct2.ocx" "c:/windows/system32/mscomct2.ocx"
copy "\\jup-svr02\apps\job bag\latest update\0 july05 2.12.1 install all\mscal.ocx" "c:/windows/system32/mscal.ocx"

regsvr32 mscomct2.ocx
regsvr32 mscal.ocx

::Create c:/jbwv2 dir and apply relevant perms
c:
mkdir jbwv2

:: Install Job Bag
"\\jup-svr02\apps\job bag\latest update\0 july05 2.12.1 install all\setup.exe"
"\\jup-svr01\jbupdate\jbwv2update.exe"

cacls c:/jbwv2 /E /G "domain users@sgl:F"

:: Run Job Bag to set path
c:/jbwv2/jbwv2.exe