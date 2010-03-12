:: 'Fixes' signatures for Outlook '07
:: Apparently it can't cope with *.html signatures (though '03 could) so 
:: they need renaming to *.htm

c:
cd \
cd "documents and settings\%username%\application data\microsoft\signatures"
for %%J in (*.html) do rename "%%~NJ.html" "%%~NJ.htm"



