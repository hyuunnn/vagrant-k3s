# change mirror server
sudo sed -i 's@mirrors.edge.kernel.org@mirror.kakao.com@g' /etc/apt/sources.list

# disable swap
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# https://kubernetes.io/ko/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/
sudo apt-get install -y bash-completion
type _init_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc

sudo apt-get update
sudo apt-get install -y docker.io nfs-common dnsutils curl vim git net-tools

# helm install
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# k3s install
MASTER_IP="192.168.123.120"

# https://velog.io/@pipi
# https://github.com/bjpublic/core_kubernetes/tree/master/chapters/03
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="\
    --disable traefik \
    --node-name master --docker \
    --node-ip ${MASTER_IP} \
    --disable servicelb " sh -s -

mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown -R $(id -u):$(id -g) ~/.kube
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
source ~/.bashrc

NODE_TOKEN="/var/lib/rancher/k3s/server/node-token"
#while [ ! -e "${NODE_TOKEN}" ]
#do
#    sleep 2
#done
cp ${NODE_TOKEN} /vagrant/

sleep 5
MASTER_IP=$(kubectl get node master -ojsonpath="{.status.addresses[0].address}")
echo ${MASTER_IP} > /vagrant/master_ip
