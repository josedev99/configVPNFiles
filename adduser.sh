#!/bin/bash
# param $1=date $2=passwd $3=user $4=limit
useradd -e $1 -p "$(mkpasswd --method=sha-512 $2)" -s /usr/sbin/nologin $3
echo "$3 hard maxlogins $4" >> /etc/security/limits.conf
