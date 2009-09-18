#! /usr/bin/perl

use File::Copy;

use warnings;
use diagnostics;
#use strict;

## $argv[0] = location
## $argv[1] = debug (if exists)
#my $location=$ARGV[0];
my $location = "london";

my $today_cmd = "date +%y%m%d";
my $today=qx/$today_cmd/;
chomp $today;


 #########################################################################################
## ALL directory paths _MUST_ feature a trailing slash since paths are just concatenated ##
 ########################################################################################

	my $whitelist_path = "/home/avi/bin/spam2/whitelist";
#	my $in_dir = "/mnt/".$location."/in/";
#	my $bad_dir = "/var/badmail/".$location."/".$today."/";
#	my $good_dir = "/var/goodmail/".$location."/".$today."/";


	my $in_dir = "/var/badmail/london/080423/";
	my $bad_dir = "/var/badmail/london/080423/bad/";
	my $good_dir = "/var/badmail/london/080423/good/";


## Mail-related settings:
	my $problem_address = 'avi.greenbury@servicegraphics.co.uk';
	my $sendmail = "/usr/sbin/sendmail -t";
	my $reply_to = 'avi.greenbury@servicegraphics.co.uk';
	my $header = "Following is an email plucked from the spam filter\n\n\t\tBEGIN FORWARDED MESSAGE:\n\n";
	my $signature = "\n\n\t\tEND FORWARDED MESSAGE\nAny problems, let ".$problem_address." know";



# Print some stats:
	print "Input:\t\t$in_dir\nBad:\t\t$bad_dir\nGood:\t\t$good_dir\nWhitelist:\t$whitelist_path\n";


## Check we have everything:

	# Check for, and create if neccesary, today's directories:
	## If they already exist, but are not writeable, we will not be able to create them, so will fail.
	unless ( (-d $bad_dir) && (-w $bad_dir)){
		mkdir $bad_dir || die ("Error creating Bad directory at $bad_dir");
	}
	unless ( (-d $good_dir) && (-w $bad_dir)){
		mkdir $good_dir || die ("Error creating Good directory at $good_dir");
	}	

	# Check for existence of, and permissions on, other files and dirs:

#	unless ( (-w $bad_dir) && (-w $good_dir) && (-w $in_dir ) && (-r $whitelist) ){
#
#		## If the dirs exist, then the issue is writing.
#		if (-e $in_dir){
#			die ("Error writing to In directory: $in_dir");
#		}else{	
#			die ("Error finding In directory: $in_dir");
#		}
#
#		if (-e $whitelist){
#			die ("Error reading whitelist at $whitelist");
#		}else{
#			die ("Error finding whitelist at $whitelist"); 
#		}
#	}
#


## Read Whitelist
# Whitelist is read into @whitelist_file, then the first column of each line (i.e. the actual
# whitelist items) are read into @whitelist

	open (WHITELIST, $whitelist_path) || die ("Error opening Whitelist at $whitelist_path");
		my @whitelist_file = <WHITELIST>;
	close (WHITELIST);
	my @whitelist=();
	foreach (@whitelist_file){
		@white = split /%/, $_;
		push (@whitelist, $white[0]);
	}
	my $whitelist_size = @whitelist;

	if ($whitelist_size == 1){
		$cmd = "grep -i \"".$whitelist[0]."\"";
		print "Whoop";
	}else{
		$cmd = "grep -i \"";
		foreach (@whitelist){
			$count++;

	# If the whitelist term contains '&&' then we're only interested in the portion before that.
			if ( $_ =~ m/&&/ ){
				@whitelist_candidates = split(/&&/, $_, [0]);
				$_ = $whitelist_candidates[0];
			}
	# Build the command:	
			$cmd.=$_;
			if ($count < $whitelist_size){
				$cmd.="\\|";
			}

		}
		$cmd.="\" ";
	}
	$count = 0;

	# Build a second whitelist, using the second portions, for the rechecking:
	
	foreach (@whitelist_file){
		@white_two = split /%/, $_;

		if ( $white_two[0] =~ /&&/){
			@white_array = split (/&&/, $_);
			$white_two = @white_array[1];
		}
		push (@whitelist_two, $white_two);
	}

## read in dir
	opendir (IN, $in_dir) || die ("Error opening In directory at $in_dir");
		my @emails = readdir(IN);
	closedir(IN);




