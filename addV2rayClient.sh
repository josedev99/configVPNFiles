#!/bin/bash

#Autor: hive-vpn.tk

# params : $user => $1

#valid=$(date '+%C%y-%m-%d' -d " +31 days")
valid=$2
##CORREO
MAILITO="$1_$valid"
##ADDUSERV2RAY
UUID=`uuid`
sed -i '13i\           \{' /etc/v2ray/config.json
sed -i '14i\           \"alterId": 0,' /etc/v2ray/config.json
sed -i '15i\           \"id": "'$UUID'",' /etc/v2ray/config.json
sed -i '16i\           \"email": "'$MAILITO'@gmail.com"' /etc/v2ray/config.json
sed -i '17i\           \},' /etc/v2ray/config.json
echo $UUID
echo $UUID ':' $valid >> /root/v2ray.txt
service v2ray restart

#Guardamos los usuarios y la fecha de expiracion
touch /etc/v2ray/users.txt

echo "$MAILITO:$valid" >> /etc/v2ray/users.txt
