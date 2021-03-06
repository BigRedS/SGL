#! /usr/bin/perl

use strict;
#use warnings;
#use diagnostics;

##	Most Recent Changes:
##
##	Added dupe checking. Before writing to array, checks whether that element exists or not. 
##	If it does, writes message to error array and carries on. At the end of the run, if the 
##	error array contains messages it dumps them to a new errors file, and exits. It does not
##	create the output csv.
##
##	Also writes more general errors to the file, including if it finds no csv files.
##
##	Might support filenames with spaces.
##
##

my $output_file = './out.csv';

my $error_file = "./errors.txt";
my @error_array = ();

# Open the current directory and read its full contents to a new array called @files. The go through
# @files and, if the file does not begin with a dot, ends with `csv` and is not `out.csv` add it to an 
# array.  We then sort the array and pick the first file and presume that is our input file.
opendir(DIR, ".") || die("Error opening working dir");
my @files=readdir(DIR);
my @csvs;
foreach my $f (@files){
	if (($f !~ /^\./) && ($f =~ /csv$/) && ($f !~ /^out\.csv$/)){
		push( @csvs, $f);
	}
}
if (@csvs < 1){
	print "no csvs";
	push (@error_array, "Can find no csv files. Check it's not saved as xls");
}

@files=sort(@csvs);
my $input_file = "./$files[0]";

# Handy info for the user
print $input_file."\n";
# Open the input file, and read its contents into an array, then close it.
#open INPUT_FILE , "< $input_file" || die ("Error opening input file at $input_file");
#	my @input_file = <INPUT_FILE>;
#close INPUT_FILE;

# Initialise an array for the output, and one for error messages.
my @output_array = ();

# Go through each element of the array (and therefore line of the file) and, if it contains
# the string 'LO' but not 'Unknown', process it


#foreach (@input_file){
open INPUT_FILE , "< $input_file" || die ("Error opening input file at $input_file");

foreach (<INPUT_FILE>){
	my $line = $_;
	## If the line begins with two or more decimal digits, it's probably one of those funny bungay ones
	if ($line =~ /^\d{2}/){
		my $line_number = (split /,/, $_)[0];
		$line_number--;
		## If the line we want to write to is non-empty (i.e. it has digits in it), then error
		if ($output_array[$line_number] =~ /\d/){
			my $repeat_count = 0;
			foreach (<INPUT_FILE>){
				if ((split /,/, $_)[0] =~ m/$line_number/){
					$repeat_count++;
				}
			}
			$error_array[$line_number] = $line_number." exists about ".$repeat_count." times.";
#			push (@error_array, $line_number." exists about ".$repeat_count." times.");
		}


		$output_array[$line_number]=$line;
	## If it doesn't, carry on as normal.
	}elsif ($line =~ /LO/ ){
		if ($line !~ /Unknown/){
			# Pick out where the TN is in the line (in the third /-separated
			# group of the third comma-separated group).
			# Then write the entire line to the element of the array that is one
			# less than the TN. Chop() gets rid of the last character of the string
			# which here is a "
			# (remember that the first element of an array is 0, but the first
			# line of a file is 1; element 0 will become line 1)
			my @cur_line = split (/,/, $_);
			my @tn_string = split (/\//, $cur_line[2]);
			my $tn = $tn_string[2];
#			chop $tn;
			$tn--;
#			print $tn." ";
			$output_array[$tn] = $line;
		}
	} 	

}	
close INPUT_FILE;

#print "\n\t\t".@output_array."\n";

foreach (@error_array){print;}

# If the error array contains records (i.e. its length is greater than zero), create an error log file
if (@error_array > 0){
	open ERROR_FILE , "> $error_file" || die ("Error opening error log at $error_file. You're fucked.");
		print ERROR_FILE "Errors encountered processing ".$input_file.":\n";
		print STDERR "Errors encountered processing ".$input_file.":\n";
		foreach my $error (@error_array){
			print ERROR_FILE $error;
			print STDERR "\t".$error;
		}
	close ERROR_FILE;
	print "\n";
}


# Open the output file, and write the contents of the output array to file.
# Remember that Perl will append a \n to each non-null element of the array, but we want one
# on the end of every element, including null. So we chomp each line to remove the /n from 
# those that have it, and re-add it to _every_ array.

open OUTPUT_FILE, "> $output_file" || die ("Error opening output file at $output_file");
	my $output_line;
	foreach $output_line (@output_array){	
		chomp $output_line;
#		if ($_){
			print OUTPUT_FILE $output_line. "\n";
#		}else{
#			print OUTPUT_FILE "\n";
#		}
	#print $_, "\n";
	}
close OUTPUT_FILE;


print "\n";
