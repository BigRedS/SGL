#! /usr/bin/perl

use File::Copy;
use Time::HiRes;

$source_up="/home/avi/bin/test/source";			# local (include filename!)
$destination_up="/mnt/london/ftp/avi_test/dest";	# remote (dir, or file to overwrite)
$source_down=$destination_up;			
$destination_down="/tmp/";
$log="/home/avi/bin/live/speedtest.log";	

print "OS type = ".$^O."\n";

$share_type="smbfs";
$osx_identifier="darwin";

#########################################
## OSX-specific workarounds happen here: ##
 #########################################
if($^O = $osx_identifier"){

	$destination_smb_share="//jup-svr02/ftp/";	# Mounted at runtime. This is passed
							# as an argument to mount
	$destination_smb_subdir="avi_test";		# Since OSX's smb_mount dislikes subdirs
	$destination_mountpoint="~/.speedtest/";	
	$destination=$destination_mountpoint.$destination_smb_subdir;
							# ^^^ Relatively sweeping but generally 
							# true generalisation.

	if(!`mount -t $share_type $destination_smb_share $destination_mountpoint`){
		print "Failed to mount ".$destination_smb_share." at ".$destination_mountpoint."\n";
		exit 1;
	}
	#If we can't mount, exit and whinge.
}


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
if ($^O = $osx_identifier){
	if(!`umount $destination_mountpoint`){
		print "failed to unmount $destination_mountpoint";
		exit 1;
	}
}


open (LOGFILE, ">> $log");
	print LOGFILE $time_since_epoch_m,"\t".$transfer_up."\t".$transfer_down."\t".$filesize."\t".$time_up."\t".$time_down."\t".$timestamp."\t".$time_now."\t".$date."\n";
close LOGFILE;
sleep 1;
