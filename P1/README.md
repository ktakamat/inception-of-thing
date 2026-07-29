# Part  1

## Architecture

The purpose of this part is setup k3s with 1 server and 1 agent in vagrant

We using vagrant with libvirt provider

For setup k3s, follow the guide in their homepage

Server

```
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_TOKEN=secret sh -
```

We set kubeconfig 644, for any user can read this

Agent

```
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=secret sh -
```

To achieve static ip for each node, we set mac address for each then config ip for this mac address in file net.xml

We hook when vagrant up, we launch virsh net-create net.xml to create network for this


## Time to demo

To launch our intra, we use command `vagrant up`, this will setup everything we define in Vagrantfile, one server, one agent

Some command helpful

```
scp -P 2222 -r p1 user@localhost:/home/user # copy our config to the machine
vagrant ssh node_name # ssh to node
kubectl get nodes -o wide # list all nodes in cluster
```
