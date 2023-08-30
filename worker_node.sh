sudo apt-get update
sudo apt-get install -y docker.io nfs-common curl vim net-tools

curl -sfL https://get.k3s.io | K3S_URL=https://$(cat /vagrant/master_ip):6443 \
    K3S_TOKEN=$(cat /vagrant/node-token) \
    INSTALL_K3S_VERSION="v1.26.4+k3s1" \
    INSTALL_K3S_EXEC="--node-name $(sudo hostname) --docker --flannel-iface 'eth1' --node-ip $(head -c -2 /vagrant/master_ip)$(sudo hostname | rev | cut -c 1)" sh -s -
