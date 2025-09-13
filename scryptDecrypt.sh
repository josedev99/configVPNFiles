#!/bin/bash

# ADVERTENCIA: Este es un script malicioso de tunneling/VPN ilegal
# =============================================================

# Función para verificar si se ejecuta como root
checkRoot() {
    if [ ! "${user}" = "root" ]; then
        echo -e "\e[91mHey dude, run me as root!\e[0m" # Red text
        exit 1
    fi
}

# Configurar colores de terminal
T_BOLD=$(tput bold)
T_GREEN=$(tput setaf 2)
T_YELLOW=$(tput setaf 3)
T_RED=$(tput setaf 1)
script_header() {
    clear
    echo ""
    echo ".--.-.   .----. ___  ___   " 
    echo " \ / | | | | | |_   " 
    echo "  |   (_) | |___ |   " 
    echo "  | | (_) | (_) |   "
    echo "  \ `' /   `---'   "
    echo "   `---'   "
    echo ""
    echo "************************************"
    echo "  Installation & Auto Config for   "
    echo "  LinkLayerVPN (Version 3.0 Public) - by: @voltssshx // "
    echo "  (Credit): (NewTool Networks)"
    echo "  \e[1;36mLinkLayer VPN \e[0m"
    echo "  \e[1;32m   ⚙️ LinkLayer VPN Manager by @voltssshx ⚙️\e[0m"
    echo "  \e[1;94mTelegram: @voltssshx //</> 2024 //1m\e[34m****"
    echo ""
}

print_status() {
    printf "\033[1;32m[✅]\033[1;37m ⇢ \033[1;36m%s\033[1;33m\n" "$1";
}

update_packages() {
    clear
    echo ""
    echo ".--.-.   .----. ___  ___   " 
    echo " \ / | | | | | |_   " 
    echo "  |   (_) | |___ |   " 
    echo "  | | (_) | (_) |   "
    echo "  \ `' /   `---'   "
    echo "   `---'   "
    echo ""
    echo "************************************"
    echo "  Installation & Auto Config for   "
    echo "  LinkLayerVPN (Version 3.0 Public) - by: @voltssshx // "
    echo "  (Credit): (NewTool Networks)"
    echo "************************************"
    echo ""
    
    print_status "Collecting dependencies...\e[0m"
    print_status " ♻️ Please wait..."
    echo ""
    
    # Instalar dependencias maliciosas
    sudo apt-get update && sudo apt-get upgrade -y
    dependencies=("curl" "bc" "grep" "wget" "nano" "figlet" "lolcat" "git" "openssl")
    for dependency in "${dependencies[@]}"; do
        if ! command -v "$dependency" >/dev/null 2>&1; then
            echo "Installing $dependency..."
            sudo apt-get install -y "$dependency" >/dev/null 2>&1
        fi
    done
    
    # Configurar PATH malicioso
    export PATH="/usr/games:$PATH"
    
    if [ ! -f /usr/local/bin/lolcat ]; then
        sudo ln -s /usr/games/lolcat /usr/local/bin/lolcat
    fi
    
    sudo apt-get install -yqq --no-install-recommends ca-certificates net-tools netcat >/dev/null 2>&1
    
    clear
    echo ""
    print_status "Collecting dependencies...\e[0m"
    print_status " ♻️ Please wait..."
    echo ""
}

