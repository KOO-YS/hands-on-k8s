#!/bin/bash

sudo apt install bash-completion -y

# 자동 완성 스크립트 결과 저장
echo 'source <(kubectl completion bash)' >>~/.bashrc

# 추가한 내용 저장
source ~/.bashrc