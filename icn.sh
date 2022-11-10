#!/bin/bash
# inc (identifying a card number) - checking issuing bank and bank identification number

R='\e[1;31m' G='\e[1;32m' Y='\e[1;33m' N='\e[0m'
clear

while :
do
	read -p "Input a card number: " number
	digit=$(echo "${number//[!0-9]/}")
	length=$(expr length "$digit")

	if [[ $length != 15 && $length != 16 && $length != 18 && $length != 19 ]]; then
		echo -e $R"$number - incorrect Card Number! Try again."$N
	else
		break
	fi
done
echo -e $Y"Card Number:" $G"$digit"$N

issuers=( [35]="American Express" [37]="American Express" [22]="Mir" [50]="Maestro" [58]="Maestro" [63]="Maestro" [67]="Maestro" [51]="Mastercard" [52]="Mastercard" [53]="Mastercard" [54]="Mastercard" [55]="Mastercard" [40]="Visa Electron" [41]="Visa Electron" [49]="Visa Electron" [48]="Visa Electron" [49]="Visa Electron")

iins=$(echo ${digit:0:2})

for i in "${!issuers[@]}"
do
	if [ $i -eq $iins ]; then
		iin=$(echo ${issuers[$i]}); break	#Checking Issuer Bank
	else
		iin="-"
	fi
done
echo -e $Y"Payment System:" $G"$iin"$N

banks=( [548673]="Alfa-Bank" [415428]="Alfa-Bank" [477964]="Alfa-Bank" [548674]="Alfa-Bank" [521178]="Alfa-Bank" [415428]="Alfa-Bank" [427901]="Sberbank" [636933]="Sberbank" [639002]="Sberbank" [427644]="Sberbank" [427631]="Sberbank" [427601]="Sberbank" [220220]="Sberbank" [521324]="Tinkoff Bank" [43773]="Tinkoff Bank" )

bin=${digit:0:6}

for b in "${!banks[@]}"
do
	if [ $b -eq $bin ]; then
		bank=$(echo ${banks[$b]}); break	#Checking Bank Identification Number
	else
		bank="-"
	fi
done
echo -e $Y"Issuing Bank:" $G"$bank"$N
#echo $digit, $iin, $bank >>card.csv
