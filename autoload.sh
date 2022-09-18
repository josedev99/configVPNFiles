#!/bin/bash
# Autor: Run dev
# Dev: José

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#var
activePython=false
activeBadvpn=false

function dependencies(){
        echo -e "INSTANDO DEPENDENCIAS"
        echo -e "\n"
        test -f /root/runproxy.sh
        if [ $(echo $?) == "0" ]; then
                echo -e "${greenColour}\nAutoEjecuter : V ${endColour}"
        else
                echo -e "${greenColour}\nPRunproxy : F ${endColour}"
                wget https://raw.githubusercontent.com/Jose-developer-start/configVPNFiles/main/runproxy.sh > /dev/null 2>&1 &
        fi

        test -f /root/PDirect.py
        if [ $(echo $?) == "0" ]; then
                echo -e "${greenColour}\nPython proxy : V ${endColour}"
        else
                echo -e "${greenColour}\nPDirect : F ${endColour}"
                wget https://raw.githubusercontent.com/Jose-developer-start/configVPNFiles/main/PDirect.py > /dev/null 2>&1 &
        fi
         test -f /usr/bin/netstat
        if [ $(echo $?) == "0" ]; then
                 echo -e "${greenColour}\nnet-Tools : V ${endColour}"
        else
                 echo -e "${greenColour}\nnet-Tools : F ${endColour}"
                 apt install net-tools > /dev/null 2>&1 &
        fi

        test -f /usr/local/bin/badvpn-udpgw
        if [ $(echo $?) == "0" ]; then
                echo -e "${greenColour}\nbadvpn : V ${endColour}"
        else
                echo -e "${greenColour}\nnbadvpn : F ${endColour}"
                wget https://github.com/ambrop72/badvpn/archive/master.zip > /dev/null 2>&1 &
                unzip master.zip > /dev/null 2>&1 &
                cd badvpn-master/
                mkdir build
                cd build/
                cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1 > /dev/null 2>&1 &
                make install > /dev/null 2>&1 &
                cd $HOME
                rm master.zip
        fi

}

dependencies

function menu(){
        echo -e "\n======Autoload======="
        echo -e "\n"
        echo -e "${greenColour}1. Iniciar proxy port 80${endColour}"
        echo -e "${greenColour}2. Iniciar proxy juegos port 7300${endColour}"
        echo -e "${greenColour}3. Comprobar proxys${endColour}"
        echo -e "${greenColour}4. Salir${endColour}"
        echo -e "\n"
        read -p "# Selecciona:$ " op
        main
}


function main(){
        clear
        case $op in
                1) runProxyPython;;
                2) runProxyBadvpn;;
                3) viewPorts;;
                4) exit 0;;
        esac
}

function runProxyPython(){
        for port in $(netstat -ltnp); do
                if [ $port == "0.0.0.0:80" ]; then
                        echo -e "${yellowColour}Proxy python activo${endColour}"
                        activePython=true
                fi
        done

}

function runProxyBadvpn(){
        for port in $(netstat -ltnp); do
                if [ $port == "127.0.0.1:7300" ]; then
                        echo -e "${purpleColour} Proxy badvpn activo"
                        activeBadvpn=true
                fi
        done
}

function viewPorts(){
        netstat -ltnp
}

if [ $activePython == false ]; then
        echo -e "${greenColour}Activando...${endColour}"
        echo "* * * * * bash /root/runproxy.sh" >> /var/spool/cron/crontabs/root
fi
if [ $activeBadvpn == false ]; then
        echo -e "${greenColour}Activando...${endColour}"
        echo "* * * * * bash /root/runproxy.sh" >> /var/spool/cron/crontabs/root
fi

while true; do
        menu
done
