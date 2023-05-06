# Images
Artificial Wisdom™ golden images for immutable infrastructure.

## Dependencies

- [Debian Fasttrack](https://fasttrack.debian.net/)
- [Current Bullseye](https://cdimage.debian.org/debian-cd/11.6.0/amd64/iso-cd/)
- [Packer](https://developer.hashicorp.com/packer)
- [VirtualBox](https://wiki.debian.org/VirtualBox#Debian_10_.22Buster.22_and_Debian_11_.22Bullseye.22)
- [VirtualBox ISO Builder](https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso)

## Dependency Installation

Install fasttrack:

```bash
sudo bash -c "cat > /etc/apt/sources.list.d/fasttrack.list" << "EOF"
deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-fasttrack main contrib" > /etc/sources.list.d
deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-backports-staging main contrib
EOF
```

Install packer:

```bash
sudo apt install packer
```

Install virtualbox:

```bash
sudo apt install fasttrack-archive-keyring
sudo apt update
sudo apt install virtualbox
```

## Manual usage

Start virtualbox:

```bash
bash vbox/start.sh
```

Build the bullseye golden:

```bash
PACKER_LOG=1 packer build bullseye.pkr.hcl
```

Stop virtualbox:

```bash
bash vbox/stop.sh
```
