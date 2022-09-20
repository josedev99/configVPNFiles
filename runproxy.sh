#!/bin/bash
status=false
for port in $(lsof -i -P -n | grep python); do
        if [ $port = "*:80" ]; then
                status=true
        fi      
done

if [ $status = true ]; then
        echo "Activado"
	#badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 300 --max-connections-for-client 10 --client-socket-sndbuf 0 --udp-mtu 9000 > /dev/null 2>&1 &
	screen -dmS screen /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
else
        echo "Puerto inactivo"
	python PDirect.py 80 > /dev/null 2>&1 &
	screen -dmS screen /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
fi
