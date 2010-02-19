#! /usr/bin/perl

use strict;
use warnings;
use CGI qw(param);
use LWP::Simple;
use HTML::TableExtract;
use XML::RSSLite;
use 5.010;
print "Content-type: text/html\n\n";

print "
	<html>
	<h1>Avi's Dell Warranty Status getter</h1>
Stick a service tag in the box, hit the button, see what warranty you have.<br />
	<form action='dell.pl' method='GET'>
		Service Tag: <input type='text' name='tag'><br>
		<input type='submit' label='submit' value='Get it!'>
	</form>
";

if(defined(param('tag'))){
	my $service_tag = param('tag');
	my $url_base = "http://support.euro.dell.com/support/topics/topic.aspx/emea/shared/support/my_systems_info/en/details";
	my $url_params = "?c=uk&cs=ukbsdt1&l=en&s=gen";
	my $url = $url_base.$url_params."&servicetag=".$service_tag;
	my $content = get($url);
	
	# Tell HTML::TableExtract to pick out the table(s) whose class is 'contract_table':
	my $table = HTML::TableExtract->new( attribs => { class => "contract_table" } );
	$table->parse($content);
	
	## Gimme infos!
	foreach my $ts ($table->tables) {
		print "<table border=\"1\"><tr><td>";
		foreach my $row ($ts->rows) {
			print "", join("</td><td>", @$row), "\n";
			print "</td></tr><tr><td>";
		}
	}
	print "</td></tr></table>";

	## Drivers:
#	say "DRIVERS";
	## Make a url:
	$url_base = "http://support.euro.dell.com/support/downloads/driverslist.aspx";
	$url_params = "?c=uk&l=en&s=gen&catid=-1&dateid=-1&formatid=Hard-Drive&hidlang=en&hidos=WW1&impid=-1&os=WW1&osl=EN&scanConsent=False&scanSupported=False&TabIndex=&typeid=DRVR";
	$url=$url_base.$url_params."&servicetag=".$service_tag;
	
	$content = get($url);
	my @page = split(/\n/, $content);
	@page = grep(/SystemID/i, @page);
	
	if ($page[@page-1] =~ /&SystemID=(\w+)&/){
		my $system_id = $1;
		
		my $url_base="http://support.euro.dell.com/support/Downloads/rss/rss.aspx";
		my $url_params="?c=uk&l=en&s=gen&deviceids=all&oscodes=WLH&osl=en";
		my $url=$url_base.$url_params."&systemid=".$system_id;
		my $content = get($url);
		my %result;

	say "<table border='1'>";

		parseRSS(\%result, \$content);
		foreach my $item (@{$result{'item'}}) {
			say "<tr><td><a href='$item->{'link'}'>$item->{'title'}</a></td><td>$item->{'description'}</td></tr>";
		}
	say "</table>";
	}


}
print "<a href='dell.txt'>sauce</a> <a href='..'>home</a> <a href='../wp/dell-warranty-info/'>non-cgi</a>";;
print "<html>";
