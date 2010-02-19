#! /usr/bin/perl

use strict;
use warnings;
use 5.010;

die "$0\n\tGet warranty info from dell.\nUsage\n$0 [SERVICE TAG]\n" if !$ARGV[0];

my $service_tag = $ARGV[0];

use LWP::Simple;
use HTML::TableExtract; # Is in the CPAN, and exists in the debian repositories as libhtml-tableextract-perl

## Make a URL:
my $url_base = "http://support.euro.dell.com/support/topics/topic.aspx/emea/shared/support/my_systems_info/en/details";
my $url_params = "?c=uk&cs=ukbsdt1&l=en&s=gen";
my $url = $url_base.$url_params."&servicetag=".$service_tag;
#my $content = get($url);

# Tell HTML::TableExtract to pick out the table(s) whose class is 'contract_table':
#my $table = HTML::TableExtract->new( attribs => { class => "contract_table" } );
#$table->parse($content);

#rint $url;
print "\n";

### Gimme infos!
#foreach my $ts ($table->tables) {
#	foreach my $row ($ts->rows) {
#		print "", join("\t", @$row), "\n";
#	}
#}


## Drivers:

## Make a url:
$url_base = "http://support.euro.dell.com/support/downloads/driverslist.aspx";
$url_params = "?c=uk&l=en&s=gen&catid=-1&dateid=-1&formatid=Hard-Drive&hidlang=en&hidos=WW1&impid=-1&os=WW1&osl=EN&scanConsent=False&scanSupported=False&TabIndex=&typeid=DRVR";
$url=$url_base.$url_params."&servicetag=".$service_taglge = split(/\n/, $content);
@page = grep(/SystemID/i, @page);

if ($page[@page-1] =~ /&SystemID=(\w+)&/){
	my $system_id = $1;
	
	my $url_base="http://support.euro.dell.com/support/Downloads/rss/rss.aspx";
	my $url_params="?c=uk&l=en&s=gen&deviceids=all&oscodes=WLH&osl=en";
	my $url=$url_base.$url_params."&systemid=".$system_id;
	my $content = get($url);
	my %result;
	parseRSS(\%result, \$content);
	foreach my $item(@{result{'item'}}){
		say "<h3>$item->{'title'}</h3>";
	}


}

