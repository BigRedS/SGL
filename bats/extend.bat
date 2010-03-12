:: Deletes Outlook's extend.dat and clear it's cache of extensions, forcing it to
:: re-discover McAfee.
:: Should be run with Outlook not open.

:: close outlook:
taskkill /IM outlook.exe /T
:: Delete file:
del "%USERPROFILE%\Local Settings\Application Data\Microsoft\Outlook\Extend.dat"
