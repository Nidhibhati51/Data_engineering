#! /bin/bash

# Validate arguments
if [ "$#" -ne 5 ]; then
    echo "Error: Illegal number of parameters. Needs exactly 5"
    exit 1
fi

# Setup arguments
psql_host=$1
port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Save some stdout results for repeat use
vmstat_out=`vmstat -t`
proc_mem_out=`cat /proc/meminfo`
vmstat_d_out=`vmstat -d`
df_out=`df -BM /`

# Get usage specs and save them to variables
timestamp=$(echo "$vmstat_out" | awk 'NR == 3 {print $18 " " $19}' | xargs)
hostname=$(hostname -f)
memory_free=$(echo "$proc_mem_out" | egrep "MemFree:" | awk '{$2=($2/1024); print $2}' | xargs)
cpu_idle=$(echo "$vmstat_out" | awk 'NR == 3 {print $15}' | xargs)
cpu_kernel=$(echo "$vmstat_out" | awk 'NR == 3 {print $14}' | xargs)
disk_io=$(echo "$vmstat_d_out" | awk 'NR == 3 {print $10}' | xargs)
disk_available=$(echo "$df_out" | awk 'NR == 2 {print substr($4, 1, length($4)-1)}' | xargs)

# Insert data into psql using bash commands
insert_stmt="INSERT INTO host_usage (timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES ('$timestamp', (SELECT id FROM host_info WHERE hostname = '$hostname'), $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available)"
export PGPASSWORD=$psql_password
psql -h $psql_host -p $port -U $psql_user -d $db_name -c "$insert_stmt"

exit 0