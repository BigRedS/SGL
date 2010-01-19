#! /usr/bin/perl

use strict;
use warnings;
use XML::Simple;
my $HOME = $ENV{ HOME };

my $bookmarks_file = "$HOME/.local/share/vinagre/vinagre-bookmarks.xml";
my $menu_file = "$HOME/.fluxbox/vnc_menu";

my $xml = new XML::Simple (KeyAttr=>[]);
my $data = $xml->XMLin("$bookmarks_file");

open(MENU, ">$menu_file") || die "Error opening \$menu_file: $menu_file $0";

print MENU "[begin]\n";

foreach my $b(@{$data->{"item"}}){
	print MENU "[exec] ($b->{name}) {vinagre $b->{host}:$b->{port}}\n";
}
print MENU "[end]\n";
close MENU;
