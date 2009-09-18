#! /usr/bin/perl

use warnings;
use strict;

my $location = $ARGV[0];
my $from = $ARGV[1];
my $to = $ARGV[2];
my $searchterm = $ARGV[3];

my $searchdir="/mnt/".$location."/bad";
my $todaydir="/mnt/".$location."/in";


my $from_key;
my $to_key;
my @email;
my $date;
my @emails;
my $cmd;
my $grep;
my $this_date;
my $cmd2;
my $subject;

opendir (BAD, $searchdir) || die ("Error opening $searchdir");
	my @dates = readdir(BAD);
closedir(BAD);
my @sorted_dates = sort @dates;

my $count = 0;
foreach (@sorted_dates){
	if ( $_ =~ m/^\d/ ){
		if ( $_ >= $from && $_ <= $to ){
			## foreach(dir){
		
			$this_date = $_;
			my $path = "/mnt/".$location."/bad/".$_;

			opendir (DATE, $path);
				@emails = readdir(DATE);
			closedir (DATE);

				foreach (@emails){
					$cmd = "grep -i ".$searchterm." ".$path."/".$_." | wc -l";
					$grep = qx/$cmd/;
					if ($grep > 0){
	
						$cmd2 = "grep -i ^Subject ".$path."/".$_." | awk -F: '{print \$2}'";
						$subject = qx/$cmd2/;
						$subject =~ s/\n//;
						chomp $subject;

						print $_, ":", $this_date, ":", $subject, "\n";
#						print ":";
#						print $this_date;
#						print ":";
#						print $subject;
#						print "\n";
					}

				}

		}
	}
}

print "\n";




	
