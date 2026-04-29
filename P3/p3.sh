#!/usr/bin/env bash

set -euo pipefail

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_deps() {
  echo "Installing dependencies..."

  # curl
  if ! command_exists curl; then
    echo "curl. Installing..."
    sudo apt update && sudo apt install -y curl
  fi

  # Docker
  if ! command_exists docker; then
    echo "Docker not found. Installing..."
    curl -sL https://get.docker.com | bash
    sudo usermod -aG docker "$USER"
    echo "Docker installed. Please reboot your system for group changes to take effect."
    exit 0
  else
    echo "Docker already installed."
  fi

  # k3d
  if ! command_exists k3d; then
    echo "k3d not found. Installing..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  else
    echo "k3d already installed."
  fi

  # kubectl
  if ! command_exists kubectl; then
    echo "kubectl not found. Installing..."
    mkdir -p ~/.local/bin
    cd /tmp
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl ~/.local/bin/

    # Ensure ~/.local/bin is in PATH
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
      echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
      echo "Added ~/.local/bin to PATH. Reload your shell."
    fi
  else
    echo "kubectl already installed."
  fi
}

up() {
  echo "Starting cluster and ArgoCD setup..."

  # Check if k3d cluster exists
  if ! k3d cluster list | grep -q 'k3s-'; then
    echo "No k3d cluster found. Creating one..."
    k3d cluster create
  else
    echo "k3d cluster already exists."
  fi

  # Namespace argocd
  if ! kubectl get namespace argocd >/dev/null 2>&1; then
    echo "Creating argocd namespace..."
    kubectl create namespace argocd
  else
    echo "Namespace argocd already exists."
  fi

  # Namespace dev
  if ! kubectl get namespace dev >/dev/null 2>&1; then
    echo "Creating dev namespace..."
    kubectl create namespace dev
  else
    echo "Namespace dev already exists."
  fi

  # ArgoCD install (check server service)
  if ! kubectl -n argocd get svc argocd-server >/dev/null 2>&1; then
    echo "Installing ArgoCD..."
    kubectl apply -n argocd --server-side --force-conflicts \
      -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  else
    echo "ArgoCD already installed."
  fi

  # Admin password
  echo "Fetching ArgoCD admin password..."
  PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d)

  echo "Init admin password: $PASSWORD"
}

case "$1" in
  install_deps)
    install_deps
    ;;
  up)
    up
    ;;
  *)
    echo "Usage: $0 {install_deps|up}"
    exit 1
    ;;
esac
