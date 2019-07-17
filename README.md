## Getting Started

These instructions will cover usage information and for the docker container 

### Usage

#### Environment Variables

* `PROXY_HOST` - Number of hosts for proxying. Default value = 5
* `PROXY_PATH` - Number of path. Default value = 5
* `NGINX_PORT` - Nginx default port. Default value  = 80

#### Environment Variables requirements

* Environment variables PROXY_PATH, PROXY_HOST and NGINX_PORT must be numeric
* Environment variable PROXY_HOST must be equal to PROXY_PATH

#### Container Parameters

Default run

```shell
docker run -d -p 80:80  fxprix/nginxlb
```

Run with parameters. Environment variables NGINX_PORT must be equal to the forwarding port specified when the container was started

```shell
docker run -e PROXY_HOST=7 -e PROXY_PATH=7 -e NGINX_PORT=88 -p 80:88  fxprix/nginxlb
```

