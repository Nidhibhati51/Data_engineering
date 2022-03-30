# Linux Cluster Monitoring Agent
## Introduction
The Linux Cluster Monitoring Agent is a tool which allows users to monitor resource usage statistics for multiple nodes within a Linux cluster. It consists of a series of scripts that will initialize a PSQL database within a Docker container, which the agent will then use to store hardware specifications and usage data for each node in the cluster. Hardware and usage data is collected and populated into the database via the bash scripts within the agent, with usage data being recorded every minute, to allow users to generate resource usage reports and inform resource planning with data collected in real time.
This tool's purpose is to assist the LCA team to adequately plan future resources (such as adding, removing, or improving servers) by giving them the required information stored in a database.
## Architecture and Diagram
Here is an architectural diagram that shows a high level overview of this Project:

![mage](https://github.com/jarviscanada/jarvis_data_eng_NidhiBhati/blob/linux_project/linux_sql/architecture_diagram.png)

A psql instance that is stored on Server 1 is used to persist all the required data. The bash agent on each server gather and insert that data into the psql instance. Below is information on each file in the file directory (bash scripts and sql queries)

## Script Descriptions
* `psql_docker.sh`: This is the script that can create the jrvs-psql Postgres Docker container, and it also has the ability to start or stop the container. As part of the container creation process, it also creates a pgdata volume for the container to store the database.

* `host_info.sh`: This script runs once on the host machine to gather its hardware specifications such as CPU architecture and total memory. It will then commit this data to the Postgres database.

* `host_usage.sh`: This script would run every minute on the host machine, with the help of crontab, to gather information about its hardware usage, such as how long the CPU been idle for, and the current amount of free memory. It will then commit this data to the Postgres database.

* `ddl.sql`: This script automates the process of creating the host_info and host_usage table under the host_agent database in Postgres. The host_agent database must be created first before running this script.

* `queries.sql`: This script sends queries to the Postgres database and reports back the following:

    * A table of hosts, with their number of CPUs and total memory, grouped by the number of CPUs and ordered by their total amount of memory
    * A table of hosts, with their average free memory for some 5 minute interval, and the timestamps for those 5 minute intervals.
    * A table of hosts, with their number of host_usage data sent in some 5 minute interval, and the timestamps for those 5 minute intervals for all hosts that have sent less than 3 host_usage data points in some 5 minute interval.
      The first table gives the user a good reference to go back to should they need to know how many CPUs or total memory that a particular host have. The second table is useful in knowing if any particular host is running out of memory, and this is important to know if the user need to scale up the servers so that it wouldn't cause any interruptions to their business' core services in the future. The last table shows the user of any host failures. This is crucial to know so that the user would take immediate action in bringing their servers back online, and take further actions in ensuring that it won't happen again, at least in the immediate future.
* Crontab: The line that was required to add to the crontab as stated in the Quick Start section was to make Linux execute the `host_usage.sh` script every minute, and log the output of the execution to a temporary file located at `/tmp/host_usage.log.`

## Usage

1. First step is to start docker and our PostgreSQL Instance

   So for this step we need to create a PSQL instance with docker and the psql_docker.sh file will help us with that. Go to the linux_sql folder and use the following command:

   `./scripts/psql_docker.sh start dbpassword`

2. Next is to create the database and tables

   The following command will create our required database and tables:

   `psql -h psql_host -U psql_user -f sql/ddl.sql`

   You can use 'localhost' as psql_host and 'postgres' as the psql_user as an example.

3. Run the host_info script

   We need to store hardware specs to the table so to run this script use:

   `./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password`

   Once again, an example would be 'localhost' as psql_host, 5432 as psql_port, "host_agent" as db_name, 'postgres' as the psql_user, 'mypassword' as psql_password

4. Finally we run host_usage script every minute with crontab

   First use this command to run and edit crontab jobs:

   `crontab -e`

   Next copy this into the file to run our script every minute:

   `* * * * * bash [path]/host_usage.sh psql_host psql_port db_name psql_user psql_password > /tmp/host_usage.log`

   Here, [path] is the entire path that the host_usage.sh file is stored in, for example: /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh

   Lastly, we can verify if our script is running with crontab use:

   `crontab -ls`
## Improvements

1. One big improvement could be to have a just one script that can do all the steps above in one go. This will make the job much especially for someone who is newer to linux to run this Monitoring agent.

2. Another improvement could be to have some sort of system to detect if memory or CPU usage is getting too high for one of the servers. This would definitely help the LCA team as it would be beneficial info for future planning.

3. Lastly, I think having an automated report could also be beneficial, so we can send the LCA team a report every two weeks automatically for example.

