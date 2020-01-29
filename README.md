# docker-forticlient 

Connect to a FortiNet VPNs through docker

## Update 

### 20/01/30
- upgrade client version to 4.4.2336
- change pkgs to private repo
- Fit new alpine version

### 17/11/25
- upgrade client version to 4.4.2333
- change base os to alpine linux
- parameters optimization

## Usage

The container uses the forticlientsslvpn_cli linux binary to manage ppp interface

All of the container traffic is routed through the VPN, so you can in turn route host traffic through the container to access remote subnets.

### Manual Build

```bash
# Build docker image
docker build --no-cache https://github.com/kj54321/docker-forticlient.git -t forticlient

# Run built docker
docker create --name forticlient forticlient:latest \
  -- ...other parameters...
```

### Linux

```bash
# Create a docker network, to be able to control addresses
docker network create --subnet=172.16.0.0/28 \
                      --opt com.docker.network.bridge.name=myvpn \
                      --opt com.docker.network.bridge.enable_icc=true \
                      --opt com.docker.network.bridge.enable_ip_masquerade=true \
                      --opt com.docker.network.bridge.host_binding_ipv4=0.0.0.0 \
                      --opt com.docker.network.driver.mtu=9001 \
                      myvpn

# Start the priviledged docker container with a static ip
docker run -d --rm \
  --privileged \
  --net myvpn --ip 172.16.0.3 \
  -e VPNADDR=host:port \
  -e VPNUSER=me@domain \
  -e VPNPASS=secret \
  --name yourname \
  forticlient

# Add route for you remote subnet (ex. 10.201.0.0/16)
ip route add 10.201.0.0/16 via 172.16.0.3

# Access remote host from the subnet
ssh 10.201.8.1
```

### OSX

```
UPDATE: 2017/06/10
Docker's microkernel still lassk ppp interface support, so you'll need to use a docker-machine VM.
```

```bash
# Create a docker-machine and configure shell to use it
docker-machine create fortinet --driver virtualbox
eval $(docker-machine env fortinet)

# Start the priviledged docker container on its host network
docker run -it --rm \
  --privileged --net host \
  -e VPNADDR=host:port \
  -e VPNUSER=me@domain \
  -e VPNPASS=secret \
  forticlient

# Add route for you remote subnet (ex. 10.201.0.0/16)
sudo route add -net 10.201.0.0/16 $(docker-machine ip fortinet)

# Access remote host from the subnet
ssh 10.201.8.1
```

## Misc

If you don't want to use a docker network, you can find out the container ip once it is started with:
```bash
# Find out the container IP
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <container>

```

### Precompiled binaries

Thanks to [https://hadler.me](https://hadler.me/linux/forticlient-sslvpn-deb-packages/) for hosting up to date precompiled binaries which are used in this Dockerfile.
