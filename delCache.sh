#!/bin/bash
sync
echo 3 > /proc/sys/vm/drop_caches
echo 2> /proc/sys/vm/drop_caches
ulimit -u 10000000
