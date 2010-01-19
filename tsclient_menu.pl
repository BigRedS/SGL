#! /usr/bin/perl

use warnings;
use strict;
my $HOME = $ENV{ HOME };

my $menu_file = "$HOME/.fluxbox/ts_menu";
my $ts_client_dir = "$HOME/.tsclient";
my $ts_client_bin = "/usr/bin/tsclient";

open(MENU,  ">$menu_file") || die "Error opening \$menu_file: $menu_file $!";
opendir(my $dh, $ts_client_dir) || die "Error opening \$ts_client_dir: $ts_client_dir $!";

print MENU "[begin]\n";

foreach (sort(readdir($dh))){
	if ($_ =~ /.rdp$/i && $_ !~ /^\./){
		my $name = ( s/\.rdp//, $_);
		print MENU "[exec] ($_) {$ts_client_bin -x $_} \n";
	}
}
closedir $dh;

print MENU "[end]\n";
close MENU;
