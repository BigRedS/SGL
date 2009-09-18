#! /usr/bin/perl

${email}="./email.eml";

open (EMAIL, ${email});
	@{email} = <EMAIL>;

close (EMAIL);

#@{email} = 
#
if (grep(m/dotofoz/, @email)) {


#f (@email =~ m/dotofoz/){

foreach $line (@email){
	print $line ;
}

}

