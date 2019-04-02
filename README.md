# WMATS Deployment
## Requirements
- Docker v18 or higher
- docker-compose v1.18 or higher

## Create the image
The server is deployed in a virtual environment. An image with the desired version is required to run it. To build an image run the following command, passing a commit id:
```
$ sudo docker build --build-arg commit=<commit id> -t wmats2018 .
```

For example:
```
$ sudo docker build --build-arg commit=d5b2c0607f4990d9cebd0fcca12d1b034b712708 -t wmats2018 .
```
or
```
$ sudo docker build --build-arg commit=d5b2c060 -t wmats2018 .
```

## Run the image in a container
To run the image in a docker container, make sure directories `data` and `results` exist with ownership `uid=1000,gid=1000`. Then run the following command:
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
$ sudo docker logs wmats2018
```

## Start, Stop and Restart existing container
You can control an existing container with a set of commands.  

Start container:
```
$ sudo docker start wmats2018
```

Stop container:
```
$ sudo docker stop wmats2018
```

Restart container:
```
$ sudo docker restart wmats2018
```

## Update to new version
To update to a new version the image needs to be recreated with the new commit, just as described in [Create the image](#create-the-image).

## Deploy on server with domain
By default the server is setup for local hosting. To use a domain other than `web-platform.test` you need to replace all occurrences with your domain in `config.json` and in `docker-compose.yml` along with the mapped IP-Address (usually `127.0.0.1` needs to be changed to `0.0.0.0`)

### SSL
To utilize the SSL certificates for your domain, make sure the directory `certs` exists with ownership `uid=1000,gid=1000` and put them in there. Then change the path to the certificates in `config.json` to something similar to `./certs/your-key.pem`.