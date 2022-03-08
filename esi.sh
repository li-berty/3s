#!/bin/sh
# esi - extract system information

main()
{
echo "<--- About The User --->"
echo -n " Username  : "; whoami 2> /dev/null
echo -n " Hostname  : "; uname -n 2> /dev/null
echo -n " EUID      : "; id -u 2> /dev/null
echo -n " EGID      : "; id -g 2> /dev/null
echo -n " Groups    : "; groups 2> /dev/null
echo " Home Path : $HOME" 2> /dev/null
echo
echo "<--- About The System --->"
echo -n " Kernel Name    : "; uname -s 2> /dev/null
echo -n " Kernel Release : "; uname -r 2> /dev/null
echo -n " Kernel Version : "; uname -v 2> /dev/null
echo -n " Architecture   : "; uname -m 2> /dev/null
echo -n " OS Name        : "; uname -o 2> /dev/null
echo
echo "<--- Product --->"
p_family=`cat /sys/class/dmi/id/product_family` 2> /dev/null; echo " Product Family  : $p_family"
p_name=`cat /sys/class/dmi/id/product_name` 2> /dev/null; echo " Product Name    : $p_name"
p_version=`cat /sys/class/dmi/id/product_version` 2> /dev/null; echo " Product Version : $p_version"
echo
echo "<--- BIOS Information --->"
b_vendor=`cat /sys/class/dmi/id/bios_vendor` 2> /dev/null; echo " BIOS Vendor  : $b_vendor"
b_date=`cat /sys/class/dmi/id/bios_date` 2> /dev/null; echo " BIOS Dat     : $b_date"
b_version=`cat /sys/class/dmi/id/bios_version` 2> /dev/null; echo " BIOS Version : $b_version"
echo
echo "<--- CPUs and Bugs --->"
grep "model name\|bugs" /proc/cpuinfo | awk -F ':' '{print "",substr($2,2)}' 2> /dev/null
echo
echo "<--- Memory --->"
echo -n " RAM Total      : "; grep "MemTotal:" /proc/meminfo | awk '{print $2,$3}' 2> /dev/null
echo -n " RAM Available  : "; grep "MemAvailable:" /proc/meminfo | awk -F ' ' '{print $2,$3}' 2> /dev/null
echo -n " RAM Free       : "; grep "MemFree:" /proc/meminfo | awk '{print $2,$3}' 2> /dev/null
echo
echo "<--- Network Interfaces --->"
printf " %-16s %s\n" "[Interface]" "[Flags]"; ip -o link show | awk '{printf " %-16s %s\n", substr($2,1,length($2)-1), $3}' | sort 2> /dev/null
echo
echo "<--- MAC Addresses --->"
printf " %-16s %s\n" "[Interface]" "[MAC Address]"; ip -o link show | awk '{printf " %-16s %s\n", substr($2,1,length($2)-1), $(NF-2)}' | sort 2> /dev/null
echo
echo "<--- IP Addresses --->"
printf " %-16s %s\n" "[Interface]" "[IP Address]"; ip address | grep "inet " | awk '{printf " %-16s %s\n", $NF, $2}'  2> /dev/null
printf " %-16s " "Public"; dig +short myip.opendns.com @resolver1.opendns.com 2> /dev/null
echo
echo "<--- Open Ports --->"
printf " %-8s %-24s %s\n" "[Type]" "[Address]" "[PID/Program]"; netstat -tulpn 2> /dev/null | grep "LISTEN" | awk '{printf " %-8s %-24s %s\n", $1, $4, $NF}' 2> /dev/null
echo
echo "<--- List Of All Users --->"
printf " %-24s %8s %8s   %s\n" "[Shell]" "[GID]" "[UID]" "[User]"; awk -F ':' '{printf " %-24s %8s %8s   %s\n", $NF, $3, $4, $1}' /etc/passwd | sort 2> /dev/null
echo
echo "<--- List Of Users With Login Shells --->"
printf " %-32s %s\n" "[Shell]" "[User]"; grep -v "/usr/bin/nologin" /etc/passwd | awk -F ':' '{printf " %-32s %s\n", $NF, $1}' | sort 2> /dev/null
echo
echo "<--- List Of Users With Home Directories --->"
printf " %-32s %s\n" "[Home Directory]" "[User]"; grep -v ":/:" /etc/passwd| awk -F ':' '{printf " %-32s %s\n", $(NF-1), $1}' | sort 2> /dev/null
echo
echo "<--- List Of Groups --->"
printf " %-8s %s\n" "[GID]" "[Group]"; awk -F ':' '{printf " %-8s %s\n", $3, $1}' /etc/group | sort -V 2> /dev/null
echo
echo "<--- Activity Current Online Users --->"
printf " %-12s %-6s %-16s %-8s %-8s %s\n" "[Username]" "[Term]" "[IP Address]" "[Login]" "[Idle]" "[Current Activity]"; w -i | tail +3 | awk '{printf " %-12s %-6s %-16s %-8s %-8s %s\n", $1, $2, $3, $4, $5, F}' | sort 2> /dev/null
echo
echo "<--- Currently Running Processes --->"
printf " %-12s %-8s %s\n" "[Username]" "[PID]" "[Process]"; ps -aux | tail +2 | awk '{printf " %-12s %-8s %s\n", $1, $2, $11}' | sort -V 2> /dev/null
echo
echo "<--- Active Services --->"
systemctl --type=service --state=active 2> /dev/null | grep "service.*active" | awk '{print "",$1}' | sort
echo
echo "<--- Running Services --->"
systemctl --type=service --state=running 2> /dev/null | grep "service.*running" | awk '{print "",$1}' | sort
echo
echo "<--- Timers --->"
printf " %-32s %s\n" "[Timer]" "[Service]"; systemctl list-timers 2> /dev/null | grep ".*\.timer" | awk '{printf " %-32s %s\n", $(NF-1), $NF}' | sort
echo
echo "<--- /etc/shadow Permissions --->"
echo -n " Access : "; ls -l /etc/shadow | awk  '{print $1}' 2> /dev/null
echo -n " Owner  : "; ls -l /etc/shadow | awk  '{print $3}' 2> /dev/null
echo -n " Group  : "; ls -l /etc/shadow | awk  '{print $4}' 2> /dev/null
echo
echo "<--- /etc/sudoers Permissions --->"
echo -n " Access : "; ls -l /etc/sudoers | awk '{print $1}' 2> /dev/null
echo -n " Owner  : "; ls -l /etc/sudoers | awk '{print $3}' 2> /dev/null
echo -n " Group  : "; ls -l /etc/sudoers | awk '{print $4}' 2> /dev/null
echo
echo "<--- Possible SUIDs --->"
find / -perm /6000 2> /dev/null | awk '{print "",$0}' 2> /dev/null
echo
echo "<--- sudo History --->"
grep "sudo " ~/.bash_history 2> /dev/null | awk '{print "",$0}' 2> /dev/null
echo
echo "<--- SSH Keys --->"
ls /home/*/.ssh/*.rsa /home/*/.ssh/*.pub /root/.ssh/*.rsa /root/.ssh/*.pub 2> /dev/null | awk '{print "",$0}' 2> /dev/null
echo
echo "Done!"
}
clear
main
#exec; echo "wait...";  main > esi.log

# Thanks <Shawn Duong> https://github.com/shawnduong/PXEnum
