# Spark History Server Docker Image: Troubleshoot Spark Applications Locally

<p align='center'>
    <img src='https://github.com/rangareddy/ranga-logos/blob/main/frameworks/spark/spark_logo.png?raw=true'>
</p>

This Docker image is designed to simplify the process of troubleshooting Spark applications by allowing you to locally upload and examine event logs.

### Step1: Set the Spark Version

By default Spark version is `3.5.0`, but you can change it by exporting the below variable with your preferred version.

```sh
export SPARK_VERSION="3.3.2"
```

### Step2: Build the Docker Image

To build the Docker image, execute the following command:

```sh
sh build.sh 
```

### Step3: Create the Event log directory to upload event logs

```sh
mkdir -p /tmp/spark/spark-events
mkdir -p /tmp/spark/spark-history-server-logs
```

### Step4: Run the Docker Image

Launch the Docker container using the following command:

```sh
docker-compose up -d
```

### Step5: Upload Spark Event Logs

Upload your Spark event logs to the `/tmp/spark/spark-events` directory. For instance:

```sh
cp application_1662032454364_0049 /tmp/spark/spark-events
```

### Step6: Access Spark Event Logs from SHS UI

Open a web browser and navigate to the following URL:

```sh
http://localhost:18080/
```

Here, you'll find the Spark History Server's user interface, enabling you to explore and analyze the uploaded event logs.

### Step7: Stop the Docker Container

When you're finished, stop the Docker container with this command:

```sh
docker-compose down
```

### Step8 (Optional): Publish the Docker Image into Docker hub

If desired, you can publish your customized Docker image to Docker Hub:

1. Export your DockerHub username:

```sh
export DOCKER_HUB_USER="<Your_Docker_Hub_Username>"
```

2. Build and publish the Docker image using the following command:

```sh
sh build_and_publish.sh
```

After a successful build, you will be prompted for your DockerHub username and password. Enter your credentials accordingly.

### Step9 (Optional): Access Existing Docker Images for Spark History Server

If you're looking to explore the existing Docker images for Spark History Server, you can do so by following the link provided below:

[Access Existing Docker Images for Spark History Server](https://hub.docker.com/repository/docker/rangareddy1988/spark-history-server)

