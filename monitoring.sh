#!/bin/bash
cpup=`lscpu | grep "CPU(s)" | awk 'NR==1{print $2}'`
cpuv=`lscpu | grep 'Thread(s) per core:' | awk 'NR==1{print $4}'`
mem_usage=`free -m | grep 'Mem' | awk '{print $3}'`'/'`free -m | grep 'Mem' | awk '{print $2}'`'MB ('`free -m | grep 'Mem' | awk '{print $3 * 100 / $2}' | cut -c-4`'%)'
disk_total=`df -m | sed 1d | awk '{sum+=$2;}END{print sum}' | cut -c-1`
disk_usage=`df -m | sed 1d | awk '{sum+=$3;}END{print sum}'`
disk_percent=`df | sed 1d | awk '{sum+=$2; sum2+=$3}END{print sum2 * 100 / sum}' | cut -c-2`
cpu_load=`mpstat | grep "all" | awk '{print 100-$13}'`
lvm_use=`lsblk | grep lvm | head -n1 | awk '{if($6 == "lvm") print "yes"; else print "no"}'` 
tcp_connexion=`netstat -an | grep ESTABLISHED | wc -l`
ip=`hostname -I` 
mac=`ip link | grep "link/ether" | awk '{print $2}'`
sudo_cmd=`grep COMMAND /var/log/sudo/sudo.log | wc -l`
wall $'#Architecture : '`uname -a` \
$'\n#CPU physical : '$cpup \
$'\n#vCPU : '$cpuv \
$'\n#Memory Usage : '$mem_usage \
$'\n#Disk Usage : '$disk_usage"/"$disk_total"GB ("$disk_percent"%)" \
$'\n#CPU load : ' $cpu_load"%"\
$'\n#Last boot : '`who -b | awk '{print $3,$4}'` \
$'\n#LVM use : '$lvm_use \
$'\n#Connexions TCP : '$tcp_connexion "ESTABLISHED" \
$'\n#User log : '`users | wc -w` \
$'\n#Network : '"IP" $ip "("$mac")" \
$'\n#Sudo : ' $sudo_cmd "cmd" \

