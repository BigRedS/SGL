#! /usr/bin/perl

use strict;
use warnings;
use 5.010;

my $dump_file = $ARGV[0];

&usage() if !$dump_file;

say "using ".$dump_file;

open(DUMP_IN, "<$dump_file");
my ($line, $table,@query, $file_number,$file_name);
my $line_number = 1;
my $find_count = 0;
        while(<DUMP_IN>){
                my $line = $_;
                if (/^USE\s.(\w+)./){
                        say "changing db: ".$1;
                        $file_name = &make_file_name("USE_$1", "$find_count");
                        &write_USE($file_name, $line);
                        $find_count++;
                }elsif (/^-- Table structure for table .(.+)./){
			## If the current line is the beginning of a table definition
			## and @query is defined, then @query must be full of the previous
			## table, so we want to process it now:
                        if (@query){
                        $file_name = &make_file_name("$table", "$find_count");
                                open(OUTPUT, ">$file_name");
                                        foreach(@query){
                                                print OUTPUT $_;
                                        }
                                close OUTPUT;
                                undef @query;
                        }
                        $table = $1;
                        $find_count++;
                }
                next unless $table;
                push @query, $line;

                $line_number++;
        }
close DUMP_IN;
say $line_number;

sub write_USE() {
        my($filename, $line) = @_[0,1];
        open (OUTPUT, ">$filename");
        print OUTPUT $line;
        close OUTPUT;
}

sub make_file_name() {
        my ($type, $number) = @_[0,1];
        $number = sprintf("%05d", $number);
        $file_name=$number."_".$type.".sql";
        return $file_name;
}

sub usage() {
        say "Error: missing arguments.";
	say "Usage:";
	say "$0 [MYSQL_DUMP]";
        exit 1;
}
