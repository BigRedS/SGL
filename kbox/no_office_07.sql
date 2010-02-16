-- This is the SQL behind the no_office_07 report --

/*

First we left join MACHINE and M_S_JT, then that with SOFTWARE
such that we have a table of all the info on every software install.

We then select hostnames from this, where we cannot find an associated
software install that matches the office 07 regex.

*/


select 	MACHINE.NAME as SYSTEM_NAME, 
	USER_FULLNAME, 
	SOFTWARE.DISPLAY_NAME as SOFTWARE_DISPLAY_NAME 

FROM (
	(
	MACHINE	left join MACHINE_SOFTWARE_JT on 
		MACHINE_SOFTWARE_JT.MACHINE_ID = MACHINE.ID
	)

	left join SOFTWARE on 
		SOFTWARE.ID = MACHINE_SOFTWARE_JT.SOFTWARE_ID 

WHERE   
	(1 not in (
	(select 1 
		from SOFTWARE, MACHINE_SOFTWARE_JT 
		where MACHINE_SOFTWARE_JT.MACHINE_ID = MACHINE.ID 
		and SOFTWARE.ID = MACHINE_SOFTWARE_JT.SOFTWARE_ID 
		and SOFTWARE.DISPLAY_NAME rlike 'Microsoft Office[ ]*[a-z]*[ ]2007'))
  
group by MACHINE.ID 
order by MACHINE.NAME asc

)