## Start Processing Files:
# Each file is grepped for *any* of the whitelist. If there is no match it is treated as 'bad'. 
# If there is a match, it is then regrepped to find *which* whitelist item matched. The details
# for that whitelist item are then extracted from the whitelist, and the email is sent.
#
# By this point in the program, the only I/O should be on the emails themselves. Everything else 
# (whitelist, directory listings, commands) should be in memory.

	foreach (@emails) {
		$email = $_;

		print "Checking ".$_."...";

		if ($email =~ m/EML$/){		#Only bother processing if it ends with EML
			$email_path = $in_dir.$email;
			$cmd2=$cmd.$email_path;
			$cmd2.=" | wc -l";
			
			if ($whitelist_size < 2){	# If there's only one line in the whitelist,
				print "1\n";		# we don't need to build the command.
			}else{
				$match_count = qx/$cmd2/;	

## $match_count is the amount of lines that matched any of the searchterms plucked from the whitelist.
## So this is essentially if (file is good){
## Commands (or, rather $cmds) hereafter are for the rescanning of the good files, to determine why they 
#  are good.
				if ( $match_count > 0){
					foreach (@whitelist_two){
						$_;
	
						$command="grep -i \"".$_."\" ".$email_path." | wc -l";

						$count2=qx/$command/;
						if ($count2 > 0){
							$winner = $_;
							last;
						}
					}

#	# If the whitelist item that made this email good contains an '&&'
#					if ($winner =~ &&){
#						@winner_array = split (/&&/, $winner);
#						
#
#
#				}else{
						
						for ($i=0; $i<$whitelist_size; $i++){
							if ($whitelist_file[$i] =~ m/^$winner/){
								$matching_line = $i;
							last;
							}
						}
						$details = $whitelist_file[$matching_line];
						@detail_array=split(/%/, $details);
					
							$subject = $detail_array[1];
							$to_address = $detail_array[2];
							$cc_address = $detail_array[3];
#					}

					open (EMAIL, $email_path);
						@full_email = <EMAIL>;
					close (EMAIL);

					$email_size=@full_email;
					for ($i=0, $i<$email_size, $i++){
						if ($full_email[$i] =~ m/^X-Original/){
							$dividing_line=$i;
							last;
						}else{
							$dividing_line=0;
						}
					}

#################################################
 # Incredibly quick and dirty hack begins here #
################################################
	#			
	#				my %sgcontactforms_to =(
	#					scanachrome => 'info@scanachrome.com, alex.wilson@b-s.co.uk, rob.kelly@servicegraphics.co.uk, lawrence.hinchey@servicegraphics.co.uk, john.boniface@servicegraphics.co.uk'
	#					b_s => 'enq@b-s.co.uk, alex.wilson@b-s.co.uk, rob.kelly@Servicegraphics.co.uk, lawrence.hinchey@Servicegraphics.co.uk, john.boniface@servicegraphics.co.uk'
	#					wandsworth => ''
	#					jupiter => '' 
	#					service_exhibitions => ''
	#					
	#
	#				)
	#				my %sgcontactforms_cc = (
	#
	#				)
	#
	#				if ($white == "sgcontactforms"){
	#					foreach (
	#						$cmd = "grep -i \"".$_." ";
	#
	#						$to=
	#
	#
	#				}
	#
	#
###############################################
 # Incredibly quick and dirty hack ends here #
###############################################


					open (MAIL, "|$sendmail") || die "Couldn't open pipe to $sendmail";
						print MAIL "to:", $to_address, "\n";
						print MAIL "Subject:", $subject, "\n";
						print MAIL "cc:", $cc_address, "\n";
						print MAIL $header;	
						$print = 0;
						foreach (@full_email){
							if ($print == 1){
								print MAIL $_;
							}

							if ( $_ =~ m/^X-Original/i ){
								$print = 1;
							}
						}
						print MAIL $signature;
						print MAIL "\n";
					close (MAIL);
					print "\t good\t".$winner;

					$winner =~ s/^\s+//g;
					$winner =~ s/\s+$//g;
					$winner =~ s/\s+/_/g;

					copy ($email_path, $good_dir.$winner.".".$email);
				}else{
					print "\t bad";

					# Extract subject line to rename file with.
					open (BADMAIL, $email_path);
						while ($line = <BADMAIL>){
							if ($line =~ m/^Subject:/){
								$subject_line = $line;
								last;
							}
						}
						$subject_line =~ s/subject://i;		#Strip leading 'subject'
						$subject_line =~ s/^\s+//g;		#Strip leading whitepace
						$subject_line =~ s/\s+$//g;		#Strip trailing whitespace
						$subject_line =~ s/\s+/_/gi;		#Sub every string of whitespace for underscores
						chomp $subject_line;
#						print "\t", $subject_line;
					close (BADMAIL);
					copy ($email_path, $bad_dir.$subject_line.".EML");
#				print "\t move ($email_path, $bad_dir"."$subject_line)";
				}
			}
		}
		print "\n";
	}









