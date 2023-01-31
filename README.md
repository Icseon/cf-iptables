## Automated Cloudflare iptables Configuration

**Status**: Untested. I'll update this status once I have tested this and confirmed it to be working.

**Disclaimer**:\
I was inspired by: https://gist.github.com/AndrewJDR/47ea02e7d5b4665d705e

Built this because I wanted an easier way to configure it and the aforementioned gist does not contain the IPv6s, which is a problem for me.

I do not hold any responsibility for any damages caused by improper usage of this repository.

### Usage
1. Modify `iptables.template` to your liking. You can add your own custom rules such as allowing a specific IP address to access your services.
2. Run `install.sh` as a root user. This will automatically set everything up and create the cronjob for you.

That's all. Your webserver should no longer respond to any request that does not orginate from Cloudflare, as if it doesn't even exist on the internet.

### Removal
If you'd like to remove this from your system, follow these these three easy steps:
1. Remove the crontab in root mode using `crontab -e`.
2. Run: `rm /usr/local/sbin/iptables-cron.sh /etc/sysconfig/iptables.template`
3. Run: `iptables -F`

### Additional Recommendations
While this will stop any connection that does not come from Cloudflare, it's still a good idea to:
1. If you use nginx as a reverse proxy for your applications, verify if the real-ip header comes from Cloudflare as well (`real_ip_header CF-Connecting-IP` & `set_real_ip_from`).
2. This is not enough to fully hide your IP address. You'd want to configure a default virtual host with a self signed certificate that does not contain any information about you or your website. Failure to do this will result in IP address exposure overtime.
3. In nginx, you'd want to also check if the `$realip_remote_addr` variable is in a hashtable containing Cloudflare IP addresses. This allows for greater traffic control ability and would allow you to block certain resources to Cloudflare clients (in case you whitelisted your own IP address for internal services), for example.


— Icseon\
This repository has been made open source because I believe that some people would find this useful. I also want to be able to refer to this in the future without potentially losing access to this. You're free to modify and fork this as you wish.