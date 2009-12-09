#! /usr/bin/perl

if ($ARGV[0] =~ /config/){
	print <<EOF;
graph_category shares
graph_title pst file sizes
graph_vlabel size
biggest.label biggest
smallest.label smallest non-zero
average.label average
topten.label largest 10
topfive.label largest 5
EOF

	exit;
}


my $files = "/srv/http/files/files";
my (@sizes,$top_ten,$top_five);


open (FILELIST, "<$files");
my ($size,$count,$total_size,$biggest) = 0;
my $smallest = 10000000000;
while (<FILELIST>){
	if ($_ =~ /^pst/){
		$size = (split(/\s/, $_))[1];
		$total_size += $size;
		$count++;
		push(@sizes, $size);

		if($size < $smallest && $size != 0){
			$smallest = $size;
		}

	}
}


@sizes = sort { $b > $a } (@sizes);
($top_ten, $top_five) = 0;

$biggest = @sizes[0];

for ($i=0; $i<10; $i++){
	$top_ten += @sizes[$i];
	if ($i < 5){ $top_five += @sizes[$i];}
}

if ($ARGV[0] =~ /debug/){
	print "total_size $total_size\n";
	print "count $count\n";
}

if ($count != 0){
	my $average = $total_size / $count;
}else{
	($average,$bigest,$smallest,$top_ten,$top_five)="";
}

print "average.value ".$average;
print "\nbiggest.value ".$biggest;
print "\nsmallest.value ".$smallest;
print "\ntopten.value ".$top_ten;
print "\ntopfive.value ".$top_five;
print "\n";
