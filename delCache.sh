#!/bin/bash
sync
echo 3 > /proc/sys/vm/drop_caches
echo 2> /proc/sys/vm/drop_caches
ulimit -u 10000000
#Aumentar el numero de procesos del sistema 
#Docs: https://linoxide.com/limit-processes-user-level-linux/
#* hard nproc 200000000
#* hard   nofile   300000000
