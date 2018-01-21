!/usr/bin/perl
#Name:db-compare.pl
#
#Purpose:Script to compare LIVE and DR Datbases 
# NOTE **** THIS SCRIPT MUST BE RUN AS ROOT *****
#
#Author:Date:Revision 1.0 Only alert via slack if @results are found 
#Chris Smith:20161016:01
#Chris Smith:20161025:02 Check if table is set to be ignored from a list

use strict;
use warnings;

#Slack notify routine
sub IS_slack_notify {
  my $message = shift;
    my $slackNotify = qq{curl -X POST --data-urlencode 'payload={"channel": "#test", "username": "db-compare.pl:", "text": "$message", "icon_emoji": ":robot_face:"}' https://hooks.slack.com/services/SLACK_USER/SLACK_UNIQUE _ID};
      system($slackNotify);
        return;
        }

        my @results ;

        # Grab Live Dbase from external script
        print "Please wait while I grab the LIVE Dbase table count\n";
        my @live_db_count = `ssh criis\@IPofREmtoehosts "/var/www/first_db.pl"` or die "Something is wrong with LIVE DBase ?" ; # Live DB Tables : row count
        #my @live_db_count = `ssh someone\@IPofremotehost"cat /var/www/temp/live-db-test2.txt"`; #Test txt file

        # Grab DR Dbase from external script
        print "Please wait while I grab the DR Dbase table count\n";
        my @dr_db_count = `./DR-WEB_db_count.pl` or die "There's something wrong with the DR Database ?";
        #my @dr_db_count = `cat ./dr-db-test2.txt`;# Minimal Test txt file
        print "Checking for differnces Live vs DR\n";

        #Check if current table in Live is in the table ignore list 
        my $field = 0; # set counter for Array Elements
         foreach (@live_db_count) {
          my ($tablename, $row_count) = split /\s:\s/, $live_db_count[$field]; # extract table and rowcount and seperate
           chomp $row_count;
            #print "Current table: $tablename|$row_count|\n";
               # List of Tables to be ignored
                  my @tables_to_ignore = qw (
                     tableq1
                       tableeq2
                         tableq3
                            tableeq4
                                                                      );  
foreach (@tables_to_ignore) { 
if ($tablename eq $_) {
 #print "Ignoring this table $tablename and $_ \n";
 print "Ignoring this table its set to be ignored $_ \n";
 goto IGNORE; # Jump out to the IGNORE Label and if current table is in ignore list. 
                                                                                               } 
                                                                                                  }

#Loop through Live Dbase tables and compare each element against Same Element in DR Database 	
                                                                                                      if ($live_db_count[$field] ne $dr_db_count[$field]) { # were only interested if array values are different
                                                                                                        chomp $live_db_count[$field];
                                                                                                        print "Live Dbase $live_db_count[$field] ,DR Dbase $dr_db_count[$field]";
                                                                                                        push @results,"Live Dbase ",$live_db_count[$field],",DR Dbase",$dr_db_count[$field]; # Send any differences to slack results array
                                                                                                              }
                                                                                                              IGNORE:
                                                                                                               $field ++; #Add 1 to counter to run through arrays 
                                                                                                                }

                                                                                                                if (@results >= 1) { # Only send messages via Slack if values in @results
                                                                                                                #print "Result: @results \n";
                                                                                                                IS_slack_notify ("@results");
                                                                                                                }
                                                                                                               else {print "No differences found\n";}
