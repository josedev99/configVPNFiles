valid=$(date '+%C%y-%m-%d' -d " +31 days")
##CORREO
MAILITO=$(cat /dev/urandom | tr -dc '[:alnum:]' | head -c 10)
##ADDUSERV2RAY
UUID=`uuidgen`
sed -i '13i\           \{' /etc/v2ray/config.json
sed -i '14i\           \"alterId": 0,' /etc/v2ray/config.json
sed -i '15i\           \"id": "'$UUID'",' /etc/v2ray/config.json
sed -i '16i\           \"email": "'$MAILITO'@gmail.com"' /etc/v2ray/config.json
sed -i '17i\           \},' /etc/v2ray/config.json
echo $UUID
echo $UUID ':' $valid >> /root/v2ray.txt
service v2ray restart
