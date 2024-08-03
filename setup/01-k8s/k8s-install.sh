#/bin/bash

# 패키지 업데이트
sudo apt-get update

# 필수 패키지 설치
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# containerd 설치
sudo apt-get install containerd -y

# containerd 시스템에 등록
systemctl enable containerd

# IPv4 포워딩
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# 모듈 로드
sudo modprobe overlay           # 오버레이 파일 시스템을 위한 모듈
sudo modprobe br_netfilter      # 브릿지 방화벽을 위한 모듈

# 커널 파라미터 설정
# 필요한 sysctl 파라미터를 설정하면, 재부팅 후에도 값이 유지된다.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 재부팅하지 않고 sysctl 파라미터 적용하기
sudo sysctl --system

# 변경된 cgroup driver 확인
sudo crtctl info | grep -i cgroup

# 메모리 swap off
sudo swapoff -a; sudo sed -i '/swap/d' /etc/fstab

sudo systemctl disable --now ufw

# containerd 설정경로
sudo mkdir /etc/containerd
# 기본 설정파일 생성
sudo containerd config default > /etc/containerd/config.toml
# systemd cgroup 드라이버룰 runc에서 사용하기 위한  환경 설정
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd


# kubernetes 설치를 위해 필요한 패키지 설치
sudo apt update -y
sudo apt install -y containerd apt-transport-https


#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
#sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

sudo mkdir -p -m 755 /etc/apt/keyrings # Ubuntu 22.04 이전 버전에서 기본으로 제공하지 않는 디렉토리
# kubernetes 패키지 저장소 공개 서명키 다운로드 (1.27 버전을 특정)
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# kubernetes 1.27 apt 저장소 추가  (마이너 버전 주의)
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubeadm kubelet kubectl
# 패키지 자동 업데이트를 막고, 해당 버전을 고정
sudo apt-mark hold kubelet kubeadm kubectl
