#! /usr/bin/perl

use warnings;
use strict;
use diagnostics;

my $ts_client_dir = "/home/avi/.tsclient";
my $ts_client_bin = "/usr/bin/tsclient";

opendir(my $dh, $ts_client_dir) || die "Error opening \$ts_client_dir: $ts_client_dir $!";

foreach (readdir($dh)){
	if ($_ =~ /.rdp$/ && $_ !~ /^./){
		print "$ts_client_bin $_ \n";
	}
}
closedir $dh;

