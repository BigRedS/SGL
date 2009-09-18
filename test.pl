#! /usr/bin/perl

($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;

print "year:\t",$year,"\n";
print "month:\t",$min,"\n";
print "day:\t",$hour,"\n";
print "hour:\t",$mday,"\n";
print "min:\t",$mon,"\n";
print "sec:\t",$sec,"\n";
print "wday:\t",$wday,"\n";
print "yday:\t",$yday,"\n";
print "isdst:\t",$isdst,"\n";
