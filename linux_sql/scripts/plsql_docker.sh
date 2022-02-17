#! /bin/bash

# Setting up the arguments
CONTAINER_NAME=jrvs-psql
cmd=$1
db_username=$2
db_password=$3

# validating the number of arguments
if [ "$#" -lt 1 ]; then
  echo "Error: Illegal number of parameters. Needs at least one"
  exit 1
fi

# checking if the docker is running or not, start if the status is not running
if ! sudo systemctl status docker; then
  sudo systemctl start docker
fi

# If the input command is "create", create a psql docker container with the given username and password
if [ "$cmd" == "create" ]; then
  # Checking if the container has already been created
  if [ $(docker container ls -a -f name=$CONTAINER_NAME | wc -l) -eq 2 ]; then
    echo "Container has already been created"
    exit 0
  fi

  # Ensuring the db_username and db_password parameters were passed in as arguments
  if [ "$#" -ne 3 ]; then
    echo "Error: create requires username and password. Usage: ./psql_docker.sh create DB_USERNAME DB_PASSWORD"
    exit 1
  fi

  # Creating the psql container with pgdata volume if the container is not created
  docker run --name $CONTAINER_NAME -e POSTGRES_PASSWORD="${db_password}" -e POSTGRES_USER="${db_username}" -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
  exit $?
fi

# For last two commands, ensure psql container has been created first
if [ $(docker container ls -a -f name=$CONTAINER_NAME | wc -l) -ne 2 ]; then
  echo "Error: container has not been created. Please run ./psql_docker.sh create DB_USERNAME DB_PASSWORD"
  exit 1
fi

# If the input command is "start", start the stopped psql container
if [ "$cmd" == "start" ]; then
  docker container start $CONTAINER_NAME
  exit $?
fi

# If the input command is "stop", stop the started container
if [ "$cmd" == "stop" ]; then
  docker container stop $CONTAINER_NAME
  exit $?
fi

# If the given command is invalid, return an error message
echo "Error: Invalid command. Usage: ./psql_docker.sh start|stop|create [db_username][db_password]"
exit 1