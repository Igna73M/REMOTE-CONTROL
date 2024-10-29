# Written By https://github.com/Igna73M

#! /bin/bash



# 1.5 Allow the user to specify the address to scan via remote server; save into a variable.
function MENU(){
    echo -e "\e[32m" 
    figlet -k -f small "    OPTION: "
    read -p "Give the Virtual Private Server Ip Address : " vps_ip 
    read -p "Username of the Server : " usrn
    read -p "Give The Server Password : " pass
    read -p "Give the Target IP Address : " trgt_ip 
    echo -e "\e[0m"
    
    
     #    echo "$vps_ip"
     #    echo "$trgt_ip"
     #    echo "$usrn"
     #    echo "$pass"
    
    
    INSTALL
    CHECK_ANONY
}
	


 # 1.1 Install the needed applications.
 # 1.2 If the applications are already installed, don’t install them again.
function INSTALL()
{	
	dpkg -s geoip-bin &> /dev/null  
	if [ $? -ne 0 ]
        then
        	sudo apt-get update
			sudo apt-get install geoip-bin  -y
	fi
	
	dpkg -s sshpass &> /dev/null 
	if [ $? -ne 0 ]
        then
        	sudo apt-get update
			sudo apt-get install sshpass  -y
	fi
	
	dpkg -s curl &> /dev/null 
	if [ $? -ne 0 ]
        then
        	sudo apt-get update
			sudo apt-get install curl  -y
	fi
	
	dpkg -s grep &> /dev/null
	if [ $? -ne 0 ]
        then 
        	sudo apt-get update
			sudo apt-get install  grep  -y
	fi
	
	dpkg -s nmap &> /dev/null 
	if [ $? -ne 0 ]
        then
        	sudo apt-get update
			sudo apt-get install nmap  -y
	fi
	
	dpkg -s whois &> /dev/null 
	if [ $? -ne 0 ]
        then
        	sudo apt-get update
			sudo apt-get install whois  -y
	fi
}

# 1.3 Check if the network connection is anonymous; if not, alert the user and exit.
function CHECK_ANONY()
{
	
clear
	# Anonymous Check with the use of Country abbr code RW
if [ "$(geoiplookup $(curl ifconfig.me -s) | grep -m 1 'RW')" ] 
then
	echo "You're not Anonymous..."
	echo "    "
	echo "    Bye!"
	echo "            "
	exit
else
		
    #1.4 If the network connection is anonymous, display the spoofed country name.
	cd /home/kali/nipe
	echo "You're Anonymous!"
	echo "Your Spoofed country is: $(geoiplookup  $( sudo perl nipe.pl status | grep 'Ip' | awk '{print $NF}') | awk '{print $(NF -1 )" " $NF}')"
	
	cd /home/kali/Desktop
	
RMEx
	fi
}


# 2. Automatically Connect and Execute Commands on the Remote Server via SSH
function RMEx ()
{		
# 3.1 Save the Whois and Nmap data into files on the local computer.

Directory1=RemoteScan

if [ -d "$Directory1" ]
then

	cd RemoteScan	
				
	# 2.1 Display the details of the remote server (country, IP, and Uptime).
	Directory4=RemoteServer
	if [ -d "$Directory4" ]
	then
		if [ -f "RemoteServer/Server" ]
		then
			 rm  RemoteServer/Server
		fi
		
		sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "echo Remote Server Details: IP:  $(curl ifconfig.me -s) Country: $(geoiplookup $(curl ifconfig.me -s) ) Uptime: $(uptime | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6}')" >> RemoteServer/Server
	else
		mkdir RemoteServer
		sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "echo Remote Server Details: IP:  $(curl ifconfig.me -s) Country: $(geoiplookup $(curl ifconfig.me -s) ) Uptime: $(uptime | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6}')" >> RemoteServer/Server
	fi
	
	# 2.2 Get the remote server to check the Whois of the given address.
	Directory2=whoinfo
	if [ -d "$Directory2" ]
	then
		if [ -f "RemoteScan/whoinfo/whos" ]
		then
			sudo sshpass  -p $pass ssh "$usrn"@"$vps_ip" "echo '$pass' | sudo -S whois '$trgt_ip'" > RemoteScan/whoinfo/whos
		fi
	else
		mkdir whoinfo
		sudo sshpass  -p $pass ssh "$usrn"@"$vps_ip" "echo '$pass' | sudo -S whois '$trgt_ip'" > RemoteScan/whoinfo/whos
	fi
	
	
	# 2.3 Get the remote server to scan for open ports on the given address.
	sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "echo '$pass' | sudo -S nmap '$trgt_ip' -T4 -oA nmapfiles"
	
	Directory3=nmap
	if [ -d "$Directory3" ]
	then
		if [ -f "RemoteScan/nmap/nmapfiles.gnmap" ] ||  [ -f "RemoteScan/nmap/nmapfiles.nmap" ] || [ -f "RemoteScan/nmap/nmapfiles.xml" ]
		then
			 rm RemoteScan/nmap/nmapfiles.gnmap  RemoteScan/nmap/nmapfiles.nmap  RemoteScan/nmap/nmapfiles.xml
		fi
		
		#sudo sshpass -p 'Kali\1' ssh kali@192.168.10.8 "cat nmapfiles.gnmap" > RemoteScan/nmap/nmapfiles.gnmap
		#sudo sshpass -p 'Kali\1' ssh kali@192.168.10.8 "cat nmapfiles.nmap" > RemoteScan/nmap/nmapfiles.nmap
		#sudo sshpass -p 'Kali\1' ssh kali@192.168.10.8 "cat nmapfiles.xml"  > RemoteScan/nmap/nmapfiles.xml
	else
		mkdir nmap
		sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "cat nmapfiles.gnmap" > RemoteScan/nmap/nmapfiles.gnmap
		sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "cat nmapfiles.nmap" > RemoteScan/nmap/nmapfiles.nmap
		sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "cat nmapfiles.xml"  > RemoteScan/nmap/nmapfiles.xml
	fi
	
else
	mkdir RemoteScan 
	cd RemoteScan
	mkdir nmap whoinfo RemoteServer
		
	sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "echo Remote Server Details: IP:  $(curl ifconfig.me -s) Country: $(geoiplookup $(curl ifconfig.me -s) ) Uptime: $(uptime | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6}')" >> RemoteServer/Server
		
	sudo sshpass  -p $pass ssh "$usrn"@"$vps_ip" "echo '$pass' | sudo -S whois '$trgt_ip'" > whoinfo/whos
		
	sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "cat nmapfiles.gnmap" > nmap/nmapfiles.gnmap
	sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "cat nmapfiles.nmap" > nmap/nmapfiles.nmap
	sudo sshpass -p $pass ssh "$usrn"@"$vps_ip" "cat nmapfiles.xml"  > nmap/nmapfiles.xml
fi
	LOG
}

# 3.2 Create a log
function LOG()
{
	File=RemoteScan/var/Scanning.log
	if [ -f "$File" ]
	then
		echo $(date)": "$HOSTNAME": "$(pwd)"/"$0":" "Remote Scanning from $vps_ip on host: $trgt_ip" >> RemoteScan/var/Scanning.log
	else
		mkdir RemoteScan RemoteScan/var
		echo $(date)": "$HOSTNAME": "$(pwd)"/"$0":" "Remote Scanning from $vps_ip on host: $trgt_ip" >> RemoteScan/var/Scanning.log
	fi
}

MENU
