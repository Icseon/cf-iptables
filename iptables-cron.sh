#!/bin/bash
# This script will automatically generate Cloudflare iptable rules for us based on the IP addresses they expose for our use.

# Temporary iptables configuration file location.
IP_TABLES_TEMP=/tmp/iptables.new

# Initialize an array which will hold the Cloudflare rules.
CLOUDFLARE_RULES=""

# Download the Cloudflare IP addresses that we wish to allow.
CLOUDFLARE_IP_ADDRESSES=$(curl --max-time 10 --silent -S -snL https://www.cloudflare.com/ips-v4 https://www.cloudflare.com/ips-v6)

if ["$?" = "0" ]; then

    # Loop through every IP address that we have downloaded
    for line in $CLOUDFLARE_IP_ADDRESSES; do

        # Add the IP address to the CLOUDFLARE_RULES variable
        CLOUDFLARE_RULES += "-A INPUT -s $line -p tcp -m multiport --dports 80,443 -j ACCEPT
        "

    done

    # Store our results to a temporary file.
    eval "cat <<< \$(</etc/iptables.template)\"" > $IP_TABLES_TEMP

    # Find differences between the temporary file and the configuration we already have.
    diff -q $IP_TABLES_TEMP /etc/iptables

    # If we have a difference, replace the configuration with our temporary file and restart iptables
    if [ -s $IP_TABLES_TEMP -a "$?" = "1" ]; then
    
        # Replace our current configuration with our temporary file
        mv -f $IP_TABLES_TEMP /etc/iptables

        # Load new rules
        iptables-restore /etc/iptables

    else

        # Delete the temporary file from our filesystem
        rm -f $IP_TABLES_TEMP

    fi

fi