#! /usr/bin/perl
use strict;	# Tell me off if I don't dot my t's and cross my i's
use warnings;	
use File::Copy; # Gives me move() and copy() functions

##	Avi's handy file renaming script
#
#
# File batch renamer. Takes a directory as an argument, and renames the files inside it. Files are renamed of 
# the form <prefix><separator><number>.<extension>.
# <extension> is not changed.
# <number> is sequential - each file gets a number one higher than the last file.
# <separator> is the value of $separator
# <prefix> is the value of $prefix unless $use_old_name != 0, in which case it is the file's current name, less
#	the extension
#
# If $date_order != 0, files will be processed in order of modification date. If not, they will be processed in
# the order in which the OS supplies them to Perl.
# The first number used is $begin_number. Numbers are formatted such that alphabetical order is also numerical 
# order (i.e. leading zeros are prepended).
#


my @allowed_extensions = ("jpg", "png");	# Only operate on files with these
						# extensions
my $use_old_name = 1;				
my $prefix = "piccy";				
my $separator = "-";
my $begin_number = 0;
my $date_order = 1;


## Check we have an argument.
unless ($ARGV[0]){
	print STDERR "You didn't provide an argument. Silly boy.\n";
	exit 1;
}
my $working_dir = $ARGV[0];
my @unsorted_files;

if( -d $working_dir){
	opendir (DIR, $working_dir) || die ("Error: can't open $working_dir as a directory\n");
	@unsorted_files=readdir(DIR);
	closedir (DIR);
}else{
	die ("Error: $working_dir doesn't appear to be a directory\n");
}


## Sort files by date:
my @files;
if ($date_order){
	@files = sort { -M $a <=> -M $b } @unsorted_files;
} else {
	@files = @unsorted_files;
}


## Work out how long the number on the end should be 
## such that an alphabetic sort is also a numeric one:
## $#files is the length of the array @files
my $digits = length($#files + $begin_number);


my $file_number = $begin_number;
my $file_count = 0;
my $match_count = 0;

foreach my $file (@files){
	my $match=0;
	# Unless the file begins with a dot...
	unless ($file =~ /^\./){
		$file_count++;

		my $path = $working_dir."/".$file;	

		my @filename = split (/\./, $file);			
		my $extension = pop(@filename);
		my $filename = join ('', @filename);

		foreach my $ext (@allowed_extensions){
			if ($extension =~ m/^$ext$/){
				$match=1;
				$match_count++;
				last;
			}else{
				$match=0;
			}
		}	
		my $new_filename;
		if ($match){
			my $number = sprintf("%0${digits}d", $file_number);			
			if ($use_old_name){
				$new_filename = $filename.$separator.$number.".".$extension;
			}else{
				$new_filename = $prefix.$separator.$number.".".$extension;
			}

			my $new_path = $working_dir."/".$new_filename;
			move ($path, $new_path );
			$file_number++;
		}
					
	}## unless file =~ /^\./
}

print $file_count." files checked, ".$match_count." files renamed.";
print "\n";
