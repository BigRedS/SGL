-- SQL behind machines-with-office-07-on-them report --

/*
First joins the M_S_JT with MACHINES to add machine data to each
software install. Left joins this with SOFTWARE to add software info
to each install. We now have a table of every software install, 
detailling the machine and software installed.

Then joins the above with LABEL so we can GROUP BY label to make the
kbox output pretty. This isn't implemented yet, since I've not configured
the labels on the kbox.
*/

select MACHINE.NAME, SOFTWARE.DISPLAY_NAME, LABEL.NAME

from (
	
	(
		(
			MACHINE_SOFTWARE_JT join MACHINE on
				MACHINE_SOFTWARE_JT.MACHINE_ID = MACHINE.ID
		) left join (
			SOFTWARE
		) on MACHINE_SOFTWARE_JT.SOFTWARE_ID = SOFTWARE.ID
	
	) left join (
		MACHINE_LABEL_JT join LABEL on
			MACHINE_LABEL_JT.LABEL_ID=LABEL.ID
	) on MACHINE_LABEL_JT.MACHINE_ID = MACHINE.ID
			
)

where SOFTWARE.DISPLAY_NAME
regexp '^Microsoft Office[ ]*[a-z]*[ ]2007$'


