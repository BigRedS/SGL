#! /usr/bin/perl

$input_file = './in.csv';
$output_file = './out.csv';

open INPUT_FILE , "< $input_file" || die ("Error opening input file at $input_file");
	@input_file = <INPUT_FILE>;
close INPUT_FILE;

$file_size = $input_file;

@output_array = ();
$#output_array = $input_file[$file_size];

foreach (@input_file){
	$line = $_;
	if ($line =~ /LO/ ){
		if ($line !~ /Unknown/){
			@cur_line = split (/,/, $_);
			@tn_string = split (/\//, @cur_line[2]);
			$tn = @tn_string[2];
			chop ($tn);

			$curr_new_line=$tn-1;
			@output_array[$curr_new_line] = $line;


		}
	} 	

}	

open OUTPUT_FILE, "> $output_file" || die ("Error opening output file at $output_file");
	foreach (@output_array){
		chomp $_;
		print OUTPUT_FILE $_, "\n";
	}
close OUTPUT_FILE


