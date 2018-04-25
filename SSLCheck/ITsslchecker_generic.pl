#!/usr/bin/perl
######################################################################
# Perl Script to Check Remote/Local domains for SSL Cert expiry dates
#
# Thanks go to Mr Miller for all his hard work on this
######################################################################
use strict;
use warnings;
use Date::Calc qw(Delta_Days Today);

#######################################################################
## IS_slack_notify
## Posts a messsage in Slack with the passed message
########################################################################
sub IS_slack_notify {
  my $message = shift;
  my $channel = shift || 'general';
  my $db_name = shift || uc $ENV{'USER'};
  my $slackToken = ''; # your token here
  my $slackNotify = qq{curl -X POST --data-urlencode 'payload={"channel": "#$channel", "username": "$db_name", "text": "$message", "icon_emoji": ":ghost:"}' https://hooks.slack.com/services/$slackToken};
  system($slackNotify);
  return;
}

my @domains = qw(
  bbc.co.uk 
  google.co.uk 
  amnesty.org.uk 
);
my ($tY, $tM, $tD) = Today();
my @months = qw(Invalid Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my $slackMessage;
for (@domains) {
  my $domain = $_;
  my $pipeline = "echo | openssl s_client -servername www.$_ -connect www.$_:443 2>/dev/null | openssl x509 -noout -dates";
  my $response = `$pipeline`;
  my @lines = split('\n', $response);
  for (@lines) {
    if (m/^notAfter=([A-Za-z]{3}) +([0-9]{1,2}) +\d{2}:\d{2}:\d{2} +(\d{4})/) {
      my( $index )= grep { $months[$_] eq $1 } 0..$#months;
      my $days_til_expiry = Delta_Days($tY, $tM, $tD, $3, $index, $2);
      my $expiry_date = "$2 $1 $3";
      if ($days_til_expiry < 1) {
        $slackMessage .= "$domain SSL CERTIFICATE HAS EXPIRED\n";
      }
      elsif ($days_til_expiry == 1) {
        $slackMessage .= "$domain SSL is very close to expiry - expiration date $expiry_date\n";
      }
      elsif ($days_til_expiry < 14) {
        $slackMessage .= "$domain SSL certificate expires in $days_til_expiry days on $expiry_date\n";
      }
    }
  }
}
if ($slackMessage) {
  IS_slack_notify($slackMessage, "test");
}
