#!/bin/bash
# This script will automatically generate Cloudflare iptable rules for us based on the IP addresses they expose for our use.

# Initialize an array which will hold the Cloudflare rules.
CLOUDFLARE_IP4_RULES=""
CLOUDFLARE_IP6_RULES=""

# Download the Cloudflare IP addresses that we wish to allow.
CLOUDFLARE_IP4_ADDRESSES=$(curl -s https://www.cloudflare.com/ips-v4)
CLOUDFLARE_IP6_ADDRESSES=$(curl -s https://www.cloudflare.com/ips-v6)

# Loop through every IPv4 address that we have downloaded
for line in $CLOUDFLARE_IP4_ADDRESSES; do

    # Add the IPv4 address to the CLOUDFLARE_IP4_ADDRESSES variable
    CLOUDFLARE_IP4_RULES+="-A INPUT -s $line -p tcp -m multiport --dports 80,443 -j ACCEPT
"

done

# Loop through every IPv6 address that we have downloaded
for line in $CLOUDFLARE_IP6_ADDRESSES; do

    # Add the IPv6 address to the CLOUDFLARE_IP6_ADDRESSES variable
    CLOUDFLARE_IP6_RULES+="-A INPUT -s $line -p tcp -m multiport --dports 80,443 -j ACCEPT
"

done

# Load IPv4s
eval "cat <<< \"$(</etc/ip4tables.template)\"" > /etc/ip4tables
iptables-restore /etc/ip4tables

# Load IPv6s
eval "cat <<< \"$(</etc/ip6tables.template)\"" > /etc/ip6tables
ip6tables-restore /etc/ip6tables