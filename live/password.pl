#! /usr/bin/perl

use strict;
use warnings;

my $lengths="10 20 30 40";
my $characters="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5 6 7 8 9 0 ! £ $ % ^ & ( ) _ - + = { } [ ] : @ ~ # < , > . ? / | ";

my @chars=split(/ /, $characters);
#my @lens=split(/ /, $lengths);

my $chars_count = @chars;

#foreach (@lens){
	my $count;
#		print $_."\t";
	my $_ = 60;
	for ($count = 0; $count <= $_; $count++){
		print $chars[int(rand($chars_count))];
	}
	print "\n";
#}






