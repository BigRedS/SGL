#! /usr/bin/perl

use File::Copy;
use Time::HiRes;

$source_up="/home/avi/bin/test/source";		#local (include filename!)
$destination_up="/mnt/london/ftp/avi_test/dest";	#remote (dir, or file to overwrite)
$source_down=$destination_up;			
$destination_down="/tmp/";
$log="/home/avi/bin/live/speedtest.log";	

$my_epoch=1228694400; # currently Decmber 12th 2008 00:00:00
$timestamp=time();
$time=time();
$time_since_epoch=($time-$my_epoch);
$time_since_epoch_m=$time_since_epoch/60;
$time_since_epoch_m=sprintf("%.0f", $time_since_epoch_m);

($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
$year+=1900;


#$hr, $min, $sec) = localtime[2,1,0];
$time_now=$hour.":".$min,":".$sec;

#($day, $mon, $yr) = localtime[3,4,5];
$date=$year."-".$mon."-".$mday;


$filesize= -s $source_up;
$filesize = ($filesize/1024)/1024; # convert to mb

$begin=[ Time::HiRes::gettimeofday() ];
	copy($source_up, $destination_up);
$time_up = Time::HiRes::tv_interval( $begin );
$transfer_up=$filesize/$time_up;

$filesize_down= -s $source_down;
$filesize_down = ($filesize_down/1024)/1024; # convert to mb
$begin=[ Time::HiRes::gettimeofday() ];
	copy($source_down, $destination_down);
$time_down= Time::HiRes::tv_interval( $begin );
$transfer_down=$filesize_down/$time_down;


unlink $destination;
unlink $down_destination;
open (LOGFILE, ">> $log");
	print LOGFILE $time_since_epoch_m,"\t".$transfer_up."\t".$transfer_down."\t".$filesize."\t".$time_up."\t".$time_down."\t".$timestamp."\t".$time_now."\t".$date."\n";
close LOGFILE;
sleep 1;
