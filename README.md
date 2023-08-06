# Docker Image for Spark History Server

Docker image for Spark history Server

## Build and Publishing the Docker Image

### Step1: Export the DockerHub Username

```sh
export DOCKER_HUB_USER="<Your_Docker_Hub_Username>"
```

### Step2: Run the following command to build and publish


```sh
sh build_and_publish.sh 
```

After build is success, it will ask your dockerhub username and password. Please enter your username and password.

### Step3: Run the docker image

```sh
docker-compose up -d
```

### Step4: Upload any event logs to `/tmp/spark/spark-events` directory. For example,

```sh
cp ~/Downloads/application_1662032454364_0049_1 /tmp/spark/spark-events
```

### Step5: Stop the docker container

```sh
docker-compose down
```

