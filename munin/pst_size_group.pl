#! /usr/bin/perl

if ($ARGV[0] =~ /config/){


	print <<EOF;
graph_category shares
graph_title pst files by size
8GB.label over 8GB
6GB.label 6-8GB
4GB.label 4-6GB
lower.label <4GB
EOF
	exit;
}


my $files = "/srv/http/files/files";

open (FILELIST. "<$files");
my ($eight, $six, $four, $less) = 0;
