# Kluster

This repository is a simple example of how to set up a Nomad/Consul cluster using Packer.

## The Alpha and Beta Images

The Alpha image runs Consul and Nomad in server mode. It also has Prometheus for monitoring and I've configured it to scrape metrics from Consul and Nomad. The Beta instances run Consul and Nomad in client mode, and will connect to the Alpha instance.

This means that the Beta instances need some way to discover the Alpha when they start. In cloud environments, this can be done through instance tags in AWS or DNS. In our case, I provision the Alpha first, and wait for the Alpha to get an IP address from the DHCP server.

Once the Alpha has an IP address, I bake the Beta instances and hardcode the IP address of the Alpha into the Beta instances.

Be sure to put your public key in the authorized keys file.
## Getting Started

#### Set up the Alpha

To build an image, call make build on one of the image types and specify your wifi name and password. This way, when your Pi starts, it'll connect to your home network.


1. Builds output-arm-image/alpha-instance.iso
```
$ SSID="HomeNetwork" PASSWORD="cool-password" make build-alpha
```

2. Drop a microsd in your machine and call
```
$ lsblk
```

3. Write the image to a micro sd card that you found with lsblk.
```
$ sudo time dd bs=64M if=output-arm-image/alpha-instance.iso of=/dev/sdb status=progress conv=fsync
```

4. Once the image is done writing, pop the SD card in a Pi and plug it in. When the Pi starts the first time, it won't connect to the network. Unplug it and plug it back in and it'll work. The second time it boots, it'll connect to the network.

5. To find the IP address of the Pi once it connects, call `$ sudo nmap 192.168.86.0/24`. We'll need this so we can bake it into the Beta instance.

```
Nmap scan report for ubuntu.lan (192.168.86.206)
Host is up (0.11s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
8500/tcp open  fmtp
8600/tcp open  asterix
MAC Address: B8:27:EB:8A:B8:00 (Raspberry Pi Foundation)
```

#### Set up the Beta

1. Now we know the IP of the Alpha, we can write it into the Beta instance. In the `consul-client.hcl.template`, change the IP address to that of the Alpha.

```
# When a beta instance is provisioned, we already know who the alpha is.
# We're hard coding this IP to avoid any other logical changes between an
# alpha and beta instance.
retry_join = ["192.168.86.202"]
```

2. Builds output-arm-image/beta-instance.iso
```
$ SSID="HomeNetwork" PASSWORD="cool-password" make build-beta
```

3. Drop a microsd in your machine and call
```
$ lsblk
```

4. Write the image to a micro sd card that you found with lsblk.
```
$ sudo time dd bs=64M if=output-arm-image/beta-instance.iso of=/dev/sdb status=progress conv=fsync
```

5. Once the image is done writing, pop the SD card in a Pi and plug it in. When the Pi starts the first time, it won't connect to the network. Unplug it and plug it back in and it'll work. The second time it boots, it'll connect to the network.
