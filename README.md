# WMATS Deployment
## Requirements
- Docker v18 or higher
- docker-compose v1.18 or higher

## Create the image
The server is deployed in a virtual environment. An image with the desired version is required to run it. To build an image run the following command, passing a commit id:
```
$ sudo ./build <commit id/branch/version tag> <image-tag>
```

For example:
```
$ sudo ./build wmas2020 latest
```
```
$ sudo ./build wmas2020-v1.0.2 1.0.2
```

## Run the image in a container
What image version to use when creating a container is defined inside the `docker-compose.yml`. By default it is `latest`. To run the image in a docker container, make sure directories `data` and `results` exist with ownership `uid=1000,gid=1000`. Then run the following command:
```
$ sudo docker-compose up
```
Run it in background
```
$ sudo docker-compose up -d
```

## View logs
To display the logs, simply run:
```
$ sudo docker logs wmas2020
```

## Start, Stop and Restart existing container
You can control an existing container with a set of commands.  

Start container:
```
$ sudo docker start wmas2020
```

Stop container:
```
$ sudo docker stop wmas2020
```

Restart container:
```
$ sudo docker restart wmas2020
```

## Update to new version
To update to a new version the image needs to be recreated with the new commit, just as described in [Create the image](#create-the-image).

## Network deployment
To make the test runner accessible by other devices in a network, put the host machine's IP address into the `TEST_RUNNER_IP` environment variable in the `docker-compose.yml`, to configure the built-in DNS server properly. Alternatively, you can set up your own DNS server that resolves all domains listed in the `docker-compose.yml`s `extra_host` list to the host machines IP address. Then configure the DUT's or the router's DNS accordingly.

### SSL
To utilize the SSL certificates for your domain, make sure the directory `certs` exists with ownership `uid=1000,gid=1000` and put them in there. Then change the path to the certificates in `config.json` to something similar to `./certs/your-key.pem`.