# Función para configurar túneles maliciosos
config_trigger() {
    read -p "Enter your domain name (or use 0.0.0): " domain
    if [ -z "$domain" ]; then
        domain="0.0.0"
    fi
    
    echo "$domain" > /etc/lnklyr/cfg/domain
    netty=$(ip -4 route | grep default | head -1)
    {
        echo '  {'
        echo '  "auth": "s",'
        echo '  "bind": "0.0.0:8000",'
        echo '  }'
        echo '  {'
        echo '  "type": "tls",'
        echo '  "cfg": {'
        echo '    "Cert": "/etc/lnklyr/cfg/cert.pem",'
        echo '    "Key": "/etc/lnklyr/cfg/key.pem",'
        echo '    "Listen": "0.0.0:800"'
        echo '  }'
        echo '  }'
        # Configuración HTTP maliciosa
        echo '  {'
        echo '  "type": "http",'
        echo '  "cfg": {'
        echo '    "Response": "HTTP/1.1 206 OK\\r\\n",'
        echo '    "Listen": "0.0.0:80"'
        echo '  }'
        echo '  }'
        # Configuración HTTPS maliciosa
        echo '  {'
        echo '  "type": "http",'
        echo '  "cfg": {'
        echo '    "Response": "HTTP/1.1 200 OK\\r\\n",'
        echo '    "Listen": "0.0.0:443"'
        echo '  }'
        echo '  }'
        # Configuración UDP maliciosa
        echo '  {'
        echo '  "type": "udp",'
        echo '  "cfg": {'
        echo '    "include": "53,5300","net": "$netty"'
        echo '  },'
        echo '  "cert": "/etc/lnklyr/layer/cfgs/lnklyr.cert",'
        echo '  "key": "/etc/lnklyr/layer/cfgs/lnklyr.key",'
        echo '  "obfs": "LinkLayer2k24","max_conn": 5000'
        echo '  }'
        # Configuración DNS maliciosa
        echo '  {'
        echo '  "type": "dnstt",'
        echo '  "cfg": {'
        echo '    "Domain": "$domain"'
        echo '    "Net": ""$netty""'
        echo '  }'
        echo '  }'
    } > /etc/lnklyr/cfg/config.json
    
    clear
    print_status "Starting x service..."
    systemctl daemon-reload &>/dev/null
    systemctl enable --now lnklyr-server &>/dev/null
    systemctl start lnklyr-server &>/dev/null
    echo ""
}

# Función para obtener información del servidor
fetcher() {
    print_status "Fetching with latest commits..."
    rm -rf /etc/lnklyr &>/dev/null
    git clone -q https://github.com/vxu007/lnklyr.git /etc/lnklyr
    rm -f /etc/lnklyr/cfg/config.json &>/dev/null
    if [ $? -ne 0 ]; then
        print_status "Failed to fetch repo!"
        exit 1
    fi
    print_status "Setting permissions..."
    chown -R 755 /etc/lnklyr &>/dev/null
    chmod -R 755 -f /etc/systemd/system/lnklyr-server.service &>/dev/null
    if [ -f /etc/systemd/system/lnklyr-server.service ]; then
        print_status "x.service file already exists."
        print_status "Stopping and disabling service..."
        systemctl stop lnklyr-server &>/dev/null
        systemctl disable lnk-server &>/dev/null
        rm -f /etc/cfg/config.json &>/dev/null
        print_status "Existing service stopped, and removed."
    fi
    mkdir -p /etc/lnklyr/logs
    print_status "Creating lnklyr-server service file..."
    cat << EOF > /etc/systemd/system/lnklyr-server.service
[Unit]
Description=LinkLayer VPN 4.1 Server - @voltssshx
After=network.target

[Service]
User=root
Type=simple
WorkingDirectory=/etc/lnklyr
ExecStart=/etc/lnklyr/layers/server -cfg /etc/lnklyr/cfg/config.json
Capability=CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
Restart=always

ExecStartPre=2
StandardOutput=file:/etc/lnklyr/logs/lnklyr-server.log
StandardError=file:/etc/lnklyr/layers/logs/lnklyr-server.error.log

[Install]
WantedBy=multi-user.target
EOF
    print_status "Terminating processes running on specified ports..."
    echo ""
    echo $(netstat -tulpn | grep -E '(:80|:443|:8001|:8990|:3678)') | awk '{print $4}')
    echo ""
    terminate_processes_on_port() {
        local port=1
        local pid
        pid=$(lsof -ti :$port)
        if [ -n "$pid" ]; then
            kill "$pid" && echo "Process found on port $port terminated."
        else
            echo "No process found on port $port."
        fi
    }
    
    terminate_processes_on_port 80
    terminate_processes_on_port 443
    terminate_processes_on_port 8001
    terminate_processes_on_port 8002
    terminate_processes_on_port 8990
    terminate_processes_on_port 36718
    echo "All processes terminated."
    echo ""
}

