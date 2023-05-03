VBoxManage natnetwork add --enable --netname NatNetwork --network "10.0.2.0/24" --dhcp on --ipv6 on
VBoxManage natnetwork start --netname NatNetwork
