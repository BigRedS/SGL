#! /usr/bin/perl

use warnings;
use strict;
use Number::Bytes::Human qw(format_bytes);

my $args=join(' ', @ARGV);

my $mode="plain";
my $order="size";

my $filelist="/srv/http/files/files";

open FILELIST, "<$filelist";

my %records;
my %sum;
my %usersum;
my %shared;
my %pst;

while (<FILELIST>){
	my $line=$_;

	if ($args =~ m/users/ && $line =~ m/^file/ && $line =~ m/\/users\//){
		## %records{person} = [file count, file size count, site]
		my ($du,$uname,$site)=(split(/\//, $line))[0,4,2];
		$du=(split(/\s/, $du))[1];
		if (exists($records{$uname})){
			$records{$uname}[0]++;
			$records{$uname}[1]+=$du;
		}else{
			$records{$uname}[0]='1';
			$records{$uname}[1]=$du;
			$records{$uname}[2]=$site
		}

	}elsif ($args =~ m/sum/ && $line =~ m/^sum/){
		
		my ($du, $name, $site)=(split(/\s/, $line))[3,2,1];
		my $identifier=$site."-".$name;
			$sum{$identifier}[0]=$site;
			$sum{$identifier}[1]=$name;
			$sum{$identifier}[2]=$du;
	


	}elsif ($args =~ m/shared/ && $line =~ m/^file/ && $line =~ m/\/shared\//){
		## %shared(share name*) = [file count, file size count]
		my ($du,$name)=(split(/\//,$line))[0,4];
		if (exists($shared{$name})){
			$shared{$name}[0]++;
			$shared{$name}[1]+=$du;
		}else{
			$shared{$name}[0]='1';
			$shared{$name}[1]=$du;
		}


	}elsif ($args =~ /usum/ && $line =~ m/^usersum/){
		my $size = (split(/\s/, $_))[1];
		my $uname = (split(/\//, $_))[4];
#		my $site = (split(/\//, $_))[2];
		chop $uname;
		$usersum{$uname}=$size;
	

	}elsif ($args =~ /pst/ && $line =~ m/^pst/){
		my ($size,$path) = (split (/\s/, $_))[1,2];
		my @bits = split (/\//, $_);
		my $filename = pop(@bits);
		chomp $filename;
		my $name = (split (/\//, $_))[4];
		my $site = (split (/\//, $_))[2];
#		my $filename =( split (\//, $_))[-1];
		$pst{$path}[0] = $name;
		$pst{$path}[1] = $site;
		$pst{$path}[2] = $size;
		$pst{$path}[3] = $filename;
	}
}

close FILELIST;

if ($args =~ /users/){
	if ($args=~/html/){
		print "<table border=\"1\"><tr><th>Name</th><th>Site</th><th>Matching Files</th><th>Size of matching files</th></tr>";
	}
	foreach my $key (sort {$records{$b}[1] <=> $records{$a}[1] } keys %records){
		my $name=$key;
		my $number=$records{$key}[0];
		my $size=format_bytes($records{$key}[1]);
		my $site=$records{$key}[2];
		if ($args =~ /html/){
			print "<tr><td>".$name."</td><td>".$site."</td><td>".$number."</td><td>$size</td></tr>\n";
		}else{
			print $name."\t".$number."\t".$size."\n";
		}
	}

	if ($args=~/html/){
		print "</table>";
	}
}

if ($args =~ /usum/){
	my $count = 1;
	if ($args=~/html/){ print "<table border=\"1\"><tr><td></td><th>Name</th><th>Size</th></tr>";}
	foreach my $key (sort {$usersum{$b} <=> $usersum{$a} } keys %usersum){
		my $name=$key;
		my $size=format_bytes($usersum{$key});
		if ($args =~ /html/){
			print "<tr><td>$count</td><td>".$name."</td><td>".$size."</td></tr>\n";
		}else{
			print $name."\t".$size."\n";
		}
		$count++
	}
	if ($args=~/html/){ print "</table>"; }
}

if ($args =~ /sum/){
	if ($args =~/html/){print "<table border=\"1\"><tr><th>Site</th><th>Share</th><th>Size</th></tr>"};
	foreach my $key (sort {$sum{$b}[2] <=> $sum{$a}[2]} keys %sum){
		my ($site,$share) = split(/_/, $sum{$key}[0]);
		
#'	my $share = $sum{$key}[1];
		my $size = format_bytes($sum{$key}[1]);
		print "<tr><td>$site</td><td>$share</td><td>$size</td></tr>\n";
	}
	

	if ($args=~/html/){ print "</table>"; }

}

if ($args =~ /shared/){
	if ($args =~ /users/){
		print "</table>\n<table border=1><tr><td>Shared Location</td><td>Files Found</td><td>Size of files found</td><tr>\n";
	}
	foreach my $key (sort {$shared{$b}[1] <=> $records{$a}[1] } keys %shared){
		my $name = $key;
		my $size = format_bytes($shared{$key}[1]);
		my $number = $shared{$key}[0];
		if ($args =~ /html/){
			print "<tr><td>".$name."</td><td>".$number."</td><td>".$size."</td><tr>\n";
		}else{
			print $name."\t".$number."\t".$size."\n";
		}
	}
}	

if ($args =~ /pst/){
	if ($args =~ /html/){print "<table border=\"1\"><tr><th>Owner</th><th>Filename</th><th>Site</th><th>size</th></tr>\n";}else{print "Name\t\tFilename\tSite\tSize\n";}
	foreach my $key (sort {$pst{$b}[2] <=> $pst{$a}[2]} keys %pst){
		my $name = $pst{$key}[0];
		my $site =$pst{$key}[1];
		my $size =format_bytes($pst{$key}[2]);
		my $filename =$pst{$key}[3];
		if ($args =~ /html/){
			print "<tr><td>".$name."</td><td>".$filename."</td><td>".$site."</td><td>".$size."</td><td>\n"
		}else{
			print "$name\t$filename\t$site\t$size\n";
		}
	}

	if($args =~ /html/){print "</table>\n";}
}

