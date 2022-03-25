#!/bin/bash

clear
R='\e[1;31m' G='\e[1;32m' Y='\e[1;33m' N='\e[0m'
dir=`dirname $0`

echo -e $R"
WARNING :
This tool is only for educational purpose.
If you use this tool for other purposes except education,
we will not be responsible in such cases.
"$N
echo -e $Y"Select Output File Format (json, by default):
1 - json
2 - csv
3 - xml
4 - yaml
---------------------------------------------"
read -s -n1 key

if [[ $key = 1 ]]; then
	exe=json
elif [[ $key = 2 ]]; then
	exe=csv
 elif [[ $key = 3 ]]; then
	exe=xml
  elif [[ $key = 4 ]]; then
	exe=yaml
   else
	exe=json
fi

for target in `cat IP.list`
do  
	if ping -c1 $target &> /dev/null; then
		echo -e $G"$target is UP"$N
		ip=`ping -c1 $target | head -1 | awk '{print $3}' | tr -d '()'`
		curl https://ipapi.co/$ip/$exe/ >> $dir/ip.$exe; echo >> $dir/ip.$exe
	else
		echo -e $R"$target is DOWN"$N
	fi
done

read -p "Input URL or IP address: " target; ip=`ping -c1 $target | head -1 | awk '{print $3}' | tr -d '()'`
curl https://ipapi.co/$ip/$exe/ >> $dir/ip.$exe; echo >> $dir/ip.$exe

echo -e $G"DONE!" $Y"Inspect created $dir/ip.$exe file."$N
