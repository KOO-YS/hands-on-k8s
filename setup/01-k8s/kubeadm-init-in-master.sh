#!/bin/bash

# 서버 IP 입력 받기
read -p "서버 private IP를 입력하세요: " SERVER_IP

# 입력값 재확인
read -p "입력한 서버 IP: $SERVER_IP. 맞습니까? (y/n): " CONFIRM

if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
    # kubeadm init 명령 실행
    echo "다음 명령을 실행합니다:"
    echo "sudo kubeadm init --pod-network-cidr=192.168.0.0/16"

    sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address="$SERVER_IP"
else
    echo "서버 IP 입력이 취소되었습니다."
fi
