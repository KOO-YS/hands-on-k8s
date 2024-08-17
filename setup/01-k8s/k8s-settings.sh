#!/bin/bash

sudo apt install bash-completion -y

# 자동 완성 스크립트 결과 저장
echo 'source <(kubectl completion bash)' >>~/.bashrc

# 추가한 내용 저장
source ~/.bashrc

echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc

# 현재 세션에서 활성화
exec bash

# 쉘 접속시 bash 자동완성 활성화
echo 'source ~/.bashrc' >> /etc/bash.bashrc
