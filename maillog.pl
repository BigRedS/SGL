#! /usr/bin/perl

@sites=("london", "glasgow", "wandsworth");
%client_ip=(
	london 	   => '3',
	glasgow    => '3',
	wandsworth => '3'
);

foreach(@sites){
	print $_, "\n";
	$site=$_;
	$path_to_log_dir = "/mnt/".$_."/maillog/*";
	@logs=glob($path_to_log_dir);
	foreach(@logs)
	{
		print "\t", $_, "\n";
#		$path_to_logfile=$path_to_log_dir.$_;
		$path_to_logfile=$_;
		open(LOGFILE, "$path_to_logfile") || die ("Error opening $path_to_logfile");
			$count=0;
			while (<LOGFILE>)
			{
				$count++;

				if($count > 5){ 
			#		print $client_ip($site);
			#		print ((split(/\s/, $_))[$client_ip($site)]), "\n";
			#		print "\n";
					if(((split(/\s/, $_))[3]) =~ m/\b10\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)
			#
					{
	#					print "\t\tLine $count:",$_;
					}
					else
					{
						print ((split(/\s/, $_))[4]), "\n";
					}
				}
			}
		close LOGFILE
	}
	


}
