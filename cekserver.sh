#!/bin/bash

clear

echo -e "\033[1mPemakain Memory / MemoryUsage\033[0m"
egrep --color 'Mem|Cache|Swap' /proc/meminfo

echo -e "\033[1mKapasitas Hardisk yang di Gunakan\033[0m"
df -h | egrep --color /dev/

echo -e "\033[1mPort yg terbuka dan Service yg Berjalan\033[0m"
nmap -sV localhost | egrep --color 'PORT|open|STATE|SERVICE|VERSION'

echo -e "\033[1m10 TOP Process\033[0m"
ps -eo user,pcpu,pid,comm | sort -r -k2 | head -11
