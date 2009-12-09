#! /usr/bin/perl

use strict;
#use warnings;


if ($ARGV[0] =~ /config/){
	print <<EOF;
graph_category shares
graph_title SMB/CIFS share sizes
graph_vlabel size
EOF

}

my @df = qx/df -P/;
my $files = "/srv/http/files/files";
my ($site,$name,$size,$space_name);

open (FILELIST, "<$files") || die "Error opening filelist at $files";

while (<FILELIST>){
	if ($_ =~ /^sum/){
		
		my $line = $_;		
#
#		if ($_ =~ /scanachrome customer services/i){
#			$line =~ s/scanachrome customer services/scanachrome customer_services/i;
#		}
#		if ($_ =~ /scanachrome job bag/i){
#			$line =~ s/job bag/jobbag/i
#		}
#

		
		my $share_name = $site." ".$name;
		$name =~ s/ //;
		$name =~ s/-//;

#		print $line."\n";
	
		($name,$size)=(split(/\s+/, $line))[1,2];
		$space_name = $name;
		$space_name =~ (s/_/ /g);
		if ($ARGV[0] =~ /config/){
			print "$name.label $space_name \n";
		}else{
		if ($size =~ /\d+/){
				print $name.".value $size\n";
			}
		}
	}
	
}
#
#my($name,$size);
#
#foreach (@df){
#	if ($_ =~ /^\/\//){
#		($name,$size) = (split(/\s+/, $_))[0,2];
#
#		$name =~ s/\/$//;
#
#		if ($ARGV[0] =~ /config/){
#			print $name.".label ".$name."\n";
#		}else{
#			print $name.".value ".$size."\n";
#		}
#	}
###}
