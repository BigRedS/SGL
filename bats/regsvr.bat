:: Register all ocx and dll files found in the dirs in the array
:: at line beginning `For %%I In'

@Echo Off
For %%I In ("C:\Windows" "C:\Windows\System32") Do (
PushD %%I
For /F "Tokens=1 Delims=" %%A In ('Dir /A-D /B "%%I\*.dll" "%%I\*.ocx"') Do Regsvr32 /i /s %%A
PopD
)
