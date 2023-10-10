# change mirror server
sudo sed -i 's@mirrors.edge.kernel.org@mirror.kakao.com@g' /etc/apt/sources.list

# disable swap
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# https://github.com/k3s-io/k3s/issues/60#issuecomment-467858023
echo "192.168.123.120 master" >> /etc/hosts
for (( i=1; i<=$1; i++  )); do echo "192.168.123.12$i worker$i" >> /etc/hosts; done

# .vimrc
echo "set nu" >> ~/.vimrc
echo "set mouse=a" >> ~/.vimrc
echo "set ignorecase" >> ~/.vimrc
echo "set hlsearch" >> ~/.vimrc
echo "set incsearch" >> ~/.vimrc

# https://johngrib.github.io/wiki/vim/set-empty-chars/
echo "set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab" >> ~/.vimrc
