!/usr/bin/perl
#Name: DR-email-criis-users.pl#
#Purpose:Script to trigger a script in DR to email all users (from drweb server) 
#
 Note: This script will email 3000 users  with a default messages "There has been issues today on CRiiS...." and takes about 8 mins to complete
# Full details of remote script and message are available from customerlane.org.uk /var/www/customerdoamin/dr_scripts/email_alert_criis_users.pl

#Author:Date:Revision 1.0  
#Chris Smith:20170124:01

use strict;
use warnings;

print "Note: This script sends approx 3,000 Emails to all users with a message defined in customer-domain.com:/var/www/customerdoamin.com/dr_scripts/message.txt\n";
print "Are you sure you want to continue Y/n ? ";
my $answer = <>;
chomp $answer;
if ($answer eq "Y") {
print "Thanks. Now running customer domain.com:/var/www/customerdomain/dr_scripts/email_alert_criis_users.pl\n";
system ('cd /var/www/vhosts/customer-doamin.com/aws;ssh -i "xxxxxTEST.pem" centos@customerlan.com "sudo /var/www/customert.london.uk/dr_scripts/email_alert_users.pl" or die "Something is wrong with the remote script on aws adminserver"')
}
