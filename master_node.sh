sudo apt-get update
sudo apt-get install -y docker.io nfs-common dnsutils curl vim git net-tools

# https://kubernetes.io/ko/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/
sudo apt-get install -y bash-completion
type _init_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc

# helm install
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# k3s install
MASTER_IP=$(ip addr show eth1 | grep -Eo 'inet [0-9\.]+' | awk '{print $2}')

# https://velog.io/@pipi
# https://github.com/bjpublic/core_kubernetes/tree/master/chapters/03
# https://github.com/rgl/k3s-vagrant/blob/master/provision-k3s-server.sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="\
    --disable traefik \
    --node-name master --docker \
    --node-ip ${MASTER_IP} \
    --flannel-iface 'eth1' \
    --disable servicelb " \
    INSTALL_K3S_VERSION="v1.26.4+k3s1" sh -s -

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

# https://youtu.be/UfKZPEk6D0k

## krew install
## https://krew.sigs.k8s.io/docs/user-guide/setup/install/
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
echo "export PATH=\"${KREW_ROOT:-$HOME/.krew}/bin:$PATH\"" >> ~/.bashrc
source ~/.bashrc

## https://github.com/itaysk/kubectl-neat
kubectl krew install neat

## https://github.com/tohjustin/kube-lineage
kubectl krew install lineage

## https://github.com/stern/stern
kubectl krew install stern

# prometheus + grafana install
#kubectl create namespace monitoring
#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm repo update
#helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

#kubectl expose service prometheus-kube-prometheus-prometheus -n monitoring --type=NodePort --target-port=9090 --name=prometheus-server-exp
#kubectl expose service prometheus-grafana -n monitoring --type=NodePort --target-port=3000 --name=grafana-server-exp
