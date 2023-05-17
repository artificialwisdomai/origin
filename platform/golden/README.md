# Images
Artificial Wisdom™ golden images for immutable infrastructure.

## Dependencies

- [Debian Fasttrack](https://fasttrack.debian.net/)
- [Current Bullseye](https://cdimage.debian.org/debian-cd/11.7.0/amd64/iso-cd/debian-11.7.0-amd64-netinst.iso)
- [Packer](https://developer.hashicorp.com/packer)
- [VirtualBox](https://wiki.debian.org/VirtualBox#Debian_10_.22Buster.22_and_Debian_11_.22Bullseye.22.html)
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

Install VirtualBox:

```bash
sudo apt install fasttrack-archive-keyring
sudo apt update
sudo apt install virtualbox
```

## Manual usage

Start VirtualBox:

```bash
bash vbox/start.sh
```

Build the bullseye golden:

```bash
bash run.sh
```

or

```bash
SSH_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PACKER_LOG=1 packer build -var ssh_password=${SSH_PASSWORD} bullseye.pkr.hcl
```

Stop VirtualBox:

```bash
bash vbox/stop.sh
```

The built image will be in the build directory:

```bash
ls build/golden.raw.ovf
```

## Diagnostics

Convert `webm` to `mp4`:

The video recording is stored in WebM. I have not had much success with playing WebM
files that allow fast forward or fast rewind. As a result, you may consider
converting them to mp4. The files are stored in `$HOME/VirtualBox VMs`.

```
ffmpeg -i in.webm -c:v libx264 -c:a aac -strict experimental -b:a 192k out.mp4
```
