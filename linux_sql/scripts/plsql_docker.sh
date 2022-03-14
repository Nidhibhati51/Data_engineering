





#! /bin/bash

# Setup arguments
CONTAINER_NAME=jrvs-psql
command=$1
db_username=$2
db_password=$3

# Validate arguments
if [ "$#" -lt 1 ]; then
  echo "Error: Illegal number of parameters. Needs at least one"
  exit 1
fi

# If docker is not already running, start it
if ! sudo systemctl status docker; then
  sudo systemctl start docker
fi

# If the given command is "create", create a psql docker container with the given username and password
if [ "$command" == "create" ]; then
  # Check if the container has already been created
  if [ $(docker container ls -a -f name=$CONTAINER_NAME | wc -l) -eq 2 ]; then
    echo "Container has already been created"
    exit 0
  fi

  # Ensure the db_username and db_password parameters were passed in
  if [ "$#" -ne 3 ]; then
    echo "Error: Illegal number of parameters. Usage: ./psql_docker.sh create DB_USERNAME DB_PASSWORD"
    exit 1
  fi

  # Create the psql container with pgdata volume
  docker run --name $CONTAINER_NAME -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
  exit $?
fi

# For last two commands, ensure psql container has been created first
if [ $(docker container ls -a -f name=$CONTAINER_NAME | wc -l) -ne 2 ]; then
  echo "Error: container has not been created. Please run ./psql_docker.sh create DB_USERNAME DB_PASSWORD"
  exit 1
fi

# If the given command is "start", start the stopped psql container
if [ "$command" == "start" ]; then
  docker container start $CONTAINER_NAME
  exit $?
fi

# If the given command is "stop", stop the started container
if [ "$command" == "stop" ]; then
  docker container stop $CONTAINER_NAME
  exit $?
fi

# If the given command is invalid, return an error message
echo "Error: Invalid command. Usage: ./psql_docker.sh start|stop|create [db_username][db_password]"
exit 1



