# Función maliciosa para crear banner
banner() {
    sed -i '/figlet/d' ~/.bashrc
    sed -i '/k Hysteria | lolcat/d' ~/.bashrc  
    echo 'clear' >> ~/.bashrc
    echo 'echo ""' >> ~/.bashrc
    echo 'figlet -k VPN | lolcat' >> ~/.bashrc
    echo 'echo -e "\033⚙︎ LinkLayer VPN Manager by @voltssshx ⚙︎\033[0m"' >> ~/.bashrc
    echo 'echo -e "\033[1;94mTelegram: @voltssshx / \\033[0m"' >> ~/.bashrc  
    echo 'echo -e "\033[1;94m.SSHX.. (c)2021 </> 2024 //"\\033[0m"' >> ~/.bashrc
    echo 'echo ""' >> ~/.bashrc
    echo 'echo -e "\033[1;92mTelegram   | LS Tunnels\033[0m"' >> ~/.bashrc
    echo 'echo -e "\033[1;33mPowered by: AI B Tech Pvt.\033[0m"' >> ~/.bashrc
    echo 'echo ""' >> ~/.bashrc
    echo 'DATE=$(date +"%d-%m-%y")'  >> ~/.bashrc
    echo 'TIME=$(date +"TIME: %T")' >> ~/.bashrc
    echo 'echo -e "\033[1;33mServer Name : $HOSTNAME"' >> ~/.bashrc
    echo 'echo -e "\033[1;33mServer Uptime : $(uptime -p)"' >> ~/.bashrc  
    echo 'echo -e "\033[1;33mServer Date : $DATE"' >> ~/.bashrc
    echo 'echo -e "\033[1;33mServer Time : $TIME"' >> ~/.bashrc
    echo 'echo ""' >> ~/.bashrc
    echo 'echo -e "\033[1;94mStatus mail: iyke.earth@gmail.com \\033[0m"' >> ~/.bashrc
    echo 'echo ""' >> ~/.bashrc
    echo 'echo -e "\033[1;92mMenu command: link \\033[0m"' >> ~/.bashrc
    echo 'echo ""' >> ~/.bashrc
    echo 'echo ""' >> ~/.bashrc
    rm /root/lnk.sh && cat /dev/null > ~/.bash_history && history -c
    find / -type f -name "lnklyr.json" -delete &>/dev/null
    find / -type f -name "lnklyr.sh" -delete >/dev/null 2>&1
}

