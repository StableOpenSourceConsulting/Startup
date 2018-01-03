#!/usr/bin/perl
# Perl Script to use output from apache server-status to monitor how many apache worker processes are busy and Requests Per Second
# cs 6/6/2017
use strict;
use warnings;
use ADroutines;

# Check server name and ajust connections to apache staus page, based on this.
my $port = IS_get_server_name() eq 'Endive' ? qq{:7080\\} : '';
my $domain  = IS_get_server_name() eq 'Endive' ? 'criisrestore' : 'criis';

#Install Lync to allow connection to apache-status
my $apache_status = "lynx -auth=Stats4U\$\:'your UserNameUserPassword\$\' -dump http:\/\/localhost\$port/server-status?auto";
my @apache_stats=split(/\s/,`$apache_status`); # Use space to separate array elements. Makes it easier to select numbers later
chomp @apache_stats;

# Print out all stats to a file for zabbix to monitor in /var/tmp
open(my $fh, ">", "/var/tmp/apache_status.txt");
my @apache_op=split(/\n/,`$apache_status`);
for (@apache_op) {
  print $fh "$_\n";
}
close $fh;

my $ReqPerSec   = $apache_stats[11];
my $BusyWorkers = $apache_stats[17];

if ($ReqPerSec >= 27.1 || $BusyWorkers >= 200) { 
  my $status_message = "apache-status.pl : " . IS_get_server_name() . " reports high values -> Request Per Second: $ReqPerSec Busy Workers: $BusyWorkers. See http://www.$domain.org.uk/server-status";
  my $hour = (localtime)[2];
  if ($hour >= 7 && $hour <= 19) {
    IS_slack_notify($status_message, 0, IS_get_server_name() . "  Apache Process status");
  }
}
