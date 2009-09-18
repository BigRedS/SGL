#! /usr/bin/perl

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time());
$year += 1900;
if(length($mday) < 2){
	$mday="0".$mday;
}
$date = $year."-".$mon."-".$mday;

print $date, "\n";
