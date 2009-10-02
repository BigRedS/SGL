#! /usr/bin/perl

use warnings;
use strict;

## List of file extensions to look for:
my @extensions=("exe", "mp3", "aac", "wav");

## List of shares to check
my %check_shares = (
"london users" => '/mnt/london/users',
"london it" => '/mnt/london/it'
);

## Built the find command. We have to insert a path into it,
## so the command is built in two parts, with the path to be 
## inserted between them:

my $find_cmd_begin = "find ";	##Trailing space
my $find_cmd_end = " ";			## Leading space
foreach my $ex (@extensions){
	$find_cmd_end.=' -or -name \*'.$ex.' -exec du -s {} \;';
}


while (my ($share_name, $share_path) = each(%check_shares)){
	print $share_name."\n";
	my $cmd = .$find_cmd_begin.$share_path." -false".$find_cmd_end;
	exec ($cmd);

}
print "\n";

