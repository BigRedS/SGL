#! /usr/bin/perl

#$today=(localtime)[3];
$today = 15;
$this_year=(localtime)[5];
$this_year+=1900;

($hour, $minute)=(localtime)[2,1];

$hour=1;

if ($today > 16 || $year > 2008){
	print "Cancel mian's email reminder - It's past the 16th\n";
	exit 0;
}elsif ($today == 16) {
	if ($hour < 14){
		$this_minute = ($hour * 60) + $minute;
		$leave_minute = 14 * 60;
		$minutes_to_departure = $leave_minute - $this_minute;
		$email_body = "Good Morning! \n\n\n\t This is a handy reminder that you need to leave in ".$minutes_to_departure." minutes\n\n\t Don't forget";
	}else{
		print "Cancel mian's email reminder - it's gone 2pm\n";
		exit 0;
	}

}else{
	$email_body	="Good Morning! \n\n\n\t This is a handy reminder that your theory test is in ".$num_days." ".$days."\n\n\t Don't forget to go.\n";
}


$num_days=16-$today;

$days = ($num_days = 1) ? "day" : "days";
#$days="days";
#if($num_days == 1){
#	$days = "day";
#}

$sendmail	="/usr/sbin/sendmail -t";

$email_address	="avi.greenbury\@servicegraphics.co.uk";

$email_to	="To: $email_address\n";
$email_subject	="Subject: Your theory test in ".$num_days." days\n";
$email_reply_to	="Reply-to: avi.greenbury\@servicegraphics.co.uk\n";
$email_content	="Content-type: text/plain\n\n";

if($num_days < 1){
	$body="Good Morning! \n\n\n\t This is a handy reminder that your theory test is now. \n\n\t If you're reading this before you go to it, you've missed it again. \n";
}

#open(SENDMAIL, "|$sendmail") || die ("cannot open pipe to $sendmail");
	print $email_reply_to;
	print $email_subject;
	print $email_to;
	print $email_content;
	print $email_body;
	print "\n";
#close (SENDMAIL)
