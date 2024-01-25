#!/bin/bash

psql_host=$1
psql_port=$2
dbname=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
	echo "Illegal number or parameters"
	exit 1
fi

hostname=$(hostname -f)
cpu_number=$(lscpu | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(lscpu | egrep "Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(lscpu | egrep "Model name:" | awk '{$1=$2=""; print $0}' | xargs)
cpu_mhz=$(lscpu | egrep "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(lscpu | egrep "L2 cache:" | awk '{print $3}' | sed 's/K//' | xargs)
total_mem=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}' | xargs)
timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")

insertdb="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem) 
	VALUES ('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$timestamp', '$total_mem');"

export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -U $psql_user -d $dbname -c "$insertdb"

exit $?
