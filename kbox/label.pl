#! /usr/bin/perl

#use strict;
use 5.010;
use DBI;
print "content-type:text/html\n\n\n";

$dbh = DBI->connect('dbi:mysql:ORG16;host=kbox.st-ives.int', 'R16', 'XXXXXXXXXXXXX') or die "Couldn't connect to db";
$sql = "select software_id from SOFTWARE_LABEL_JT where label_id = '52'";
$sth = $dbh->prepare($sql);

$sth->execute
or die "SQL Error: $DBI::errstr\n";

my @software_ids;

while (@row = $sth->fetchrow_array) {
	push @software_ids, @row[0];
} 

$sql = "select SOFTWARE_ID, count(*) from MACHINE_SOFTWARE_JT where SOFTWARE_ID=? group by SOFTWARE_ID";

$sth = $dbh->prepare($sql);

my %software_count;
foreach (@software_ids){
	$sth->execute($_) or die "MySQLError: $DBI::errstr\n";
	while (@row = $sth->fetchrow_array){
		$software_count{@row[0]} = @row[1];
	}
}

$sql = "select ID, DISPLAY_NAME, VERSION from SOFTWARE where ID = ? order by DISPLAY_NAME";
$sth = $dbh->prepare($sql);

say "<html><table border='1'>";
say "<th>Display Name</th><th>Count</th>";

while( (my($software_key, $count)) = each (%software_count)){
	$sth->execute($software_key) or die "MySQLError: $DBI::errstr\n";
	while (@row = $sth->fetchrow_array){
		my ($id, $display_name, $version) = @row[0,1,2];
#		say $display_name."==".$version."==".$count;
		say "<tr><td>$display_name</td><td>$version</td><td>$count</td></tr>";
	}
}

say "</table></html>";
