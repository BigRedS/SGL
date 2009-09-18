#! /usr/bin/perl

$input_file = './in.csv';
$output_file = './out.csv';

# Open the input file, and read its contents into an array, then close it.
open INPUT_FILE , "< $input_file" || die ("Error opening input file at $input_file");
	@input_file = <INPUT_FILE>;
close INPUT_FILE;

@output_array = ();

# Go through each element of the array (and therefore line of the file) and, if it contains
# the string 'LO' but not 'Unknown', process it
foreach (@input_file){
	$line = $_;
	if ($line =~ /LO/ ){
		if ($line !~ /Unknown/){
			# Pick out where the TN is in the line (in the third /-separated
			# group of the third comma-separated group) and minus one from it.
			# Then write the entire line to the element of the array that is one
			# less than the TN. Chop() gets rid of the last character of the string
			# which here is a "
			# (remember that the first element of an array is 0, but the first
			# line of a file is 1 - element 0 will become line 1)
			@cur_line = split (/,/, $_);
#		print @curr_line[2];
			@tn_string = split (/\//, @cur_line[2]);
			$tn = chop(@tn_string[2]);
		print $tn, " \n";
			$curr_new_line=$tn-1;
#			@output_array[$curr_new_line] = $line;
		}
	} 	

}	

# Open the output file, and write the contents of the output array to file.
# Remember that Perl will append a \n to each non-null element of the array, but we want one
# on the end of every element, including null. So we chomp each line to remove the /n from 
# those that have it, and re-add it to _every_ array.

open OUTPUT_FILE, "> $output_file" || die ("Error opening output file at $output_file");
	foreach (@output_array){
		chomp $_;
		print OUTPUT_FILE $_, "\n";
	}
close OUTPUT_FILE

