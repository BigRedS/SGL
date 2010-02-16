-- SQL behind the per-seat report --

/*
Joins S_L_JT with SOFTWARE, and then that with M_S_JT. We know the ID 
(52) of the interesting label (per-seat) to avoid looking up on LABEL. 
*/



select SOFTWARE.DISPLAY_NAME, count(*)
 
from (
	SOFTWARE_LABEL_JT join SOFTWARE on
	SOFTWARE_LABEL_JT.SOFTWARE_ID = SOFTWARE.ID
)
join MACHINE_SOFTWARE_JT on
SOFTWARE_LABEL_JT.SOFTWARE_ID = MACHINE_SOFTWARE_JT.SOFTWARE_ID
 
where SOFTWARE_LABEL_JT.LABEL_ID = '52'
group by SOFTWARE_LABEL_JT.SOFTWARE_ID
order by SOFTWARE.DISPLAY_NAME
