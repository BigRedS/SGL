#! /usr/bin/perl

use strict;
use 5.010;

my @error_array;
opendir(DIR, ".") or die ("Error opening directory");
my @files=readdir(DIR);
my @csvs;
foreach my $f (@files){
	if (($f !~ /^\./) && ($f =~ /csv$/)){
		push @csvs, $f;
	}
}


if (@csvs < 1){
	say "no CSV files found";
	push (@error_array, "Can find no CSV files. Check it's not save as XLS");
}

@files=sort(@csvs);
my $input_file = "./$files[0]";


if(open (IN, "<$input_file")) {
	say "whooo";
}else{
	say "Error opening input file $input_file";
	push (@error_array, "Error opening input file $input_file");
	exit 1;
}

my %interesting_bits;

while (my $line = <IN>){
	print "1";
	say $line;
	my $interesting_bit = (split(/,/, $line))[0];
	$interesting_bits{$interesting_bit}+=1;
}

my @dupes;
while(my($key, $value) = each(%interesting_bits)){
	if($value < 1){
		push (@dupes, $key);
	}
}

if (@error_array){
	open(E, ">./errors.txt");
	foreach (@error_array){
		print $_;
		print E $_;
	}
	print "\n";
	exit 1;
}
		

open(OUT, ">./duplicates.csv");

while(<F>){
	my $interesting_bit = (split(/,/, $_))[0];
	my $line = $_;
	foreach (@dupes){
		if ($interesting_bit = $_){
			print OUT $_;
		}
	}
}

close OUT;	

