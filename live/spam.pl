#! /usr/bin/perl

use warnings;
#use strict;
#use diagnostics;

use File::Copy;

my ${in_dir}="/home/avi/bin/perl/spam/in/";
my ${good_dir}="/home/avi/bin/perl/spam/good/";
my ${bad_dir}="/home/avi/bin/perl/spam/bad/";
my ${whitelist}="whitelist";

my ${today}=qx/date +%y%m%d/;
#{today}=chop(${today});
${today} =~ s/\n/\//g;
#${today}=chomp(${today});


##Mail!
my ${sendmail}="/usr/sbin/sendmail -t";
my ${from}="From: Spam-Alerts";
my ${reply}='Reply-to: avi.greenbury@servicegraphics.co.uk';

## Checking for dir existence

${fatal_error} = "0";

foreach ( ${good_dir}, ${in_dir}, ${bad_dir} ) {
	if ( -w $_ ) {
		sleep 0
	}else{
		print "Error! Cannot find directory $_. \t Either it doesn't exist, or I cannot read it.";
		${fatal_error} = 1
	}

}

## Check for file existence and readability

foreach ( ${whitelist} ) {
	if ( -r $_ ) {
		sleep 0;
	}else{
		print "Error! Cannot find file $_. \t Either it doesn't exist, or I cannot read it.";
		${fatal_error} = 1;
	}

}

if ( ${fatal_error} == 1  ) { exit }

open (WHITELIST, "< ${whitelist}") || die "Error opening whitelist at ${whitelist}";
	@{whitelist} = <WHITELIST>;
close (WHITELIST);

opendir (DIR, "${in_dir}");
	my @files=readdir(DIR);
closedir (DIR);



foreach (@files) {

	${good} = 0;

	unless ( $_ =~ m/^\./ ) {

		${filename} = $_ ;
		${file} = ${in_dir}.${filename};

		## Read email into array
		open (EMAIL, "${file}");
			@{email} = <EMAIL>;
		close (EMAIL);

		## Extract subject line
		@{intended_subject} = grep(m/^Subject/, @{email});
#		${intended_subject} = chomp(${intended_subject}[0]);
#
		foreach (@whitelist) {
			
			( ${white}, ${to}, ${subject}, ${cc} ) = (split /%/, $_)[0,1,2,3];

			${email} = join ("", @email);
			if (${email} =~ m/${white}/){

#				@white_test = grep(/.${white}./ , @{email});
#				if (${white_test}[0] ne "" ){

			

#				open (MAIL, "|${sendmail}") or die "Couldn't open ${sendmail}";
#					print MAIL "To: ${to} \n";
#					print MAIL "From: ${from} \n";
#					print MAIL "cc: ${cc} \n";
#					print MAIL "Subject: ${subject}";
#
#					foreach (@{email}) {
#						print MAIL "$_ \n";
#					}
#				close MAIL;

				print ${to}, "\n", ${from}, "\n", ${cc}, ${subject}, "\n"; 

#				! ### ! ### ! ### Change this copy to move:

				print "good \t", ${file}, "\t", ${good_dir}, "/", ${white}, "\n";
				#copy ("${file}", "${good_dir}/${white}") || die "Could not move ${file} to ${good_dir}/${white}";
				${good} = 1;
				last;			
			}
		}

		if ( ${good} == "1"){
			last;
		}else{
			# ! ### ! ### ! ### Change this copy to move:
#		copy ("${file}", "${bad_dir}/${today}/${subject}") || die "Could not move ${file} to ${bad_dir}/${today}/${subject}";
#		print "bad \t", ${file}, "\t", ${bad_dir}, ${today}, ${intended_subject}, "\n";
		}
	}
}
