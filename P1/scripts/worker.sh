#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl

export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN="test"

curl -sfL https://get.k3s.io | INSTALL_k3S_EXEC="--node-ip=192.168.56.111" sh -
