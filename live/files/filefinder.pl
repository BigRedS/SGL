#! /usr/bin/perl

use diagnostics;
use warnings;
use strict;

my $debug;
if ($ARGV[0]){
	if ($ARGV[0] =~ /debug/){$debug = 1;}
}

## List of file extensions to look for:
my @extensions=("exe", "mp3", "aac", "wav", "mpg", "ogg", "wmv", "wma", "msi", "zip", "cab", "torrent", "flv", "iso", "rar", "3gp", "asf", "mov", "real", "divx", "xvid", "avi", "obj", "mp4", "gif");
my $logfile = "/srv/http/files/filefinder.log";
#my $logfile = "/home/avi/bin/filefinder.log";
my $outputfile="/srv/http/files/files";
#my $outputfile="/home/avi/bin/filelist";
my $extensions_file="/srv/http/files/extensions";
my %summary;
my %users_summaries;
my @psts;

if ($debug){
	print "\nExtensions:\n\t";
	foreach (@extensions){
		print $_;
		print " ";
	}
}
open (EXTENSIONS_FILE, ">$extensions_file") || die "(Error opening extensions file $extensions_file";
@extensions = sort (@extensions);
foreach (@extensions){
	print EXTENSIONS_FILE $_." ";
}
close EXTENSIONS_FILE;

## List of shares to check
my %check_shares = (
	"wandsworth_users" => '/mnt/wandsworth/users/',
	"wandsworth_shared" => '/mnt/wandsworth/shared/',
	"scanachrome_users" => '/mnt/scanachrome/users/',
	"scanachrome_shared" => '/mnt/scanachrome/shared/',
	"london_it" => '/mnt/london/it/',
	"glasgow_ftp" =>'/mnt/glasgow/ftp/',
	"glasgow_users" =>'/mnt/glasgow/users/',
	"glasgow_shared" => '/mnt/glasgow/shared/',
	"glasgow_apps" =>'/mnt/glasgow/apps/',
	"scanachrome_apps" => '/mnt/scanachrome/apps/',
	"scanachrome_admin" => '/mnt/scanachrome/admin/',
	"scanachrome_customer_services" => '/mnt/scanachrome/custserve/',
	"scanachrome_production" => '/mnt/scanachrome/production/',
	"scanachrome_jobbag" => '/mnt/scanachrome/jobbag/',
	"london_users" => '/mnt/london/users/'
);

if ($debug){
	print "\nShares:\n";
	while((my ($share_name, $share_path))=each(%check_shares)){
		print "\t$share_path\n";
	}
}

my $time=time();
if ($debug){print "Building find command...";}
## Build the find command. We have to insert a path into it,
## so the command is built in two parts, with the path to be 
## inserted between them:

## Make the beginning and the end first.
my $find_cmd_begin = "find ";	##Trailing space
my $find_cmd_end = " ";		## Leading space
foreach my $ex (@extensions){
	$find_cmd_end.=' -or -name \*'.$ex.' -exec du -b {} \;';
}
if ($debug){print" done\n";}
## And then loop to construct the middle bit (and get some summaries while we're here)

while (my($share_name, $share_path)=each(%check_shares)){
	if ($debug){print "Summarising $share_path...";}
	$find_cmd_begin.=" ".$share_path;		## Begin the find command
	$summary{$share_name}=qx(du -bs $share_path);	## Get the summary for the whole share

	if ($share_name =~ /users/){			## If it's a userdir, du on its contents
		if ($debug){print "\n\tsummarising userdirs..";}
		my @users=qx(du -bs $share_path*);
		if ($debug){print ".";}
		my $users_array_ref = \@users;
		$users_summaries{$share_name}=$users_array_ref;
		
							## And search it for pst files:
		if($debug){print "done (found @users)\n\tsearching for PSTs...";}
		my $pst_cmd = 'find '.$share_path.' -iname \*.pst -exec du -b {} \;';
		my @temp_psts = qx($pst_cmd);
		if($debug){print "..";}
		foreach (@temp_psts){
			push (@psts, $_);
		}
		if($debug){print "done (found @temp_psts)\n";}
	}else{
		if($debug){print "done\n";}
	}
}
## Aaand put them together.
my $cmd = $find_cmd_begin." -false".$find_cmd_end;
## Then run the constructed command, and stash the output away in an array:
if ($debug){print "Searching by extension ...";}
my @info=qx($cmd);
if ($debug){print "done (found @info)";}


	      # # # # # # # # # # # # # # # # # # # # # # # #
	# # #						      # # #
	## End of data gathering, beginning of data manipulation ##
	# # #						      # # #
	      # # # # # # # # # # # # # # # # # # # # # # # #
if ($debug){print "Writing to output file at $outputfile ...";}
open (OUTPUT, ">$outputfile") || die ("Error opening output file at $outputfile");
## Output the filesizes of what we've found:
foreach (@info){print OUTPUT "file ".$_;}
while (my($share_name, $summary)=each(%summary)){print OUTPUT "sum ".$share_name." ".$summary."\n";}
foreach (@psts){print OUTPUT "pst ".$_;}

## Note the reference-related odd syntax:
while (my($share_name,$users_array)=each(%users_summaries)){
	foreach my $item (@{$users_array}){
		print OUTPUT "usersum ".$item."";
	}
}

close OUTPUT;
if ($debug){print "\tdone\nwriting log...";}

## Some logging:
my $info = @info;
my $extensions = @extensions;

open (LOGFILE, ">>$logfile") || die ("Error opening logfile at $logfile");
	print LOGFILE $time.":";
	$time=(time())-$time;
	print LOGFILE $time.":";
	print LOGFILE $info.":";
	print LOGFILE $extensions;
	print LOGFILE "\n";
close LOGFILE;
if ($debug){
	print "done\n\n\tAll Done in $time seconds";
}

