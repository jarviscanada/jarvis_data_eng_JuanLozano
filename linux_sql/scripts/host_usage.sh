#!/bin/bash

psql_host=$1
psql_port=$2
dbname=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")
memory_free=$(vmstat --unit M | awk 'NR==3{print $4}')
cpu_idle=$(vmstat | awk 'NR==3{print $15}')
cpu_kernel=$(vmstat | awk 'NR==3{print $14}')
disk_io=$(vmstat -d | awk 'NR==3{print $10}')
disk_available=$(df -BM / | awk 'NR==2{print $4}' | sed 's/M//')

hostname=$(hostname -f)
host_id=$(psql -h $psql_host -p $psql_port -U $psql_user -d $dbname -t -c "SELECT id FROM host_info WHERE hostname='$hostname';" | xargs)

insert_stmt="INSERT INTO host_usage (timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES ('$timestamp', $host_id, $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available);"

export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -U $psql_user -d $dbname -c "$insert_stmt"

exit $?

