#!/bin/bash

clear
R='\e[1;31m' G='\e[1;32m' Y='\e[1;33m' N='\e[0m'

for target in `cat IP.list`
do  
	if ping -c1 $target &> /dev/null; then
		echo -e $G "$target is UP" $N
		ip=`ping -c1 $target | head -1 | awk '{print $3}' | tr -d '()'`
		curl https://ipapi.co/$ip/csv/ >> ip.csv; echo >> ip.csv
	else
		echo -e $R "$i is DOWN" $N
	fi
done

read -p "Input URL or IP address: " target; ip=`ping -c1 $target | head -1 | awk '{print $3}' | tr -d '()'`
curl https://ipapi.co/$ip/csv/ >> ip.csv; echo >> ip.csv

echo -e $Y"DONE!" $N
