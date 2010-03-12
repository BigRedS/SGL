mkdir u:\documents
mkdir u:\outlook

reg.exe delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Personal /f

reg.exe Add  "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Personal /t REG_SZ /d "u:\documents"

