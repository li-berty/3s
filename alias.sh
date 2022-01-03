#!/bin/bash
# Creating permanent executable aliases

R='\e[1;31m' G='\e[1;32m' Y='\e[1;33m' N='\e[0m'

set=~/.bash_aliases
#set=/etc/bash.bashrc; sys=/etc/bash.bashrc

if [[ $set = $sys ]]; then
	if [ $EUID -ne 0 ]; then
		echo -e $R"Run this script as root (sudo)"$N; exit
	fi
fi

cat  >> $set << 'EOF'
# Alias definitions

alias apt="sudo apt"
alias q!="exit"
alias ?="pwd"
alias hi="history |"
alias ping="ping -c4"
alias ipconfig="ip address | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias wfp="sudo egrep -h -s -A 9 --color -T 'ssid=' /etc/NetworkManager/system-connections/*"
alias speed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

EOF

echo -e $Y"Permanent executable aliases was created in fale" $G"$set"$N
