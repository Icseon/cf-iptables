#!/bin/bash
# This file will install the cron-job that will automatically renew Cloudflare rules.

# Step 1: Copy the template file to /etc and create the default iptables files
touch /etc/ip4tables
touch /etc/ip6tables
cp ./ip4tables.template /etc/ip4tables.template
cp ./ip6tables.template /etc/ip6tables.template
echo "1. Copied ip(4|6)tables.template to /etc/ip(4|6)tables.template"

# Step 2: Copy the iptables-cron.sh file to /usr/local/sbin/ and make it executable.
cp ./iptables-cron.sh /usr/local/sbin/
chmod +x /usr/local/sbin/iptables-cron.sh
echo "2. Copied iptables-cron.sh to /usr/local/sbin/ and made it executable"

# Step 3: Run the script for the first time so that it's setup immediately.
/usr/local/sbin/iptables-cron.sh
echo "3. Ran cronjob script for the first time"

# Step 4: Install the crontab that will run once every hour.
# Get current crontab file and add our new crontab on top of it.
# We're also going to restore the iptables on reboot.
crontab -l > tempcron
echo "@reboot iptables-restore /etc/ip4tables" >> tempcron
echo "@reboot ip6tables-restore /etc/ip6tables" >> tempcron
echo "0 * * * * /usr/local/sbin/iptables-cron.sh" >> tempcron

# Install new cron file.
crontab tempcron
rm tempcron
echo "4. Installed cronjob"