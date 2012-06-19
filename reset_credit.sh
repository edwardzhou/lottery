#!/bin/sh
. /etc/environment
. /etc/profile
cd /home/ec2-user/ruby_work/lottery
echo "start to reset credit..." >> log/reset_credit.log
echo `date` >> log/reset_credit.log
/usr/local/ruby/bin/rake lottery:reset_available_credits 1>>log/reset_credit.log 2>>&1

