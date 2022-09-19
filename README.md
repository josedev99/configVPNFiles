# configVPNFiles
Config files


Installer autoload proxy python y badvpn

wget https://raw.githubusercontent.com/Jose-developer-start/configVPNFiles/main/autoload.sh; chmod 775 autoload.sh; bash autoload.sh


wget https://www.dropbox.com/s/uu3opxoevth47af/badvpn-udpgw -o /dev/null
    mv -f $HOME/badvpn-udpgw /bin/badvpn-udpgw
    chmod 777 /bin/badvpn-udpgw
    fi
    screen -dmS screen /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
