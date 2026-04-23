#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --node-ip=192.168.56.110" K3S_TOKEN="test" sh -

