#! /usr/bin/perl

my $file;
if ($ARGV[0]){
	$file = $ARGV[0];
#	print $file;
}else{
	die "error: no file specified";
}

open ($fh, "<$file") || die "error: couldn't read from $file";

my $file = join(/ /, <$fh>);
$file =~ s/\t//g;
$file =~ s/\n//g;
#file =~ s/ //g;

$file =~ s/<table>/\n\{|table/g;
$file =~ s/<\/table>/\n|\}/g;

#$file =~ s/<\

$file =~ s/<\/tr>//g;
$file =~ s/<\/td>//g;
$file =~ s/<tr>/\n|-/g;
$file =~ s/<td>/\n|/g;


print $file;
print "\n";

