#!/bin/bash
# Script name:apache_404_notfound-check.sh
# Script to count apache upstream  ' 404 ' gateway Invalid Request-Page Not found/Timeouts/per minute and alert if greater than hit_limit 10x404's per minute 
# v 1.0 cs 19012016 Send alert out to Slack channel if limit is hit  
# v.1.2.cs 21022017 Bug fix non double digit Minutes or Days.Simplify previous minute with date --date
# date --date="last Min" +"%Y/%m/%d %H:%M"
# 2017/02/01 01:14

search_string=" 404 "
# Ver 1.2
# This will calculate the previous Minute whatever the time or day. 
# i.e 2016/12/31 23:59 if current time is 2017/01/01 00:00
date_last_full_min=`date --date="last Min" +"%d/%b/%Y:%H:%M"`
#date_last_full_min="2017/02/21 11:07"
date_last_time=`date --date="last Min" +"%H:%M"`
date_now=`date +"%Y%m%d%H%M%S"`
current_time=`date  +"%H:%M"`

###echo "Here's the last previous minute we will search for $date_last_full_min."

count_504s=`grep "$date_last_full_min" /var/log/httpd/ssl_access_log | grep "$search_string"|wc -l`
###count_504s=`grep "$date_last_full_min" ./ssl_access_example_log | grep "$search_string"|wc -l`
###echo " Ive found $count_504s 504's"

hit_limit=10


if [ "$count_504s" -ge "$hit_limit" ];then
###echo "504 messages Limit of $hit_limit breached. $count_504s Apache Gateway timed outs at $date_last_time"

#echo "the nginx file would be called nginx-queries-$date_now"

curl -X POST --data-urlencode "payload={\"channel\": \"#sysadmin\", \"username\": \"DR Apache File not found\", \"text\": \"404 Apache File not found exceeded limit of $hit_limit in last minute! ${count_504s} at ${date_last_time} \", \"icon_emoji\": \":robot_face:\"}" https://hooks.slack.com/services/slack-account_no/B0-slack-api-unique-id
fi
