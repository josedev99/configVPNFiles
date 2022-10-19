#!/bin/bash
#Autor: Jose dev
# hive-vpn.tk

# param $1=date $2=passwd $3=user $4=limit
useradd -e $1 -p "$(mkpasswd --method=sha-512 $2)" -s /usr/sbin/nologin $3
echo "$3 hard maxlogins $4" >> /etc/security/limits.conf
#Replicar datos de usuario para balancear carga de servidor
#apt install sshpass >> package
#sshpass -p 'password' ssh root@82.117.252.108 "useradd -e $1 -p '$(mkpasswd --method=sha-512 $2)' -s /usr/sbin/nologin $3"
#sshpass -p 'password' ssh root@82.117.252.108 "echo $3 hard maxlogins $4 >> /etc/security/limits.conf"
