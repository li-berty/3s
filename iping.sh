#!/bin/bash

R="\e[1;31m" G="\e[1;32m" Y="\e[1;33m" N="\e[0m"
echo -e $Y"Welcome, $(whoami | sed 's/^./\U&\E/')!" $N

for i in `cat IP.list`
do  
  if ping -c1 $i &> /dev/null
  then
    echo -e $G "$i is UP" $N
  else
    echo -e $R "$i is DOWN" $N
  fi
done
echo -e $Y"DONE!" $N
