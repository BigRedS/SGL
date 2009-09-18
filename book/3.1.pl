#! /usr/bin/perl
use strict;
use warnings;

use File::Spec;
use Cwd;

my $dir = getcwd();

my @files = <*>;
foreach my file (@files) {
	my $absolute_path = File::Spec->rel2abs( $file );
	print $absolute_path, "\n";
}


print "\n";
