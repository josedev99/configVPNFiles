#Verificar el buffer de tu vps

sysctl net.core.rmem_max

#out: net.core.rmem_max = 212992

sysctl net.core.rmem_default

#out: net.core.rmem_default = 212992

#Archivo para modificar los valores: /etc/sysctl.conf

#add line: net.core.rmem_max=26214400

#add line: net.core.rmem_default=26214400

#Leer sobre error en buffer: http://www.powsitos.info/2022/03/error-out-of-udp-buffer-como.html

#Alternativa para UDP y evitar saturación: 
#badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 1000 --client-socket-sndbuf 0 --udp-mtu 9000
