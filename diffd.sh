#!/bin/bash
# diffd.sh - compare the two directories content based on the date of their change

clear
R='\e[1;31m' G='\e[1;32m' P='\e[1;35m' N='\e[0m'

ls $1 | while read f
do
	if [ -e "$2/$f" ]
		then
			if [ `stat -c %Y $1/$f` -eq `stat -c %Y $2/$f` ]
				then echo -e $G"+ $f $N- status not changed"
			elif [ `stat -c %Y $1/$f` -gt `stat -c %Y $2/$f` ]
				then echo -e $R"< $f $N- more newer in $1"
			else
				echo -e $R"> $f $N- more newer in $2"
			fi
		else
			echo -e $P"- $f $N- absent in $2"
	fi
done

ls $2 | while read f
do
	if [ ! -e "$1/$f" ]
		then echo -e $P"- $f $N- absent in $1"
	fi
done
