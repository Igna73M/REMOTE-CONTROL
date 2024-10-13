# Written By https://github.com/Igna73M


#! /bin/bash

function INSTALL()
{
	sudo apt-get update
	sudo apt-get install geoip-bin sshpass curl grep  nmap -y
}


function check_Anony()
{
	if [  "$(geoiplookup $(curl ifconfig.co -s) | grep -m 1 '$1')" ] # Anonymous Check with the use of Country abbr code $1
	then
		echo "You're not Anonymous exiting..."
		echo " ... "
		echo "    Bye!"
		echo "        ... "
		exit
	else
		# You are not Anonymous then use nipe to create tor network
		git clone https://github.com/htrgouvea/nipe && cd nipe
		cpanm --installdeps .
		sudo perl nipe.pl install
		perl nipe.pl restart
		cd ..

		# Then do remote execution using ssh
		RMEx
	fi
}


# Perform remote scan on the $2 host ip
function RMEx ()
{
	sshpass -p '<password>' ssh user@<Vps ip address> "sudo nmap -F $2" # $2 argument are the target host ip address
	LOG
}



# save log into the file
function LOG()
{
	mkdir var
	echo $(date) $HOSTNAME $0 $? "Remote Scanning from <Vps ip address> on host: $2" >> var/Scanning.log
}


INSTALL
clear
check_Anony
