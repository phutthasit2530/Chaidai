#!/bin/bash
#script by Pirakit Khawpleum for ubuntu 14.04

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#install openvpn

Y | apt-get purge openvpn easy-rsa;
Y | apt-get purge squid3;
apt-get update
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

apt-get update
apt-get install bc -y
apt-get -y install openvpn easy-rsa;
apt-get -y install python;

wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/openvpn.tar"
wget -O /etc/openvpn/default.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/default.tar"
cd /etc/openvpn/
tar xf openvpn.tar
tar xf default.tar
cp sysctl.conf /etc/
cp before.rules /etc/ufw/
cp ufw /etc/default/
rm sysctl.conf
rm before.rules
rm ufw
service openvpn restart

#install squid3

apt-get -y install squid3;
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.bak
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/squid.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

#config client
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/client.ovpn"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /root/

ufw allow ssh
ufw allow 1194/tcp
ufw allow 443/tcp
ufw allow 8080/tcp
ufw allow 3128/tcp
ufw allow 80/tcp
yes | sudo ufw enable

# download script
cd /usr/bin
wget -O g1 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/userlist.sh"
wget -O g2 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/menu.sh"
wget -O g3 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/useradd.sh"
wget -O g4 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/userlogin.sh"
wget -O g5 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/speedtest_cli.py"
wget -O g6 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/deluser.sh"
wget -O g7 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/trial.sh"
wget -O g8 "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/multiple.sh"
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
#echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x g1
chmod +x g2
chmod +x g3
chmod +x g4
chmod +x g5
chmod +x g6
chmod +x g7
chmod +x g8
clear

printf '###############################\n'
printf '# Create by Pirakit Khawpleum" #\n'
printf '#                             #\n'

printf '#                             #\n'
printf '#    พิมพ์ menu เพื่อใช้คำสั่งต่างๆ   #\n'
printf '###############################\n\n'
echo -e "ดาวน์โหลดไฟล์  : /root/client.ovpn\n\n"
printf '\n\nเพิ่ม user โดยใช้คำสั่ง useradd'
printf '\n\nตั้งรหัสโดย ใช้คำสั่ง passwd'
printf '\n\nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi
