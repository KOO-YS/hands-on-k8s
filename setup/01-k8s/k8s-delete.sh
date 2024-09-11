#설치여부 확인
kubectl version --client && kubeadm version

systemctl stop kubelet
systemctl stop containerd

sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*
sudo apt-get remove containerd -y


# 불필요한 패키지, 의존성 정리
sudo apt-get -y autoremove
sudo apt-get autoclean

rm -rf /etc/kubernetes
rm -rf /var/lib/etcd
sudo rm -rf ~/.kube
rm -rf /var/lib/kubelet/*


#calico 관련자원 삭제
rm -rf /var/run/calico/
rm -rf /var/lib/calico/
rm -rf /etc/cni/net.d/
rm -rf /var/lib/cni/


rm -rf /var/lib/cni/
rm -rf /run/flannel
rm -rf /etc/cni
rm -rf /opt/cni/bin




#docker 가 설치되어 있는지 확인
dpkg -l | grep -i docker


#docker 삭제
sudo apt-get purge docker-ce docker-ce-cli containerd.io -y
sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce

#containerd 파일 삭제
sudo apt-get purge containerd -y
sudo rm -rf /var/lib/containerd
sudo rm -rf /var/run/containerd
sudo rm -rf /opt/containerd

sudo rm -rf /etc/containerd
sudo rm -rf /var/lib/containerd
sudo rm -rf /run/containerd


#모든 이미지, 컨테이너 및 볼륨을 삭제
sudo groupdel docker

sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo rm -rf /var/run/docker.sock
sudo rm -rf /etc/docker
