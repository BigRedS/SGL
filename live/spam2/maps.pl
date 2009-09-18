#! /usr/bin/perl

use warnings;
use strict;
use diagnostics;

my $location = $ARGV[0];
my $from = $ARGV[1];
my $to = $ARGV[2];
my $searchterm = $ARGV[3];

my $searchdir="/mnt/".$location."/bad";
my $todaydir="/mnt/".$location."/in";

## Rudimentary sanitisation:
$searchterm =~ s/\"/\\"/;


my @email;
my $date;
my @emails;
my $cmd;
my $grep;
my $this_date;
my $cmd2;
my $subject;
my $email;
my @or_terms;
my @and_terms;
my $term;
my $grep_result;

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
				$email = $_;

					$term = $_;
			
					$cmd = "grep -i \"".$searchterm."\" ".$path."/".$email." | wc -l";
					$grep_result = qx/$cmd/;
					if ($grep_result > 0){
						$cmd2 = "grep -i ^Subject ".$path."/".$email." ".$grep." | awk -F: '{print \$2}'";
						$subject = qx/$cmd2/;
						$subject =~ s/\n//;
						$subject =~ s/:/|/;
						$term =~ s/:/|/;
						chomp $subject;
						print $email, ":", $this_date, ":", $subject, "\n";
#						print $cmd, "\n";
					}
			
			}
		}
	}
}

print "\n";




	
