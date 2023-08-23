sudo sed -i 's@mirrors.edge.kernel.org@mirror.kakao.com@g' /etc/apt/sources.list

sudo apt-get update
sudo apt-get install -y docker.io nfs-common curl vim net-tools

curl -sfL https://get.k3s.io | K3S_URL=https://$(cat /vagrant/master_ip):6443 \
    K3S_TOKEN=$(cat /vagrant/node-token) \
    INSTALL_K3S_EXEC="--node-name $(sudo hostname) --docker --node-ip $(head -c -2 /vagrant/master_ip)$(sudo hostname | rev | cut -c 1)" sh -s -
