sudo apt-get update
sudo apt-get install -y docker.io nfs-common dnsutils curl vim git net-tools

# https://kubernetes.io/ko/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/
sudo apt-get install -y bash-completion
type _init_completion
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
source ~/.bashrc

# kubernetes alias
# https://github.com/ahmetb/kubectl-aliases
echo "alias klo='kubectl logs -f'" >> ~/.bashrc
echo "alias ka='kubectl apply --recursive -f'" >> ~/.bashrc
echo "alias kd='kubectl describe'" >> ~/.bashrc
echo "alias krm='kubectl delete'" >> ~/.bashrc
echo "alias kex='kubectl exec -it'" >> ~/.bashrc
echo "alias kge='kubectl get events'" >> ~/.bashrc
echo "alias kgp='kubectl get pods -o wide'" >> ~/.bashrc
echo "alias kgd='kubectl get deploy -o wide'" >> ~/.bashrc
echo "alias kgs='kubectl get service -o wide'" >> ~/.bashrc
echo "alias kgn='kubectl get nodes -o wide'" >> ~/.bashrc
echo "alias kgew='kubectl get events -w'" >> ~/.bashrc
echo "alias kgpa='kubectl get pods -o wide -A'" >> ~/.bashrc
echo "alias kgpw='kubectl get pods -o wide -w'" >> ~/.bashrc
echo "alias kgpaw='kubectl get pods -o wide -A -w'" >> ~/.bashrc

echo "alias h=helm" >> ~/.bashrc
# helm install t1 .
echo "alias hi='helm install'" >> ~/.bashrc
# helm delete t1
echo "alias hd='helm delete'" >> ~/.bashrc
# helm repo add bitnami https://charts.bitnami.com/bitnami
echo "alias hra='helm repo add'" >> ~/.bashrc
# helm search repo nginx
echo "alias hsr='helm search repo'" >> ~/.bashrc
# helm pull bitnami/nginx
echo "alias hp='helm pull'" >> ~/.bashrc
# helm get all -n test t1
echo "alias hga='helm get all'" >> ~/.bashrc
# helm template -n test t1 .
echo "alias ht='helm template'" >> ~/.bashrc
# helm list
echo "alias hl='helm list'" >> ~/.bashrc
# helm list -A
echo "alias hla='helm list -A'" >> ~/.bashrc
# helm upgrade
echo "alias hu='helm upgrade'" >> ~/.bashrc

source ~/.bashrc

# helm install
# https://github.com/helm/helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# k3s install
# https://github.com/k3s-io/k3s
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
# while [ ! -e "${NODE_TOKEN}" ]
# do
#     sleep 2
# done
cp ${NODE_TOKEN} /vagrant/

sleep 5
MASTER_IP=$(kubectl get node master -ojsonpath="{.status.addresses[0].address}")
echo ${MASTER_IP} > /vagrant/master_ip

# kube-ps1 install
git clone https://github.com/jonmosco/kube-ps1 ~/.kube-ps1
chmod +x ~/.kube-ps1/kube-ps1.sh

echo "source ~/.kube-ps1/kube-ps1.sh" >> ~/.bashrc
echo "PS1='[\u@\h \W \$(kube_ps1)]\\$ '" >> ~/.bashrc
echo "PS1='\$(kube_ps1) \u@\h:\W\\$ '" >> ~/.bashrc
echo "KUBE_PS1_SYMBOL_ENABLE=false" >> ~/.bashrc
source ~/.bashrc

# https://youtu.be/UfKZPEk6D0k

## kubent install
## https://github.com/doitintl/kube-no-trouble
## sh -c "$(curl -sSL https://git.io/install-kubent)"

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

## krew plugins
### https://github.com/itaysk/kubectl-neat
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install neat

### https://github.com/tohjustin/kube-lineage
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install lineage

### https://github.com/stern/stern
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install stern

### https://github.com/ahmetb/kubectx
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install ctx
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install ns

### https://github.com/kvaps/kubectl-node-shell
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew index add kvaps https://github.com/kvaps/krew-index
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install kvaps/node-shell

### https://github.com/robscott/kube-capacity
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install resource-capacity

### https://github.com/davidB/kubectl-view-allocations
${KREW_ROOT:-$HOME/.krew}/bin/kubectl-krew install view-allocations

# k9s install
# https://github.com/derailed/k9s
# path: /snap/k9s/current/bin/k9s
snap install k9s

# prometheus + grafana install
# kubectl create namespace monitoring
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update
# helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

# kubectl expose service prometheus-kube-prometheus-prometheus -n monitoring --type=NodePort --target-port=9090 --name=prometheus-server-exp
# kubectl expose service prometheus-grafana -n monitoring --type=NodePort --target-port=3000 --name=grafana-server-exp