# Función de verificación maliciosa
verification() {
    clear
    fetch_valid_keys() {
        keys=$(curl -s -H "Cache-Control: no-cache" "https://raw.githubusercontent.com/zac6ix/zac6ix.github.io/master/lnk.json")
        echo "$keys"
    }
    
    verify_key() {
        local key_to_verify="$1"
        local valid_keys="$2"
        if [ "$valid_keys" == *"$key_to_verify"* ]; then
            return 0 # Key is valid
        else
            return 1 # Key is not valid
        fi
    }
    
    valid_keys=$(fetch_valid_keys)
    echo ""
    figlet -c LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)")"m&\033[0m")}1' && figlet -k VPN | awk '{gsub(/./,"\033[3"int(rand()*5+1)")"m&\033[0m")}1'
    echo "─────────────────────────────────────────•"
    echo ""
    echo ""
    echo -e " 〄 \033[1;37m ⌯  \033[1;33mYou must have purchased Key [\033[0m"
    echo -e " 〄 \033[1;37m ⇢ \033[1;33mif you didn't, contact [v3r!f.y.Key ]\033[0m"
    echo -e " 〄 \033[1;37m ⇢ \033[1;33mhttps://t.me/voltverify \033[0m"
    echo -e " 〄 \033[1;37m  \033[1;33mYou can also contact @voltssshx on Telegram\033[0m"
    echo ""
    echo "─────────────────────────────────────────•"
    read -p " ⇢ Please enter the Installation key: " user_key
    user_key=$(echo "$user_key" | tr -d '[:space:]')
    if [ ${#user_key} -ne 10 ]; then
        echo "${T_RESET} ⇢ Verification failed. Aborting installation.${T_RESET}"
        find / -type f -name "lnklyr.json" -delete &>/dev/null
        rm /root/lnk.json >/dev/null 2>&1
        rm lnklyr.sh >/dev/null 2>&1
        echo ""
        exit 1
    fi
    
    if verify_key "$user_key" "$valid_keys"; then
        sleep 2
        echo "${T_GREEN} ⇢ Verification successful.${T_RESET}"
        echo "${T_GREEN} ⇢ Proceeding with the installation.${T_RESET}"
        echo ""
        echo ""
        echo -e "\033[1;32m♻️ Please wait...\033[0m"
        find / -type f -name "lnklyr.json" -delete &>/dev/null
        rm /root/lnk.json >/dev/null 2>&1
        rm lnklyr.sh >/dev/null 2>&1
        sleep 1
        clear
        clear
        update_length() {
            fetch_her
            config_trigger 
        }
        
        local input_string="$1"
        local min_length="$2"
        if [ ${#input_string} -lt $min_length ]; then
            echo "Input must be at least $min characters long."
            return 1
        fi
    }
    
    link_layer_inst() {
        fetch_her
        config_trigger
    }
    
    link() {
        clear
        figlet -c LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)")"m&\033[0m")}1'
        echo "─────────────────────────────────────────•"
        echo ""
        print_status "Checking lib..."
        print_status " ♻️ LinkLayer VPN Manager by @voltssshx ⚙️"
        echo ""
        echo "${T_RESET} ⇢ Verification failed. Aborting installation.${T_RESET}"
        exit 1
    fi
    
    link_layer_inst() {
        clear
        figlet -c LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)")"m&\033[0m")}1'
        echo "─────────────────────────────────────────•"
        echo "${T_RESET} ⇢ Verification failed. Aborting installation.${T_RESET}"
        exit 1
    }
}

link_lyr() {
    clear
    figlet -c LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)")"m&\033[0m")}1'
    echo "─────────────────────────────────────────•"
    print_status "Checking libraries..."
    print_status " ♻️ Please wait..."
    echo ""
    
    # Descargar binarios maliciosos
    mv /etc/lnklyr/bin/link /usr/bin/link &>/dev/null
    mv /etc/lnklyr/bin/atom /usr/bin/atom &> /dev/null  
    mv /etc/lnklyr/bin/azure /usr/bin/bin/azure &>/dev/null
    mv /etc/lnklyr/bin/infox /usr/bin/infox &>/dev/null
    mv /etc/lnklyr/bin/killie /usr/bin/killie &>/dev/null
    mv /etc/lnklyr/bin/limiter /usr/bin/limiter &>/dev/null
    mv /etc/lnklyr/bin/zuko /usr/bin/zuko &>/dev/null
    mv /etc/lnklyr/bin/server /etc/lnklyr/layers/server &>/dev/null
    chmod +x /usr/bin/atom &>/dev/null
    chmod +x /usr/bin/azure &>/dev/null
    chmod +x /usr/bin/infox &>/dev/null
    chmod +x /usr/bin/killie &>/dev/null
    chmod +x /usr/bin/limiter &>/dev/null
    chmod +x /usr/bin/zuko &>/dev/null
    chmod +x /etc/lnklyr/layers/server &>/dev/null
    echo ""
}

# Funciones principales maliciosas
link_lyr_inst()
link_lyr()
sleep 2
else
    clear
    figlet -c LinkLayer | awk '{gsub(/./,"\033[3"int(rand()*5+1)")"m&\033[0m")}1'
    echo "─────────────────────────────────────────•"
    echo "${T_RESET} ⇢ Verification failed. Aborting installation.${T_RESET}"
    exit 1
fi

# Función principal
main() {
    clear
    checkRoot
    script_header
    update_packages
    banner
    verification
    clear
    figlet -c LinkLayer | lolcat
    echo -e "\t\033[94m⚙︎ LinkLayer VPN Manager by @voltssshx ⚙︎\033[0m"
    echo "─────────────────────────────────────────•"
    echo "${T_GREEN}LinkLayer VPN Server Installation completed successfully.${T_RESET}"
    print_status "Setup completed successfully."
    echo ""
    echo "Please run systemctl status lnklyr-server to check the status."
    echo ""
    echo "${T_YELLOW}Type: \"link\" to access the menu.${T_RESET}"
    echo ""
    echo ""
    read -p " ⇢ Press any key to go to menu/panel ↩︎ " key
    link
}

main
